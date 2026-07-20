#include <stdint.h>

#include "sys.h"
#include "command.h"
#include "terminal.h"
#include "benchmark.h"
#include "expression.h"

static void terminal_put_int32(int32_t value)
{
    if (value < 0) {
        uint32_t magnitude;

        terminal_putchar('-');

        // 避免直接计算 -INT32_MIN。
        magnitude =
            (uint32_t)(-(value + 1)) + 1u;

        terminal_put_uint(magnitude);
    } else {
        terminal_put_uint((uint32_t)value);
    }
}

static const char* expression_error_text(
      ExpressionError error)
{
    switch (error) {
    case EXPR_EXPECTED_VALUE:
        return "Expected value";
    case EXPR_EXPECTED_RPAREN:
        return "Expected ')'";
    case EXPR_DIVIDE_BY_ZERO:
        return "Divide by zero";
    case EXPR_OVERFLOW:
        return "Integer overflow";
    case EXPR_TRAILING_INPUT:
        return "Unexpected input";
    default:
        return "Invalid expression";
    }
}

static int is_space(char ch) {
    return ch == ' ' || ch == '\t';
}

static const char* skip_spaces(const char* text) {
    while (is_space(*text)) {
        ++text;
    }
    return text;
}

static int consume_word(const char** text, const char* word) {
    const char* cursor = *text;

    while (*word != '\0' && *cursor == *word) {
        ++cursor;
        ++word;
    }

    if (*word != '\0') {
        return 0;
    }
    if (*cursor != '\0' && !is_space(*cursor)) {
        return 0;
    }

    *text = cursor;
    return 1;
}

static int only_trailing_spaces(const char* text) {
    return *skip_spaces(text) == '\0';
}

static int digit_value(char ch, uint32_t *value)
{
    if (ch >= '0' && ch <= '9') {
        *value = (uint32_t)(ch - '0');
        return 1;
    }

    if (ch >= 'a' && ch <= 'f') {
        *value = (uint32_t)(ch - 'a') + 10u;
        return 1;
    }

    if (ch >= 'A' && ch <= 'F') {
        *value = (uint32_t)(ch - 'A') + 10u;
        return 1;
    }

    return 0;
}

static int parse_uint(const char **text, uint32_t *result)
{
    const char *cursor = *text;
    uint32_t value = 0;
    uint32_t base = 10u;
    uint32_t digit;
    int has_digit = 0;

    // 0x 或 0X 前缀表示十六进制。
    if (cursor[0] == '0' &&
        (cursor[1] == 'x' || cursor[1] == 'X')) {
        base = 16u;
        cursor += 2;
    }

    while (digit_value(*cursor, &digit) &&
            digit < base) {
        if (value > (0xffffffffu - digit) / base) {
            return 0;
        }

        value = value * base + digit;
        ++cursor;
        has_digit = 1;
    }

    // 空字符串直接返回
    if (!has_digit) {
        return 0;
    }

    *text = cursor;
    *result = value;
    return 1;
}

static int parse_uint_argument(const char *text,
                                uint32_t *result)
{
    text = skip_spaces(text);

    return parse_uint(&text, result) &&
            only_trailing_spaces(text);
}

static int parse_seg_value(const char **text,
                            uint32_t *seg_value,
                            uint8_t *dp_mask)
{
    const char *cursor = *text;
    uint32_t value = 0;
    uint8_t points = 0;
    uint32_t digit_count = 0;
    uint32_t point_count = 0;

    // 可选的 0x/0X 前缀。
    if (cursor[0] == '0' &&
        (cursor[1] == 'x' || cursor[1] == 'X')) {
        cursor += 2;
    }

    while (*cursor != '\0' &&
            !is_space(*cursor)) {
        uint32_t digit;

        if (digit_value(*cursor, &digit)) {

            // 数码管最多只有 8 位。
            if (digit_count >= 8u) {
                return 0;
            }

            /*
            * 新数字加入最低 4 位；
            * 之前解析的数字整体向高位移动。
            */
            value = (value << 4) | digit;

            /*
            * 新数字成为当前最低位，
            * 已有小数点也要向高位移动一位。
            */
            points = (uint8_t)(points << 1);

            ++digit_count;
            ++cursor;
            continue;
        }

        if (*cursor == '.') {
            /*
            * 小数点必须放在至少一个数字之后。
            */
            if (digit_count == 0u || point_count >= 1u) {
                return 0;
            }

            /*
            * 当前最后读到的数字现在位于 bit 0，
            * 因此将它的小数点位置置 1。
            */
            points |= 1u;
            ++point_count;
            ++cursor;
            continue;
        }

        /*
        * 既不是十六进制数字，也不是小数点。
        */
        return 0;
    }

    if (digit_count == 0u) {
        return 0;
    }

    *text = cursor;
    *seg_value = value;
    *dp_mask = points;
    return 1;
}

static uint32_t fib(uint32_t n) {
    uint32_t a = 0;
    uint32_t b = 1;

    while (n != 0) {
        uint32_t next = a + b;
        a = b;
        b = next;
        n--;
    }

    return a;
}

void command_execute(const char* line) {
    const char* cursor;
    const char* rest;
    uint32_t argument;

    if (line == 0) {
        return;
    }

    cursor = skip_spaces(line);
    if (*cursor == '\0') {
        return;
    }

    rest = cursor;
    if (consume_word(&rest, "help") &&
        only_trailing_spaces(rest)) 
    {
        terminal_puts("Commands:\n");
        terminal_puts("  hello\n");
        terminal_puts("  time\n");
        terminal_puts("  fib <0..46>\n");
        terminal_puts("  calc <expression>\n");
        terminal_puts("  bench [1..100000]\n");
        terminal_puts("  led <value>\n");
        terminal_puts("  seg <hex-value> <enable>\n");
        return;
    }

    rest = cursor;
    if (consume_word(&rest, "hello") && only_trailing_spaces(rest)) {
        terminal_puts("Hello World!\n");
        return;
    }

    rest = cursor;
    if (consume_word(&rest, "time") && only_trailing_spaces(rest)) {
        terminal_put_uint(timer_millis());
        terminal_puts(" ms\n");
        return;
    }

    rest = cursor;
    if (consume_word(&rest, "fib")) {
        rest = skip_spaces(rest);

        if (parse_uint(&rest, &argument) &&
            only_trailing_spaces(rest) && argument <= 46u) {
            terminal_put_uint(fib(argument));
            terminal_putchar('\n');
        } else {
            terminal_puts("Usage: fib <0..46>\n");
        }
        return;
    }

    rest = cursor;
    if (consume_word(&rest, "calc")) {
        ExpressionResult result;

        rest = skip_spaces(rest);

        if (*rest == '\0') {
            terminal_puts(
                "Usage: calc <expression>\n");
            return;
        }

        // calc 后面的所有字符整体交给表达式解析器。
        result = expression_evaluate(rest);

        if (result.error == EXPR_OK) {
            terminal_put_int32(result.value);
            terminal_putchar('\n');
        } else {
            terminal_puts(
                expression_error_text(result.error));
            terminal_puts(" at position ");
            terminal_put_uint(result.error_position);
            terminal_putchar('\n');
        }

        return;
    }

    rest = cursor;
    if (consume_word(&rest, "bench")) {
        rest = skip_spaces(rest);

        /*
        * 没有参数时使用默认值。
        */
        if (*rest == '\0') {
            benchmark_run(1000u);
            return;
        }

        if (parse_uint(&rest, &argument) &&
            only_trailing_spaces(rest) &&
            argument >= 1u &&
            argument <= 100000u) {
            benchmark_run(argument);
        } else {
            terminal_puts(
                "Usage: bench [1..100000]\n");
        }

        return;
    }

    rest = cursor;
    if (consume_word(&rest, "led")) {
        if (parse_uint_argument(rest, &argument) &&
            argument <= 0xffffu) {
            led_write((uint16_t)argument);
        } else {
            terminal_puts(
                "Usage: led <0..0xffff>\n");
        }

        return;
    }

    rest = cursor;
    if (consume_word(&rest, "seg")) {
        uint32_t value;
        uint32_t enable;
        uint8_t points;

        rest = skip_spaces(rest);

        if (!parse_seg_value(&rest,
                            &value,
                            &points)) {
            terminal_puts(
                "Usage: seg <hex-value> <enable>\n");
            return;
        }

        // value 后面必须还有 enable 参数。
        rest = skip_spaces(rest);

        if (!parse_uint(&rest, &enable) ||
            !only_trailing_spaces(rest) ||
            enable > 0xffu) {
            terminal_puts(
                "Usage: seg <hex-value> <enable>\n");
            return;
        }

        /*
        * 先关闭显示，避免三个寄存器依次更新时
        * 短暂显示混合状态。
        */
        seg_enable(0u);
        seg_write(value);
        seg_dp(points);
        seg_enable((uint8_t)enable);

        return;
    }

    terminal_puts("Unknown Command.\n");
}
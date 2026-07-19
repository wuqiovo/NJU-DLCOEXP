#include <stdint.h>

#include "sys.h"
#include "command.h"
#include "terminal.h"

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

static int parse_uint(const char** text, uint32_t* result) {
    const char* cursor = *text;
    uint32_t value = 0;

    if (*cursor < '0' || *cursor > '9') {
        return 0;
    }

    while (*cursor >= '0' && *cursor <= '9') {
        uint32_t digit  = (uint32_t)(*cursor - '0');

        if (value > (0xffffffffu - digit) / 10u) {
            return 0;
        }

        value = value * 10u + digit;
        ++cursor;
    }

    *text = cursor;
    *result = value;
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

    terminal_puts("Unknown Command.\n");
}
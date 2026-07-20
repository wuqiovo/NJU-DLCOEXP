#include <stdint.h>

#include "expression.h"

typedef struct {
    const char *begin;
    const char *cursor;
    ExpressionError error;
    uint32_t error_position;
} Parser;

#define INT32_MAX_VALUE  2147483647
#define INT32_MIN_VALUE  (-2147483647 - 1)

static int parse_expression(Parser *parser, int32_t *value);
static int parse_term(Parser *parser, int32_t *value);
static int parse_unary(Parser *parser, int32_t *value);
static int parse_primary(Parser *parser, int32_t *value);

static int is_space(char ch)
{
    return ch == ' ' || ch == '\t';
}

static void skip_spaces(Parser *parser)
{
    while (is_space(*parser->cursor)) {
        ++parser->cursor;
    }
}

static void set_error(Parser *parser,
                      ExpressionError error,
                      const char *position)
{
    if (parser->error == EXPR_OK) {
        parser->error = error;
        parser->error_position =
            (uint32_t)(position - parser->begin);
    }
}

static int checked_result(Parser *parser,
                          int64_t value,
                          const char *position,
                          int32_t *result)
{
    if (value < (int64_t)INT32_MIN_VALUE ||
        value > (int64_t)INT32_MAX_VALUE) {
        set_error(parser, EXPR_OVERFLOW, position);
        return 0;
    }

    *result = (int32_t)value;
    return 1;
}

static int parse_magnitude(Parser *parser,
                           uint32_t limit,
                           uint32_t *result)
{
    const char *cursor = parser->cursor;
    uint32_t value = 0;

    if (*cursor < '0' || *cursor > '9') {
        set_error(parser, EXPR_EXPECTED_VALUE, cursor);
        return 0;
    }

    while (*cursor >= '0' && *cursor <= '9') {
        uint32_t digit = (uint32_t)(*cursor - '0');

        if (value > (limit - digit) / 10u) {
            set_error(parser, EXPR_OVERFLOW, cursor);
            return 0;
        }

        value = value * 10u + digit;
        ++cursor;
    }

    parser->cursor = cursor;
    *result = value;
    return 1;
}

static int parse_primary(Parser *parser, int32_t *value)
{
    uint32_t magnitude;

    skip_spaces(parser);

    if (*parser->cursor >= '0' &&
        *parser->cursor <= '9') {
        if (!parse_magnitude(parser,
                             2147483647u,
                             &magnitude)) {
            return 0;
        }

        *value = (int32_t)magnitude;
        return 1;
    }

    if (*parser->cursor == '(') {
        ++parser->cursor;

        if (!parse_expression(parser, value)) {
            return 0;
        }

        skip_spaces(parser);

        if (*parser->cursor != ')') {
            set_error(parser,
                      EXPR_EXPECTED_RPAREN,
                      parser->cursor);
            return 0;
        }

        ++parser->cursor;
        return 1;
    }

    set_error(parser,
              EXPR_EXPECTED_VALUE,
              parser->cursor);
    return 0;
}

static int parse_unary(Parser *parser, int32_t *value)
{
    const char *operator_position;

    skip_spaces(parser);

    if (*parser->cursor == '+') {
        ++parser->cursor;
        return parse_unary(parser, value);
    }

    if (*parser->cursor == '-') {
        uint32_t magnitude;

        operator_position = parser->cursor;
        ++parser->cursor;
        skip_spaces(parser);

        if (*parser->cursor >= '0' &&
            *parser->cursor <= '9') {
            if (!parse_magnitude(parser,
                                 2147483648u,
                                 &magnitude)) {
                return 0;
            }

            if (magnitude == 2147483648u) {
                *value = INT32_MIN_VALUE;
            } else {
                *value = -(int32_t)magnitude;
            }

            return 1;
        }

        if (!parse_unary(parser, value)) {
            return 0;
        }

        if (*value == INT32_MIN_VALUE) {
            set_error(parser,
                      EXPR_OVERFLOW,
                      operator_position);
            return 0;
        }

        *value = -*value;
        return 1;
    }

    return parse_primary(parser, value);
}

static int parse_term(Parser *parser, int32_t *value)
{
    int32_t left;

    if (!parse_unary(parser, &left)) {
        return 0;
    }

    for (;;) {
        char operation;
        const char *operator_position;
        int32_t right;

        skip_spaces(parser);
        operation = *parser->cursor;

        if (operation != '*' &&
            operation != '/' &&
            operation != '%') {
            break;
        }

        operator_position = parser->cursor;
        ++parser->cursor;

        if (!parse_unary(parser, &right)) {
            return 0;
        }

        if (operation == '*') {
            int64_t product =
                (int64_t)left * (int64_t)right;

            if (!checked_result(parser,
                                product,
                                operator_position,
                                &left)) {
                return 0;
            }
        } else {
            if (right == 0) {
                set_error(parser,
                          EXPR_DIVIDE_BY_ZERO,
                          operator_position);
                return 0;
            }

            if (left == INT32_MIN_VALUE && right == -1) {
                set_error(parser,
                          EXPR_OVERFLOW,
                          operator_position);
                return 0;
            }

            if (operation == '/') {
                left = left / right;
            } else {
                left = left % right;
            }
        }
    }

    *value = left;
    return 1;
}

static int parse_expression(Parser *parser, int32_t *value)
{
    int32_t left;

    if (!parse_term(parser, &left)) {
        return 0;
    }

    for (;;) {
        char operation;
        const char *operator_position;
        int32_t right;
        int64_t result;

        skip_spaces(parser);
        operation = *parser->cursor;

        if (operation != '+' && operation != '-') {
            break;
        }

        operator_position = parser->cursor;
        ++parser->cursor;

        if (!parse_term(parser, &right)) {
            return 0;
        }

        if (operation == '+') {
            result = (int64_t)left + (int64_t)right;
        } else {
            result = (int64_t)left - (int64_t)right;
        }

        if (!checked_result(parser,
                            result,
                            operator_position,
                            &left)) {
            return 0;
        }
    }

    *value = left;
    return 1;
}

ExpressionResult expression_evaluate(const char *text)
{
    Parser parser;
    ExpressionResult result;

    result.value = 0;
    result.error = EXPR_EXPECTED_VALUE;
    result.error_position = 0;

    if (text == 0) {
        return result;
    }

    parser.begin = text;
    parser.cursor = text;
    parser.error = EXPR_OK;
    parser.error_position = 0;

    skip_spaces(&parser);

    if (*parser.cursor == '\0') {
        return result;
    }

    if (!parse_expression(&parser, &result.value)) {
        result.error = parser.error;
        result.error_position = parser.error_position;
        return result;
    }

    skip_spaces(&parser);

    if (*parser.cursor != '\0') {
        result.error = EXPR_TRAILING_INPUT;
        result.error_position =
            (uint32_t)(parser.cursor - parser.begin);
        return result;
    }

    result.error = EXPR_OK;
    result.error_position = 0;
    return result;
}
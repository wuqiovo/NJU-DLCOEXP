#ifndef EXPR_H
#define EXPR_H

#include <stdint.h>

typedef enum {
    EXPR_OK = 0,
    EXPR_EXPECTED_VALUE,
    EXPR_EXPECTED_RPAREN,
    EXPR_DIVIDE_BY_ZERO,
    EXPR_OVERFLOW,
    EXPR_TRAILING_INPUT
} ExpressionError;

typedef struct {
    int32_t value;
    ExpressionError error;
    uint32_t error_position;
} ExpressionResult;

ExpressionResult expression_evaluate(const char *text);

#endif  // EXPR_H
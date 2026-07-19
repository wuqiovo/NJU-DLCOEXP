#ifndef TERMINAL_H
#define TERMINAL_H

#include <stdint.h>

#define TERMINAL_WIDTH   70u
#define TERMINAL_HEIGHT  30u
#define TERMINAL_SIZE    (TERMINAL_WIDTH * TERMINAL_HEIGHT)

void terminal_init(void);
void terminal_clear(void);
void terminal_putchar(char ch);
void terminal_puts(const char *str);
void terminal_put_uint(uint32_t value);

void terminal_get_cursor(uint32_t *x, uint32_t *y);
void terminal_set_cursor(uint32_t x, uint32_t y);

void terminal_write_at(uint32_t x, uint32_t y, char ch);
void terminal_scroll_up(uint32_t rows);

#endif // TERMINAL_H 
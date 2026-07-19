#include "terminal.h"
#include "sys.h"

static uint32_t cursor_x;
static uint32_t cursor_y;
static uint32_t row_base;

static void scroll_buffer_one_row(void);

static uint32_t physical_row(uint32_t logical_row) {
    uint32_t row = row_base + logical_row;

    if (row >= TERMINAL_HEIGHT){
        row -= TERMINAL_HEIGHT;
    }

    return row;
}

static void clear_physical_row(uint32_t row) {
    uint32_t x;
    uint32_t begin = row * TERMINAL_WIDTH;

    for (x = 0; x < TERMINAL_WIDTH; x++) {
        vram_write(begin + x, ' ');
    }
}

static void update_hardware_state(void) {
    vga_set_row_base(row_base);
    vga_set_cursor(cursor_x, cursor_y);
}

static void terminal_newline(void) {
    cursor_x = 0;

    if (cursor_y + 1u < TERMINAL_HEIGHT) {
        cursor_y++;
    }
    else {
        scroll_buffer_one_row();
    }

    update_hardware_state();
}

void terminal_init(void) {
    terminal_clear();
}

void terminal_clear(void) {
    uint32_t index;

    for (index = 0; index < TERMINAL_SIZE; index++) {
        vram_write(index, ' ');
    }

    row_base = 0;
    cursor_x = 0;
    cursor_y = 0;
    update_hardware_state();
}

void terminal_putchar(char ch) {
    if (ch == '\n') {
        terminal_newline();
        return;
    }

    // Enter
    if (ch == '\r') {
        cursor_x = 0;
        vga_set_cursor(cursor_x, cursor_y);
        return;
    }

    // Backspace
    if (ch == '\b') {
        if (cursor_x != 0) {
            --cursor_x;
        } else if (cursor_y != 0) {
            --cursor_y;
            cursor_x = TERMINAL_WIDTH - 1u;
        } else {
            return;
        }

        terminal_write_at(cursor_x, cursor_y, ' ');
        vga_set_cursor(cursor_x, cursor_y);
        return;
    }

    terminal_write_at(cursor_x, cursor_y, ch);

    cursor_x++;
    if (cursor_x >= TERMINAL_WIDTH) {
        terminal_newline();
    }
    else {
        vga_set_cursor(cursor_x, cursor_y);
    }
}

void terminal_puts(const char *str) {
    if (str == 0) {
        return;
    }

    while (*str != '\0') {
        terminal_putchar(*str);
        ++str;
    }
}

void terminal_put_uint(uint32_t value) {
    char buffer[10];
    uint32_t length = 0;

    do {
        buffer[length++] = (char)('0' + value % 10);
        value /= 10u;
    } while (value != 0);

    while (length != 0) {
        terminal_putchar(buffer[--length]);
    }
}

void terminal_get_cursor(uint32_t* x, uint32_t* y) {
    if (x != 0)
        *x = cursor_x;
    if (y != 0)
        *y = cursor_y;
}

void terminal_set_cursor(uint32_t x, uint32_t y)
{
    if (x >= TERMINAL_WIDTH || y >= TERMINAL_HEIGHT)
        return;

    cursor_x = x;
    cursor_y = y;
    vga_set_cursor(cursor_x, cursor_y);
}

void terminal_write_at(uint32_t x, uint32_t y, char ch)
{
    uint32_t row;
    uint32_t index;

    if (x >= TERMINAL_WIDTH || y >= TERMINAL_HEIGHT)
        return;

    row = physical_row(y);
    index = row * TERMINAL_WIDTH + x;
    vram_write(index, ch);
}

static void scroll_buffer_one_row(void)
{
    if (row_base + 1u == TERMINAL_HEIGHT)
        row_base = 0;
    else
        ++row_base;

    clear_physical_row(physical_row(TERMINAL_HEIGHT - 1u));
}

void terminal_scroll_up(uint32_t rows)
{
    while (rows != 0) {
        scroll_buffer_one_row();

        if (cursor_y != 0)
            --cursor_y;

        --rows;
    }

    update_hardware_state();
}

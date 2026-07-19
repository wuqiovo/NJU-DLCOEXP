#include "sys.h"

static inline uint32_t mmio_read32(uint32_t address)
{
    return *(volatile uint32_t *)address;
}

static inline void mmio_write32(uint32_t address, uint32_t value)
{
    *(volatile uint32_t *)address = value;
}

static inline void mmio_write8(uint32_t address, uint8_t value)
{
    *(volatile uint8_t *)address = value;
}

void vram_write(uint32_t index, char ch)
{
    mmio_write8(VRAM_BASE_ADDR + index, (uint8_t)ch);
}

void vga_set_row_base(uint32_t row)
{
    mmio_write32(VGA_ROW_BASE_ADDR, row);
}

void vga_set_cursor(uint32_t x, uint32_t y)
{
    mmio_write32(VGA_CURSOR_X_ADDR, x);
    mmio_write32(VGA_CURSOR_Y_ADDR, y);
}

int keyboard_available(void)
{
    return mmio_read32(KEYBOARD_HEAD_ADDR)
        != mmio_read32(KEYBOARD_TAIL_ADDR);
}

int keyboard_getchar_nonblock(void)
{
    uint32_t head = mmio_read32(KEYBOARD_HEAD_ADDR);
    uint32_t tail = mmio_read32(KEYBOARD_TAIL_ADDR);
    uint32_t value;

    if (head == tail)
        return -1;

    value = mmio_read32(KEYBOARD_BUFFER_ADDR + (head << 2));
    head = (head + 1u) & KEYBOARD_FIFO_MASK;
    mmio_write32(KEYBOARD_HEAD_ADDR, head);

    return (int)(value & 0xffu);
}

char keyboard_getchar(void)
{
    int ch;
    do {
        ch = keyboard_getchar_nonblock();
    } while (ch < 0);
    return (char)ch;
}

uint32_t timer_millis(void)
{
    return mmio_read32(TIMER_MILLIS_ADDR);
}

void timer_delay(uint32_t milliseconds)
{
    uint32_t start = timer_millis();
    while ((uint32_t)(timer_millis() - start) < milliseconds) {
        /* busy wait */
    }
}
#ifndef SYS_H
#define SYS_H

#include <stdint.h>

#define VRAM_BASE_ADDR        0x00200000u
#define VGA_ROW_BASE_ADDR     0x00201000u
#define VGA_CURSOR_X_ADDR     0x00201004u
#define VGA_CURSOR_Y_ADDR     0x00201008u

#define KEYBOARD_HEAD_ADDR    0x00300000u
#define KEYBOARD_TAIL_ADDR    0x00300004u
#define KEYBOARD_BUFFER_ADDR  0x00300100u
#define KEYBOARD_FIFO_MASK    31u

#define TIMER_MILLIS_ADDR     0x00400000u
#define TIMER_CYCLES_ADDR     0x00400004u

#define LED_VALUE_ADDR        0x00500000u
#define SEG_VALUE_ADDR        0x00500004u
#define SEG_ENABLE_ADDR       0x00500008u
#define SEG_DP_ADDR           0x0050000Cu

// 显示接口
// 用index表示字符单元编号
// VRAM 地址从 0x0020_0000 开始

void vram_write(uint32_t index, char ch);

// 设置循环显示缓冲区的起始行
void vga_set_row_base(uint32_t row);

// 设置硬件光标坐标。
void vga_set_cursor(uint32_t x, uint32_t y);

// 键盘接口

// 如果键盘 FIFO 中存在字符，返回非零
int keyboard_available(void);

/*
* 非阻塞读取字符。
*
* 成功：返回 0~255 的字符值
* 无字符：返回 -1
*/
int keyboard_getchar_nonblock(void);

// 阻塞等待并读取一个字符。
char keyboard_getchar(void);

// 计时器接口

// 返回系统启动之后经过的毫秒数
uint32_t timer_millis(void);
uint32_t timer_cycles(void);

// 阻塞等待指定毫秒数。
void timer_delay(uint32_t milliseconds);

// 写入 led 显示
// 16位开关码，1 - on, 0 - off
void led_write(uint16_t value);

// 数码管相关
// 依次为：显示数据写入，使能，小数点
void seg_write(uint32_t value);
void seg_enable(uint8_t mask);
void seg_dp(uint8_t mask);

#endif // SYS_H
#ifndef SYS_H
#define SYS_H

#include <stdint.h>

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

// 阻塞等待指定毫秒数。
void timer_delay(uint32_t milliseconds);

#endif // SYS_H
#include <stdint.h>

#include "sys.h"
#include "terminal.h"
#include "command.h"

#define LINE_CAPACITY 128u
#define HISTORY_CAPACITY 8u

/* keyboard_decoder 写入 FIFO 的内部方向键编码。 */
#define KEY_LEFT   0x11
#define KEY_RIGHT  0x12
#define KEY_UP     0x13
#define KEY_DOWN   0x14

static char history[HISTORY_CAPACITY][LINE_CAPACITY];
static uint32_t history_count;

static uint32_t input_visual_row(uint32_t, uint32_t);

static void input_position(uint32_t input_x, uint32_t input_y,
                            uint32_t position, 
                            uint32_t *x, uint32_t *y);

static void set_input_cursor(uint32_t input_x, uint32_t input_y,
                            uint32_t position);


static void ensure_input_visible(uint32_t input_x,
                                   uint32_t *input_y,
                                   uint32_t length);


static void redraw_input(const char *line, uint32_t length, 
                        uint32_t old_length, uint32_t edit_pos, 
                        uint32_t input_x, uint32_t *input_y);


static uint32_t line_copy(char*, const char*);

static void replace_input(char *line, const char *source,
                            uint32_t *length, uint32_t *edit_pos,
                            uint32_t input_x, uint32_t *input_y);

static void update_draft(const char *line, char *draft,
                            uint32_t *history_pos,
                            int *browsing_history);

static void history_add(const char*);

int main(void) {
    char line[LINE_CAPACITY];
    uint32_t length;    // line 中已有的字符数 
    uint32_t edit_pos;  // 编辑位置，范围为 0..length 

    // 命令输入起始位置
    uint32_t input_x;   
    uint32_t input_y;   

    terminal_init();
    terminal_puts("Terminal ready.\n");

    for (;;) {
        terminal_puts("> ");
        terminal_get_cursor(&input_x, &input_y);

        length = 0;
        edit_pos = 0;
        line[0] = '\0';

        // 历史记录相关
        uint32_t history_pos;
        char draft[LINE_CAPACITY];
        int browsing_history;

        history_pos = history_count;
        draft[0] = '\0';
        browsing_history = 0;

        for (;;) {
            int ch = (uint8_t)keyboard_getchar();

            if (ch == '\n') {
                line[length] = '\0';

                set_input_cursor(input_x, input_y, length);
                terminal_putchar('\n');

                command_execute(line);
                history_add(line);
                break;
            }

            if (ch == '\b') {
                if (edit_pos != 0) {
                    uint32_t i;
                    uint32_t old_length = length;

                    
                    // 删除 edit_pos 前面的字符。
                    // 把右侧字符整体左移。
                    for (i = edit_pos - 1u; i + 1u < length; ++i){
                        line[i] = line[i + 1u];
                    }

                    --edit_pos;
                    --length;
                    line[length] = '\0';

                    update_draft(line, draft, &history_pos,
                                &browsing_history);

                    redraw_input(line, length, old_length,
                                edit_pos, input_x, &input_y);
                }

                continue;
            }

            if (ch == KEY_LEFT) {
                if (edit_pos != 0) {
                    --edit_pos;
                    set_input_cursor(input_x, input_y, edit_pos);
                }

                continue;
            }

            if (ch == KEY_RIGHT) {
                if (edit_pos < length) {
                    ++edit_pos;
                    set_input_cursor(input_x, input_y, edit_pos);
                }

                continue;
            }

            if (ch == KEY_UP) {
                uint32_t current_row = 
                    input_visual_row(input_x, edit_pos);
                
                if (current_row != 0) {
                    uint32_t total = input_x + edit_pos;
                    uint32_t target_total = total - TERMINAL_WIDTH;
                    uint32_t target_pos;

                    if (target_total <= input_x) {
                        target_pos = 0;
                    }
                    else {
                        target_pos = target_total - input_x;
                    }

                    edit_pos = target_pos;
                    set_input_cursor(input_x, input_y, edit_pos);
                } 
                else if (history_count != 0) {
                    if (!browsing_history) {
                        line_copy(draft,line);
                        history_pos = history_count;
                        browsing_history = 1;
                    }

                    if (history_pos != 0) {
                        history_pos--;
                    }

                    replace_input(line, history[history_pos],
                        &length, &edit_pos, input_x, &input_y);
                }

                continue;
            }

            if (ch == KEY_DOWN) {
                uint32_t current_row = 
                    input_visual_row(input_x, edit_pos);
                uint32_t last_row = 
                    input_visual_row(input_x, length);
                
                if (current_row < last_row) {
                    uint32_t target_pos = edit_pos + TERMINAL_WIDTH;

                    if (target_pos > length) {
                        target_pos = length;
                    }

                    edit_pos = target_pos;
                    set_input_cursor(input_x, input_y, edit_pos);
                } else if (browsing_history) {
                    if (history_pos + 1u < history_count) {
                        history_pos++;
                        replace_input(line, history[history_pos],
                            &length, &edit_pos, input_x, &input_y);
                    } else {
                        history_pos = history_count;
                        browsing_history = 0;
                        replace_input(line, draft,
                            &length, &edit_pos, input_x, &input_y);
                    }
                }

                continue;
            }

            if (ch >= 0x20 && ch <= 0x7e &&
                length + 1u < LINE_CAPACITY) {
                uint32_t i;
                uint32_t old_length = length;

                // 从后向前移动，给新字符腾出位置。
                for (i = length; i > edit_pos; --i) {
                    line[i] = line[i - 1u];
                }

                line[edit_pos] = (char)ch;

                ++edit_pos;
                ++length;
                line[length] = '\0';

                update_draft(line, draft, &history_pos,
                            &browsing_history);

                redraw_input(line, length, old_length,
                            edit_pos, input_x, &input_y);

                continue;
            }
        }
    }
}

static void input_position(uint32_t input_x, uint32_t input_y,
                            uint32_t position, 
                            uint32_t *x, uint32_t *y)
{
    uint32_t offset = input_x + position;

    *x = offset % TERMINAL_WIDTH;
    *y = input_y + offset / TERMINAL_WIDTH;
}

static void set_input_cursor(uint32_t input_x, uint32_t input_y,
                            uint32_t position)
{
    uint32_t x;
    uint32_t y;

    input_position(input_x, input_y, position, &x, &y);
    terminal_set_cursor(x, y);
}

static void ensure_input_visible(uint32_t input_x,
                                   uint32_t *input_y,
                                   uint32_t length)
{
    uint32_t end_offset = input_x + length;
    uint32_t end_y =
        *input_y + end_offset / TERMINAL_WIDTH;

    if (end_y >= TERMINAL_HEIGHT) {
        uint32_t scroll_rows =
            end_y - (TERMINAL_HEIGHT - 1u);

        terminal_scroll_up(scroll_rows);
        *input_y -= scroll_rows;
    }
}

static void redraw_input(const char *line, uint32_t length, 
                        uint32_t old_length, uint32_t edit_pos, 
                        uint32_t input_x, uint32_t *input_y)
{
    uint32_t i;
    uint32_t x;
    uint32_t y;

    ensure_input_visible(input_x, input_y, length);

    for (i = 0; i < length; ++i) {
        input_position(input_x, *input_y, i, &x, &y);
        terminal_write_at(x, y, line[i]);
    }

    // 擦除旧字符串尾部。
    for (i = length; i < old_length; ++i) {
        input_position(input_x, *input_y, i, &x, &y);
        terminal_write_at(x, y, ' ');
    }

    input_position(input_x, *input_y,
                    edit_pos, &x, &y);
    terminal_set_cursor(x, y);
}


static uint32_t input_visual_row(uint32_t input_x, uint32_t position) {
    return (input_x + position) / TERMINAL_WIDTH;
}

static uint32_t line_copy(char* des, const char* src) {
    uint32_t length = 0;
    while (src[length] != '\0' &&
                length + 1u < LINE_CAPACITY) {
            des[length] = src[length];
            ++length;
        }

        des[length] = '\0';
        return length;
}

static void replace_input(char *line, const char *source,
                            uint32_t *length, uint32_t *edit_pos,
                            uint32_t input_x, uint32_t *input_y)
{
    uint32_t old_length = *length;

    *length = line_copy(line, source);
    *edit_pos = *length;

    redraw_input(line, *length, old_length,
                *edit_pos, input_x, input_y);
}

static void update_draft(const char *line, char *draft,
                            uint32_t *history_pos,
                            int *browsing_history)
{
    *browsing_history = 0;
    *history_pos = history_count;
    line_copy(draft, line);
}

static void history_add(const char* line) {
    uint32_t i;
    if (line[0] == '\0') {
        return;
    }

    if (history_count < HISTORY_CAPACITY) {
        line_copy(history[history_count], line);
        history_count++;
        return;
    }

    for (i = 1; i < HISTORY_CAPACITY; i++) {
        line_copy(history[i - 1u], history[i]);
    }

    line_copy(history[HISTORY_CAPACITY - 1u], line);
}

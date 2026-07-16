`timescale 1ns / 1ps

// Data flow:
//   PS/2 pins -> ps2_keyboard -> keyboard_decoder -> terminal_ctrl
//                                                    |
//                                                    v
//                         VGA <- text_renderer <- text_vram
module exp(
    input  wire       PS2_CLK,
    input  wire       PS2_DATA,

    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B,
    output wire       VGA_HS,
    output wire       VGA_VS,

    input  wire       CLK100MHZ,
    input  wire [0:0] SW,
    output wire [0:0] LED
    );

    wire board_reset;
    wire CLK25MHZ;
    wire clk_locked;
    wire system_reset;

    assign board_reset = SW[0];
    assign system_reset = board_reset | ~clk_locked;
    assign LED[0] = clk_locked;

    // PS/2 byte receiver and keyboard event decoder
    
    wire [7:0] ps2_keyboard_data;
    wire       ps2_ready;
    wire       ps2_nextdata_n;
    wire       ps2_overflow;
    wire       scan_ready;

    ps2_keyboard u_ps2_keyboard (
        .clk        (CLK100MHZ),
        .clrn       (~system_reset),
        .ps2_clk    (PS2_CLK),
        .ps2_data   (PS2_DATA),
        .data       (ps2_keyboard_data),
        .ready      (ps2_ready),
        .nextdata_n (ps2_nextdata_n),
        .overflow   (ps2_overflow)
    );

    // nextdata_n is an active-low FIFO acknowledgement. Only pop a byte when
    // keyboard_decoder is able to accept it. This provides back-pressure while
    // terminal_ctrl is clearing a row during scrolling.
    assign ps2_nextdata_n = ~(ps2_ready && scan_ready);

    wire       key_valid;
    wire       key_ready;
    wire [7:0] key_ascii;
    wire       key_enter;
    wire       key_backspace;
    wire       shift_down;

    keyboard_decoder u_keyboard_decoder (
        .clk             (CLK100MHZ),
        .reset           (system_reset),
        .scan_valid      (ps2_ready),
        .scan_code       (ps2_keyboard_data),
        .scan_ready      (scan_ready),
        .event_valid     (key_valid),
        .event_ready     (key_ready),
        .event_ascii     (key_ascii),
        .event_enter     (key_enter),
        .event_backspace (key_backspace),
        .shift_down      (shift_down)
    );

    // Terminal editing policy and VRAM write port

    wire        vram_wr_en;
    wire [11:0] vram_wr_addr;
    wire [7:0]  vram_wr_data;

    wire [6:0] cursor_x;
    wire [4:0] cursor_y;
    wire [4:0] row_base;
    wire       terminal_busy;

    terminal_ctrl u_terminal_ctrl (
        .clk             (CLK100MHZ),
        .reset           (system_reset),
        .event_valid     (key_valid),
        .event_ready     (key_ready),
        .event_ascii     (key_ascii),
        .event_enter     (key_enter),
        .event_backspace (key_backspace),
        .vram_wr_en      (vram_wr_en),
        .vram_wr_addr    (vram_wr_addr),
        .vram_wr_data    (vram_wr_data),
        .cursor_x        (cursor_x),
        .cursor_y        (cursor_y),
        .row_base        (row_base),
        .busy            (terminal_busy)
    );

    // Dual-port character memory

    wire [11:0] vram_rd_addr;
    wire [7:0]  vram_rd_data;

    text_vram u_text_vram (
        .wr_clk  (CLK100MHZ),
        .wr_en   (vram_wr_en),
        .wr_addr (vram_wr_addr),
        .wr_data (vram_wr_data),
        .rd_clk  (CLK25MHZ),
        .rd_addr (vram_rd_addr),
        .rd_data (vram_rd_data)
    );

    // VGA timing generator and character renderer

    wire [11:0] vga_data;
    wire [9:0]  h_addr;
    wire [9:0]  v_addr;
    wire        vga_valid;
    wire        raw_hsync;
    wire        raw_vsync;

    vga_ctrl u_vga_ctrl (
        .pclk     (CLK25MHZ),
        .reset    (system_reset),
        .vga_data (vga_data),
        .h_addr   (h_addr),
        .v_addr   (v_addr),
        .hsync    (raw_hsync),
        .vsync    (raw_vsync),
        .valid    (vga_valid),
        .vga_r    (VGA_R),
        .vga_g    (VGA_G),
        .vga_b    (VGA_B)
    );

    // text_vram performs a synchronous read. text_renderer delays pixel
    // metadata and synchronization signals by one pclk so RGB, HS and VS stay
    // aligned. Therefore VGA_HS/VGA_VS come from text_renderer, not directly
    // from vga_ctrl.
    text_renderer #(
        .FONT_INIT_FILE("D:/DLCOEXP/lab08/ascii_font_9x16.mem")
    ) u_text_renderer (
        .pclk         (CLK25MHZ),
        .reset        (system_reset),
        .h_addr       (h_addr),
        .v_addr       (v_addr),
        .valid_in     (vga_valid),
        .hsync_in     (raw_hsync),
        .vsync_in     (raw_vsync),
        .vram_rd_addr (vram_rd_addr),
        .vram_rd_data (vram_rd_data),
        .cursor_x     (cursor_x),
        .cursor_y     (cursor_y),
        .row_base     (row_base),
        .vga_data     (vga_data),
        .hsync_out    (VGA_HS),
        .vsync_out    (VGA_VS)
    );
    
    // 100 MHz board clock -> 25 MHz VGA pixel clock

    clk_wiz_0 u_25mhz_clk (
        .reset    (board_reset),
        .clk_in1  (CLK100MHZ),
        .clk_out1 (CLK25MHZ),
        .locked   (clk_locked)
    );

endmodule

`timescale 1ns / 1ps

// Render a 70 x 30 character screen using 9 x 16 glyphs.
// text_vram has a one-pixel-clock synchronous read latency, so pixel metadata
// and VGA synchronization signals are delayed by the same one clock.
module text_renderer #(
    parameter FONT_INIT_FILE = "ascii_font_9x16.mem"
)(
    input  wire        pclk,
    input  wire        reset,

    input  wire [9:0]  h_addr,
    input  wire [9:0]  v_addr,
    input  wire        valid_in,
    input  wire        hsync_in,
    input  wire        vsync_in,

    output wire [11:0] vram_rd_addr,
    input  wire [7:0]  vram_rd_data,

    input  wire [6:0]  cursor_x,
    input  wire [4:0]  cursor_y,
    input  wire [4:0]  row_base,

    output reg  [11:0] vga_data,
    output reg         hsync_out,
    output reg         vsync_out
    );

    reg [11:0] font_rom [0:4095];

    initial begin
        $readmemh(FONT_INIT_FILE, font_rom);
    end

    wire [6:0] char_x_now;
    wire [4:0] char_y_now;
    wire [3:0] pixel_x_now;
    wire [3:0] pixel_y_now;
    wire       inside_now;

    assign char_x_now  = h_addr / 10'd9;
    assign pixel_x_now = h_addr % 10'd9;
    assign char_y_now  = v_addr[8:4];
    assign pixel_y_now = v_addr[3:0];
    assign inside_now  = valid_in &&
                         (h_addr < 10'd630) &&
                         (v_addr < 10'd480);

    // Synchronize terminal state into the pixel-clock domain, then update the
    // displayed snapshot only at the beginning of a visible frame.
    reg [6:0] cursor_x_sync0;
    reg [6:0] cursor_x_sync1;
    reg [4:0] cursor_y_sync0;
    reg [4:0] cursor_y_sync1;
    reg [4:0] row_base_sync0;
    reg [4:0] row_base_sync1;

    reg [6:0] cursor_x_frame;
    reg [4:0] cursor_y_frame;
    reg [4:0] row_base_frame;

    reg [5:0] physical_row_sum;
    reg [4:0] physical_row_now;

    always @(*) begin
        physical_row_sum = row_base_frame + char_y_now;
        if (physical_row_sum >= 6'd30)
            physical_row_now = physical_row_sum - 6'd30;
        else
            physical_row_now = physical_row_sum[4:0];
    end

    assign vram_rd_addr = inside_now
                        ? physical_row_now * 12'd70 + char_x_now
                        : 12'd0;

    reg [3:0]   pixel_x_d;
    reg [3:0]   pixel_y_d;
    reg         inside_d;
    reg         cursor_here_d;
    reg [23:0]  blink_counter;

    wire [11:0] font_row;
    wire        glyph_pixel_on;
    wire        cursor_pixel_on;

    assign font_row = font_rom[{vram_rd_data, pixel_y_d}];
    assign glyph_pixel_on = font_row[pixel_x_d];
    assign cursor_pixel_on = cursor_here_d && blink_counter[23] &&
                             (pixel_y_d >= 4'd14);

    always @(posedge pclk) begin
        if (reset) begin
            cursor_x_sync0 <= 7'd0;
            cursor_x_sync1 <= 7'd0;
            cursor_y_sync0 <= 5'd0;
            cursor_y_sync1 <= 5'd0;
            row_base_sync0 <= 5'd0;
            row_base_sync1 <= 5'd0;
            cursor_x_frame <= 7'd0;
            cursor_y_frame <= 5'd0;
            row_base_frame <= 5'd0;
            pixel_x_d      <= 4'd0;
            pixel_y_d      <= 4'd0;
            inside_d       <= 1'b0;
            cursor_here_d  <= 1'b0;
            blink_counter  <= 24'd0;
            hsync_out      <= 1'b0;
            vsync_out      <= 1'b0;
        end
        else begin
            cursor_x_sync0 <= cursor_x;
            cursor_x_sync1 <= cursor_x_sync0;
            cursor_y_sync0 <= cursor_y;
            cursor_y_sync1 <= cursor_y_sync0;
            row_base_sync0 <= row_base;
            row_base_sync1 <= row_base_sync0;

            if (valid_in && (h_addr == 10'd0) && (v_addr == 10'd0)) begin
                cursor_x_frame <= cursor_x_sync1;
                cursor_y_frame <= cursor_y_sync1;
                row_base_frame <= row_base_sync1;
            end

            pixel_x_d     <= pixel_x_now;
            pixel_y_d     <= pixel_y_now;
            inside_d      <= inside_now;
            cursor_here_d <= inside_now &&
                             (char_x_now == cursor_x_frame) &&
                             (char_y_now == cursor_y_frame);
            blink_counter <= blink_counter + 24'd1;
            hsync_out     <= hsync_in;
            vsync_out     <= vsync_in;
        end
    end

    always @(*) begin
        if (inside_d && (glyph_pixel_on || cursor_pixel_on))
            vga_data = 12'hFFF;
        else
            vga_data = 12'h000;
    end

endmodule

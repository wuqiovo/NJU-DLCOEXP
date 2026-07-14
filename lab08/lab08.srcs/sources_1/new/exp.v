`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/12 22:36:13
// Design Name: 
// Module Name: exp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module exp(
    input PS2_CLK,
    input PS2_DATA,

    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output VGA_HS,
    output VGA_VS,

    input CLK100MHZ,
    input [0:0] SW,
    output [0:0] LED
);

    wire reset;
    assign reset = SW[0];

    wire CLK25MHZ;
    wire clk_locked;

    assign LED[0] = clk_locked;

    // Font ROM
    // 256 characters
    // 16 rows per character
    // 12 bits per row, but only bits [8:0] are used

    reg [11:0] font_rom [0:4095];

    initial begin
        $readmemh(
            "D:/DLCOEXP/lab08/ascii_font_9x16.mem",
            font_rom
        );
    end

    // Character screen memory
    // 70 columns x 30 rows = 2100 characters

    reg [7:0] char_ram [2099:0];

    integer i;

    initial begin
        for (i = 0; i < 2100; i = i + 1)
            char_ram[i] = 8'h20;
    end

    wire [7:0] ps2_keyboard_data;
    wire ready;
    wire nextdata_n;
    wire overflow;

    // Keeping nextdata_n low while ready is high to continuously accept char 

    assign nextdata_n = ~ready;

    ps2_keyboard u_ps2_keyboard (
        .clk(CLK100MHZ),
        .clrn(~reset),
        .ps2_clk(PS2_CLK),
        .ps2_data(PS2_DATA),
        .data(ps2_keyboard_data),
        .ready(ready),
        .nextdata_n(nextdata_n),
        .overflow(overflow)
    );

    // Scan code to ASCII conversion

    function [7:0] scan_to_ascii;
        input [7:0] scan_code;

        begin
            case (scan_code)

                // Letters
                8'h1C: scan_to_ascii = "a";
                8'h32: scan_to_ascii = "b";
                8'h21: scan_to_ascii = "c";
                8'h23: scan_to_ascii = "d";
                8'h24: scan_to_ascii = "e";
                8'h2B: scan_to_ascii = "f";
                8'h34: scan_to_ascii = "g";
                8'h33: scan_to_ascii = "h";
                8'h43: scan_to_ascii = "i";
                8'h3B: scan_to_ascii = "j";
                8'h42: scan_to_ascii = "k";
                8'h4B: scan_to_ascii = "l";
                8'h3A: scan_to_ascii = "m";
                8'h31: scan_to_ascii = "n";
                8'h44: scan_to_ascii = "o";
                8'h4D: scan_to_ascii = "p";
                8'h15: scan_to_ascii = "q";
                8'h2D: scan_to_ascii = "r";
                8'h1B: scan_to_ascii = "s";
                8'h2C: scan_to_ascii = "t";
                8'h3C: scan_to_ascii = "u";
                8'h2A: scan_to_ascii = "v";
                8'h1D: scan_to_ascii = "w";
                8'h22: scan_to_ascii = "x";
                8'h35: scan_to_ascii = "y";
                8'h1A: scan_to_ascii = "z";

                // Number row
                8'h16: scan_to_ascii = "1";
                8'h1E: scan_to_ascii = "2";
                8'h26: scan_to_ascii = "3";
                8'h25: scan_to_ascii = "4";
                8'h2E: scan_to_ascii = "5";
                8'h36: scan_to_ascii = "6";
                8'h3D: scan_to_ascii = "7";
                8'h3E: scan_to_ascii = "8";
                8'h46: scan_to_ascii = "9";
                8'h45: scan_to_ascii = "0";

                // Space
                8'h29: scan_to_ascii = 8'h20;

                // Symbols that do not require Shift
                8'h0E: scan_to_ascii = "`";
                8'h4E: scan_to_ascii = "-";
                8'h55: scan_to_ascii = "=";
                8'h54: scan_to_ascii = "[";
                8'h5B: scan_to_ascii = "]";
                8'h5D: scan_to_ascii = "\\";
                8'h4C: scan_to_ascii = ";";
                8'h52: scan_to_ascii = "'";
                8'h41: scan_to_ascii = ",";
                8'h49: scan_to_ascii = ".";
                8'h4A: scan_to_ascii = "/";

                default:
                    scan_to_ascii = 8'h00;
            endcase
        end
    endfunction

    wire [7:0] decoded_ascii;

    assign decoded_ascii =
        scan_to_ascii(ps2_keyboard_data);

    // handle the reception code from the ps/2 keyboard 
    
    reg break_pending;
    reg extended_pending;

    // Current cursor position
    reg [6:0] cursor_x;  // 0 - 69
    reg [4:0] cursor_y;  // 0 - 29

    wire [11:0] cursor_addr;

    assign cursor_addr =
        cursor_y * 12'd70 + cursor_x;

    always @(posedge CLK100MHZ) begin
        if (reset) begin
            cursor_x        <= 7'd0;
            cursor_y        <= 5'd0;
            break_pending   <= 1'b0;
            extended_pending <= 1'b0;
        end
        else if (ready) begin

            // Extended scan-code prefix
            if (ps2_keyboard_data == 8'hE0) begin
                extended_pending <= 1'b1;
            end

            // Break-code prefix
            else if (ps2_keyboard_data == 8'hF0) begin
                break_pending <= 1'b1;
            end

            // Ignore the key code following F0
            else if (break_pending) begin
                break_pending    <= 1'b0;
                extended_pending <= 1'b0;
            end

            // Ignore extended keys for the basic implementation
            else if (extended_pending) begin
                extended_pending <= 1'b0;
            end

            // Enter key
            else if (ps2_keyboard_data == 8'h5A) begin
                cursor_x <= 7'd0;

                if (cursor_y == 5'd29)
                    cursor_y <= 5'd0;
                else
                    cursor_y <= cursor_y + 5'd1;
            end

            // Normal printable character
            else if (decoded_ascii != 8'h00) begin
                char_ram[cursor_addr] <= decoded_ascii;

                // Automatically wrap at the end of a line
                if (cursor_x == 7'd69) begin
                    cursor_x <= 7'd0;

                    if (cursor_y == 5'd29)
                        cursor_y <= 5'd0;
                    else
                        cursor_y <= cursor_y + 5'd1;
                end
                else begin
                    cursor_x <= cursor_x + 7'd1;
                end
            end
        end
    end

    // VGA Control part 

    wire [11:0] vga_data;
    wire [9:0] h_addr;
    wire [9:0] v_addr;
    wire valid;

    vga_ctrl u_vga_ctrl (
        .pclk(CLK25MHZ),
        .reset(reset),
        .vga_data(vga_data),
        .h_addr(h_addr),
        .v_addr(v_addr),
        .hsync(VGA_HS),
        .vsync(VGA_VS),
        .valid(valid),
        .vga_r(VGA_R),
        .vga_g(VGA_G),
        .vga_b(VGA_B)
    );
    
    // Calculate character coordinates

    wire [6:0] display_char_x;
    wire [4:0] display_char_y;

    wire [3:0] font_pixel_x;
    wire [3:0] font_pixel_y;

    assign display_char_x = h_addr / 10'd9;
    assign font_pixel_x   = h_addr % 10'd9;

    assign display_char_y = v_addr[8:4];
    assign font_pixel_y   = v_addr[3:0];

    // The remaining 10 pixels on the right are black.

    wire inside_text_area;

    assign inside_text_area =
        valid &&
        (h_addr < 10'd630) &&
        (v_addr < 10'd480);

    wire [11:0] display_char_addr;

    assign display_char_addr =
        inside_text_area
        ? display_char_y * 12'd70 + display_char_x
        : 12'd0;

    // Read the ASCII code at the current screen position
    wire [7:0] current_ascii;

    assign current_ascii =
        char_ram[display_char_addr];
        
    // get the pixel of the current char 

    wire [11:0] font_addr;

    assign font_addr =
        {current_ascii, font_pixel_y};

    wire [11:0] current_font_row;

    assign current_font_row =
        font_rom[font_addr];

    wire font_pixel_on;

    assign font_pixel_on =
        current_font_row[font_pixel_x];

    // White character on black background
    assign vga_data =
        (inside_text_area && font_pixel_on)
        ? 12'hFFF
        : 12'h000;

    clk_wiz_0 u_25mhz_clk (
        .reset(reset),
        .clk_in1(CLK100MHZ),
        .clk_out1(CLK25MHZ),
        .locked(clk_locked)
    );

endmodule

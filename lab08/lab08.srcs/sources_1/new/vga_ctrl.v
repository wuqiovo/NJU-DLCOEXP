`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/12 23:07:48
// Design Name: 
// Module Name: vga_ctrl
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

module vga_ctrl(
    input             pclk,       // 25 MHz pixel clock
    input             reset,      // Active-high reset
    input      [11:0] vga_data,   // RGB data from upper-level module

    output     [9:0]  h_addr,     // Current horizontal pixel coordinate
    output     [9:0]  v_addr,     // Current vertical pixel coordinate

    output            hsync,      // Horizontal synchronization signal
    output            vsync,      // Vertical synchronization signal
    output            valid,      // High when scanning the visible area

    output     [3:0]  vga_r,      // Red component
    output     [3:0]  vga_g,      // Green component
    output     [3:0]  vga_b       // Blue component
);

    // VGA timing parameters for 640 x 480 @ approximately 60 Hz
    parameter h_frontporch = 96;
    parameter h_active     = 144;
    parameter h_backporch  = 784;
    parameter h_total      = 800;

    parameter v_frontporch = 2;
    parameter v_active     = 35;
    parameter v_backporch  = 515;
    parameter v_total      = 525;

    // Horizontal and vertical scan counters
    reg [9:0] x_cnt;
    reg [9:0] y_cnt;

    wire h_valid;
    wire v_valid;

    // Horizontal counter
    always @(posedge reset or posedge pclk) begin
        if (reset == 1'b1)
            x_cnt <= 10'd1;
        else begin
            if (x_cnt == h_total)
                x_cnt <= 10'd1;
            else
                x_cnt <= x_cnt + 10'd1;
        end
    end

    // Vertical counter
    always @(posedge pclk) begin
        if (reset == 1'b1)
            y_cnt <= 10'd1;
        else begin
            if ((y_cnt == v_total) && (x_cnt == h_total))
                y_cnt <= 10'd1;
            else if (x_cnt == h_total)
                y_cnt <= y_cnt + 10'd1;
        end
    end

    // Synchronization signals
    assign hsync = (x_cnt > h_frontporch);
    assign vsync = (y_cnt > v_frontporch);

    // Visible-area signals
    assign h_valid =
        (x_cnt > h_active) &&
        (x_cnt <= h_backporch);

    assign v_valid =
        (y_cnt > v_active) &&
        (y_cnt <= v_backporch);

    assign valid = h_valid && v_valid;

    // Visible pixel coordinates:
    // h_addr ranges from 0 to 639
    // v_addr ranges from 0 to 479
    assign h_addr =
        h_valid ? (x_cnt - 10'd145) : 10'd0;

    assign v_addr =
        v_valid ? (y_cnt - 10'd36) : 10'd0;

    // Split 12-bit RGB data into three 4-bit color channels
    assign vga_r = vga_data[11:8];
    assign vga_g = vga_data[7:4];
    assign vga_b = vga_data[3:0];

endmodule

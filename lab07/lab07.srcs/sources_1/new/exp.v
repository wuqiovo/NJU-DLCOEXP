`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/12 11:57:53
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
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output       VGA_HS,
    output       VGA_VS,

    input        CLK100MHZ,
    input  [0:0] SW,
    output [0:0] LED
);

    wire CLK25MHZ;
    wire clk_locked;

    wire reset;
    wire system_reset;

    wire [9:0] h_addr;
    wire [9:0] v_addr;
    wire [18:0] ram_addr;
    wire [11:0] vga_data;

    wire [3:0] vga_r_raw;
    wire [3:0] vga_g_raw;
    wire [3:0] vga_b_raw;
    wire       hsync_raw;
    wire       vsync_raw;
    wire       valid_raw;

    reg hsync_d;
    reg vsync_d;
    reg valid_d;

    assign reset = SW[0];

    /*
     * Keep the VGA logic in reset until the generated clock is stable.
     * Do not connect system_reset back to the Clocking Wizard reset.
     */
    assign system_reset = reset | ~clk_locked;
    assign LED[0] = clk_locked;
    assign ram_addr = {h_addr, v_addr[8:0]};

    /*
     * Generate the 25 MHz VGA pixel clock.
     */
    clk_wiz_0 u_clk_25M (
        .clk_in1  (CLK100MHZ),
        .reset    (reset),
        .locked   (clk_locked),
        .clk_out1 (CLK25MHZ)
    );

    /*
     * 12-bit RGB444 framebuffer.
     * Width: 12 bits
     * Depth: 327680
     */
    blk_mem_gen_0 u_ram (
        .clka  (CLK25MHZ),
        .ena   (1'b1),
        .wea   (1'b0),
        .addra (ram_addr),
        .dina  (12'h000),
        .douta (vga_data)
    );

    vga_ctrl u_vga_ctrl (
        .pclk     (CLK25MHZ),
        .reset    (system_reset),
        .vga_data (vga_data),

        .h_addr   (h_addr),
        .v_addr   (v_addr),

        .hsync    (hsync_raw),
        .vsync    (vsync_raw),
        .valid    (valid_raw),

        .vga_r    (vga_r_raw),
        .vga_g    (vga_g_raw),
        .vga_b    (vga_b_raw)
    );

    /*
     * Delay control signals by one pixel clock to match
     * the one-cycle synchronous Block RAM read latency.
     */
    always @(posedge CLK25MHZ or posedge system_reset) begin
        if (system_reset) begin
            hsync_d <= 1'b1;
            vsync_d <= 1'b1;
            valid_d <= 1'b0;
        end
        else begin
            hsync_d <= hsync_raw;
            vsync_d <= vsync_raw;
            valid_d <= valid_raw;
        end
    end

    assign VGA_R = valid_d ? vga_r_raw : 4'h0;
    assign VGA_G = valid_d ? vga_g_raw : 4'h0;
    assign VGA_B = valid_d ? vga_b_raw : 4'h0;

    assign VGA_HS = hsync_d;
    assign VGA_VS = vsync_d;

endmodule
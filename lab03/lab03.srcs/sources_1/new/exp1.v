`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/06 19:44:22
// Design Name: 
// Module Name: exp1
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


module exp1(
    input [1:0] SW,
    input CLK100MHZ,
    output reg [0:0] LED,
    output reg [7:0] AN,
    output reg [7:0] HEX
    );
    
    wire clk_1HZ;
    wire ctrl; // 1 for suspend and 0 for work 
    wire rst;
    reg [5:0] Q;
    parameter count_limit = 59;
    
    assign ctrl = SW[0];
    assign rst = SW[1];
    
    clkgen #(1) clk_inst(
        .clkin(CLK100MHZ),
        .rst(rst),
        .clken(~ctrl),
        .clkout(clk_1HZ)
    );
    
    // 0~59 conuter
    always @(posedge clk_1HZ or posedge rst) begin
        if (rst) begin
            LED[0] <= 1'b0;
            Q <= 6'd0;
        end
        else begin
            if (Q >= count_limit) begin
                Q <= 6'd0;
                LED[0] <= 1'b1;
            end
            else begin
                Q <= Q + 1;
                LED[0] <= 1'b0;
            end
        end
    end 
    
    // split Q to units and tens
    wire [3:0] ones;
    wire [3:0] tens;

    assign ones = Q % 10;
    assign tens = Q / 10;
    
    // display tube
    wire [7:0] hex_ones;
    wire [7:0] hex_tens;

    bcd7seg m_bcd_ones(
        .b(ones),
        .h(hex_ones)
    );

    bcd7seg m_bcd_tens(
        .b(tens),
        .h(hex_tens)
    );
    
    // dynamic scan
    reg [16:0] scan_cnt;

    always @(posedge CLK100MHZ) begin
        if (rst) 
            scan_cnt <= 17'd0;
        else
            scan_cnt <= scan_cnt + 1'b1;
    end

    always @(*) begin
        case(scan_cnt[16])
            1'b0: begin
                AN  = 8'b11111110;   
                HEX = hex_ones;      
            end

            1'b1: begin
                AN  = 8'b11111101;   
                HEX = hex_tens;      
            end

            default: begin
                AN  = 8'b11111111;   // all off
                HEX = 8'b11111111;
            end
        endcase
    end
    
endmodule

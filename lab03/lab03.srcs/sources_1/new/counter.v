`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/06 17:00:30
// Design Name: 
// Module Name: counter
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


module counter(
	input  clk,
	input  en,
	input  rst,
	input  [3:0] cnt_limit,
	output reg [3:0] Q,
	output reg rco
	);

// add your code here
    always @ (posedge clk) begin
        if (en) begin 
            if (rst) begin
                Q <= 4'd0;
                rco <= 1'b0;
            end
            else begin
                if (Q >= cnt_limit - 1) begin
                    Q <= 4'd0;
                    rco <= 1'b1;
                end
                else begin
                    Q <= Q + 1;
                    rco <= 1'b0;
                end
            end
        end
    end
endmodule

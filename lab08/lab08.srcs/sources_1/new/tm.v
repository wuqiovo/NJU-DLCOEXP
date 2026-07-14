`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/12 21:10:35
// Design Name: 
// Module Name: tm
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

module tm (
    input  clk,
	input  [7:0] datain,
	input  reset,
	output reg [7:0] dataout,
	output reg move,
	output reg halt
	);

    //add your code here
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;
    localparam S7 = 3'b101;
    
    reg [2:0] state;
    
    always @(posedge clk) begin
        if (reset) begin
            dataout <= 8'h00;
            move <= 1'b0;
            halt <= 1'b0;
            state <= S0;
        end
        else begin
            case(state)
                S0: begin
                    if (datain == 8'h00) begin
                        state <= S7;
                        move <= 1'b0;
                        dataout <= "T";
                        halt <= 1'b1;
                    end
                    if (datain == "(") begin
                        state <= S1;
                        move <= 1'b0;
                        dataout <= 8'h0;
                        halt <= 1'b0;
                    end
                    if (datain == ")") begin
                        state <= S7;
                        move <= 1'b0;
                        dataout <= "F";
                        halt <= 1'b1;
                    end
                end
                S1: begin
                    if (datain == 8'h00) begin
                        state <= S7;
                        move <= 1'b0;
                        dataout <= "F";
                        halt <= 1'b1;
                    end
                    if (datain == "(") begin
                        state <= S1;
                        move <= 1'b0;
                        dataout <= "(";
                        halt <= 1'b0;
                    end
                    if (datain == ")") begin
                        state <= S2;
                        move <= 1'b0;
                        dataout <= ")";
                        halt <= 1'b0;
                    end
                end
                S2: begin
                    if (datain == 8'h00) begin
                        state <= S3;
                        move <= 1'b1;
                        dataout <= 8'h0;
                        halt <= 1'b0;
                    end
                    if (datain == "(") begin
                        state <= S7;
                        move <= 1'b0;
                        dataout <= "F";
                        halt <= 1'b1;
                    end
                    if (datain == ")") begin
                        state <= S2;
                        move <= 1'b0;
                        dataout <= ")";
                        halt <= 1'b0;
                    end
                end
                S3: begin
                    if (datain == ")") begin
                        state <= S4;
                        move <= 1'b1;
                        dataout <= 8'h0;
                        halt <= 1'b0;
                    end
                end
                S4: begin
                    if (datain == 8'h00) begin
                        state <= S0;
                        move <= 1'b0;
                        dataout <= 8'h0;
                        halt <= 1'b0;
                    end
                    if (datain == "(") begin
                        state <= S4;
                        move <= 1'b1;
                        dataout <= "(";
                        halt <= 1'b0;
                    end
                    if (datain == ")") begin
                        state <= S4;
                        move <= 1'b1;
                        dataout <= ")";
                        halt <= 1'b0;
                    end
                end
                S7: begin
                    halt <= 1'h1;
                end
            endcase 
        end
    end
    
endmodule
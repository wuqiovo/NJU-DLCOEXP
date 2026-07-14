`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/13 17:21:17
// Design Name: 
// Module Name: ALU
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

module alu(
    input  [31:0] dataa,
    input  [31:0] datab,
    input  [3:0]  ALUctr,
    output        less,
    output        zero,
    output reg [31:0] aluresult
);

    wire [2:0] ALUout_sel;

    wire addsub;
    wire al;
    wire lr;
    wire us;       // 1: unsigned comparison, 0: signed comparison

    wire [31:0] shifter_out;
    wire [31:0] adder_out;
    wire cf;
    wire of;

    assign ALUout_sel = ALUctr[2:0];

    assign addsub =
        (ALUctr == 4'b1000) ||
        (ALUout_sel == 3'b010);

    assign us = ALUctr[3];
    assign lr = (ALUout_sel == 3'b001);
    assign al = ALUctr[3];
    assign less = us ? cf : (adder_out[31] ^ of);

    barrel u_barrel (
        .indata  (dataa),
        .shamt   (datab[4:0]),
        .lr      (lr),
        .al      (al),
        .outdata (shifter_out)
    );

    adder u_adder (
        .A      (dataa),
        .B      (datab),
        .addsub (addsub),
        .F      (adder_out),
        .cf     (cf),
        .zero   (zero),
        .of     (of)
    );

    always @(*) begin
        case (ALUout_sel)
            3'b000: aluresult = adder_out;
            3'b001: aluresult = shifter_out;
            3'b010: aluresult = {31'b0, less};
            3'b011: aluresult = datab;
            3'b100: aluresult = dataa ^ datab;
            3'b101: aluresult = shifter_out;
            3'b110: aluresult = dataa | datab;
            3'b111: aluresult = dataa & datab;
            default: aluresult = 32'b0;
        endcase
    end

endmodule

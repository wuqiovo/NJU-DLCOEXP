`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/06 17:53:25
// Design Name: 
// Module Name: alu_top
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


module top_alu(
    input  [10:0] SW,
    output [7:0] HEX,
    output [7:0] AN,
    output [2:0] LED
);

    wire [3:0] A;
    wire [3:0] B;
    wire [2:0] ALUctr;

    wire [3:0] F;
    wire cf;
    wire zero;
    wire of;

    assign A      = SW[3:0];
    assign B      = SW[7:4];
    assign ALUctr = SW[10:8];

    alu_s alu_inst(
        .A(A),
        .B(B),
        .ALUctr(ALUctr),
        .F(F),
        .cf(cf),
        .zero(zero),
        .of(of)
    );

    // only use the far right display tube
    assign AN = 8'b1111_1110;

    //  LED for sign
    assign LED[0] = cf;
    assign LED[1] = zero;
    assign LED[2] = of;

    hex7seg hex_inst(
        .x(F),
        .HEX(HEX)
    );

endmodule
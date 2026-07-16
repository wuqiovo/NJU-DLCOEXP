`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/05 17:12:35
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


module alu_s( input [3:0] A,
			  input [3:0] B,
			  input [2:0] ALUctr,
			  output reg [3:0] F,
			  output wire cf,
			  output wire zero,
			  output wire of
);

    wire [3:0] Adder_F;
    wire Adder_addsub;
    wire Adder_cf;
    wire Adder_zero;
    wire Adder_of;
    wire less;
    
    assign Adder_addsub = (ALUctr == 3'b001)
                        || (ALUctr == 3'b110) 
                        || (ALUctr == 3'b111);
    
    Adder4 adder(
        .A(A),
        .B(B),
        .addsub(Adder_addsub),
        .F(Adder_F),
        .cf(Adder_cf),
        .zero(Adder_zero),
        .of(Adder_of)
    );
    
    assign less = Adder_F[3] ^ Adder_of;
    
    always @(*) begin 
        case(ALUctr) 
            3'b000: F = Adder_F;
            3'b001: F = Adder_F;
            3'b010: F = ~A;
            3'b011: F = A & B;
            3'b100: F = A | B;
            3'b101: F = A ^ B;
            3'b110: F = {3'b000, less};
            3'b111: F = {3'b000, Adder_zero};
            default: F = 4'b0000;
        endcase
    end
    
    assign cf = (ALUctr == 3'b000 || ALUctr == 3'b001) ? Adder_cf : 1'b0;
    assign of = (ALUctr == 3'b000 || ALUctr == 3'b001) ? Adder_of : 1'b0;
    
    // zero is related to the final result of ALU
    // not the result of Adder
    // which is different from the design of last semester 
    assign zero = ~(|F); 

endmodule

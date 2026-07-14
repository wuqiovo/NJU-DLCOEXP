`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/13 22:10:37
// Design Name: 
// Module Name: jump_ctrl
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


module jump_ctrl(
    input  wire [2:0] Branch,
    input  wire       zero,
    input  wire       less,
    output reg        PCAsrc,
    output reg        PCBsrc
    );

    always @(*) begin
        // Default path for non-branch instructions: PC + 4.
        PCAsrc = 1'b0;
        PCBsrc = 1'b0;

        case (Branch)
            3'b000: begin
                // Sequential execution: PC + 4.
                PCAsrc = 1'b0;
                PCBsrc = 1'b0;
            end

            3'b001: begin
                // JAL: PC + immJ.
                PCAsrc = 1'b1;
                PCBsrc = 1'b0;
            end

            3'b010: begin
                // JALR: rs1 + immI.
                PCAsrc = 1'b1;
                PCBsrc = 1'b1;
            end

            3'b100: begin
                // BEQ: branch when rs1 equals rs2.
                if (zero == 1'b1)
                    PCAsrc = 1'b1;
            end

            3'b101: begin
                // BNE: branch when rs1 does not equal rs2.
                if (zero == 1'b0)
                    PCAsrc = 1'b1;
            end

            3'b110: begin
                // BLT/BLTU: branch when rs1 is less than rs2.
                if (less == 1'b1)
                    PCAsrc = 1'b1;
            end

            3'b111: begin
                // BGE/BGEU: branch when rs1 is not less than rs2.
                if (less == 1'b0)
                    PCAsrc = 1'b1;
            end

            default: begin
                PCAsrc = 1'b0;
                PCBsrc = 1'b0;
            end
        endcase
    end

endmodule

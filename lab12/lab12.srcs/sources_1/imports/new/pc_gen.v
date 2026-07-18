`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/13 22:10:57
// Design Name: 
// Module Name: pc_gen
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


module pc_gen(
    input  wire [31:0] pc,
    input  wire [31:0] imm,
    input  wire [31:0] rs1_data,
    input  wire        PCAsrc,
    input  wire        PCBsrc,
    output wire [31:0] nextpc
    );

    wire [31:0] pc_adder_a;
    wire [31:0] pc_adder_b;
    wire [31:0] pc_sum;

    // Select constant 4 for sequential execution or the branch immediate.
    assign pc_adder_a = PCAsrc ? imm : 32'd4;

    // Select the current PC as the normal base or rs1 as the JALR base.
    assign pc_adder_b = PCBsrc ? rs1_data : pc;

    assign pc_sum = pc_adder_a + pc_adder_b;

    // PCBsrc is asserted only for JALR. RISC-V requires the target
    // address bit 0 to be cleared for JALR.
    assign nextpc = PCBsrc ? {pc_sum[31:1], 1'b0} : pc_sum;

endmodule

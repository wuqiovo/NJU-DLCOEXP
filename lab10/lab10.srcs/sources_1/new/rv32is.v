`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/13 20:39:32
// Design Name: 
// Module Name: rv32is
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

module rv32is(
	input  clock,
	input  reset,
	output [31:0] imemaddr,
	input  [31:0] imemdataout,
	output imemclk,
	output [31:0] dmemaddr,
	input  [31:0] dmemdataout,
	output [31:0] dmemdatain,
	output dmemrdclk,
	output dmemwrclk,
	output [2:0] dmemop,
	output dmemwe,
	output [31:0] dbgdata
    );
    
    // Clock 
    assign imemclk  = ~clock;
    assign dmemrdclk = clock;
    assign dmemwrclk = ~clock;
    
    // Reg data 
    wire [31:0] writeback_data;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    
    // Control signal
    wire [2:0] ExtOP; 
    wire RegWr;
    wire ALUAsrc;
    wire [1:0] ALUBsrc;
    wire [3:0] ALUctr;
    wire [2:0] Branch;
    wire MemtoReg;
    wire MemWr;
    wire [2:0] MemOP;
    
    // PC register 
    reg     [31:0] pc;
    wire    [31:0] nextpc;
    
    // Instruction data 
    wire [31:0] instr = imemdataout;
    wire [31:0] imm;
    
    // PC jumping signal 
    wire PCAsrc;
    wire PCBsrc;
    
    // ALU source 
    wire [31:0] alu_dataa;
    wire [31:0] alu_datab;
    assign alu_dataa = ALUAsrc ? pc : rs1_data;
    assign alu_datab =
        (ALUBsrc == 2'b00) ? rs2_data :
        (ALUBsrc == 2'b01) ? imm      :
        (ALUBsrc == 2'b10) ? 32'd4    :
                             32'b0;
                             
    // ALU result  
    wire less;
    wire zero;   
    wire [31:0] alu_result;                      

    always @(negedge clock or posedge reset) begin
        if (reset)
            pc <= 32'b0;
        else
            pc <= nextpc;
    end
    
    assign dbgdata = pc;
    
    // Instruction address 
    assign imemaddr = reset ? 32'b0 : nextpc;    
    
    RegFile myregfile (
        .Ra    (instr[19:15]),
        .Rb    (instr[24:20]),
        .Rw    (instr[11:7]),
        .busW  (writeback_data),
        .RegWr (RegWr & ~reset),
        .WrClk (clock),
        .busA  (rs1_data),
        .busB  (rs2_data)
    );    
    
    imm_gen u_imm_gen (
        .instr (instr),
        .ExtOP (ExtOP),
        .imm   (imm)
    );
    
    alu u_alu (
        .dataa     (alu_dataa),
        .datab     (alu_datab),
        .ALUctr    (ALUctr),
        .less      (less),
        .zero      (zero),
        .aluresult (alu_result)
    );    
    
    // WriteBack Choice 
    assign writeback_data = MemtoReg ? dmemdataout : alu_result;
    
    jump_ctrl u_jump_ctrl (
        .Branch (Branch),
        .zero   (zero),
        .less   (less),
        .PCAsrc (PCAsrc),
        .PCBsrc (PCBsrc)
    );

    pc_gen u_pc_gen (
        .pc       (pc),
        .imm      (imm),
        .rs1_data (rs1_data),
        .PCAsrc   (PCAsrc),
        .PCBsrc   (PCBsrc),
        .nextpc   (nextpc)
    );
    
    controller u_ctrl (
        .instr      (instr),
        .ExtOP      (ExtOP),
        .RegWr      (RegWr),
        .ALUAsrc    (ALUAsrc),
        .ALUBsrc    (ALUBsrc),
        .ALUctr     (ALUctr),
        .Branch     (Branch),
        .MemtoReg   (MemtoReg),
        .MemWr      (MemWr),
        .MemOP      (MemOP)
    );
    
    // DataMem Interface 
    assign dmemaddr   = alu_result;
    assign dmemdatain = rs2_data;
    assign dmemop     = MemOP;
    assign dmemwe     = MemWr & ~reset;
    
endmodule

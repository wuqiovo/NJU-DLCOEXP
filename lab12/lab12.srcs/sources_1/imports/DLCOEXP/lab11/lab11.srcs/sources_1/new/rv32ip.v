`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/15 13:24:07
// Design Name: 
// Module Name: rv32ip
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

module rv32ip(
	input          clock,
	input          reset,
	output [31:0]  imemaddr,
	input  [31:0]  imemdataout,
	output         imemclk,
	output [31:0]  dmemaddr,
	input  [31:0]  dmemdataout,
	output [31:0]  dmemdatain,
	output         dmemrdclk,
	output         dmemwrclk,
	output [2:0]   dmemop,
	output         dmemwe,
	output [31:0]  dbgdata
	);

    // Clock definition  
    assign imemclk = clock;
    assign dmemrdclk = clock;
    assign dmemwrclk = ~clock;
    
    wire [31:0] instr;
    
    // IF declaration  
    reg [31:0] IF_PC;
    wire [31:0] IF_instr = imemdataout;
    
    // ID declaration 
    wire [31:0] ID_PC;
    wire [31:0] ID_instr;
    wire [2:0]  ID_ExtOP;
    wire        ID_RegWr;
    wire        ID_ALUAsrc;
    wire [1:0]  ID_ALUBsrc;
    wire [3:0]  ID_ALUctr;
    wire [2:0]  ID_Branch;
    wire        ID_MemtoReg;
    wire        ID_MemWr;
    wire [2:0]  ID_MemOP;
    wire [31:0] ID_imm;
    wire [4:0]  ID_rs1;
    wire [4:0]  ID_rs2;
    wire [4:0]  ID_rd;
    wire [31:0] ID_rs1_data;
    wire [31:0] ID_rs2_data;
    wire [9:0]  ID_ex_ctrl;
    wire [3:0]  ID_mem_ctrl;
    wire [1:0]  ID_wb_ctrl;
    
    wire stall_rs1_we;
    wire stall_rs2_we;
    
    // Whether the instruction really uses rs1/rs2
    wire ID_use_rs1;
    wire ID_use_rs2;
    
    // EX declaration 
    wire [31:0] EX_PC;
    wire [31:0] EX_imm;
    wire [31:0] EX_rs1_data;
    wire [31:0] EX_rs2_data;
    wire [31:0] EX_rs1_data_final;
    wire [31:0] EX_rs2_data_final;
    wire [1:0]  EX_rs1_sel;
    wire [1:0]  EX_rs2_sel;
    wire [4:0]  EX_rs1;
    wire [4:0]  EX_rs2;
    wire [4:0]  EX_rd;
    wire        EX_use_rs1;
    wire        EX_use_rs2;
    wire [9:0]  EX_ex_ctrl;
    wire [3:0]  EX_mem_ctrl;
    wire [1:0]  EX_wb_ctrl;
    wire        load_use_stall;
    wire        stallIF;
    wire        stallID;
    wire        stallEX;
    wire        flushEX;
    wire        EX_PCSrc;
    wire [2:0]  EX_Branch;
    wire        EX_Branchsel;
    wire        flushIF;
    wire        flushID;
    wire [31:0] EX_redirect_addr;
    wire [31:0] EX_alu_dataa;
    wire [31:0] EX_alu_datab;
    wire        EX_ALUAsrc;
    wire [1:0]  EX_ALUBsrc;
    wire [3:0]  EX_ALUctr;
    wire        EX_less;
    wire        EX_zero;
    wire [31:0] EX_ALUResult;
    
    // MEM declaration 
    wire [4:0]  MEM_rd;
    wire        MEM_RegWr;
    wire        MEM_MemtoReg;
    wire        MEM_MemWr;
    wire [2:0]  MEM_MemOp;
    wire [31:0] MEM_rs2_data;
    wire [31:0] MEM_ALUResult;
    wire [3:0]  MEM_mem_ctrl;
    wire [1:0]  MEM_wb_ctrl;
    wire [31:0] MEM_MemOut;
    
    // WB declaration 
    wire [31:0] WB_ALUResult;
    wire [31:0] WB_MemOut;
    wire [4:0]  WB_rd;
    wire [1:0]  WB_wb_ctrl;
    wire        WB_RegWr;
    wire        WB_MemtoReg;
    wire [31:0] WB_writeback_data;
    
    assign instr = ID_instr;
    
    // IF part 
    always @(negedge clock or posedge reset) begin
        if (reset)
            IF_PC <= 32'b0;
        else if (stallIF)
            IF_PC <= IF_PC;
        else if (EX_PCSrc)
            IF_PC <= EX_redirect_addr;
        else
            IF_PC <= IF_PC + 32'd4;
    end
    
    assign dbgdata = IF_PC;
    assign imemaddr = IF_PC;
    
    if_id_reg u_ifid_reg (
        .clock      (clock),
        .reset      (reset),
        .stall      (stallID),
        .flush      (flushIF),
        .pc_in      (IF_PC),
        .instr_in   (IF_instr),
        .pc_out     (ID_PC),
        .instr_out  (ID_instr)
    );
    
    // ID part 
    assign stall_rs1_we =
        load_use_stall && (EX_rs1_sel == 2'b01);

    assign stall_rs2_we =
        load_use_stall && (EX_rs2_sel == 2'b01);
    
    assign ID_rs1 = ID_instr[19:15];
    assign ID_rs2 = ID_instr[24:20];
    assign ID_rd  = ID_instr[11:7];
    
    assign ID_use_rs1 =
        (ID_instr[6:0] == 7'b0010011) || // OP-IMM
        (ID_instr[6:0] == 7'b0110011) || // OP
        (ID_instr[6:0] == 7'b1100111) || // JALR
        (ID_instr[6:0] == 7'b1100011) || // BRANCH
        (ID_instr[6:0] == 7'b0000011) || // LOAD
        (ID_instr[6:0] == 7'b0100011);   // STORE

    assign ID_use_rs2 =
        (ID_instr[6:0] == 7'b0110011) || // OP
        (ID_instr[6:0] == 7'b1100011) || // BRANCH
        (ID_instr[6:0] == 7'b0100011);   // STORE
    
    // [9:7] Branch
    // [6]   ALUAsrc
    // [5:4] ALUBsrc
    // [3:0] ALUctr
    assign ID_ex_ctrl = {
        ID_Branch,
        ID_ALUAsrc,
        ID_ALUBsrc,
        ID_ALUctr
    };

    // [3]   MemWr
    // [2:0] MemOP
    assign ID_mem_ctrl = {
        ID_MemWr,
        ID_MemOP
    };

    // [1] RegWr
    // [0] MemtoReg
    assign ID_wb_ctrl = {
        ID_RegWr,
        ID_MemtoReg
    };
    
    controller u_controller (
        .instr      (ID_instr),
        .ExtOP      (ID_ExtOP),
        .RegWr      (ID_RegWr),
        .ALUAsrc    (ID_ALUAsrc),
        .ALUBsrc    (ID_ALUBsrc),
        .ALUctr     (ID_ALUctr),
        .Branch     (ID_Branch),
        .MemtoReg   (ID_MemtoReg),
        .MemWr      (ID_MemWr),
        .MemOP      (ID_MemOP)
    );
    
    imm_gen u_imm_gen (
        .instr  (ID_instr),
        .ExtOP  (ID_ExtOP),
        .imm    (ID_imm)
    );

    RegFile myregfile (
        .Ra    (ID_rs1),
        .Rb    (ID_rs2),
        .busA  (ID_rs1_data),
        .busB  (ID_rs2_data),
        .Rw    (WB_rd),
        .busW  (WB_writeback_data),
        .RegWr (WB_RegWr && !reset),
        .WrClk (~clock)
    );
    
    id_ex_reg u_id_ex_reg (
        .clock          (clock),
        .reset          (reset),
        .stall          (stallEX),
        .flush          (flushID),
        
        .pc_in          (ID_PC),
        .imm_in         (ID_imm),
        .rs1_data_in    (ID_rs1_data),
        .rs2_data_in    (ID_rs2_data),
        .rs1_in         (ID_rs1),
        .rs2_in         (ID_rs2),
        .rd_in          (ID_rd),
        .use_rs1_in     (ID_use_rs1),
        .use_rs2_in     (ID_use_rs2),

        .ex_ctrl_in     (ID_ex_ctrl),
        .mem_ctrl_in    (ID_mem_ctrl),
        .wb_ctrl_in     (ID_wb_ctrl),
        .stall_rs1_we   (stall_rs1_we),
        .stall_rs2_we   (stall_rs2_we),
        .stall_rs1_data (WB_writeback_data),
        .stall_rs2_data (WB_writeback_data),
        .pc_out         (EX_PC),
        .imm_out        (EX_imm),
        .rs1_data_out   (EX_rs1_data),
        .rs2_data_out   (EX_rs2_data),
        .rs1_out        (EX_rs1),
        .rs2_out        (EX_rs2),
        .rd_out         (EX_rd),
        .use_rs1_out    (EX_use_rs1),
        .use_rs2_out    (EX_use_rs2),
        .ex_ctrl_out    (EX_ex_ctrl),
        .mem_ctrl_out   (EX_mem_ctrl),
        .wb_ctrl_out    (EX_wb_ctrl)
    );
    
    // EX part 
    assign EX_Branch  = EX_ex_ctrl[9:7];
    assign EX_ALUAsrc = EX_ex_ctrl[6];
    assign EX_ALUBsrc = EX_ex_ctrl[5:4];
    assign EX_ALUctr  = EX_ex_ctrl[3:0];
    
    assign EX_rs1_data_final = 
            (EX_rs1_sel == 2'b00) ? EX_rs1_data :
            (EX_rs1_sel == 2'b01) ? WB_writeback_data :
                                    MEM_ALUResult;
    
    assign EX_rs2_data_final = 
            (EX_rs2_sel == 2'b00) ? EX_rs2_data :
            (EX_rs2_sel == 2'b01) ? WB_writeback_data :
                                    MEM_ALUResult;
    
    assign EX_alu_dataa = 
            EX_ALUAsrc ? EX_PC : EX_rs1_data_final;
            
    assign EX_alu_datab =
      (EX_ALUBsrc == 2'b00) ? EX_rs2_data_final :
      (EX_ALUBsrc == 2'b01) ? EX_imm            :
      (EX_ALUBsrc == 2'b10) ? 32'd4             :
                              32'b0;
    
    alu u_alu (
        .dataa     (EX_alu_dataa),
        .datab     (EX_alu_datab),
        .ALUctr    (EX_ALUctr),
        .less      (EX_less),
        .zero      (EX_zero),
        .aluresult (EX_ALUResult)
    );
  
    forward_unit u_forward_unit (
        .EX_rs1         (EX_rs1),
        .EX_rs2         (EX_rs2),
        .EX_use_rs1     (EX_use_rs1),
        .EX_use_rs2     (EX_use_rs2),
        .MEM_rd         (MEM_rd),
        .MEM_RegWr      (MEM_RegWr),
        .MEM_MemtoReg   (MEM_MemtoReg),
        .WB_rd          (WB_rd),
        .WB_RegWr       (WB_RegWr),
        .rs1_sel        (EX_rs1_sel),
        .rs2_sel        (EX_rs2_sel)
    );
    
    stall_unit u_stall_unit (
        .EX_rs1         (EX_rs1),
        .EX_rs2         (EX_rs2),
        .EX_use_rs1     (EX_use_rs1),
        .EX_use_rs2     (EX_use_rs2),
        .MEM_rd         (MEM_rd),
        .MEM_RegWr      (MEM_RegWr),
        .MEM_MemtoReg   (MEM_MemtoReg),
        .load_use_stall (load_use_stall),
        .stallIF        (stallIF),
        .stallID        (stallID),
        .stallEX        (stallEX),
        .flushEX        (flushEX)
    );
    
    Branch_unit u_branch_unit (
        .Branch    (EX_Branch),
        .zero      (EX_zero),
        .less      (EX_less),
        .Branchsel (EX_Branchsel),
        .PCSrc     (EX_PCSrc),
        .flushIF   (flushIF),
        .flushID   (flushID)
    );
    
    pc_gen u_pc_gen (
        .pc       (EX_PC),
        .imm      (EX_imm),
        .rs1_data (EX_rs1_data_final),
        .PCAsrc   (EX_PCSrc),
        .PCBsrc   (EX_Branchsel),
        .nextpc   (EX_redirect_addr)
    );
    
    ex_mem_reg u_ex_mem_reg (
        .clock          (clock),
        .reset          (reset),
        .flush          (flushEX),
        
        .alu_result_in  (EX_ALUResult),
        .rs2_data_in    (EX_rs2_data_final),
        .rd_in          (EX_rd),
        .mem_ctrl_in    (EX_mem_ctrl),
        .wb_ctrl_in     (EX_wb_ctrl),
        
        .alu_result_out (MEM_ALUResult),
        .rs2_data_out   (MEM_rs2_data),
        .rd_out         (MEM_rd),
        .mem_ctrl_out   (MEM_mem_ctrl),
        .wb_ctrl_out    (MEM_wb_ctrl)
    );
    
    // MEM part     
    assign MEM_MemWr = MEM_mem_ctrl[3];
    assign MEM_MemOp = MEM_mem_ctrl[2:0];
    assign {MEM_RegWr, MEM_MemtoReg} = MEM_wb_ctrl;
    
    assign dmemaddr = MEM_ALUResult;
    assign dmemop = MEM_MemOp;
    assign dmemdatain = MEM_rs2_data;
    assign dmemwe = MEM_MemWr && !reset;
    assign MEM_MemOut = dmemdataout;
    
    mem_wb_reg u_mem_wb_reg (
        .clock          (clock),
        .reset          (reset),
        
        .alu_result_in  (MEM_ALUResult),
        .mem_out_in     (MEM_MemOut),
        .rd_in          (MEM_rd),
        .wb_ctrl_in     (MEM_wb_ctrl),
        
        .alu_result_out (WB_ALUResult),
        .mem_out_out    (WB_MemOut),
        .rd_out         (WB_rd),
        .wb_ctrl_out    (WB_wb_ctrl)
    );
    
    // WB part 
    assign WB_RegWr    = WB_wb_ctrl[1];
    assign WB_MemtoReg = WB_wb_ctrl[0];
    
    assign WB_writeback_data =
        WB_MemtoReg ? WB_MemOut : WB_ALUResult;
    
endmodule

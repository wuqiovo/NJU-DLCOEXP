`timescale 1ns / 1ps

// Load-use hazard detector.
//
// When a load is in MEM and the instruction in EX consumes its destination,
// the load data is not ready early enough for MEM->EX forwarding.  IF, ID and
// EX are held for one cycle, while EX/MEM is flushed to insert a bubble.

module stall_unit(
    input  wire [4:0] EX_rs1,
    input  wire [4:0] EX_rs2,
    input  wire       EX_use_rs1,
    input  wire       EX_use_rs2,

    input  wire [4:0] MEM_rd,
    input  wire       MEM_RegWr,
    input  wire       MEM_MemtoReg,

    output wire       load_use_stall,
    output wire       stallIF,
    output wire       stallID,
    output wire       stallEX,
    output wire       flushEX
    );

    wire rs1_hazard;
    wire rs2_hazard;

    assign rs1_hazard = EX_use_rs1 && (MEM_rd == EX_rs1);
    assign rs2_hazard = EX_use_rs2 && (MEM_rd == EX_rs2);

    assign load_use_stall = MEM_MemtoReg && MEM_RegWr &&
                            (MEM_rd != 5'b0) &&
                            (rs1_hazard || rs2_hazard);

    assign stallIF = load_use_stall;
    assign stallID = load_use_stall;
    assign stallEX = load_use_stall;
    assign flushEX = load_use_stall;

endmodule

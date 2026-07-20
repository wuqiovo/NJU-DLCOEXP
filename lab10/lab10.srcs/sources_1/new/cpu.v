`timescale 1ns / 1ps

// rv32is contains the processor datapath/control path. 
// Debug ports are read-only and do not affect CPU execution.

module cpu #(
    parameter IMEM_INIT_FILE = "",
    parameter [31:0] INPUT_N_ADDR    = 32'hFFFF_0000,
    parameter [31:0] FIB_RESULT_ADDR = 32'hFFFF_0004
)(
    input  wire        clock,
    input  wire        reset,
    input  wire [31:0] external_n,

    output reg  [31:0] fib_result,
    output reg         fib_valid,

    output wire [31:0] dbg_pc,
    output wire [31:0] dbg_instr,
    output wire [31:0] dbg_dmem_addr,
    output wire [31:0] dbg_dmem_wdata,
    output wire [31:0] dbg_dmem_rdata
    );

    wire [31:0] imem_addr;
    wire [31:0] imem_dataout;
    wire        imem_clk;

    wire [31:0] dmem_addr;
    wire [31:0] core_dmem_dataout;
    wire [31:0] ram_dmem_dataout;
    wire [31:0] dmem_datain;
    wire        dmem_rdclk;
    wire        dmem_wrclk;
    wire [2:0]  dmem_op;
    wire        dmem_we;
    wire [31:0] core_dbgdata;

    wire access_input;
    wire access_output;
    wire access_io;
    wire ram_we;

    assign access_input  = (dmem_addr == INPUT_N_ADDR);
    assign access_output = (dmem_addr == FIB_RESULT_ADDR);
    assign access_io     = access_input | access_output;

    // Memory-mapped input. Reads from ordinary addresses still come from RAM.
    assign core_dmem_dataout = access_input ? external_n :
                               access_output ? 32'b0 :
                                               ram_dmem_dataout;

    // MMIO stores must not also modify the aliased location in data RAM.
    assign ram_we = dmem_we & ~access_io;

    rv32is core (
        .clock       (clock),
        .reset       (reset),
        .imemaddr    (imem_addr),
        .imemdataout (imem_dataout),
        .imemclk     (imem_clk),
        .dmemaddr    (dmem_addr),
        .dmemdataout (core_dmem_dataout),
        .dmemdatain  (dmem_datain),
        .dmemrdclk   (dmem_rdclk),
        .dmemwrclk   (dmem_wrclk),
        .dmemop      (dmem_op),
        .dmemwe      (dmem_we),
        .dbgdata     (core_dbgdata)
    );

    // The instruction memory is word-addressed.  The low two byte-address
    // bits are discarded; bits [17:2] address all 64K instruction words.
    imem #(
        .INIT_FILE (IMEM_INIT_FILE)
    ) instructions (
        .address (imem_addr[17:2]),
        .clock   (imem_clk),
        .dataout (imem_dataout)
    );

    dmem datamem (
        .addr    (dmem_addr),
        .dataout (ram_dmem_dataout),
        .datain  (dmem_datain),
        .rdclk   (dmem_rdclk),
        .wrclk   (dmem_wrclk),
        .memop   (dmem_op),
        .we      (ram_we)
    );

    // A store to FIB_RESULT_ADDR is the program's output operation.
    always @(posedge dmem_wrclk) begin
        if (reset) begin
            fib_result <= 32'b0;
            fib_valid  <= 1'b0;
        end
        else if (dmem_we && access_output) begin
            fib_result <= dmem_datain;
            fib_valid  <= 1'b1;
        end
    end

    assign dbg_pc         = core_dbgdata;
    assign dbg_instr      = imem_dataout;
    assign dbg_dmem_addr  = dmem_addr;
    assign dbg_dmem_wdata = dmem_datain;
    assign dbg_dmem_rdata = core_dmem_dataout;

endmodule

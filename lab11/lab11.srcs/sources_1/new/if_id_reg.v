`timescale 1ns / 1ps

// IF/ID pipeline register
// Stored state: PC + instruction = 64 bits.
module if_id_reg(
    input  wire        clock,
    input  wire        reset,
    input  wire        stall,
    input  wire        flush,
    
    input  wire [31:0] pc_in,
    input  wire [31:0] instr_in,
    output reg  [31:0] pc_out,
    output reg  [31:0] instr_out
    );

    // A pipeline cycle starts and ends on the falling edge.
    // Stall has priority over flush: an instruction waiting for data must
    // remain in this stage until the hazard disappears.
    always @(negedge clock) begin
        if (reset) begin
            pc_out    <= 32'b0;
            instr_out <= 32'b0;
        end
        else if (stall) begin
            pc_out    <= pc_out;
            instr_out <= instr_out;
        end
        else if (flush) begin
            pc_out    <= 32'b0;
            instr_out <= 32'b0;
        end
        else begin
            pc_out    <= pc_in;
            instr_out <= instr_in;
        end
    end

endmodule

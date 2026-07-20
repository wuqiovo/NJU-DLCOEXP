`timescale 1ns / 1ps

// MEM/WB pipeline register
// Stored state: ALU result + memory output + rd + WB controls = 71 bits.
module mem_wb_reg(
    input  wire        clock,
    input  wire        reset,
    
    input  wire [31:0] alu_result_in,
    input  wire [31:0] mem_out_in,
    input  wire [4:0]  rd_in,
    input  wire [1:0]  wb_ctrl_in,
    
    output reg  [31:0] alu_result_out,
    output reg  [31:0] mem_out_out,
    output reg  [4:0]  rd_out,
    output reg  [1:0]  wb_ctrl_out
    );

    always @(negedge clock) begin
        if (reset) begin
            alu_result_out <= 32'b0;
            mem_out_out    <= 32'b0;
            rd_out         <= 5'b0;
            wb_ctrl_out    <= 2'b0;
        end
        else begin
            alu_result_out <= alu_result_in;
            mem_out_out    <= mem_out_in;
            rd_out         <= rd_in;
            wb_ctrl_out    <= wb_ctrl_in;
        end
    end

endmodule

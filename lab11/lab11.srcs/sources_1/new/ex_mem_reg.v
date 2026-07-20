`timescale 1ns / 1ps

// EX/MEM pipeline register
// Stored state: ALU result + store data + rd + MEM/WB controls = 75 bits.
module ex_mem_reg(
    input  wire        clock,
    input  wire        reset,
    input  wire        flush,
    
    input  wire [31:0] alu_result_in,
    input  wire [31:0] rs2_data_in,
    input  wire [4:0]  rd_in,
    input  wire [3:0]  mem_ctrl_in,
    input  wire [1:0]  wb_ctrl_in,
    
    output reg  [31:0] alu_result_out,
    output reg  [31:0] rs2_data_out,
    output reg  [4:0]  rd_out,
    output reg  [3:0]  mem_ctrl_out,
    output reg  [1:0]  wb_ctrl_out
    );

    always @(negedge clock) begin
        if (reset) begin
            alu_result_out <= 32'b0;
            rs2_data_out   <= 32'b0;
            rd_out         <= 5'b0;
            mem_ctrl_out   <= 4'b0;
            wb_ctrl_out    <= 2'b0;
        end
        else if (flush) begin
            // Used by load-use handling to insert one bubble after EX.
            alu_result_out <= 32'b0;
            rs2_data_out   <= 32'b0;
            rd_out         <= 5'b0;
            mem_ctrl_out   <= 4'b0;
            wb_ctrl_out    <= 2'b0;
        end
        else begin
            alu_result_out <= alu_result_in;
            rs2_data_out   <= rs2_data_in;
            rd_out         <= rd_in;
            mem_ctrl_out   <= mem_ctrl_in;
            wb_ctrl_out    <= wb_ctrl_in;
        end
    end

endmodule

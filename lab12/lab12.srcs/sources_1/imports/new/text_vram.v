`timescale 1ns / 1ps

// Simple dual-port character memory.
// Port A is written by terminal_ctrl at 100 MHz. Port B is synchronously read
// by text_renderer at the 25 MHz pixel clock. The 4096-entry depth avoids an
// awkward non-power-of-two RAM while only addresses 0..2099 are displayed.
module text_vram (
    input  wire        wr_clk,
    input  wire        wr_en,
    input  wire [11:0] wr_addr,
    input  wire [7:0]  wr_data,

    input  wire        rd_clk,
    input  wire [11:0] rd_addr,
    output reg  [7:0]  rd_data
    );

    (* ram_style = "block" *) reg [7:0] ram [0:4095];

    always @(posedge wr_clk) begin
        if (wr_en)
            ram[wr_addr] <= wr_data;
    end

    always @(posedge rd_clk) begin
        rd_data <= ram[rd_addr];
    end

endmodule

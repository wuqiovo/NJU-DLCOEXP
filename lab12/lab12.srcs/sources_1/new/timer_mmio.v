`timescale 1ns / 1ps

module timer_mmio #(
    parameter integer CYCLES_PER_MS = 25000
)(
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] addr,
    output reg  [31:0] rdata
);
    
    reg [14:0] ms_divider;
    reg [31:0] timer_ms;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ms_divider <= 15'd0;
            timer_ms   <= 32'd0;
        end
        else if (ms_divider == CYCLES_PER_MS - 1) begin
            ms_divider <= 15'd0;
            timer_ms   <= timer_ms + 32'd1;
        end
        else begin
            ms_divider <= ms_divider + 15'd1;
        end
    end
    
    always @(*) begin
        if (addr == 32'h0040_0000)
            rdata = timer_ms;
        else
            rdata = 32'b0;
    end
    
endmodule

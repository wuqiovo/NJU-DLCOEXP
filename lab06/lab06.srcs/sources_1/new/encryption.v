`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/10 21:48:13
// Design Name: 
// Module Name: encryption
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

module encryption(
    input  [63:0] seed,
    input         clk,
    input         load,
    input  [7:0]  datain,
    output reg    ready,
    output [7:0]  dataout
);

    reg [63:0] lfsr;
    reg [2:0]  cnt;
    
    lfsr u_lfsr (
        .clk(clk),
        .seed(seed),
        .load(load),
        .dout(lfsr)
    );
    
    assign dataout = {2'b01, lfsr[63:58] ^ datain[5:0]};
    
    always @(posedge clk) begin
        if (load) begin
            cnt <= 3'd0;
            ready <= 1'b0;
        end
        else begin
            if (cnt == 3'd5) begin
                cnt <= 3'd0;
                ready <= 1'b1;
            end
            else begin
                cnt <= cnt + 1;
            end
        end
    end    

endmodule
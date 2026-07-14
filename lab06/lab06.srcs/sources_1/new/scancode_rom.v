`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/11 00:31:06
// Design Name: 
// Module Name: scancode_rom
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

module scancode_rom (
    input  [7:0] scancode,
    output [7:0] ascii
);

    reg [7:0] rom [255:0];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            rom[i] = 8'h00;
        end

        $readmemh("D:/DLCOEXP/lab06/scancode_ascii.mem", rom);
    end

    assign ascii = rom[scancode];

endmodule
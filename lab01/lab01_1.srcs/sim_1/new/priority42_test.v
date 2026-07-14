
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/02 22:52:11
// Design Name: 
// Module Name: priority42_test
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


`timescale 10ns / 1ps

module test_priority42();

    reg [3:0] x;
    reg en;
    wire [1:0] y;
    wire valid;

    priority42 i1 (
        .x(x),
        .en(en),
        .y(y),
        .valid(valid)
    );

    initial begin
        en = 1'b0; x = 4'b0000; #10;
                   x = 4'b0001; #10;
                   x = 4'b0010; #10;
                   x = 4'b0100; #10;
                   x = 4'b1000; #10;
                   x = 4'b1111; #10;

        en = 1'b1; x = 4'b0000; #10;

        // 测试只有一位为 1 的情况
        x = 4'b0001; #10;   // y 应为 0，valid 应为 1
        x = 4'b0010; #10;   // y 应为 1，valid 应为 1
        x = 4'b0100; #10;   // y 应为 2，valid 应为 1
        x = 4'b1000; #10;   // y 应为 3，valid 应为 1

        // 测试多位同时为 1 的情况，高位优先
        x = 4'b0011; #10;   // x[1] 优先，y 应为 1
        x = 4'b0110; #10;   // x[2] 优先，y 应为 2
        x = 4'b1010; #10;   // x[3] 优先，y 应为 3
        x = 4'b1111; #10;   // x[3] 优先，y 应为 3
        x = 4'b0111; #10;   // x[2] 优先，y 应为 2

        $stop;
    end

endmodule

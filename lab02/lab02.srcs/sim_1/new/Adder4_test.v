`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/05 17:04:33
// Design Name: 
// Module Name: Adder4_test
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


module Adder4_test;

    reg  [3:0] A;
    reg  [3:0] B;
    reg        addsub;

    wire [3:0] F;
    wire       cf;
    wire       zero;
    wire       of;

    integer i, j;
    integer errors;

    reg [4:0] temp;
    reg [3:0] expected_F;
    reg       expected_carry;
    reg       expected_cf;
    reg       expected_zero;
    reg       expected_of;

    // 实例化待测试模块
    Adder4 uut (
        .A(A),
        .B(B),
        .addsub(addsub),
        .F(F),
        .cf(cf),
        .zero(zero),
        .of(of)
    );

    task check;
        input [3:0] exp_F;
        input       exp_cf;
        input       exp_zero;
        input       exp_of;
        begin
            if (F !== exp_F ||
                cf !== exp_cf ||
                zero !== exp_zero ||
                of !== exp_of) begin

                $display("~~~ ERROR A=4'b%b, B=4'b%b, addsub=%b, result=4'b%b, cf=%b, zero=%b, of=%b",
                         A, B, addsub, F, cf, zero, of);

                $display("    SHOULD BE: result=4'b%b, cf=%b, zero=%b, of=%b",
                         exp_F, exp_cf, exp_zero, exp_of);

                errors = errors + 1;
            end
            else begin
                $display("~~~ OK A=4'b%b, B=4'b%b, addsub=%b, result=4'b%b, cf=%b, zero=%b, of=%b",
                         A, B, addsub, F, cf, zero, of);
            end
        end
    endtask

    initial begin
        errors = 0;

        // -------------------------
        // 测试加法：A + B
        // -------------------------
        addsub = 0;

        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                A = i[3:0];
                B = j[3:0];

                temp = {1'b0, A} + {1'b0, B};

                expected_F = temp[3:0];
                expected_carry = temp[4];
                expected_cf = expected_carry ^ addsub;
                expected_zero = ~(|expected_F);

                // 加法溢出：两个操作数符号相同，结果符号不同
                expected_of = (A[3] == B[3]) && (expected_F[3] != A[3]);

                #10;
                check(expected_F, expected_cf, expected_zero, expected_of);
            end
        end

        // -------------------------
        // 测试减法：A - B
        // -------------------------
        addsub = 1;

        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                A = i[3:0];
                B = j[3:0];

                temp = {1'b0, A} + {1'b0, ~B} + 5'b00001;

                expected_F = temp[3:0];
                expected_carry = temp[4];
                expected_cf = expected_carry ^ addsub;
                expected_zero = ~(|expected_F);

                // 减法 A - B 等价于 A + (~B) + 1
                // 溢出判断应使用 ~B 的符号位，而不是 -B 之后的符号位
                expected_of = (A[3] == (~B[3])) && (expected_F[3] != A[3]);

                #10;
                check(expected_F, expected_cf, expected_zero, expected_of);
            end
        end

        if (errors == 0) begin
            $display("====================================");
            $display("All tests passed!");
            $display("====================================");
        end
        else begin
            $display("====================================");
            $display("Test finished with %0d errors.", errors);
            $display("====================================");
        end

        $finish;
    end

endmodule

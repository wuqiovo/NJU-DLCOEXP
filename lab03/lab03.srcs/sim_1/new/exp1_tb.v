`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/06 20:23:13
// Design Name: 
// Module Name: exp1_tb
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

module exp1_tb;

    reg [1:0] SW;
    reg CLK100MHZ;

    wire [0:0] LED;
    wire [7:0] AN;
    wire [7:0] HEX;

    integer errors;
    reg [5:0] hold_Q;

    exp1 uut (
        .SW(SW),
        .CLK100MHZ(CLK100MHZ),
        .LED(LED),
        .AN(AN),
        .HEX(HEX)
    );

    // 加速仿真
    defparam uut.count_limit = 6'd5;
    defparam uut.clk_inst.countlimit = 4;

    // 100MHz clock, period = 10ns
    initial begin
        CLK100MHZ = 1'b0;
        forever #5 CLK100MHZ = ~CLK100MHZ;
    end

    task check_Q_LED;
        input [5:0] expected_Q;
        input expected_LED;
        begin
            #1;

            if (uut.Q !== expected_Q) begin
                $display("ERROR at time %0t: Q expected %0d, got %0d",
                         $time, expected_Q, uut.Q);
                errors = errors + 1;
            end

            if (LED[0] !== expected_LED) begin
                $display("ERROR at time %0t: LED expected %b, got %b",
                         $time, expected_LED, LED[0]);
                errors = errors + 1;
            end
        end
    endtask

    task check_display_signal;
        begin
            #1;

            if ((AN !== 8'b11111110) && (AN !== 8'b11111101)) begin
                $display("ERROR at time %0t: AN invalid, got %b", $time, AN);
                errors = errors + 1;
            end

            if (^HEX === 1'bx) begin
                $display("ERROR at time %0t: HEX has unknown X, got %b", $time, HEX);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;

        // 初始：运行，不复位
        SW = 2'b00;
        #20;

        // 复位
        SW[1] = 1'b1;
        #20;
        check_Q_LED(6'd0, 1'b0);

        // 释放复位
        SW[1] = 1'b0;

        // 现在开始正常计数
        @(posedge uut.clk_1HZ);
        check_Q_LED(6'd1, 1'b0);

        @(posedge uut.clk_1HZ);
        check_Q_LED(6'd2, 1'b0);

        @(posedge uut.clk_1HZ);
        check_Q_LED(6'd3, 1'b0);

        @(posedge uut.clk_1HZ);
        check_Q_LED(6'd4, 1'b0);

        @(posedge uut.clk_1HZ);
        check_Q_LED(6'd5, 1'b0);

        // 从 5 回到 0，同时 LED 应该亮
        @(posedge uut.clk_1HZ);
        check_Q_LED(6'd0, 1'b1);

        // 下一拍 LED 熄灭，Q 变成 1
        @(posedge uut.clk_1HZ);
        check_Q_LED(6'd1, 1'b0);

        // 测试暂停
        hold_Q = uut.Q;
        SW[0] = 1'b1;   // 暂停
        #300;

        if (uut.Q !== hold_Q) begin
            $display("ERROR at time %0t: pause failed, Q expected hold %0d, got %0d",
                     $time, hold_Q, uut.Q);
            errors = errors + 1;
        end

        // 恢复运行
        SW[0] = 1'b0;

        @(posedge uut.clk_1HZ);
        check_Q_LED(hold_Q + 1'b1, 1'b0);

        // 检查数码管信号是否有效
        #1000;
        check_display_signal();

        if (errors == 0) begin
            $display("========== PASS ==========");
        end
        else begin
            $display("========== FAIL: %0d error(s) ==========", errors);
        end

        $finish;
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/08 01:32:41
// Design Name: 
// Module Name: debounce_btn
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


module debounce_btn #(
    parameter CNT_MAX = 21'd2_000_000
)(
    input  clk,
    input  btn_in,
    output btn_pulse
);

    reg btn_sync_0;
    reg btn_sync_1;

    always @(posedge clk) begin
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;
    end

    reg [20:0] cnt;
    reg btn_stable;

    always @(posedge clk) begin
        if (btn_sync_1 == btn_stable) begin
            cnt <= 21'd0;
        end
        else begin
            cnt <= cnt + 1'b1;

            if (cnt >= CNT_MAX) begin
                btn_stable <= btn_sync_1;
                cnt <= 21'd0;
            end
        end
    end

    reg btn_stable_d;

    always @(posedge clk) begin
        btn_stable_d <= btn_stable;
    end

    assign btn_pulse = btn_stable & ~btn_stable_d;

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/08 00:40:24
// Design Name: 
// Module Name: lab05
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


module lab05 (
    input [8:0] SW,
    input BTNC,
    input CLK100MHZ,
    output reg [7:0] AN,
    output [7:0] HEX
);

    wire [7:0] seed;
    wire load;
    wire btn_pulse;

    reg [7:0] dout;

    assign seed = SW[7:0];
    assign load = SW[8];

    debounce_btn u_debounce_btn (
        .clk(CLK100MHZ),
        .btn_in(BTNC),
        .btn_pulse(btn_pulse)
    );

    always @(posedge CLK100MHZ) begin
        if (btn_pulse) begin
            if (load) begin
                if (seed == 8'b0000_0000)
                    dout <= 8'b0000_0001;
                else
                    dout <= seed;
            end
            else begin
                if (dout == 8'b0000_0000)
                    dout <= 8'b0000_0001;
                else
                    dout <= {dout[4] ^ dout[3] ^ dout[2] ^ dout[0], dout[7:1]};
            end
        end
    end

    wire [3:0] display_high;
    wire [3:0] display_low;

    assign display_high = dout[7:4];
    assign display_low  = dout[3:0];

    reg [16:0] scan_cnt;
    wire scan_sel;

    assign scan_sel = scan_cnt[16];

    always @(posedge CLK100MHZ) begin
        scan_cnt <= scan_cnt + 1'b1;
    end

    reg [3:0] display_num;

    always @(*) begin
        AN = 8'b1111_1111;
        display_num = 4'h0;

        case (scan_sel)
            1'b0: begin
                AN = 8'b1111_1110;
                display_num = display_low;
            end

            1'b1: begin
                AN = 8'b1111_1101;
                display_num = display_high;
            end
        endcase
    end

    bcd7seg u_bcd7seg (
        .b(display_num),
        .h(HEX)
    );

endmodule

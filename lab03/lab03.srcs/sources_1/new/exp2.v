`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/06 20:50:19
// Design Name: 
// Module Name: exp2
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

module exp2(
    input  CLK100MHZ,
    input  [15:0] SW,
    output [0:0] LED,
    output reg [7:0] AN,
    output [7:0] HEX
);

    wire [5:0] load_value;
    wire [1:0] load_sel;

    wire load_time;
    wire load_alarm;
    wire clock_run;
    wire mode_sel;
    wire sw_run;
    wire sw_rst;
    wire rst;
    wire alarm_en_sw;

    assign load_value  = SW[5:0];
    assign load_sel    = SW[7:6];

    assign load_time   = SW[8];
    assign load_alarm  = SW[9];

    assign clock_run   = SW[10];   // 0 for pause and 1 for work
    assign mode_sel    = SW[11];   // 0 for clock and 1 for stopwatch

    assign sw_run      = SW[12];   // 0 for pause and 1 for work
    assign sw_rst      = SW[13];   // 1 for stopwatch reset

    assign rst         = SW[14];   // global reset
    assign alarm_en_sw = SW[15];   // en for alarm

    wire tick_1hz;
    wire tick_100hz;

    clkgen #(1) u_tick_1hz (
        .clkin  (CLK100MHZ),
        .rst    (rst),
        .clken  (1'b1),
        .clkout (tick_1hz)
    );

    clkgen #(100) u_tick_100hz (
        .clkin  (CLK100MHZ),
        .rst    (rst),
        .clken  (1'b1),
        .clkout (tick_100hz)
    );

    wire [5:0] load_value_0_59;
    wire [4:0] load_value_0_23;

    assign load_value_0_59 = (load_value > 6'd59) ? 6'd59 : load_value;
    assign load_value_0_23 = (load_value > 6'd23) ? 5'd23 : load_value[4:0];

    reg [4:0] hour;
    reg [5:0] min;
    reg [5:0] sec;

    reg [4:0] alarm_hour;
    reg [5:0] alarm_min;
    reg [5:0] alarm_sec;

    reg [5:0] sw_min;
    reg [5:0] sw_sec;
    reg [6:0] sw_cs;

    // clock part
    // load clock time on the posedge of laod_time
    
    always @(posedge tick_1hz or posedge load_time or posedge rst) begin
        if (rst) begin
            hour <= 5'd0;
            min  <= 6'd0;
            sec  <= 6'd0;
        end
        else if (load_time) begin
            case(load_sel)
                2'b00: sec  <= load_value_0_59;
                2'b01: min  <= load_value_0_59;
                2'b10: hour <= load_value_0_23;
                default: ;
            endcase
        end
        else if (clock_run) begin
            if (sec == 6'd59) begin
                sec <= 6'd0;

                if (min == 6'd59) begin
                    min <= 6'd0;

                    if (hour == 5'd23)
                        hour <= 5'd0;
                    else
                        hour <= hour + 1'b1;
                end
                else begin
                    min <= min + 1'b1;
                end
            end
            else begin
                sec <= sec + 1'b1;
            end
        end
    end

    // alarm part 
    // load alarm time on the posedge of laod_alarm 

    always @(posedge load_alarm or posedge rst) begin
        if (rst) begin
            alarm_hour <= 5'd0;
            alarm_min  <= 6'd0;
            alarm_sec  <= 6'd0;
        end
        else begin
            case(load_sel)
                2'b00: alarm_sec  <= load_value_0_59;
                2'b01: alarm_min  <= load_value_0_59;
                2'b10: alarm_hour <= load_value_0_23;
                default: ;
            endcase
        end
    end

    // stopwatch part 

    always @(posedge tick_100hz or posedge sw_rst or posedge rst) begin
        if (rst || sw_rst) begin
            sw_min <= 6'd0;
            sw_sec <= 6'd0;
            sw_cs  <= 7'd0;
        end
        else if (sw_run) begin
            if (sw_cs == 7'd99) begin
                sw_cs <= 7'd0;

                if (sw_sec == 6'd59) begin
                    sw_sec <= 6'd0;

                    if (sw_min == 6'd59)
                        sw_min <= 6'd0;
                    else
                        sw_min <= sw_min + 1'b1;
                end
                else begin
                    sw_sec <= sw_sec + 1'b1;
                end
            end
            else begin
                sw_cs <= sw_cs + 1'b1;
            end
        end
    end

    // alarm LED part 
    // LED on when alarm_en_sw is 1 and time is up 

    wire alarm_match;

    assign alarm_match = alarm_en_sw &&
                         (hour == alarm_hour) &&
                         (min  == alarm_min) &&
                         (sec  == alarm_sec);

    assign LED[0] = alarm_match ? tick_1hz : 1'b0;

    // data split part 

    wire [3:0] sec_ones;
    wire [3:0] sec_tens;
    wire [3:0] min_ones;
    wire [3:0] min_tens;
    wire [3:0] hour_ones;
    wire [3:0] hour_tens;

    assign sec_ones  = sec % 10;
    assign sec_tens  = sec / 10;
    assign min_ones  = min % 10;
    assign min_tens  = min / 10;
    assign hour_ones = hour % 10;
    assign hour_tens = hour / 10;

    wire [3:0] sw_cs_ones;
    wire [3:0] sw_cs_tens;
    wire [3:0] sw_sec_ones;
    wire [3:0] sw_sec_tens;
    wire [3:0] sw_min_ones;
    wire [3:0] sw_min_tens;

    assign sw_cs_ones  = sw_cs % 10;
    assign sw_cs_tens  = sw_cs / 10;
    assign sw_sec_ones = sw_sec % 10;
    assign sw_sec_tens = sw_sec / 10;
    assign sw_min_ones = sw_min % 10;
    assign sw_min_tens = sw_min / 10;

    // dynamic scan for display tube 

    reg [18:0] scan_cnt;

    always @(posedge CLK100MHZ or posedge rst) begin
        if (rst)
            scan_cnt <= 19'd0;
        else
            scan_cnt <= scan_cnt + 1'b1;
    end

    wire [2:0] scan_sel;
    assign scan_sel = scan_cnt[18:16];

    reg [3:0] display_num;

    always @(*) begin
        AN = 8'b11111111;
        display_num = 4'd10;

        if (mode_sel == 1'b0) begin
            // clock mode: HH MM SS
            case(scan_sel)
                3'd0: begin
                    AN = 8'b11111110;
                    display_num = sec_ones;
                end

                3'd1: begin
                    AN = 8'b11111101;
                    display_num = sec_tens;
                end

                3'd2: begin
                    AN = 8'b11111011;
                    display_num = 4'd10;
                end

                3'd3: begin
                    AN = 8'b11110111;
                    display_num = min_ones;
                end

                3'd4: begin
                    AN = 8'b11101111;
                    display_num = min_tens;
                end

                3'd5: begin
                    AN = 8'b11011111;
                    display_num = 4'd10;
                end

                3'd6: begin
                    AN = 8'b10111111;
                    display_num = hour_ones;
                end

                3'd7: begin
                    AN = 8'b01111111;
                    display_num = hour_tens;
                end

                default: begin
                    AN = 8'b11111111;
                    display_num = 4'd10;
                end
            endcase
        end
        else begin
            // stopwatch mode: MM  SS  CC
            case(scan_sel)
                3'd0: begin
                    AN = 8'b11111110;
                    display_num = sw_cs_ones;
                end
        
                3'd1: begin
                    AN = 8'b11111101;
                    display_num = sw_cs_tens;
                end
        
                3'd2: begin
                    AN = 8'b11111011;
                    display_num = 4'd10; 
                end
        
                3'd3: begin
                    AN = 8'b11110111;
                    display_num = sw_sec_ones;
                end
        
                3'd4: begin
                    AN = 8'b11101111;
                    display_num = sw_sec_tens;
                end
        
                3'd5: begin
                    AN = 8'b11011111;
                    display_num = 4'd10; 
                end
        
                3'd6: begin
                    AN = 8'b10111111;
                    display_num = sw_min_ones;
                end
        
                3'd7: begin
                    AN = 8'b01111111;
                    display_num = sw_min_tens;
                end
        
                default: begin
                    AN = 8'b11111111;
                    display_num = 4'd10;
                end
            endcase
        end
    end

    bcd7seg u_bcd7seg (
        .b(display_num),
        .h(HEX)
    );

endmodule
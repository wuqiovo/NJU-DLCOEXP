`timescale 1ns / 1ps

module display_mmio(
    input  wire        scan_clk,
    input  wire        wrclk,
    input  wire        reset,

    input  wire [31:0] cpu_addr,
    input  wire [31:0] cpu_wdata,
    input  wire [2:0]  cpu_memop,
    input  wire        cpu_we,

    output wire [15:0] LED,
    output reg  [7:0]  AN,
    output wire [7:0]  HEX
);  

    localparam LED_DATA     = 32'h0050_0000;
    localparam SEG_VALUE    = 32'h0050_0004;
    localparam SEG_ENABLE   = 32'h0050_0008;
    localparam SEG_DP       = 32'h0050_000C;
    
    reg [15:0] led_value;
    reg [31:0] seg_value;
    reg [7:0]  seg_enable;
    reg [7:0]  seg_dp;
    
    wire write_enable = cpu_we && (cpu_memop == 3'b010);
    
    always @(posedge wrclk) begin
        if (reset) begin
            led_value  <= 16'h000;
            seg_value  <= 32'h0000_0000;
            seg_enable <= 8'h00;
            seg_dp     <= 8'h00;
        end else if (write_enable) begin
            case (cpu_addr[3:2])
                2'd0: led_value  <= cpu_wdata[15:0];
                2'd1: seg_value  <= cpu_wdata;
                2'd2: seg_enable <= cpu_wdata[7:0];
                2'd3: seg_dp     <= cpu_wdata[7:0];
            endcase
        end
    end
    
    assign LED = led_value;
    
    reg  [14:0] scan_counter;
    wire [2:0]  scan_index = scan_counter[14:12];
    reg  [3:0]  display_num;
    wire [7:0]  hex_value;
    reg         hex_dp;
    
    always @(posedge scan_clk) begin
        if (reset)
            scan_counter <= 15'd0;
        else
            scan_counter <= scan_counter + 15'd1;
    end    
    
    always @(*) begin
        AN = 8'b1111_1111; 
        if (seg_enable[scan_index])
            AN = ~(8'b0000_0001 << scan_index);
        hex_dp = ~seg_dp[scan_index];
        
        case(scan_index)
            3'd0:  display_num = seg_value[3:0];
            3'd1:  display_num = seg_value[7:4];
            3'd2:  display_num = seg_value[11:8];
            3'd3:  display_num = seg_value[15:12];
            3'd4:  display_num = seg_value[19:16];
            3'd5:  display_num = seg_value[23:20];
            3'd6:  display_num = seg_value[27:24];
            3'd7:  display_num = seg_value[31:28];
            default: display_num = 4'h0;
        endcase
    end
    
    bcd7seg u_seg (
        .b(display_num),
        .h(hex_value)
    );
    
    assign HEX = { hex_dp, hex_value[6:0] }; 
    
endmodule
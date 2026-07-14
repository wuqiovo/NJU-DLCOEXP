`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/07 17:48:14
// Design Name: 
// Module Name: regfile_offline
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


module lab04(
    input  [15:0] SW,
    input  CLK100MHZ,
    input  BTNC, 
    output reg [7:0] AN,
    output reg [7:0] HEX
    );

    wire [3:0] addr;
    wire [3:0] reg_data_in;
    wire [3:0] ram_data_in;
    wire reg_we;
    wire ram_we;

    wire [7:0] reg_data_out;
    wire [7:0] ram_data_out;

    wire [7:0] reg_seg_low;
    wire [7:0] reg_seg_high;
    wire [7:0] ram_seg_low;
    wire [7:0] ram_seg_high;

    reg [7:0] regs [15:0];

    initial begin
        $readmemh("D:/DLCOEXP/lab04/mem1.txt", regs, 0, 15);
    end

    assign addr        = SW[3:0];
    assign reg_data_in = SW[7:4];
    assign ram_data_in = SW[11:8];
    assign reg_we      = SW[12];
    assign ram_we      = SW[13];

    wire btn_pulse;

    debounce_btn u_debounce_btn (
        .clk(CLK100MHZ),
        .btn_in(BTNC),
        .btn_pulse(btn_pulse)
    );
    
    // regfile 
    assign reg_data_out = regs[addr];
    
    always @(posedge CLK100MHZ) begin
        if (reg_we && btn_pulse) begin
            regs[addr] <= {4'b0000, reg_data_in};
        end
    end
    
    // IP generated RAM 
    blk_mem_gen_0 m_ram(
        .addra(addr),
        .clka(CLK100MHZ),
        .dina({4'b0000, ram_data_in}),
        .douta(ram_data_out),
        .ena(1'b1),
        .wea({ram_we && btn_pulse})
    );

    // display transform 
    bcd7seg m_reg_low(
        .b(reg_data_out[3:0]),
        .h(reg_seg_low)
    );

    bcd7seg m_reg_high(
        .b(reg_data_out[7:4]),
        .h(reg_seg_high)
    );

    bcd7seg m_ram_low(
        .b(ram_data_out[3:0]),
        .h(ram_seg_low)
    );

    bcd7seg m_ram_high(
        .b(ram_data_out[7:4]),
        .h(ram_seg_high)
    );

    // dynamic scan 
    reg [16:0] scan_cnt = 17'd0;
    wire [1:0] scan_sel;

    assign scan_sel = scan_cnt[16:15];

    always @(posedge CLK100MHZ) begin
        scan_cnt <= scan_cnt + 1'b1;
    end

    always @(*) begin
        case (scan_sel)
            2'b00: begin
                AN  = 8'b1111_1110;   // AN0: regfile low
                HEX = reg_seg_low;
            end

            2'b01: begin
                AN  = 8'b1111_1101;   // AN1: regfile high 
                HEX = reg_seg_high;
            end

            2'b10: begin
                AN  = 8'b1111_1011;   // AN2: RAM low 
                HEX = ram_seg_low;
            end

            2'b11: begin
                AN  = 8'b1111_0111;   // AN3: RAM high 
                HEX = ram_seg_high;
            end

            default: begin
                AN  = 8'b1111_1111;
                HEX = 8'b1111_1111;
            end
        endcase
    end

endmodule

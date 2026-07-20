`timescale 1ns / 1ps

module keyboard_mmio(
    input  wire        clk,
    input  wire        reset,

    // PS/2 interface
    input  wire        PS2_CLK,
    input  wire        PS2_DATA,

    // CPU MMIO interface 
    input  wire [31:0] cpu_addr,
    input  wire [31:0] cpu_wdata,
    input  wire [2:0]  cpu_memop,
    input  wire        cpu_we,
    input  wire        cpu_wrclk,

    output reg  [31:0] cpu_rdata,

    // Debug output 
    output wire        overflow
    );
    
    wire [7:0] ps2_scan_code;
    wire       ps2_ready;
    wire       ps2_nextdata_n;
    wire       ps2_overflow;
    wire       scan_ready;
    
    ps2_keyboard u_ps2_keyboard (
        .clk        (clk),
        .clrn       (~reset),
        .ps2_clk    (PS2_CLK),
        .ps2_data   (PS2_DATA),
        .data       (ps2_scan_code),
        .ready      (ps2_ready),
        .nextdata_n (ps2_nextdata_n),
        .overflow   (ps2_overflow)
    );
    
    assign ps2_nextdata_n =
        ~(ps2_ready && scan_ready);
        
    wire       key_valid;
    wire       key_ready;
    wire [7:0] key_ascii;
    wire       key_enter;
    wire       key_backspace;
    wire       shift_down;
    
    keyboard_decoder u_keyboard_decoder (
        .clk             (clk),
        .reset           (reset),
        .scan_valid      (ps2_ready),
        .scan_code       (ps2_scan_code),
        .scan_ready      (scan_ready),
        .event_valid     (key_valid),
        .event_ready     (key_ready),
        .event_ascii     (key_ascii),
        .event_enter     (key_enter),
        .event_backspace (key_backspace),
        .shift_down      (shift_down)
    );
    
    reg [7:0] key_fifo [0:31];
    reg [4:0] key_head;
    reg [4:0] key_tail;
    
    wire [4:0] key_next_tail = key_tail + 5'd1;
    wire key_empty = (key_head == key_tail);
    wire key_full  = (key_next_tail == key_head);
    
    assign key_ready = ~key_full;
    
    // Direction keys are already encoded by keyboard_decoder as internal
    // control bytes: Left=11h, Right=12h, Up=13h, Down=14h.  They pass through
    // this existing 8-bit FIFO unchanged.
    wire [7:0] key_event_data =
                key_enter     ? 8'h0A :
                key_backspace ? 8'h08 :
                                key_ascii;
    
    localparam [31:0] KEY_HEAD_ADDR = 32'h0030_0000;
    localparam [31:0] KEY_TAIL_ADDR = 32'h0030_0004;
    localparam [31:0] KEY_BUF_BEGIN = 32'h0030_0100;
    localparam [31:0] KEY_BUF_END   = 32'h0030_0180;
    
    always @(*) begin
        if (cpu_addr == KEY_HEAD_ADDR) begin
            cpu_rdata = {27'b0, key_head};
        end
        else if (cpu_addr == KEY_TAIL_ADDR) begin
            cpu_rdata = {27'b0, key_tail};
        end
        else if ((cpu_addr >= KEY_BUF_BEGIN) &&
                (cpu_addr <  KEY_BUF_END)) begin
            cpu_rdata = {
                24'b0,
                key_fifo[cpu_addr[6:2]]
            };
        end
        else begin
            cpu_rdata = 32'b0;
        end
    end

    always @(posedge cpu_wrclk) begin
        if (reset) begin
            key_head <= 5'd0;
        end
        else if (cpu_we &&
                (cpu_addr == KEY_HEAD_ADDR) &&
                (cpu_memop == 3'b010)) begin
            key_head <= cpu_wdata[4:0];
        end
    end                            
    
    always @(posedge clk) begin
        if (reset) begin
            key_tail <= 5'd0;
        end
        else if (key_valid && key_ready) begin
            key_fifo[key_tail] <= key_event_data;
            key_tail <= key_tail + 5'd1;
        end
    end
    
    assign overflow = ps2_overflow;
    
endmodule

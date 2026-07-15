`timescale 1ns / 1ps

// Nexys A7 board wrapper for the single-step Fibonacci demonstration.
//
// SW[0]    : active-high reset
// SW[15:6] : unsigned input n
// BTNC     : execute one CPU instruction per press
// AN/HEX   : input n before completion, then the 32-bit result in hexadecimal
module fib_top #(
    parameter IMEM_INIT_FILE = "fib.hex",
    parameter [20:0] DEBOUNCE_COUNT = 21'd2_000_000,
    parameter [7:0] STEP_LOW_CYCLES = 8'd4
)(
    input  wire        CLK100MHZ,
    input  wire        BTNC,
    input  wire [15:0] SW,
    output reg  [7:0]  AN,
    output wire [7:0]  HEX
    );

    wire board_reset;
    wire btn_pulse;
    assign board_reset = SW[0];

    fib_debounce_btn #(
        .CNT_MAX (DEBOUNCE_COUNT)
    ) u_debounce (
        .clk       (CLK100MHZ),
        .reset     (board_reset),
        .btn_in    (BTNC),
        .btn_pulse (btn_pulse)
    );

    // Synchronize the ten input switches into the 100 MHz board-clock domain.
    reg [9:0] n_sync_0;
    reg [9:0] n_sync_1;
    always @(posedge CLK100MHZ or posedge board_reset) begin
        if (board_reset) begin
            n_sync_0 <= 10'b0;
            n_sync_1 <= 10'b0;
        end
        else begin
            n_sync_0 <= SW[15:6];
            n_sync_1 <= n_sync_0;
        end
    end

    wire [31:0] external_n;
    assign external_n = {22'b0, n_sync_1};

    // A CPU cycle starts at its falling edge.  The bootstrap state creates one
    // falling edge while reset is still asserted so instruction 0 is fetched.
    localparam [1:0] BOOT_START = 2'd0,
                     BOOT_LOW   = 2'd1,
                     IDLE       = 2'd2,
                     STEP_LOW   = 2'd3;

    reg [1:0] step_state;
    reg [7:0] step_count;
    reg       cpu_clock;
    reg       core_reset;

    always @(posedge CLK100MHZ or posedge board_reset) begin
        if (board_reset) begin
            step_state <= BOOT_START;
            step_count <= 8'b0;
            cpu_clock  <= 1'b1;
            core_reset <= 1'b1;
        end
        else begin
            case (step_state)
                BOOT_START: begin
                    // Fetch instruction 0 at this falling CPU-clock edge.
                    cpu_clock  <= 1'b0;
                    core_reset <= 1'b1;
                    step_count <= 8'b0;
                    step_state <= BOOT_LOW;
                end

                BOOT_LOW: begin
                    if (step_count >= STEP_LOW_CYCLES - 1'b1) begin
                        cpu_clock  <= 1'b1;
                        core_reset <= 1'b0;
                        step_count <= 8'b0;
                        step_state <= IDLE;
                    end
                    else begin
                        step_count <= step_count + 1'b1;
                    end
                end

                IDLE: begin
                    if (btn_pulse) begin
                        cpu_clock  <= 1'b0;
                        step_count <= 8'b0;
                        step_state <= STEP_LOW;
                    end
                end

                STEP_LOW: begin
                    if (step_count >= STEP_LOW_CYCLES - 1'b1) begin
                        cpu_clock  <= 1'b1;
                        step_count <= 8'b0;
                        step_state <= IDLE;
                    end
                    else begin
                        step_count <= step_count + 1'b1;
                    end
                end

                default: begin
                    step_state <= BOOT_START;
                    step_count <= 8'b0;
                    cpu_clock  <= 1'b1;
                    core_reset <= 1'b1;
                end
            endcase
        end
    end

    wire [31:0] fib_result;
    wire        fib_valid;
    wire [31:0] dbg_pc;
    wire [31:0] dbg_instr;
    wire [31:0] dbg_dmem_addr;
    wire [31:0] dbg_dmem_wdata;
    wire [31:0] dbg_dmem_rdata;

    cpu #(
        .IMEM_INIT_FILE (IMEM_INIT_FILE)
    ) u_cpu (
        .clock           (cpu_clock),
        .reset           (core_reset),
        .external_n      (external_n),
        .fib_result      (fib_result),
        .fib_valid       (fib_valid),
        .dbg_pc          (dbg_pc),
        .dbg_instr       (dbg_instr),
        .dbg_dmem_addr   (dbg_dmem_addr),
        .dbg_dmem_wdata  (dbg_dmem_wdata),
        .dbg_dmem_rdata  (dbg_dmem_rdata)
    );

    // Display n before completion and the 32-bit result afterwards.
    wire [31:0] display_value;
    assign display_value = fib_valid ? fib_result : external_n;

    reg [18:0] scan_count;
    wire [2:0] scan_index;
    assign scan_index = scan_count[18:16];

    always @(posedge CLK100MHZ or posedge board_reset) begin
        if (board_reset)
            scan_count <= 19'b0;
        else
            scan_count <= scan_count + 1'b1;
    end

    reg [3:0] display_nibble;
    always @(*) begin
        AN = 8'hFF;
        AN[scan_index] = 1'b0;

        case (scan_index)
            3'd0: display_nibble = display_value[3:0];
            3'd1: display_nibble = display_value[7:4];
            3'd2: display_nibble = display_value[11:8];
            3'd3: display_nibble = display_value[15:12];
            3'd4: display_nibble = display_value[19:16];
            3'd5: display_nibble = display_value[23:20];
            3'd6: display_nibble = display_value[27:24];
            3'd7: display_nibble = display_value[31:28];
            default: display_nibble = 4'h0;
        endcase
    end

    wire [7:0] hex_raw;
    fib_hex7seg u_hex7seg (
        .value (display_nibble),
        .seg   (hex_raw)
    );

    // The leftmost decimal point indicates that fib_result is valid.
    assign HEX = {(fib_valid && (scan_index == 3'd7)) ? 1'b0 : 1'b1,
                  hex_raw[6:0]};

endmodule


// Debouncer adapted from Common Code.md.  The reset and explicit initial
// values make its behavior deterministic in both hardware and simulation.
module fib_debounce_btn #(
    parameter [20:0] CNT_MAX = 21'd2_000_000
)(
    input  wire clk,
    input  wire reset,
    input  wire btn_in,
    output wire btn_pulse
    );

    reg btn_sync_0;
    reg btn_sync_1;
    reg [20:0] count;
    reg btn_stable;
    reg btn_stable_d;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            btn_sync_0  <= 1'b0;
            btn_sync_1  <= 1'b0;
            count       <= 21'b0;
            btn_stable  <= 1'b0;
            btn_stable_d <= 1'b0;
        end
        else begin
            btn_sync_0 <= btn_in;
            btn_sync_1 <= btn_sync_0;
            btn_stable_d <= btn_stable;

            if (btn_sync_1 == btn_stable) begin
                count <= 21'b0;
            end
            else if (count >= CNT_MAX - 1'b1) begin
                count      <= 21'b0;
                btn_stable <= btn_sync_1;
            end
            else begin
                count <= count + 1'b1;
            end
        end
    end

    assign btn_pulse = btn_stable & ~btn_stable_d;

endmodule


// Active-low hexadecimal decoder for the Nexys A7 seven-segment display.
// seg[7:0] = {DP, CG, CF, CE, CD, CC, CB, CA}.
module fib_hex7seg(
    input  wire [3:0] value,
    output reg  [7:0] seg
    );

    always @(*) begin
        case (value)
            4'h0: seg = 8'b1100_0000;
            4'h1: seg = 8'b1111_1001;
            4'h2: seg = 8'b1010_0100;
            4'h3: seg = 8'b1011_0000;
            4'h4: seg = 8'b1001_1001;
            4'h5: seg = 8'b1001_0010;
            4'h6: seg = 8'b1000_0010;
            4'h7: seg = 8'b1111_1000;
            4'h8: seg = 8'b1000_0000;
            4'h9: seg = 8'b1001_0000;
            4'hA: seg = 8'b1000_1000;
            4'hB: seg = 8'b1000_0011;
            4'hC: seg = 8'b1100_0110;
            4'hD: seg = 8'b1010_0001;
            4'hE: seg = 8'b1000_0110;
            4'hF: seg = 8'b1000_1110;
            default: seg = 8'b1111_1111;
        endcase
    end

endmodule

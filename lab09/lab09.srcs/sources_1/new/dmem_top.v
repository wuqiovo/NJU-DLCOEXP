`timescale 1ns / 1ps

// Nexys A7 wrapper for the data memory.
// SW[7:0]   : input byte, repeated four times to form 32-bit write data
// SW[10:8]  : MemOP
// SW[14:11] : low four address bits; upper address bits are zero
// SW[15]    : write enable
// BTNC      : one debounced memory clock cycle (1 -> 0 -> 1)
// AN/HEX    : 32-bit memory read result in hexadecimal
module dmem_top #(
    parameter [20:0] DEBOUNCE_COUNT = 21'd2_000_000,
    parameter [7:0] STEP_LOW_CYCLES = 8'd4
)(
    input  wire        CLK100MHZ,
    input  wire        BTNC,
    input  wire [15:0] SW,
    output reg  [7:0]  AN,
    output wire [7:0]  HEX
    );

    wire [7:0] datain_L8b;
    wire [3:0] addr_L4b;
    wire [16:0] addr_L17b;
    wire [31:0] addr;
    wire [31:0] datain;
    wire [31:0] dataout;
    wire [2:0] memop;
    wire we;
    reg memclk;
    wire wrclk;

    assign datain_L8b = SW[7:0];
    assign memop      = SW[10:8];
    assign addr_L4b   = SW[14:11];
    assign we         = SW[15];

    assign datain   = {4{datain_L8b}};
    assign addr_L17b = {13'b0, addr_L4b};
    assign addr       = {15'b0, addr_L17b};

    // Each debounced press creates one complete 1 -> 0 -> 1 memory-clock
    // cycle. The falling transition first creates a rising edge on wrclk;
    // returning high then creates the read edge on memclk.
    wire btn_pulse;
    dmem_top_debounce_btn #(
        .CNT_MAX (DEBOUNCE_COUNT)
    ) u_debounce (
        .clk       (CLK100MHZ),
        .btn_in    (BTNC),
        .btn_pulse (btn_pulse)
    );

    localparam IDLE = 1'b0,
               STEP_LOW = 1'b1;

    reg step_state;
    reg [7:0] step_count;

    initial begin
        memclk     = 1'b1;
        step_state = IDLE;
        step_count = 8'b0;
    end

    always @(posedge CLK100MHZ) begin
        case (step_state)
            IDLE: begin
                memclk <= 1'b1;
                if (btn_pulse) begin
                    memclk     <= 1'b0;
                    step_count <= 8'b0;
                    step_state <= STEP_LOW;
                end
            end

            STEP_LOW: begin
                if (step_count >= STEP_LOW_CYCLES - 1'b1) begin
                    memclk     <= 1'b1;
                    step_count <= 8'b0;
                    step_state <= IDLE;
                end
                else begin
                    step_count <= step_count + 1'b1;
                end
            end

            default: begin
                memclk     <= 1'b1;
                step_count <= 8'b0;
                step_state <= IDLE;
            end
        endcase
    end

    assign wrclk = ~memclk;

    dmem u_dmem (
        .addr    (addr),
        .dataout (dataout),
        .datain  (datain),
        .rdclk   (memclk),
        .wrclk   (wrclk),
        .memop   (memop),
        .we      (we)
    );

    reg [18:0] scan_count;
    wire [2:0] scan_index;
    reg [3:0] display_nibble;

    assign scan_index = scan_count[18:16];

    initial scan_count = 19'b0;

    always @(posedge CLK100MHZ) begin
        scan_count <= scan_count + 1'b1;
    end

    always @(*) begin
        AN = 8'hFF;
        AN[scan_index] = 1'b0;

        case (scan_index)
            3'd0: display_nibble = dataout[3:0];
            3'd1: display_nibble = dataout[7:4];
            3'd2: display_nibble = dataout[11:8];
            3'd3: display_nibble = dataout[15:12];
            3'd4: display_nibble = dataout[19:16];
            3'd5: display_nibble = dataout[23:20];
            3'd6: display_nibble = dataout[27:24];
            3'd7: display_nibble = dataout[31:28];
            default: display_nibble = 4'h0;
        endcase
    end

    dmem_top_hex7seg u_hex7seg (
        .value (display_nibble),
        .seg   (HEX)
    );

endmodule


module dmem_top_debounce_btn #(
    parameter [20:0] CNT_MAX = 21'd2_000_000
)(
    input  wire clk,
    input  wire btn_in,
    output wire btn_pulse
    );

    reg btn_sync_0;
    reg btn_sync_1;
    reg [20:0] count;
    reg btn_stable;
    reg btn_stable_d;

    initial begin
        btn_sync_0   = 1'b0;
        btn_sync_1   = 1'b0;
        count        = 21'b0;
        btn_stable   = 1'b0;
        btn_stable_d = 1'b0;
    end

    always @(posedge clk) begin
        btn_sync_0   <= btn_in;
        btn_sync_1   <= btn_sync_0;
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

    assign btn_pulse = btn_stable & ~btn_stable_d;

endmodule


module dmem_top_hex7seg(
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

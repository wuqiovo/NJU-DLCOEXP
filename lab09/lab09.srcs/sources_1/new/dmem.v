`timescale 1ns / 1ps

module dmem(
    input  wire [31:0] addr,
    output reg  [31:0] dataout,
    input  wire [31:0] datain,
    input  wire        rdclk,
    input  wire        wrclk,
    input  wire [2:0]  memop,
    input  wire        we
);

    // 128 KiB data memory, organized as four byte-wide lanes.
    // Each lane is a simple dual-port RAM with independent read/write clocks.
    (* ram_style = "block" *) reg [7:0] ram0 [0:32767];
    (* ram_style = "block" *) reg [7:0] ram1 [0:32767];
    (* ram_style = "block" *) reg [7:0] ram2 [0:32767];
    (* ram_style = "block" *) reg [7:0] ram3 [0:32767];

    wire [14:0] word_addr = addr[16:2];

    localparam [2:0] MEM_BYTE  = 3'b000,
                     MEM_HALF  = 3'b001,
                     MEM_WORD  = 3'b010,
                     MEM_BYTEU = 3'b100,
                     MEM_HALFU = 3'b101;

    // Keep each memory read as a direct synchronous array access so Vivado
    // can infer block RAM.  The formatting controls are registered alongside
    // the data to keep them aligned with the one-cycle RAM read latency.
    reg [7:0] ram0_q;
    reg [7:0] ram1_q;
    reg [7:0] ram2_q;
    reg [7:0] ram3_q;
    reg [1:0] read_byte_offset;
    reg [2:0] read_memop;

    always @(posedge rdclk) begin
        ram0_q <= ram0[word_addr];
        ram1_q <= ram1[word_addr];
        ram2_q <= ram2[word_addr];
        ram3_q <= ram3[word_addr];

        read_byte_offset <= addr[1:0];
        read_memop       <= memop;
    end

    // Byte selection and sign extension are deliberately outside the RAM
    // read process; they become ordinary logic after the BRAM output.
    always @(*) begin
        dataout = 32'b0;

        case (read_memop)
            MEM_BYTE: begin
                case (read_byte_offset)
                    2'b00: dataout = {{24{ram0_q[7]}}, ram0_q};
                    2'b01: dataout = {{24{ram1_q[7]}}, ram1_q};
                    2'b10: dataout = {{24{ram2_q[7]}}, ram2_q};
                    2'b11: dataout = {{24{ram3_q[7]}}, ram3_q};
                    default: dataout = 32'b0;
                endcase
            end

            MEM_HALF: begin
                if (read_byte_offset[1] == 1'b0)
                    dataout = {{16{ram1_q[7]}}, ram1_q, ram0_q};
                else
                    dataout = {{16{ram3_q[7]}}, ram3_q, ram2_q};
            end

            MEM_WORD: begin
                dataout = {ram3_q, ram2_q, ram1_q, ram0_q};
            end

            MEM_BYTEU: begin
                case (read_byte_offset)
                    2'b00: dataout = {24'b0, ram0_q};
                    2'b01: dataout = {24'b0, ram1_q};
                    2'b10: dataout = {24'b0, ram2_q};
                    2'b11: dataout = {24'b0, ram3_q};
                    default: dataout = 32'b0;
                endcase
            end

            MEM_HALFU: begin
                if (read_byte_offset[1] == 1'b0)
                    dataout = {16'b0, ram1_q, ram0_q};
                else
                    dataout = {16'b0, ram3_q, ram2_q};
            end

            default: dataout = 32'b0;
        endcase
    end

    wire store_byte = we && (memop == MEM_BYTE);
    wire store_half = we && (memop == MEM_HALF);
    wire store_word = we && (memop == MEM_WORD);

    // Independent lane enables correspond to the BRAM byte write enables.
    wire ram0_we = store_word ||
                   (store_half && (addr[1] == 1'b0)) ||
                   (store_byte && (addr[1:0] == 2'b00));

    wire ram1_we = store_word ||
                   (store_half && (addr[1] == 1'b0)) ||
                   (store_byte && (addr[1:0] == 2'b01));

    wire ram2_we = store_word ||
                   (store_half && (addr[1] == 1'b1)) ||
                   (store_byte && (addr[1:0] == 2'b10));

    wire ram3_we = store_word ||
                   (store_half && (addr[1] == 1'b1)) ||
                   (store_byte && (addr[1:0] == 2'b11));

    wire [7:0] ram0_datain = datain[7:0];
    wire [7:0] ram1_datain = store_byte ? datain[7:0] : datain[15:8];
    wire [7:0] ram2_datain = store_word ? datain[23:16] : datain[7:0];
    wire [7:0] ram3_datain = store_word ? datain[31:24] :
                             store_half ? datain[15:8]  : datain[7:0];

    // One explicit write port per byte lane.
    always @(posedge wrclk) begin
        if (ram0_we)
            ram0[word_addr] <= ram0_datain;
    end

    always @(posedge wrclk) begin
        if (ram1_we)
            ram1[word_addr] <= ram1_datain;
    end

    always @(posedge wrclk) begin
        if (ram2_we)
            ram2[word_addr] <= ram2_datain;
    end

    always @(posedge wrclk) begin
        if (ram3_we)
            ram3[word_addr] <= ram3_datain;
    end

endmodule

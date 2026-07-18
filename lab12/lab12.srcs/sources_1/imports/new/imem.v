`timescale 1ns / 1ps

// 256 KiB instruction memory (64K x 32 bit).

module imem #(
    parameter INIT_FILE = ""
)(
    input  wire [15:0] address,
    input  wire        clock,
    output reg  [31:0] dataout
    );

    (* ram_style = "block" *) reg [31:0] ram [0:65535];

    initial begin
        if (INIT_FILE != "")
            $readmemh(INIT_FILE, ram);
    end

    always @(posedge clock) begin
        dataout <= ram[address];
    end

endmodule

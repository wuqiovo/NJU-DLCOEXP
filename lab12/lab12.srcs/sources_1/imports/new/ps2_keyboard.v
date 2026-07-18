`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/12 22:54:13
// Design Name: 
// Module Name: ps2_keyboard
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

module ps2_keyboard(
    input        clk,
    input        clrn,
    input        ps2_clk,
    input        ps2_data,
    output [7:0] data,
    output reg   ready,
    input        nextdata_n,
    output reg   overflow
);

    // Temporary buffer for one PS/2 frame:
    // buffer[0]   : start bit
    // buffer[8:1] : 8-bit scan code
    // buffer[9]   : odd parity bit
    reg [9:0] buffer;

    // 8-byte FIFO
    reg [7:0] fifo [7:0];

    // FIFO write pointer and read pointer
    reg [2:0] w_ptr;
    reg [2:0] r_ptr;

    // Bit counter for one PS/2 frame
    reg [3:0] count;

    // Used to synchronize PS/2 clock and detect its falling edge
    reg [2:0] ps2_clk_sync;

    always @(posedge clk) begin
        ps2_clk_sync <= {ps2_clk_sync[1:0], ps2_clk};
    end

    // Detect the falling edge of PS/2 clock
    wire sampling;

    assign sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

    always @(posedge clk) begin
        if (clrn == 1'b0) begin
            count    <= 4'd0;
            w_ptr    <= 3'd0;
            r_ptr    <= 3'd0;
            overflow <= 1'b0;
            ready    <= 1'b0;
        end
        else begin

            // The upper-level module has finished reading current data
            if (ready) begin
                if (nextdata_n == 1'b0) begin
                    r_ptr <= r_ptr + 3'b1;

                    // FIFO becomes empty after current data is read
                    if (w_ptr == (r_ptr + 1'b1))
                        ready <= 1'b0;
                end
            end

            // Sample data at the falling edge of PS/2 clock
            if (sampling) begin
                if (count == 4'd10) begin

                    // Check start bit, stop bit, and odd parity
                    if ((buffer[0] == 1'b0) &&
                        (ps2_data == 1'b1) &&
                        (^buffer[9:1])) begin

                        // Write the 8-bit scan code into FIFO
                        fifo[w_ptr] <= buffer[8:1];
                        w_ptr <= w_ptr + 3'b1;
                        ready <= 1'b1;

                        // Check FIFO overflow
                        overflow <= overflow |
                                    (r_ptr == (w_ptr + 3'b1));
                    end

                    // Prepare to receive the next frame
                    count <= 4'd0;
                end
                else begin
                    // Store the current received bit
                    buffer[count] <= ps2_data;
                    count <= count + 1'b1;
                end
            end
        end
    end

    // Always output the data at the head of FIFO
    assign data = fifo[r_ptr];

endmodule

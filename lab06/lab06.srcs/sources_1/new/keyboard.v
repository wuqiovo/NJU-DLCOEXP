`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/10 19:38:47
// Design Name: 
// Module Name: keyboard
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

module keyboard (
    input clk,
	input clrn,
	input ps2_clk,
	input ps2_data,
	output reg [7:0] key_count,
	output reg [7:0] cur_key,
	output [7:0] ascii_key
	);

    // add your definitions here
    
    // Data from the PS/2 interface
    wire [7:0] keydata;
    wire ready;
    wire overflow;
    
    // Active-low acknowledgement signal
    reg nextdata_n;
    
    // Indicates that F0 has been received
    reg break_pending;
    
    // Indicates that one key is currently being held down
    reg key_pressed;
    
    //----DO NOT CHANGE BEGIN----
    //scancode to ascii conversion, will be initialized by the testbench
    scancode_ram myram(clk, cur_key, ascii_key);
    //PS2 interface, you may need to specify the inputs and outputs
    ps2_keyboard mykey(clk, clrn, ps2_clk, ps2_data, 
            keydata, ready, nextdata_n, overflow);
    //---DO NOT CHANGE END-----
    
    // add you code here
    
    always @(posedge clk) begin
        if (clrn == 1'b0) begin
            key_count     <= 8'h00;
            cur_key       <= 8'h00;
            nextdata_n    <= 1'b1;
            break_pending <= 1'b0;
            key_pressed   <= 1'b0;
        end
        else begin
            nextdata_n <= 1'b1;    
            /*
             * Read a new scan code only when:
             * 1. PS/2 FIFO contains valid data;
             * 2. The previous acknowledgement pulse has finished.
             */
            if (ready && nextdata_n) begin
                nextdata_n <= 1'b0;   
                if (keydata == 8'hF0) begin
                    break_pending <= 1'b1;
                end
                else if (break_pending) begin
                    // This scan code is the released key's make code
                    break_pending <= 1'b0;
                    cur_key <= 8'h0;
                    
                    // Only one key can be pressed in this experiment
                    if (keydata == cur_key)
                        key_pressed <= 1'b0;
                end
                else begin
                    // Normal make code
                    if (key_pressed == 1'b0) begin
                        cur_key <= keydata;
                        key_count <= key_count + 8'd1;
                        key_pressed <= 1'b1;
                    end
    
                    /*
                     * Repeated make codes caused by holding the key
                     * are ignored while key_pressed is high.
                     */
                end
            end
        end
    end
    
endmodule
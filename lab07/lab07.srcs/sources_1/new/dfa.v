`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/11 23:30:28
// Design Name: 
// Module Name: dfa
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

module dfa(
    input clk,
    input [7:0] data,
    input reset,
    output reg result
);

    // State encoding
    localparam S00 = 2'b00;  // n even, other even
    localparam S10 = 2'b10;  // n odd,  other even
    localparam S01 = 2'b01;  // n even, other odd
    localparam S11 = 2'b11;  // n odd,  other odd
    
    reg [1:0] current_state, next_state;

    always @(*) begin
        next_state = current_state; 
        
        case (current_state)
            S00: begin
                if (data == 8'h6E || data == 8'h4E)  // 'n' or 'N'
                    next_state = S10;  
                else if (data != 8'h00)
                    next_state = S01;  
                else
                    next_state = S00;  
            end
            
            S10: begin
                if (data == 8'h6E || data == 8'h4E)
                    next_state = S00;  
                else if (data != 8'h00)
                    next_state = S11;  
                else
                    next_state = S10;
            end
            
            S01: begin
                if (data == 8'h6E || data == 8'h4E)
                    next_state = S11;  
                else if (data != 8'h00)
                    next_state = S00;  
                else
                    next_state = S01;
            end
            
            S11: begin
                if (data == 8'h6E || data == 8'h4E)
                    next_state = S01;  
                else if (data != 8'h00)
                    next_state = S10;  
                else
                    next_state = S11;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            current_state <= S00;
            result <= 1'b0;
        end
        else begin
            current_state <= next_state;
            
            if (data == 8'h00) begin
                result <= (current_state == S10) ? 1'b1 : 1'b0;
            end
        end
    end

endmodule

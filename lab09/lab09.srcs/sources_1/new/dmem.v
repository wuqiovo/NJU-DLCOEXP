`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/13 18:04:25
// Design Name: 
// Module Name: dmem
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

module dmem(
    input  [31:0] addr,
    output reg [31:0] dataout,
    input  [31:0] datain,
    input         rdclk,
    input         wrclk,
    input  [2:0]  memop,
    input         we
);

    reg [7:0] ram0 [0:32767];
    reg [7:0] ram1 [0:32767];
    reg [7:0] ram2 [0:32767];
    reg [7:0] ram3 [0:32767];

    wire [14:0] word_addr = addr[16:2];

    always @(posedge rdclk) begin
        case (memop)
            3'b000: begin // LB
                case (addr[1:0])
                    2'b00: dataout <= {{24{ram0[word_addr][7]}}, ram0[word_addr]};
                    2'b01: dataout <= {{24{ram1[word_addr][7]}}, ram1[word_addr]};
                    2'b10: dataout <= {{24{ram2[word_addr][7]}}, ram2[word_addr]};
                    2'b11: dataout <= {{24{ram3[word_addr][7]}}, ram3[word_addr]};
                endcase
            end

            3'b001: begin // LH
                if (addr[1] == 1'b0)
                    dataout <= {
                        {16{ram1[word_addr][7]}},
                        ram1[word_addr],
                        ram0[word_addr]
                    };
                else
                    dataout <= {
                        {16{ram3[word_addr][7]}},
                        ram3[word_addr],
                        ram2[word_addr]
                    };
            end

            3'b010: begin // LW
                dataout <= {
                    ram3[word_addr],
                    ram2[word_addr],
                    ram1[word_addr],
                    ram0[word_addr]
                };
            end

            3'b100: begin // LBU
                case (addr[1:0])
                    2'b00: dataout <= {24'b0, ram0[word_addr]};
                    2'b01: dataout <= {24'b0, ram1[word_addr]};
                    2'b10: dataout <= {24'b0, ram2[word_addr]};
                    2'b11: dataout <= {24'b0, ram3[word_addr]};
                endcase
            end

            3'b101: begin // LHU
                if (addr[1] == 1'b0)
                    dataout <= {16'b0, ram1[word_addr], ram0[word_addr]};
                else
                    dataout <= {16'b0, ram3[word_addr], ram2[word_addr]};
            end

            default: dataout <= 32'b0;
        endcase
    end

    always @(posedge wrclk) begin
        if (we) begin
            case (memop)
                3'b000: begin // SB
                    case (addr[1:0])
                        2'b00: ram0[word_addr] <= datain[7:0];
                        2'b01: ram1[word_addr] <= datain[7:0];
                        2'b10: ram2[word_addr] <= datain[7:0];
                        2'b11: ram3[word_addr] <= datain[7:0];
                    endcase
                end

                3'b001: begin // SH
                    if (addr[1] == 1'b0) begin
                        ram0[word_addr] <= datain[7:0];
                        ram1[word_addr] <= datain[15:8];
                    end
                    else begin
                        ram2[word_addr] <= datain[7:0];
                        ram3[word_addr] <= datain[15:8];
                    end
                end

                3'b010: begin // SW
                    ram0[word_addr] <= datain[7:0];
                    ram1[word_addr] <= datain[15:8];
                    ram2[word_addr] <= datain[23:16];
                    ram3[word_addr] <= datain[31:24];
                end
            endcase
        end
    end

endmodule


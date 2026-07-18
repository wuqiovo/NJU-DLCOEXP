`timescale 1ns / 1ps

module controller(
    input  wire [31:0] instr,
    output reg  [2:0]  ExtOP,
    output reg         RegWr,
    output reg         ALUAsrc,
    output reg  [1:0]  ALUBsrc,
    output reg  [3:0]  ALUctr,
    output reg  [2:0]  Branch,
    output reg         MemtoReg,
    output reg         MemWr,
    output reg  [2:0]  MemOP
    );

    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire       funct7_5 = instr[30];

    localparam [6:0] OP_LUI    = 7'b0110111,
                     OP_AUIPC  = 7'b0010111,
                     OP_IMM    = 7'b0010011,
                     OP_REG    = 7'b0110011,
                     OP_JAL    = 7'b1101111,
                     OP_JALR   = 7'b1100111,
                     OP_BRANCH = 7'b1100011,
                     OP_LOAD   = 7'b0000011,
                     OP_STORE  = 7'b0100011;

    always @(*) begin
        // Safe defaults prevent state changes for unsupported instructions.
        ExtOP    = 3'b000;
        RegWr    = 1'b0;
        ALUAsrc  = 1'b0;
        ALUBsrc  = 2'b00;
        ALUctr   = 4'b0000;
        Branch   = 3'b000;
        MemtoReg = 1'b0;
        MemWr    = 1'b0;
        MemOP    = 3'b000;

        case (opcode)
            OP_LUI: begin
                ExtOP   = 3'b001;
                RegWr   = 1'b1;
                ALUBsrc = 2'b01;
                ALUctr  = 4'b0011;
            end

            OP_AUIPC: begin
                ExtOP   = 3'b001;
                RegWr   = 1'b1;
                ALUAsrc = 1'b1;
                ALUBsrc = 2'b01;
            end

            OP_IMM: begin
                ExtOP   = 3'b000;
                ALUBsrc = 2'b01;
                case (funct3)
                    3'b000: begin RegWr = 1'b1; ALUctr = 4'b0000; end
                    3'b010: begin RegWr = 1'b1; ALUctr = 4'b0010; end
                    3'b011: begin RegWr = 1'b1; ALUctr = 4'b1010; end
                    3'b100: begin RegWr = 1'b1; ALUctr = 4'b0100; end
                    3'b110: begin RegWr = 1'b1; ALUctr = 4'b0110; end
                    3'b111: begin RegWr = 1'b1; ALUctr = 4'b0111; end
                    3'b001: begin
                        if (!funct7_5) begin
                            RegWr  = 1'b1;
                            ALUctr = 4'b0001;
                        end
                    end
                    3'b101: begin
                        RegWr  = 1'b1;
                        ALUctr = funct7_5 ? 4'b1101 : 4'b0101;
                    end
                    default: ;
                endcase
            end

            OP_REG: begin
                case ({funct3, funct7_5})
                    4'b0000: begin RegWr = 1'b1; ALUctr = 4'b0000; end
                    4'b0001: begin RegWr = 1'b1; ALUctr = 4'b1000; end
                    4'b0010: begin RegWr = 1'b1; ALUctr = 4'b0001; end
                    4'b0100: begin RegWr = 1'b1; ALUctr = 4'b0010; end
                    4'b0110: begin RegWr = 1'b1; ALUctr = 4'b1010; end
                    4'b1000: begin RegWr = 1'b1; ALUctr = 4'b0100; end
                    4'b1010: begin RegWr = 1'b1; ALUctr = 4'b0101; end
                    4'b1011: begin RegWr = 1'b1; ALUctr = 4'b1101; end
                    4'b1100: begin RegWr = 1'b1; ALUctr = 4'b0110; end
                    4'b1110: begin RegWr = 1'b1; ALUctr = 4'b0111; end
                    default: ;
                endcase
            end

            OP_JAL: begin
                ExtOP   = 3'b100;
                RegWr   = 1'b1;
                ALUAsrc = 1'b1;
                ALUBsrc = 2'b10;
                Branch  = 3'b001;
            end

            OP_JALR: begin
                if (funct3 == 3'b000) begin
                    ExtOP   = 3'b000;
                    RegWr   = 1'b1;
                    ALUAsrc = 1'b1;
                    ALUBsrc = 2'b10;
                    Branch  = 3'b010;
                end
            end

            OP_BRANCH: begin
                ExtOP = 3'b011;
                case (funct3)
                    3'b000: begin Branch = 3'b100; ALUctr = 4'b0010; end
                    3'b001: begin Branch = 3'b101; ALUctr = 4'b0010; end
                    3'b100: begin Branch = 3'b110; ALUctr = 4'b0010; end
                    3'b101: begin Branch = 3'b111; ALUctr = 4'b0010; end
                    3'b110: begin Branch = 3'b110; ALUctr = 4'b1010; end
                    3'b111: begin Branch = 3'b111; ALUctr = 4'b1010; end
                    default: ;
                endcase
            end

            OP_LOAD: begin
                ExtOP    = 3'b000;
                ALUBsrc  = 2'b01;
                MemtoReg = 1'b1;
                case (funct3)
                    3'b000, 3'b001, 3'b010, 3'b100, 3'b101: begin
                        RegWr = 1'b1;
                        MemOP = funct3;
                    end
                    default: ;
                endcase
            end

            OP_STORE: begin
                ExtOP   = 3'b010;
                ALUBsrc = 2'b01;
                case (funct3)
                    3'b000, 3'b001, 3'b010: begin
                        MemWr = 1'b1;
                        MemOP = funct3;
                    end
                    default: ;
                endcase
            end

            default: ;
        endcase
    end

endmodule

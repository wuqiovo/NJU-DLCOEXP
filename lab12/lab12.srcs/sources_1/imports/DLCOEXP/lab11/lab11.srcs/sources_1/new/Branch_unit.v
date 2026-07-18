`timescale 1ns / 1ps

module Branch_unit(
    input  wire [2:0] Branch,
    input  wire       zero,
    input  wire       less,
    
    output reg        Branchsel,
    output reg        PCSrc,
    output reg        flushIF,
    output reg        flushID
    );

    // Branch encoding is inherited from controller.v:
    //   000: no branch       001: JAL          010: JALR
    //   100: BEQ             101: BNE
    //   110: BLT/BLTU        111: BGE/BGEU
    //
    // PCSrc indicates that EX has resolved a taken control transfer.
    // Branchsel selects the base used by pc_gen:
    //   0: EX_PC  + EX_imm   (JAL and conditional branches)
    //   1: EX_rs1 + EX_imm   (JALR)
    always @(*) begin
        Branchsel = 1'b0;
        PCSrc     = 1'b0;

        case (Branch)
            3'b000: begin
                // Non-control-transfer instruction.
                PCSrc = 1'b0;
            end

            3'b001: begin
                // JAL is always taken; target = PC + imm.
                PCSrc = 1'b1;
            end

            3'b010: begin
                // JALR is always taken; target = rs1 + imm.
                PCSrc     = 1'b1;
                Branchsel = 1'b1;
            end

            3'b100: begin
                // BEQ
                PCSrc = zero;
            end

            3'b101: begin
                // BNE
                PCSrc = ~zero;
            end

            3'b110: begin
                // BLT or BLTU.  Signed/unsigned selection is performed by
                // EX_ALUctr when the ALU produces less.
                PCSrc = less;
            end

            3'b111: begin
                // BGE or BGEU
                PCSrc = ~less;
            end

            default: begin
                Branchsel = 1'b0;
                PCSrc     = 1'b0;
            end
        endcase
        
        flushIF = PCSrc;
        flushID = PCSrc;
    end
    
endmodule

`timescale 1ns / 1ps

// Translate PS/2 set-2 scan-code bytes into terminal key events.
//
// scan_valid/scan_ready form a ready-valid handshake with ps2_keyboard.
// event_valid is held until terminal_ctrl raises event_ready, so no key event
// is lost while the terminal is clearing a row during scrolling.
module keyboard_decoder (
    input  wire       clk,
    input  wire       reset,

    input  wire       scan_valid,
    input  wire [7:0] scan_code,
    output wire       scan_ready,

    output reg        event_valid,
    input  wire       event_ready,
    output reg  [7:0] event_ascii,
    output reg        event_enter,
    output reg        event_backspace,

    output wire       shift_down
    );

    reg break_pending;
    reg extended_pending;
    reg left_shift_down;
    reg right_shift_down;

    assign shift_down = left_shift_down | right_shift_down;

    // A new scan-code byte may be accepted when there is no pending event, or
    // when the current event is consumed in this cycle.
    assign scan_ready = ~event_valid | event_ready;

    function [7:0] scan_to_ascii;
        input [7:0] code;
        input       shifted;
        begin
            case (code)
                // Letters
                8'h1C: scan_to_ascii = shifted ? 8'h41 : 8'h61; // A/a
                8'h32: scan_to_ascii = shifted ? 8'h42 : 8'h62;
                8'h21: scan_to_ascii = shifted ? 8'h43 : 8'h63;
                8'h23: scan_to_ascii = shifted ? 8'h44 : 8'h64;
                8'h24: scan_to_ascii = shifted ? 8'h45 : 8'h65;
                8'h2B: scan_to_ascii = shifted ? 8'h46 : 8'h66;
                8'h34: scan_to_ascii = shifted ? 8'h47 : 8'h67;
                8'h33: scan_to_ascii = shifted ? 8'h48 : 8'h68;
                8'h43: scan_to_ascii = shifted ? 8'h49 : 8'h69;
                8'h3B: scan_to_ascii = shifted ? 8'h4A : 8'h6A;
                8'h42: scan_to_ascii = shifted ? 8'h4B : 8'h6B;
                8'h4B: scan_to_ascii = shifted ? 8'h4C : 8'h6C;
                8'h3A: scan_to_ascii = shifted ? 8'h4D : 8'h6D;
                8'h31: scan_to_ascii = shifted ? 8'h4E : 8'h6E;
                8'h44: scan_to_ascii = shifted ? 8'h4F : 8'h6F;
                8'h4D: scan_to_ascii = shifted ? 8'h50 : 8'h70;
                8'h15: scan_to_ascii = shifted ? 8'h51 : 8'h71;
                8'h2D: scan_to_ascii = shifted ? 8'h52 : 8'h72;
                8'h1B: scan_to_ascii = shifted ? 8'h53 : 8'h73;
                8'h2C: scan_to_ascii = shifted ? 8'h54 : 8'h74;
                8'h3C: scan_to_ascii = shifted ? 8'h55 : 8'h75;
                8'h2A: scan_to_ascii = shifted ? 8'h56 : 8'h76;
                8'h1D: scan_to_ascii = shifted ? 8'h57 : 8'h77;
                8'h22: scan_to_ascii = shifted ? 8'h58 : 8'h78;
                8'h35: scan_to_ascii = shifted ? 8'h59 : 8'h79;
                8'h1A: scan_to_ascii = shifted ? 8'h5A : 8'h7A;

                // Number row and its Shift symbols
                8'h16: scan_to_ascii = shifted ? 8'h21 : 8'h31; // !/1
                8'h1E: scan_to_ascii = shifted ? 8'h40 : 8'h32; // @/2
                8'h26: scan_to_ascii = shifted ? 8'h23 : 8'h33; // #/3
                8'h25: scan_to_ascii = shifted ? 8'h24 : 8'h34; // $/4
                8'h2E: scan_to_ascii = shifted ? 8'h25 : 8'h35; // %/5
                8'h36: scan_to_ascii = shifted ? 8'h5E : 8'h36; // ^/6
                8'h3D: scan_to_ascii = shifted ? 8'h26 : 8'h37; // &/7
                8'h3E: scan_to_ascii = shifted ? 8'h2A : 8'h38; // */8
                8'h46: scan_to_ascii = shifted ? 8'h28 : 8'h39; // (/9
                8'h45: scan_to_ascii = shifted ? 8'h29 : 8'h30; // )/0

                // Space and punctuation
                8'h29: scan_to_ascii = 8'h20;
                8'h0E: scan_to_ascii = shifted ? 8'h7E : 8'h60; // ~/`
                8'h4E: scan_to_ascii = shifted ? 8'h5F : 8'h2D; // _/-
                8'h55: scan_to_ascii = shifted ? 8'h2B : 8'h3D; // +/=
                8'h54: scan_to_ascii = shifted ? 8'h7B : 8'h5B; // { / [
                8'h5B: scan_to_ascii = shifted ? 8'h7D : 8'h5D; // } / ]
                8'h5D: scan_to_ascii = shifted ? 8'h7C : 8'h5C; // | / backslash
                8'h4C: scan_to_ascii = shifted ? 8'h3A : 8'h3B; // :/;
                8'h52: scan_to_ascii = shifted ? 8'h22 : 8'h27; // double/single quote
                8'h41: scan_to_ascii = shifted ? 8'h3C : 8'h2C; // </,
                8'h49: scan_to_ascii = shifted ? 8'h3E : 8'h2E; // >/.
                8'h4A: scan_to_ascii = shifted ? 8'h3F : 8'h2F; // ?//

                default: scan_to_ascii = 8'h00;
            endcase
        end
    endfunction

    wire [7:0] decoded_ascii;

    assign decoded_ascii = scan_to_ascii(scan_code, shift_down);

    always @(posedge clk) begin
        if (reset) begin
            break_pending    <= 1'b0;
            extended_pending <= 1'b0;
            left_shift_down  <= 1'b0;
            right_shift_down <= 1'b0;
            event_valid      <= 1'b0;
            event_ascii      <= 8'h00;
            event_enter      <= 1'b0;
            event_backspace  <= 1'b0;
        end
        else begin
            if (event_valid && event_ready)
                event_valid <= 1'b0;

            if (scan_valid && scan_ready) begin
                if (scan_code == 8'hE0) begin
                    extended_pending <= 1'b1;
                end
                else if (scan_code == 8'hF0) begin
                    break_pending <= 1'b1;
                end
                else if (!extended_pending &&
                         ((scan_code == 8'h12) || (scan_code == 8'h59))) begin
                    // Left Shift = 12h, right Shift = 59h.
                    if (scan_code == 8'h12)
                        left_shift_down <= ~break_pending;
                    else
                        right_shift_down <= ~break_pending;

                    break_pending    <= 1'b0;
                    extended_pending <= 1'b0;
                end
                else if (break_pending) begin
                    // All non-Shift key-release events are ignored.
                    break_pending    <= 1'b0;
                    extended_pending <= 1'b0;
                end
                else if (extended_pending) begin
                    // Direction keys are intentionally left for a later
                    // extension. Consume the make code without emitting an
                    // event so it cannot be mistaken for a normal key.
                    extended_pending <= 1'b0;
                end
                else if (scan_code == 8'h5A) begin
                    // Enter pressed 
                    event_ascii     <= 8'h00;
                    event_enter     <= 1'b1;
                    event_backspace <= 1'b0;
                    event_valid     <= 1'b1;
                end
                else if (scan_code == 8'h66) begin
                    // Backspace pressed 
                    event_ascii     <= 8'h00;
                    event_enter     <= 1'b0;
                    event_backspace <= 1'b1;
                    event_valid     <= 1'b1;
                end
                else begin
                    if (decoded_ascii != 8'h00) begin
                        event_ascii     <= decoded_ascii;
                        event_enter     <= 1'b0;
                        event_backspace <= 1'b0;
                        event_valid     <= 1'b1;
                    end
                end
            end
        end
    end

endmodule

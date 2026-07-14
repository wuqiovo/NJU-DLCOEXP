`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/11 19:08:43
// Design Name: 
// Module Name: exp
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

module exp(
    input CLK100MHZ,
    input [0:0] SW,
    input PS2_CLK,
    input PS2_DATA,
    output [2:0] LED,
    output reg [7:0] AN,
    output [7:0] HEX
    );

    wire clk;
    wire clrn;

    assign clk = CLK100MHZ;
    assign clrn = SW[0];       // Active-low reset

    wire overflow;
    wire ready;
    wire [7:0] keydata;

    reg nextdata_n;

    /*
     * Prefix states:
     *
     * F0 xx    : release a normal key
     * E0 xx    : press an extended key
     * E0 F0 xx : release an extended key
     */
    reg break_pending;
    reg extend_pending;

    /*
     * key_down[{extended, scancode}]
     *
     * 0xx: normal scan code
     * 1xx: E0 extended scan code
     */
    reg [511:0] key_down;

    reg [7:0] key_count;

    /*
     * The scan code and ASCII currently shown on the display.
     * Modifier keys do not replace the displayed normal key.
     */
    reg [7:0] cur_key;
    reg cur_extended;
    reg [7:0] cur_ascii;
    reg display_key_active;

    wire [7:0] normal_ascii;

    /*
     * Modifier states
     *
     * Left Shift  : 12
     * Right Shift : 59
     * Left Ctrl   : 14
     * Right Ctrl  : E0 14
     * Left Alt    : 11
     * Right Alt   : E0 11
     */
    wire shift_pressed;
    wire ctrl_pressed;
    wire alt_pressed;

    assign shift_pressed =
        key_down[{1'b0, 8'h12}] |
        key_down[{1'b0, 8'h59}];

    assign ctrl_pressed =
        key_down[{1'b0, 8'h14}] |
        key_down[{1'b1, 8'h14}];

    assign alt_pressed =
        key_down[{1'b0, 8'h11}] |
        key_down[{1'b1, 8'h11}];

    assign LED[0] = shift_pressed;
    assign LED[1] = ctrl_pressed;
    assign LED[2] = alt_pressed;

    ps2_keyboard u_keyboard (
        .clk        (clk),
        .clrn       (clrn),
        .ps2_clk    (PS2_CLK),
        .ps2_data   (PS2_DATA),
        .data       (keydata),
        .ready      (ready),
        .nextdata_n (nextdata_n),
        .overflow   (overflow)
    );

    scancode_rom u_rom (
        .scancode(keydata),
        .ascii   (normal_ascii)
    );

    /*
     * Return 1 when the scan code belongs to a modifier key.
     */
    function is_modifier;
        input extended;
        input [7:0] scancode;

        begin
            case ({extended, scancode})
                9'h012: is_modifier = 1'b1; // Left Shift
                9'h059: is_modifier = 1'b1; // Right Shift
                9'h014: is_modifier = 1'b1; // Left Ctrl
                9'h114: is_modifier = 1'b1; // Right Ctrl
                9'h011: is_modifier = 1'b1; // Left Alt
                9'h111: is_modifier = 1'b1; // Right Alt
                default:
                    is_modifier = 1'b0;
            endcase
        end
    endfunction

    /*
     * Convert ordinary ASCII to Shift ASCII.
     *
     * The input ROM should store lowercase letters and ordinary
     * number/punctuation characters.
     */
    function [7:0] apply_shift;
        input [7:0] ascii_in;

        begin
            /*
             * Lowercase letters become uppercase.
             */
            if ((ascii_in >= 8'h61) && (ascii_in <= 8'h7A)) begin
                apply_shift = ascii_in - 8'h20;
            end
            else begin
                case (ascii_in)
                    8'h31: apply_shift = 8'h21; // 1 -> !
                    8'h32: apply_shift = 8'h40; // 2 -> @
                    8'h33: apply_shift = 8'h23; // 3 -> #
                    8'h34: apply_shift = 8'h24; // 4 -> $
                    8'h35: apply_shift = 8'h25; // 5 -> %
                    8'h36: apply_shift = 8'h5E; // 6 -> ^
                    8'h37: apply_shift = 8'h26; // 7 -> &
                    8'h38: apply_shift = 8'h2A; // 8 -> *
                    8'h39: apply_shift = 8'h28; // 9 -> (
                    8'h30: apply_shift = 8'h29; // 0 -> )

                    8'h60: apply_shift = 8'h7E; // ` -> ~
                    8'h2D: apply_shift = 8'h5F; // - -> _
                    8'h3D: apply_shift = 8'h2B; // = -> +
                    8'h5B: apply_shift = 8'h7B; // [ -> {
                    8'h5D: apply_shift = 8'h7D; // ] -> }
                    8'h5C: apply_shift = 8'h7C; // \ -> |
                    8'h3B: apply_shift = 8'h3A; // ; -> :
                    8'h27: apply_shift = 8'h22; // ' -> "
                    8'h2C: apply_shift = 8'h3C; // , -> <
                    8'h2E: apply_shift = 8'h3E; // . -> >
                    8'h2F: apply_shift = 8'h3F; // / -> ?

                    default:
                        apply_shift = ascii_in;
                endcase
            end
        end
    endfunction

    /*
     * PS/2 scan-code processing
     */
    always @(posedge clk) begin
        if (!clrn) begin
            nextdata_n <= 1'b1;
            break_pending <= 1'b0;
            extend_pending <= 1'b0;
            key_down <= 512'b0;
            key_count <= 8'h00;
            cur_key <= 8'h00;
            cur_extended <= 1'b0;
            cur_ascii <= 8'h00;
            display_key_active <= 1'b0;
        end
        else begin
            /*
             * nextdata_n is normally high.
             * It becomes low for one clock cycle when one FIFO
             * entry is accepted.
             */
            nextdata_n <= 1'b1;

            if (ready && nextdata_n) begin
                nextdata_n <= 1'b0;

                /*
                 * E0 is an extended-scan-code prefix.
                 */
                if (keydata == 8'hE0) begin
                    extend_pending <= 1'b1;
                end

                /*
                 * F0 is a break-code prefix.
                 *
                 * For E0 F0 xx, extend_pending remains high.
                 */
                else if (keydata == 8'hF0) begin
                    break_pending <= 1'b1;
                end

                /*
                 * Release code
                 */
                else if (break_pending) begin
                    key_down[{extend_pending, keydata}] <= 1'b0;

                    /*
                     * Blank the four scan-code/ASCII digits only
                     * when the released key is the displayed key.
                     */
                    if (display_key_active &&
                        (keydata == cur_key) &&
                        (extend_pending == cur_extended)) 
                    begin
                        cur_key <= 8'h00;
                        cur_extended <= 1'b0;
                        cur_ascii <= 8'h00;
                        display_key_active <= 1'b0;
                    end

                    break_pending  <= 1'b0;
                    extend_pending <= 1'b0;
                end

                /*
                 * Make code
                 */
                else begin
                    /*
                     * Only the first make code is counted.
                     * Repeated make codes caused by holding a key
                     * are ignored.
                     */
                    if (!key_down[{extend_pending, keydata}]) begin
                        key_down[{extend_pending, keydata}] <= 1'b1;
                        key_count <= key_count + 8'd1;

                        /*
                         * Modifier keys update key_down and LEDs,
                         * but do not replace the ordinary key shown
                         * on the seven-segment display.
                         */
                        if (!is_modifier(extend_pending, keydata)) begin
                            cur_key <= keydata;
                            cur_extended <= extend_pending;
                            display_key_active <= 1'b1;

                            /*
                             * Shift state has already been recorded
                             * when Shift was pressed before this key.
                             */
                            if (shift_pressed)
                                cur_ascii <= apply_shift(normal_ascii);
                            else
                                cur_ascii <= normal_ascii;
                        end
                    end

                    extend_pending <= 1'b0;
                end
            end
        end
    end

    /*
     * AN[1:0] : scan code
     * AN[4:3] : ASCII code
     * AN[7:6] : key count
     * AN[2] and AN[5] are blank separators.
     */
    reg [16:0] scan_cnt;
    wire [2:0] scan_sel;
    reg [3:0] display_num;

    always @(posedge clk) begin
        if (!clrn)
            scan_cnt <= 17'd0;
        else
            scan_cnt <= scan_cnt + 17'd1;
    end

    assign scan_sel = scan_cnt[16:14];

    always @(*) begin
        AN = 8'b1111_1111;
        display_num = 4'h0;

        case (scan_sel)
            3'd0: begin
                if (display_key_active) begin
                    AN = 8'b1111_1110;
                    display_num = cur_key[3:0];
                end
            end
            3'd1: begin
                if (display_key_active) begin
                    AN = 8'b1111_1101;
                    display_num = cur_key[7:4];
                end
            end
            3'd2: begin
                AN = 8'b1111_1111;
            end
            3'd3: begin
                if (display_key_active) begin
                    AN = 8'b1111_0111;
                    display_num = cur_ascii[3:0];
                end
            end
            3'd4: begin
                if (display_key_active) begin
                    AN = 8'b1110_1111;
                    display_num = cur_ascii[7:4];
                end
            end
            3'd5: begin
                AN = 8'b1111_1111;
            end
            3'd6: begin
                AN = 8'b1011_1111;
                display_num = key_count[3:0];
            end
            3'd7: begin
                AN = 8'b0111_1111;
                display_num = key_count[7:4];
            end
            default: begin
                AN          = 8'b1111_1111;
                display_num = 4'h0;
            end
        endcase
    end

    bcd7seg u_bcd7seg (
        .b(display_num),
        .h(HEX)
    );

endmodule

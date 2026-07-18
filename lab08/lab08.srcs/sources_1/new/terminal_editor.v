`timescale 1ns / 1ps

// Editable terminal for a 70-column by 30-row character display.
//
// Only the text entered after the latest "> " prompt is editable. The current
// command is kept in line_buffer; text_vram is redrawn after insertion or
// deletion. Enter commits the command and starts a fresh edit buffer.
module terminal_editor (
    input  wire        clk,
    input  wire        reset,

    input  wire        event_valid,
    output wire        event_ready,
    input  wire [7:0]  event_ascii,
    input  wire        event_enter,
    input  wire        event_backspace,
    input  wire        event_left,
    input  wire        event_right,
    input  wire        event_up,
    input  wire        event_down,

    output reg         vram_wr_en,
    output reg  [11:0] vram_wr_addr,
    output reg  [7:0]  vram_wr_data,

    output reg  [6:0]  cursor_x,
    output reg  [4:0]  cursor_y,
    output reg  [4:0]  row_base,
    output wire        busy
    );

    localparam integer LINE_CAPACITY = 256;

    localparam [4:0] ST_CLEAR_SCREEN   = 5'd0,
                     ST_INIT_PROMPT0   = 5'd1,
                     ST_INIT_PROMPT1   = 5'd2,
                     ST_IDLE           = 5'd3,
                     ST_INSERT_SHIFT   = 5'd4,
                     ST_INSERT_WRITE   = 5'd5,
                     ST_DELETE_SHIFT   = 5'd6,
                     ST_DELETE_FINISH  = 5'd7,
                     ST_PREPARE_REDRAW = 5'd8,
                     ST_SCROLL_CLEAR   = 5'd9,
                     ST_REDRAW_CLEAR   = 5'd10,
                     ST_REDRAW_PROMPT0 = 5'd11,
                     ST_REDRAW_PROMPT1 = 5'd12,
                     ST_REDRAW_WRITE   = 5'd13,
                     ST_REDRAW_FINISH  = 5'd14,
                     ST_ENTER_CLEAR    = 5'd15,
                     ST_ENTER_PROMPT0  = 5'd16,
                     ST_ENTER_PROMPT1  = 5'd17;

    reg [4:0] state;

    // The buffer contains only the current command, not the prompt.
    // A distributed RAM gives the shift FSM an asynchronous read and one
    // write per cycle without duplicating the VGA character memory.
    (* ram_style = "distributed" *) reg [7:0] line_buffer [0:LINE_CAPACITY-1];
    reg [8:0] line_length;
    reg [8:0] cursor_pos;
    reg [8:0] old_line_length;

    // Cache the inserted char and the moving index 
    reg [7:0] pending_char;
    reg [8:0] shift_index;

    // Logical display row containing the prompt for the editable command.
    reg [4:0] command_start_y;
    reg [6:0] preferred_x;

    reg [11:0] clear_addr;
    reg [6:0]  clear_col;
    reg [4:0]  clear_phys_row;
    reg [4:0]  pending_prompt_y;

    reg [2:0] redraw_row_index;
    reg [2:0] redraw_row_limit;
    reg [8:0] redraw_index;

    assign event_ready = (state == ST_IDLE);
    assign busy = (state != ST_IDLE);

    function [4:0] physical_row;
        input [4:0] logical_row;
        input [4:0] base_row;
        reg   [5:0] sum;
        begin
            sum = logical_row + base_row;
            if (sum >= 6'd30)
                physical_row = sum - 6'd30;
            else
                physical_row = sum[4:0];
        end
    endfunction

    // 2 + LINE_CAPACITY is 258, so the command occupies at most four rows.
    function [2:0] offset_row;
        input [9:0] offset;
        begin
            if (offset >= 10'd210)
                offset_row = 3'd3;
            else if (offset >= 10'd140)
                offset_row = 3'd2;
            else if (offset >= 10'd70)
                offset_row = 3'd1;
            else
                offset_row = 3'd0;
        end
    endfunction

    function [6:0] offset_column;
        input [9:0] offset;
        begin
            if (offset >= 10'd210)
                offset_column = offset - 10'd210;
            else if (offset >= 10'd140)
                offset_column = offset - 10'd140;
            else if (offset >= 10'd70)
                offset_column = offset - 10'd70;
            else
                offset_column = offset[6:0];
        end
    endfunction

    function [6:0] clamp_column;
        input [6:0] wanted;
        input [6:0] minimum;
        input [6:0] maximum;
        begin
            if (wanted < minimum)
                clamp_column = minimum;
            else if (wanted > maximum)
                clamp_column = maximum;
            else
                clamp_column = wanted;
        end
    endfunction

    function [8:0] row_column_to_position;
        input [2:0] row_offset;
        input [6:0] column;
        reg   [9:0] screen_offset;
        begin
            case (row_offset)
                3'd0: screen_offset = column;
                3'd1: screen_offset = 10'd70  + column;
                3'd2: screen_offset = 10'd140 + column;
                default: screen_offset = 10'd210 + column;
            endcase
            row_column_to_position = screen_offset - 10'd2;
        end
    endfunction

    function [11:0] command_char_address;
        input [8:0] char_index;
        input [4:0] start_y;
        input [4:0] base_y;
        reg   [9:0] offset;
        reg   [2:0] row_offset;
        reg   [6:0] column;
        reg   [4:0] phys_row;
        begin
            offset = char_index + 10'd2;
            row_offset = offset_row(offset);
            column = offset_column(offset);
            phys_row = physical_row(start_y + row_offset, base_y);
            command_char_address = phys_row * 12'd70 + column;
        end
    endfunction

    wire [9:0] cursor_offset = cursor_pos + 10'd2;
    wire [9:0] tail_offset = line_length + 10'd2;
    wire [9:0] old_tail_offset = old_line_length + 10'd2;

    wire [2:0] cursor_row_offset = offset_row(cursor_offset);
    wire [6:0] cursor_column = offset_column(cursor_offset);
    wire [2:0] tail_row_offset = offset_row(tail_offset);
    wire [6:0] tail_column = offset_column(tail_offset);
    wire [2:0] old_tail_row_offset = offset_row(old_tail_offset);

    wire [4:0] tail_logical_y = command_start_y + tail_row_offset;
    wire [4:0] incremented_base =
        (row_base == 5'd29) ? 5'd0 : row_base + 5'd1;

    wire [6:0] current_min_x =
        (cursor_row_offset == 3'd0) ? 7'd2 : 7'd0;

    wire [2:0] up_row_offset = cursor_row_offset - 3'd1;
    wire [6:0] up_min_x =
        (up_row_offset == 3'd0) ? 7'd2 : 7'd0;
    wire [6:0] up_max_x =
        (up_row_offset < tail_row_offset) ? 7'd69 : tail_column;
    wire [6:0] up_target_x =
        clamp_column(preferred_x, up_min_x, up_max_x);
    wire [8:0] up_target_pos =
        row_column_to_position(up_row_offset, up_target_x);

    wire [2:0] down_row_offset = cursor_row_offset + 3'd1;
    wire [6:0] down_min_x =
        (down_row_offset == 3'd0) ? 7'd2 : 7'd0;
    wire [6:0] down_max_x =
        (down_row_offset < tail_row_offset) ? 7'd69 : tail_column;
    wire [6:0] down_target_x =
        clamp_column(preferred_x, down_min_x, down_max_x);
    wire [8:0] down_target_pos =
        row_column_to_position(down_row_offset, down_target_x);

    always @(posedge clk) begin
        if (reset) begin
            state              <= ST_CLEAR_SCREEN;
            clear_addr         <= 12'd0;
            clear_col          <= 7'd0;
            clear_phys_row     <= 5'd0;
            pending_prompt_y   <= 5'd0;
            redraw_row_index   <= 3'd0;
            redraw_row_limit   <= 3'd0;
            redraw_index       <= 9'd0;
            line_length        <= 9'd0;
            cursor_pos         <= 9'd0;
            old_line_length    <= 9'd0;
            pending_char       <= 8'h00;
            shift_index        <= 9'd0;
            command_start_y    <= 5'd0;
            preferred_x        <= 7'd2;
            cursor_x           <= 7'd0;
            cursor_y           <= 5'd0;
            row_base           <= 5'd0;
            vram_wr_en         <= 1'b0;
            vram_wr_addr       <= 12'd0;
            vram_wr_data       <= 8'h20;
        end
        else begin
            vram_wr_en <= 1'b0;

            case (state)
                ST_CLEAR_SCREEN: begin
                    vram_wr_en   <= 1'b1;
                    vram_wr_addr <= clear_addr;
                    vram_wr_data <= 8'h20;

                    if (clear_addr == 12'd2099) begin
                        clear_addr <= 12'd0;
                        state      <= ST_INIT_PROMPT0;
                    end
                    else begin
                        clear_addr <= clear_addr + 12'd1;
                    end
                end

                ST_INIT_PROMPT0: begin
                    vram_wr_en   <= 1'b1;
                    vram_wr_addr <= 12'd0;
                    vram_wr_data <= 8'h3E; // '>'
                    state        <= ST_INIT_PROMPT1;
                end

                ST_INIT_PROMPT1: begin
                    vram_wr_en      <= 1'b1;
                    vram_wr_addr    <= 12'd1;
                    vram_wr_data    <= 8'h20;
                    command_start_y <= 5'd0;
                    line_length     <= 9'd0;
                    cursor_pos      <= 9'd0;
                    cursor_x        <= 7'd2;
                    cursor_y        <= 5'd0;
                    preferred_x     <= 7'd2;
                    state           <= ST_IDLE;
                end

                ST_IDLE: begin
                    if (event_valid) begin
                        if (event_backspace) begin
                            if (cursor_pos != 9'd0) begin
                                old_line_length <= line_length;
                                shift_index     <= cursor_pos;
                                // Whether to delete the last char 
                                if (cursor_pos < line_length)
                                    state <= ST_DELETE_SHIFT;
                                else
                                    state <= ST_DELETE_FINISH;
                            end
                        end
                        else if (event_enter) begin
                            // Commit after the complete command, not at a
                            // cursor that was moved into its middle.
                            clear_col <= 7'd0;
                            if (tail_logical_y == 5'd29) begin
                                clear_phys_row   <= row_base;
                                row_base         <= incremented_base;
                                pending_prompt_y <= 5'd29;
                            end
                            else begin
                                clear_phys_row <=
                                    physical_row(tail_logical_y + 5'd1,
                                                 row_base);
                                pending_prompt_y <= tail_logical_y + 5'd1;
                            end
                            state <= ST_ENTER_CLEAR;
                        end
                        else if (event_left) begin
                            // Horizontal arrows never cross a visual row.
                            if (cursor_x > current_min_x) begin
                                cursor_pos  <= cursor_pos - 9'd1;
                                cursor_x    <= cursor_x - 7'd1;
                                preferred_x <= cursor_x - 7'd1;
                            end
                        end
                        else if (event_right) begin
                            // Column 69 is a hard horizontal boundary.
                            if ((cursor_x < 7'd69) &&
                                (cursor_pos < line_length)) begin
                                cursor_pos  <= cursor_pos + 9'd1;
                                cursor_x    <= cursor_x + 7'd1;
                                preferred_x <= cursor_x + 7'd1;
                            end
                        end
                        else if (event_up) begin
                            if (cursor_row_offset != 3'd0) begin
                                cursor_pos <= up_target_pos;
                                cursor_x   <= up_target_x;
                                cursor_y   <= cursor_y - 5'd1;
                            end
                        end
                        else if (event_down) begin
                            if (cursor_row_offset < tail_row_offset) begin
                                cursor_pos <= down_target_pos;
                                cursor_x   <= down_target_x;
                                cursor_y   <= cursor_y + 5'd1;
                            end
                        end
                        else if (event_ascii != 8'h00) begin
                            if (line_length < LINE_CAPACITY) begin
                                pending_char    <= event_ascii;
                                old_line_length <= line_length;
                                if (cursor_pos < line_length) begin
                                    shift_index <= line_length;
                                    state       <= ST_INSERT_SHIFT;
                                end
                                else begin
                                    state <= ST_INSERT_WRITE;
                                end
                            end
                        end
                    end
                end

                ST_INSERT_SHIFT: begin
                    line_buffer[shift_index] <=
                        line_buffer[shift_index - 9'd1];
                    if (shift_index == cursor_pos + 9'd1)
                        state <= ST_INSERT_WRITE;
                    else
                        shift_index <= shift_index - 9'd1;
                end

                ST_INSERT_WRITE: begin
                    line_buffer[cursor_pos] <= pending_char;
                    line_length <= line_length + 9'd1;
                    cursor_pos  <= cursor_pos + 9'd1;
                    state       <= ST_PREPARE_REDRAW;
                end

                ST_DELETE_SHIFT: begin
                    if (shift_index < line_length) begin
                        line_buffer[shift_index - 9'd1] <=
                            line_buffer[shift_index];
                        shift_index <= shift_index + 9'd1;
                    end
                    else begin
                        state <= ST_DELETE_FINISH;
                    end
                end

                ST_DELETE_FINISH: begin
                    line_length <= line_length - 9'd1;
                    cursor_pos  <= cursor_pos - 9'd1;
                    state       <= ST_PREPARE_REDRAW;
                end

                ST_PREPARE_REDRAW: begin
                    if (tail_logical_y > 5'd29) begin
                        clear_phys_row  <= row_base;
                        clear_col       <= 7'd0;
                        row_base        <= incremented_base;
                        command_start_y <= command_start_y - 5'd1;
                        state           <= ST_SCROLL_CLEAR;
                    end
                    else begin
                        redraw_row_index <= 3'd0;
                        clear_col        <= 7'd0;
                        if (old_tail_row_offset > tail_row_offset)
                            redraw_row_limit <= old_tail_row_offset;
                        else
                            redraw_row_limit <= tail_row_offset;
                        state <= ST_REDRAW_CLEAR;
                    end
                end

                ST_SCROLL_CLEAR: begin
                    vram_wr_en   <= 1'b1;
                    vram_wr_addr <= clear_phys_row * 12'd70 + clear_col;
                    vram_wr_data <= 8'h20;
                    if (clear_col == 7'd69) begin
                        clear_col <= 7'd0;
                        state     <= ST_PREPARE_REDRAW;
                    end
                    else begin
                        clear_col <= clear_col + 7'd1;
                    end
                end

                // Redraw only rows owned by the current command. Committed
                // history above command_start_y is never cleared.
                ST_REDRAW_CLEAR: begin
                    vram_wr_en   <= 1'b1;
                    vram_wr_addr <=
                        physical_row(command_start_y + redraw_row_index,
                                     row_base) * 12'd70 + clear_col;
                    vram_wr_data <= 8'h20;
                    if (clear_col == 7'd69) begin
                        clear_col <= 7'd0;
                        if (redraw_row_index == redraw_row_limit)
                            state <= ST_REDRAW_PROMPT0;
                        else
                            redraw_row_index <= redraw_row_index + 3'd1;
                    end
                    else begin
                        clear_col <= clear_col + 7'd1;
                    end
                end

                ST_REDRAW_PROMPT0: begin
                    vram_wr_en   <= 1'b1;
                    vram_wr_addr <=
                        physical_row(command_start_y, row_base) * 12'd70;
                    vram_wr_data <= 8'h3E;
                    state        <= ST_REDRAW_PROMPT1;
                end

                ST_REDRAW_PROMPT1: begin
                    vram_wr_en   <= 1'b1;
                    vram_wr_addr <=
                        physical_row(command_start_y, row_base) * 12'd70 +
                        12'd1;
                    vram_wr_data <= 8'h20;
                    redraw_index <= 9'd0;
                    if (line_length == 9'd0)
                        state <= ST_REDRAW_FINISH;
                    else
                        state <= ST_REDRAW_WRITE;
                end

                ST_REDRAW_WRITE: begin
                    vram_wr_en   <= 1'b1;
                    vram_wr_addr <=
                        command_char_address(redraw_index,
                                             command_start_y,
                                             row_base);
                    vram_wr_data <= line_buffer[redraw_index];
                    if (redraw_index + 9'd1 == line_length)
                        state <= ST_REDRAW_FINISH;
                    else
                        redraw_index <= redraw_index + 9'd1;
                end

                ST_REDRAW_FINISH: begin
                    cursor_x        <= cursor_column;
                    cursor_y        <= command_start_y + cursor_row_offset;
                    preferred_x     <= cursor_column;
                    old_line_length <= line_length;
                    state           <= ST_IDLE;
                end

                ST_ENTER_CLEAR: begin
                    vram_wr_en   <= 1'b1;
                    vram_wr_addr <= clear_phys_row * 12'd70 + clear_col;
                    vram_wr_data <= 8'h20;
                    if (clear_col == 7'd69) begin
                        clear_col <= 7'd0;
                        state     <= ST_ENTER_PROMPT0;
                    end
                    else begin
                        clear_col <= clear_col + 7'd1;
                    end
                end

                ST_ENTER_PROMPT0: begin
                    vram_wr_en   <= 1'b1;
                    vram_wr_addr <=
                        physical_row(pending_prompt_y, row_base) * 12'd70;
                    vram_wr_data <= 8'h3E;
                    state        <= ST_ENTER_PROMPT1;
                end

                ST_ENTER_PROMPT1: begin
                    vram_wr_en   <= 1'b1;
                    vram_wr_addr <=
                        physical_row(pending_prompt_y, row_base) * 12'd70 +
                        12'd1;
                    vram_wr_data    <= 8'h20;
                    command_start_y <= pending_prompt_y;
                    line_length     <= 9'd0;
                    cursor_pos      <= 9'd0;
                    old_line_length <= 9'd0;
                    cursor_x        <= 7'd2;
                    cursor_y        <= pending_prompt_y;
                    preferred_x     <= 7'd2;
                    state           <= ST_IDLE;
                end

                default: begin
                    state      <= ST_CLEAR_SCREEN;
                    clear_addr <= 12'd0;
                end
            endcase
        end
    end

endmodule

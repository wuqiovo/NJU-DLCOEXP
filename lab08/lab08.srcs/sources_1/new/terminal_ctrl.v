`timescale 1ns / 1ps

// Terminal editing policy for a 70-column by 30-row character display.
//
// Hard newlines start with a "> " prompt. Automatic wrapping creates a
// continuation row without a prompt. Scrolling uses a circular row_base, so
// only the recycled 70-character row has to be cleared.
module terminal_ctrl (
    input  wire        clk,
    input  wire        reset,

    input  wire        event_valid,
    output wire        event_ready,
    input  wire [7:0]  event_ascii,
    input  wire        event_enter,
    input  wire        event_backspace,

    output reg         vram_wr_en,
    output reg  [11:0] vram_wr_addr,
    output reg  [7:0]  vram_wr_data,

    output reg  [6:0]  cursor_x,
    output reg  [4:0]  cursor_y,
    output reg  [4:0]  row_base,
    output wire        busy
    );

    localparam [2:0] ST_CLEAR_SCREEN = 3'd0,
                     ST_INIT_PROMPT0 = 3'd1,
                     ST_INIT_PROMPT1 = 3'd2,
                     ST_IDLE         = 3'd3,
                     ST_CLEAR_ROW    = 3'd4,
                     ST_NEW_PROMPT0  = 3'd5,
                     ST_NEW_PROMPT1  = 3'd6;

    reg [2:0] state;
    
    // Position immediately after the last valid character in each row.
    reg [6:0]   row_end         [0:29];
    // A prompted row starts with the fixed, non-deletable string "> ".
    // This also distinguishes hard newlines (1) from
    // automatic soft wraps (0).
    reg         row_has_prompt  [0:29];

    // Address for reset clear all 
    reg [11:0]  clear_addr;
    // For clear a certain row 
    reg [6:0]   clear_col;

    // Enter process cache data 
    reg [4:0]   pending_phys_row;
    reg [4:0]   pending_cursor_y;
    reg [4:0]   pending_new_base;
    reg         pending_scroll;
    reg         pending_soft;

    integer i;

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

    wire [4:0] current_phys_row;
    wire [4:0] previous_phys_row;
    wire [4:0] incremented_base;
    wire [6:0] current_prompt_len;
    wire [6:0] previous_prompt_len;

    assign current_phys_row = physical_row(cursor_y, row_base);
    assign previous_phys_row = physical_row(cursor_y - 5'd1, row_base);
    
    assign incremented_base = (row_base == 5'd29) ? 5'd0
                                                  : row_base + 5'd1;
                                                  
    assign current_prompt_len = row_has_prompt[current_phys_row] ? 7'd2
                                                                 : 7'd0;
                                                                 
    assign previous_prompt_len = row_has_prompt[previous_phys_row] ? 7'd2
                                                                   : 7'd0;

    always @(posedge clk) begin
        if (reset) begin
            state            <= ST_CLEAR_SCREEN;
            clear_addr       <= 12'd0;
            clear_col        <= 7'd0;
            cursor_x         <= 7'd0;
            cursor_y         <= 5'd0;
            row_base         <= 5'd0;
            pending_phys_row <= 5'd0;
            pending_cursor_y <= 5'd0;
            pending_new_base <= 5'd0;
            pending_scroll   <= 1'b0;
            pending_soft     <= 1'b0;
            vram_wr_en       <= 1'b0;
            vram_wr_addr     <= 12'd0;
            vram_wr_data     <= 8'h20;

            for (i = 0; i < 30; i = i + 1) begin
                row_end[i]        <= 7'd0;
                row_has_prompt[i] <= 1'b0;
            end
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
                    vram_wr_en       <= 1'b1;
                    vram_wr_addr     <= 12'd0;
                    vram_wr_data     <= 8'h3E; // '>'
                    row_has_prompt[0] <= 1'b1;
                    row_end[0]        <= 7'd2;
                    state             <= ST_INIT_PROMPT1;
                end

                ST_INIT_PROMPT1: begin
                    vram_wr_en   <= 1'b1;
                    vram_wr_addr <= 12'd1;
                    vram_wr_data <= 8'h20;
                    cursor_x     <= 7'd2;
                    cursor_y     <= 5'd0;
                    state        <= ST_IDLE;
                end

                ST_IDLE: begin
                    if (event_valid) begin
                        if (event_backspace) begin
                            if (cursor_x > current_prompt_len) begin
                                vram_wr_en   <= 1'b1;
                                vram_wr_addr <= current_phys_row * 12'd70 +
                                                cursor_x - 7'd1;
                                vram_wr_data <= 8'h20;
                                cursor_x     <= cursor_x - 7'd1;
                                row_end[current_phys_row] <= cursor_x - 7'd1;
                            end
                            else if ((cursor_y != 5'd0) &&
                                    !row_has_prompt[current_phys_row] &&
                                    (row_end[previous_phys_row] >
                                        previous_prompt_len)) begin
                        
                                // Only soft warp can be deleted 
                                vram_wr_en   <= 1'b1;
                                vram_wr_addr <= previous_phys_row * 12'd70 +
                                                row_end[previous_phys_row] - 7'd1;
                                vram_wr_data <= 8'h20;
                        
                                cursor_x <= row_end[previous_phys_row] - 7'd1;
                                cursor_y <= cursor_y - 5'd1;
                        
                                row_end[previous_phys_row] <=
                                    row_end[previous_phys_row] - 7'd1;
                            end
                        end
                        else if (event_enter) begin
                            clear_col      <= 7'd0;
                            pending_soft   <= 1'b0;

                            if (cursor_y == 5'd29) begin
                                pending_phys_row <= row_base;
                                pending_cursor_y <= 5'd29;
                                pending_new_base <= incremented_base;
                                pending_scroll   <= 1'b1;
                            end
                            else begin
                                pending_phys_row <= physical_row(cursor_y + 5'd1,
                                                                 row_base);
                                pending_cursor_y <= cursor_y + 5'd1;
                                pending_new_base <= row_base;
                                pending_scroll   <= 1'b0;
                            end
                            state <= ST_CLEAR_ROW;
                        end
                        else if (event_ascii != 8'h00) begin
                            vram_wr_en   <= 1'b1;
                            vram_wr_addr <= current_phys_row * 12'd70 + cursor_x;
                            vram_wr_data <= event_ascii;
                            row_end[current_phys_row] <= cursor_x + 7'd1;

                            if (cursor_x == 7'd69) begin
                                clear_col    <= 7'd0;
                                pending_soft <= 1'b1;

                                if (cursor_y == 5'd29) begin
                                    pending_phys_row <= row_base;
                                    pending_cursor_y <= 5'd29;
                                    pending_new_base <= incremented_base;
                                    pending_scroll   <= 1'b1;
                                end
                                else begin
                                    pending_phys_row <=
                                        physical_row(cursor_y + 5'd1, row_base);
                                    pending_cursor_y <= cursor_y + 5'd1;
                                    pending_new_base <= row_base;
                                    pending_scroll   <= 1'b0;
                                end
                                state <= ST_CLEAR_ROW;
                            end
                            else begin
                                cursor_x <= cursor_x + 7'd1;
                            end
                        end
                    end
                end

                ST_CLEAR_ROW: begin
                    vram_wr_en   <= 1'b1;
                    vram_wr_addr <= pending_phys_row * 12'd70 + clear_col;
                    vram_wr_data <= 8'h20;

                    if (clear_col == 7'd69) begin
                        clear_col <= 7'd0;
                        row_end[pending_phys_row]        <= 7'd0;
                        row_has_prompt[pending_phys_row] <= ~pending_soft;

                        if (pending_scroll)
                            row_base <= pending_new_base;

                        cursor_y <= pending_cursor_y;

                        if (pending_soft) begin
                            cursor_x <= 7'd0;
                            state    <= ST_IDLE;
                        end
                        else begin
                            state <= ST_NEW_PROMPT0;
                        end
                    end
                    else begin
                        clear_col <= clear_col + 7'd1;
                    end
                end

                ST_NEW_PROMPT0: begin
                    vram_wr_en   <= 1'b1;
                    vram_wr_addr <= pending_phys_row * 12'd70;
                    vram_wr_data <= 8'h3E; // '>'
                    row_end[pending_phys_row] <= 7'd2;
                    state <= ST_NEW_PROMPT1;
                end

                ST_NEW_PROMPT1: begin
                    vram_wr_en   <= 1'b1;
                    vram_wr_addr <= pending_phys_row * 12'd70 + 12'd1;
                    vram_wr_data <= 8'h20;
                    cursor_x     <= 7'd2;
                    state        <= ST_IDLE;
                end

                default: begin
                    state      <= ST_CLEAR_SCREEN;
                    clear_addr <= 12'd0;
                end
            endcase
        end
    end

endmodule

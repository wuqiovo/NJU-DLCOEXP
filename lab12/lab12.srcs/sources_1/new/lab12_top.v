`timescale 1ns / 1ps

module lab12_top(
    input   [0:0]   SW,
    input           CLK100MHZ,
   
    output  [3:0]   VGA_R,
    output  [3:0]   VGA_G,
    output  [3:0]   VGA_B,
    output          VGA_HS,
    output          VGA_VS,
    
    input           PS2_CLK,
    input           PS2_DATA,
    
    output  [7:0]   AN,
    output  [7:0]   HEX,
    output  [15:0]  LED
    );
    
    // Address decode base 
    localparam DATA_BASE    = 32'h0010_0000;
    localparam VGA_BASE     = 32'h0020_0000;
    localparam KEY_BASE     = 32'h0030_0000;
    localparam TIMER_BASE   = 32'h0040_0000;
    localparam DISPLAY_BASE = 32'h0050_0000;
    
    // Basic wire definition
    wire clk25;
    wire clk_locked;
    wire board_reset;
    wire system_reset;

    assign board_reset  = SW[0];
    
    // Instruction memory wire definition  
    wire  [31:0]   imemaddr;
    wire  [31:0]   imemdataout;
    wire           imemclk;
    
    // Data memory wire definition 
	wire  [31:0]   daddr;
	wire  [31:0]   dmem_local_addr;
	wire  [31:0]   dmem_rdata;
	wire  [31:0]   dmem_wdata;
	wire           dmemrdclk;
	wire           dmemwrclk;
	wire  [2:0]    dmemop;
	wire           dmem_we;
	
	// Debug wire 
	wire  [31:0]   dbgdata;
	
	// CPU related wire definition 
	reg   [31:0]   cpu_rdata;
	wire  cpu_we;
	
	// Vram wire 
	wire  vram_we;
	wire  [11:0]   vram_wr_addr;
    wire  [7:0]    vram_wr_data;

    wire  [11:0]   vram_rd_addr;
    wire  [7:0]    vram_rd_data;

    assign vram_wr_addr = daddr[11:0];
    assign vram_wr_data = dmem_wdata[7:0];
	
	// Keyboard wire 
	wire  [31:0]   keyboard_rdata;
	wire keyboard_overflow;
	
	// VGA related wire 
	reg   [6:0]    cursor_x;
    reg   [4:0]    cursor_y;
    reg   [4:0]    row_base;
    
    wire  [11:0]   vga_data;
    wire  [9:0]    h_addr;
    wire  [9:0]    v_addr;
    wire           vga_valid;
    wire           raw_hsync;
    wire           raw_vsync;
	
	// Timer wire 
	wire  [31:0]   timer_rdata; 
	
	// Display wire 
	wire display_we;
    
    // Memory mapping 
    wire select_dmem =
        daddr >= 32'h0010_0000 &&
        daddr <  32'h0012_0000;
    
    wire select_vram =
        daddr >= 32'h0020_0000 &&
        daddr <  32'h0020_1000;
    
    wire select_vga_ctrl =
        daddr >= 32'h0020_1000 &&
        daddr <  32'h0020_1010;
    
    wire select_keyboard = daddr[31:20] == 12'h003;
    wire select_timer    = daddr[31:20] == 12'h004;
    wire select_display  = 
        daddr >= 32'h0050_0000 &&
        daddr <  32'h0050_0010;
    
    assign dmem_local_addr = daddr - DATA_BASE;
    assign dmem_we = cpu_we && select_dmem;
    assign vram_we = cpu_we && select_vram && (dmemop == 3'b000);
    assign display_we = cpu_we && select_display;
    
    always @(*) begin
        if (select_dmem)
            cpu_rdata = dmem_rdata;
        else if (select_keyboard)
            cpu_rdata = keyboard_rdata;
        else if (select_timer)
            cpu_rdata = timer_rdata;
        else
            cpu_rdata = 32'b0;
    end
    
    clk_wiz_0 u_clk_wiz_0 (
        .clk_in1    (CLK100MHZ),
        .clk_out1   (clk25),
        .reset      (1'b0),
        .locked     (clk_locked)
    );
    
    wire reset_request = board_reset | ~clk_locked;
    reg [1:0] reset_sync;

    always @(posedge clk25) begin
        if (reset_request)
            reset_sync <= 2'b11;
        else
            reset_sync <= {reset_sync[0], 1'b0};
    end

    assign system_reset = reset_sync[1];
    
    rv32ip u_rv32ip (
        .clock          (clk25),
        .reset          (system_reset),
        
        .imemaddr       (imemaddr),
        .imemdataout    (imemdataout),
        .imemclk        (imemclk),
        
        .dmemaddr       (daddr),
        .dmemdataout    (cpu_rdata),
        .dmemdatain     (dmem_wdata),
        .dmemrdclk      (dmemrdclk),
        .dmemwrclk      (dmemwrclk),
        .dmemop         (dmemop),
        .dmemwe         (cpu_we),
        
        .dbgdata        (dbgdata)
    );
    
    imem #(
        .INIT_FILE      ("main.hex")
    ) u_imem (
        .address        (imemaddr[17:2]),
        .clock          (imemclk),
        .dataout        (imemdataout)
    );
    
    dmem #(
        .INIT_FILE0     ("main_d0.hex"),
        .INIT_FILE1     ("main_d1.hex"),
        .INIT_FILE2     ("main_d2.hex"),
        .INIT_FILE3     ("main_d3.hex")
    ) u_dmem (
        .addr           (dmem_local_addr),
        .dataout        (dmem_rdata),
        .datain         (dmem_wdata),
        .rdclk          (dmemrdclk),
        .wrclk          (dmemwrclk),
        .memop          (dmemop),
        .we             (dmem_we)
    );
    
    text_vram u_text_vram (
        // CPU implements store instruction on the posedge of dmemwrclk 
        .wr_clk  (dmemwrclk),
        .wr_en   (vram_we),
        .wr_addr (vram_wr_addr),
        .wr_data (vram_wr_data),

        // VGA read in a 25MHZ clock 
        .rd_clk  (clk25),
        .rd_addr (vram_rd_addr),
        .rd_data (vram_rd_data)
    );
    
    always @(posedge dmemwrclk) begin
        if (system_reset) begin
            row_base <= 5'd0;
            cursor_x <= 7'd0;
            cursor_y <= 5'd0;
        end
        else if (cpu_we &&
                select_vga_ctrl &&
                (dmemop == 3'b010)) begin
            case (daddr[3:2])
                2'd0: row_base <= dmem_wdata[4:0];
                2'd1: cursor_x <= dmem_wdata[6:0];
                2'd2: cursor_y <= dmem_wdata[4:0];
                default: ;
            endcase
        end
    end
    
    vga_ctrl u_vga_ctrl (
        .pclk     (clk25),
        .reset    (system_reset),
        .vga_data (vga_data),

        .h_addr   (h_addr),
        .v_addr   (v_addr),
        .hsync    (raw_hsync),
        .vsync    (raw_vsync),
        .valid    (vga_valid),

        .vga_r    (VGA_R),
        .vga_g    (VGA_G),
        .vga_b    (VGA_B)
    );
    
    text_renderer #(
        .FONT_INIT_FILE("ascii_font_9x16.mem")
    ) u_text_renderer (
        .pclk         (clk25),
        .reset        (system_reset),

        .h_addr       (h_addr),
        .v_addr       (v_addr),
        .valid_in     (vga_valid),
        .hsync_in     (raw_hsync),
        .vsync_in     (raw_vsync),

        .vram_rd_addr (vram_rd_addr),
        .vram_rd_data (vram_rd_data),

        .cursor_x     (cursor_x),
        .cursor_y     (cursor_y),
        .row_base     (row_base),

        .vga_data     (vga_data),
        .hsync_out    (VGA_HS),
        .vsync_out    (VGA_VS)
    );
    
    keyboard_mmio u_keyboard_mmio (
        .clk         (clk25),
        .reset       (system_reset),

        .PS2_CLK     (PS2_CLK),
        .PS2_DATA    (PS2_DATA),

        .cpu_addr    (daddr),
        .cpu_wdata   (dmem_wdata),
        .cpu_memop   (dmemop),
        .cpu_we      (cpu_we),
        .cpu_wrclk   (dmemwrclk),

        .cpu_rdata   (keyboard_rdata),
        .overflow    (keyboard_overflow)
    );
    
    timer_mmio #(
        .CYCLES_PER_MS(25000)
    ) u_timer (
        .clk   (clk25),
        .reset (system_reset),
        .addr  (daddr),
        .rdata (timer_rdata)
    );
    
    display_mmio u_display (
        .scan_clk   (clk25),
        .wrclk      (dmemwrclk),
        .reset      (system_reset),
        
        .cpu_addr   (daddr),
        .cpu_wdata  (dmem_wdata),
        .cpu_memop  (dmemop),
        .cpu_we     (display_we),
        
        .LED        (LED),
        .AN         (AN),
        .HEX        (HEX)
    );
    
endmodule

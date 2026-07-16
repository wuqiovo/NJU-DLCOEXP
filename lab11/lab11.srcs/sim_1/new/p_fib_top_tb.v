`timescale 1ns / 1ps

module p_fib_top_tb;

    reg         CLK100MHZ;
    reg         BTNC;
    reg  [15:0] SW;
    wire [7:0]  AN;
    wire [7:0]  HEX;
    wire [0:0]  LED;

    integer step_count;
    integer error_count;

    p_fib_top #(
        .IMEM_INIT_FILE ("fib.hex"),
        .DEBOUNCE_COUNT (21'd2),
        .STEP_LOW_CYCLES(8'd1)
    ) dut (
        .CLK100MHZ (CLK100MHZ),
        .BTNC      (BTNC),
        .SW        (SW),
        .AN        (AN),
        .HEX       (HEX),
        .LED       (LED)
    );

    initial CLK100MHZ = 1'b0;
    always #5 CLK100MHZ = ~CLK100MHZ;

    // Hold the simulated button long enough for the two synchronizer stages
    // and the shortened debounce counter, then release it completely.
    task press_step_button;
        begin
            BTNC = 1'b1;
            repeat (8) @(posedge CLK100MHZ);
            BTNC = 1'b0;
            repeat (8) @(posedge CLK100MHZ);
        end
    endtask

    // DP is active-low and must remain disabled after moving valid to LED[0].
    always @(negedge CLK100MHZ) begin
        if (HEX[7] !== 1'b1) begin
            $display("ERROR: decimal point was enabled at time %0t", $time);
            error_count = error_count + 1;
        end
    end

    initial begin
        BTNC       = 1'b0;
        SW         = 16'b0;
        step_count = 0;
        error_count = 0;

        // Set n=10 on SW[15:6] and assert the active-high reset on SW[0].
        SW[15:6] = 10'd10;
        SW[0]    = 1'b1;
        repeat (5) @(posedge CLK100MHZ);
        SW[0] = 1'b0;

        // Allow input synchronization and the bootstrap fetch to complete.
        repeat (8) @(posedge CLK100MHZ);

        while ((LED[0] !== 1'b1) && (step_count < 200)) begin
            press_step_button;
            step_count = step_count + 1;
        end

        if (LED[0] !== 1'b1) begin
            $display("ERROR: timeout after %0d CPU steps", step_count);
            error_count = error_count + 1;
        end
        else if (dut.fib_result !== 32'd55) begin
            $display("ERROR: fib(10) expected 55, got %0d (0x%08h)",
                     dut.fib_result, dut.fib_result);
            error_count = error_count + 1;
        end
        else begin
            $display("INFO: fib(10) = %0d after %0d CPU steps",
                     dut.fib_result, step_count);
        end

        if (error_count == 0)
            $display("TEST PASSED");
        else
            $display("TEST FAILED with %0d error(s)", error_count);

        #20;
        $finish;
    end

endmodule

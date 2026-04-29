`timescale 1ns/1ps

module overall_simulation();

    // Inputs/Outputs
    logic        clk;
    logic        reset;
    logic [31:0] Instruction_TEST, DataRead_TEST, Pc_TEST, DataAdress_TEST, DataWrite_TEST;
    logic [3:0]  MemoryOp_TEST;

    // File handle variable
    int f_log;

    // Instantiate DUT
    top dut (
        .clk(clk),
        .reset(reset),
        .Instruction_TEST(Instruction_TEST),
        .DataRead_TEST(DataRead_TEST),
        .Pc_TEST(Pc_TEST),
        .DataAdress_TEST(DataAdress_TEST),
        .DataWrite_TEST(DataWrite_TEST),
        .MemoryOp_TEST(MemoryOp_TEST)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Manual Monitor: Writes to file with FIXED-WIDTH columns
    always @(Pc_TEST) begin
        if (f_log != 0) begin
            // Replaced \t with spaces and added fixed width (e.g., %8t, %4d, %08h, %10d)
            $fdisplay(f_log, "%8t  %4d  %08h  %10d  %10d  %4b", 
                      $time, Pc_TEST, Instruction_TEST, DataAdress_TEST, DataWrite_TEST, MemoryOp_TEST);
        end
    end

    // Auto-Stop Logic: Monitor for program termination
    always @(posedge clk) begin
        // Check for an EBREAK (0x00100073) or a JAL-to-self (0x0000006f)
        // Note: Adjust these hex values if your compiler uses a different halt instruction!
        if (Instruction_TEST == 32'h0000006f || Instruction_TEST == 32'h00100073) begin
            $display("Program termination instruction detected at time %0t.", $time);
            $fclose(f_log);
            $display("Trace written to test/sim_results.txt");
            $finish;
        end
    end

    // Test sequence 
    initial begin
        // Open VCD for GTKWave
        $dumpfile("test/wave.vcd");
        $dumpvars(0, overall_simulation);

        // Open the log file
        f_log = $fopen("test/sim_results.txt", "w");
        
        // Update header to match the new fixed-width formatting below
        $fdisplay(f_log, "    Time    PC     Instr     ALU_Res  DataWrite MemOp");

        // Initial Reset
        reset = 1;
        #20;
        reset = 0;

        // TIMEOUT FAIL-SAFE: Simulation will stop here only if it gets stuck
        // Set this to a very high number that covers your longest program
        #500000; 
        
        $display("WARNING: Simulation stopped by fail-safe timeout.");
        $fclose(f_log);
        $finish;
    end

endmodule
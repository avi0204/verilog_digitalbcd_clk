`timescale 1ns / 1ps

module tb_digital_clock();

    // 1. Declare Testbench Signals
    // Inputs are 'reg' so we can manipulate them in the initial block
    reg clk;
    reg reset;
    reg ena;
    reg twelvehr;
    reg [7:0] ha;
    reg [7:0] ma;
    reg [7:0] sa;

    // Outputs are 'wire' to connect to the module
    wire pm;
    wire alarm;
    wire [7:0] hh;
    wire [7:0] mm;
    wire [7:0] ss;

    // 2. Instantiate the Unit Under Test (UUT)
    top_module uut (
        .clk(clk), 
        .reset(reset), 
        .ena(ena), 
        .twelvehr(twelvehr), 
        .ha(ha), 
        .ma(ma), 
        .sa(sa), 
        .pm(pm), 
        .alarm(alarm), 
        .hh(hh), 
        .mm(mm), 
        .ss(ss)
    );

    // 3. Clock Generation (10ns period -> 100MHz)
    // In this simulation, 1 clock cycle = 1 second of clock time
    always #5 clk = ~clk;

    // 4. Test Sequence
    initial begin
        // Initialize all inputs
        clk = 0;
        reset = 1;
        ena = 0;
        twelvehr = 1; // Start in 12-hour mode
        
        // Set Alarm for 12:00:05 AM
        ha = 8'h12; 
        ma = 8'h00; 
        sa = 8'h05;

        // Apply Reset
        #20;
        reset = 0;
        ena = 1;

        // Set up the console monitor. This prints a new line automatically whenever any of these variables change!
        $monitor("Time: %h:%h:%h | PM: %b | 12HR Mode: %b | Alarm: %b", hh, mm, ss, pm, twelvehr, alarm);

        // --- TEST CASE 1: Normal Counting & Alarm ---
        // Let it run for 10 clock cycles (Simulates 10 seconds).
        // You should see the alarm go high at 12:00:05 and drop at 12:00:06.
        #100; 

        // --- TEST CASE 2: The 12/24 Hour Switch ---
        // Switch to 24-hour mode. The time should instantly change from 12:00:10 to 00:00:10
        twelvehr = 0; 
        #50;

        // Switch back to 12-hour mode
        twelvehr = 1;
        #50;

        // --- TEST CASE 3: Enable/Pause functionality ---
        ena = 0; // Pause the clock
        #50;     // Time should not change during this wait
        ena = 1; // Resume

        // --- TEST CASE 4: The Midnight/Noon Rollover ---
        // Instead of waiting manually, we force the internal clock close to 11:59:58
        $display("--- Fast forwarding to 11:59:58 AM ---");
        
        // We use 'wait' to pause the testbench until a condition is met
        wait (hh == 8'h11 && mm == 8'h59 && ss == 8'h58);
        
        // Watch it roll over to 12:00:00 PM and verify 'pm' toggles to 1
        #50; 

        $display("--- Simulation Complete ---");
        $finish; // End the simulation
    end

endmodule
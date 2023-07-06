module lastInFirstOutMemoryTestBench ();

    // ----------------- CLOCK -----------------
    
    // clock generator wires/registers
	wire clock;

	// generates clock square wave with 10ns period
	ClockGenerator clock_generator(clock);

    // ----------------- Register File -----------------
 
    // register file wires/registers
    reg sig_push = 0 , sig_pop = 0;

    wire flag_full, flag_empty;

    reg [31:0] DataIn;
    wire [31:0] DataOut;
    
    // register file ( array of 32 registers )
    lastInFirstOutMemory stack_memory(clock, DataOut, flag_full, flag_empty, sig_push, sig_pop, DataIn);
    
    // ----------------- Simulation -----------------

    initial begin

        

        #0
        DataIn <= 32'd16; // write value 16
        sig_push <= 1; // enable write

        #10
        DataIn <= 32'd64; // write value 64

        #10
        DataIn <= 32'd32; // write value 32

        #10
        DataIn <= 32'd1; // write value 1

        #10
        DataIn <= 32'd2; // write value 2

        #10
        DataIn <= 32'd3; // write value 3
        

        #10
        sig_pop <= 1; // enable read
        sig_push <= 0; // disable write
        DataIn <= 32'd0; // write value 3


        #10
        $display("(%0t) > DataOut=%0d", $time, DataOut);

        #10
        $display("(%0t) > DataOut=%0d", $time, DataOut);

        #10
        $display("(%0t) > DataOut=%0d", $time, DataOut);

        #10
        $display("(%0t) > DataOut=%0d", $time, DataOut);

        #10
        $display("(%0t) > DataOut=%0d", $time, DataOut);

        #10
        $display("(%0t) > DataOut=%0d", $time, DataOut);

        #10
        $display("(%0t) > DataOut=%0d", $time, DataOut);

        #10 $finish;    // 100 cycle
    end

endmodule
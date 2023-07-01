module registerFileTestBench ();

    // ----------------- CLOCK -----------------
    
    // clock generator wires/registers
	wire clock;

	// generates clock square wave with 10ns period
	ClockGenerator clock_generator(clock);

    // ----------------- Register File -----------------
 
    // register file wires/registers
    reg [4:0] RA, RB, RW;
    reg sig_enable_write;
    reg [31:0] BusW;
    wire [31:0] BusA, BusB;
    
    // register file ( array of 32 registers )
    registerFile register_file(clock, RA, RB, RW, sig_enable_write, BusW, BusA, BusB);
    
    // ----------------- Simulation -----------------

    initial begin

        
        // test the register file by writing and reading some values from it from different registers
        // and checking if the values are correct

        #0
        RW <= 5'd1; // write to register 1
        BusW <= 32'd16; // write value 16
        sig_enable_write <= 1; // enable write

        #10
        RW <= 5'd2; // write to register 2
        BusW <= 32'd32; // write value 32
        sig_enable_write <= 1; // enable write

        #10
        RA <= 5'd1;
        RB <= 5'd2;
        sig_enable_write <= 0; // enable write

        #10

        // results of previouse cycle
        $display("(%0t) > BusA=%0d, BusB=%0d", $time, BusA, BusB);


        // test overwrite
        RW <= 5'd2; // write to register 2
        BusW <= 32'd64; // write value 32
        sig_enable_write <= 1; // enable write

        #10
        $display("(%0t) > BusA=%0d, BusB=%0d", $time, BusA, BusB);

        // test write without write signal
        RW <= 5'd2; // write to register 2
        BusW <= 32'd128; // write value 32
        sig_enable_write <= 0; // disable write

        #10
        $display("(%0t) > BusA=%0d, BusB=%0d", $time, BusA, BusB);


        #10 $finish;    // 100 cycle
    end

endmodule
module instructionMemoryTestBench ();

    // ----------------- CLOCK -----------------
    
    // clock generator wires/registers
	wire clock;

	// generates clock square wave with 10ns period
	ClockGenerator clock_generator(clock);

    // ----------------- Instruction Memory -----------------
 
    // instruction memory wires/registers		
    reg [31:0] AddressBus;
    wire [31:0] InstructionReg;
    
    instructionMemory instruction_memory(clock, AddressBus, InstructionReg);
	
    // ----------------- Simulation -----------------

    initial begin

        #0
        AddressBus <= 5'd0; // set address to 0
        
        #5
        AddressBus <= 5'd1; // set address to 1
        
        #10
        AddressBus <= 5'd2; // set address to 2

        #10
        AddressBus <= 5'd3; // set address to 3

        #10 $finish;    // 100 cycle
    end

endmodule
module pcModuleTestBench ();

    // ----------------- CLOCK -----------------
    
    // clock generator wires/registers
	wire clock;

	// generates clock square wave with 10ns period
	ClockGenerator clock_generator(clock);

    // ----------------- PC Module Ports -----------------
 
    // register file wires/registers
    reg [1:0] sig_pc_src = PC_Src_Dft;
    reg [31:0] ReturnAddress;
    reg signed [31:0] J_TypeImmediate, I_TypeImmediate;
    wire [31:0] PC;
    
    pcModule pc_module(clock, PC, I_TypeImmediate, J_TypeImmediate, ReturnAddress, sig_pc_src);
    
    // ----------------- Simulation -----------------

    initial begin

        
        // test the pc module by using different inputs and checking if the outputs are correct

        #0
        $display("(%0t) > PC=%0d", $time, PC);
        sig_pc_src <= PC_Src_Dft; // PC source default

        #10
        $display("(%0t) > PC=%0d", $time, PC);
        sig_pc_src <= PC_Src_Ra; // PC source default
        ReturnAddress <= 32'd2; // write value 2

        #10
        $display("(%0t) > PC=%0d", $time, PC);
        sig_pc_src <= PC_Src_Jmp; // PC source default
        J_TypeImmediate <= 32'd10; // add 10 to PC

        #10
        $display("(%0t) > PC=%0d", $time, PC);
        sig_pc_src <= PC_Src_Jmp; // PC source default
        J_TypeImmediate <= -32'd10; // subtract 10 from PC

        #10
        $display("(%0t) > PC=%0d", $time, PC);
        sig_pc_src <= PC_Src_BTA; // PC source default
        I_TypeImmediate <= 32'd8; // add to PC via taken branch

        #10
        // results of previouse cycle
        $display("(%0t) > PC=%0d", $time, PC);

        #10 $finish;    // 100 cycle
    end

endmodule
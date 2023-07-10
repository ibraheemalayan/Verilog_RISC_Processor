module riscProcessor();

    initial begin		 
		#0
        $display("(%0t) > initializing processor ...", $time);

        #300 $finish;
    end

    // -----------------------------------------------------------------
    // ----------------------------- Wires -----------------------------
    // -----------------------------------------------------------------

    // clock generator wires/registers
	wire clock;

    // ----------------- Control Unit -----------------

    // multi-bit mux control signals
    wire [2:0] sig_alu_op;
    wire [1:0] sig_pc_src;
    wire [1:0] sig_alu_src;

    // single bit mux control signals
    wire sig_write_back_data_select,
            sig_rb_src;

    // operation enable signals
    wire sig_rf_enable_write,
            sig_enable_data_memory_write,
            sig_enable_data_memory_read;

    // stage enable signals ( used as clock for each stage )
    wire en_instruction_fetch,
            en_instruction_decode,
            en_execute;

    // ----------------- Instrution Memory -----------------

    // instruction memory wires/registers		
    wire [31:0] PC; // output of PC Module input to instruction memory
    wire [0:31] InstructionReg; // output if instruction memory, input to other modules

    // Instruction Parts
    wire [1:0] InstructionType; // instruction type [ R, S, I, J ]
    wire [4:0] FunctionCode; // function code
    
    wire StopBit; // Stop bit

    assign InstructionType = InstructionReg[29:30];
    assign FunctionCode = InstructionReg[0:4];
    assign StopBit = InstructionReg[31];



    // ----------------- PC Modules -----------------

    // register file wires/registers
    reg [31:0] ReturnAddress;  // input to PC Module from TODO
    wire signed [31:0] Sign_Extended_J_TypeImmediate, Sign_Extended_I_TypeImmediate;  // input to PC Module from decode stage
    wire [31:0] Unsigned_Extended_I_TypeImmediate; // input to ALU Module from decode stage

    // signed extender for J-Type instructions immediate ( 24 bit to 32 )
    assign Sign_Extended_J_TypeImmediate = { {8{InstructionReg[5]}}, InstructionReg[5:28] };

    // signed extender for I-Type instructions immediate ( 14 bit to 32 )
    assign Sign_Extended_I_TypeImmediate = { {18{InstructionReg[15]}}, InstructionReg[15:28] };

    // unsigned extender for I-Type instructions immediate ( 14 bit to 32 )
    assign Unsigned_Extended_I_TypeImmediate = { {18{1'b0}}, InstructionReg[15:28] };
																				
    // ----------------- Register File -----------------

    // ----------------- ALU -----------------

    wire flag_zero; // zero flag

    // -----------------------------------------------------------------
    // ----------------------------- CLOCK -----------------------------
    // -----------------------------------------------------------------
    
    
	// generates clock square wave with 10ns period
	ClockGenerator clock_generator(clock);

    // -----------------------------------------------------------------
    // ----------------- Control Unit -----------------
    // -----------------------------------------------------------------
    

    controlUnit control_unit(
        clock,
        
        // signal outputs
        sig_alu_op,
        sig_pc_src,
        sig_rb_src,
        sig_alu_src,
        sig_rf_enable_write,
        sig_enable_data_memory_write,
        sig_enable_data_memory_read,
        sig_write_back_data_select,

        // stage enable outputs
        en_instruction_fetch,
        en_instruction_decode,
        en_execute,

        // inputs
        InstructionType,
        FunctionCode,
        StopBit,
        flag_zero
    );

    // -----------------------------------------------------------------
    // ----------------- Instruction Memory -----------------
    // -----------------------------------------------------------------
    
    // use en_instruction_fetch as clock for instruction memory
    instructionMemory instruction_memory(clock, PC, InstructionReg);

    // -----------------------------------------------------------------
    // ----------------- PC Module -----------------
    // -----------------------------------------------------------------

    
    pcModule pc_module(en_instruction_fetch, PC, Sign_Extended_I_TypeImmediate, Sign_Extended_J_TypeImmediate, ReturnAddress, sig_pc_src);
	

endmodule
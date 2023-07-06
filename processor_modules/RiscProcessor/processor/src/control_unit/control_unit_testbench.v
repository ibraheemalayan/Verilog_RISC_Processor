module controlUnitTestBench ();

    // ----------------- CLOCK -----------------
    
    // clock generator wires/registers
	wire clock;

	// generates clock square wave with 10ns period
	ClockGenerator clock_generator(clock);

    // ----------------- Inputs -----------------

    // instruction type [ R, S, I, J ]
    reg [1:0] InstructionType;

    // function code
    reg [4:0] FunctionCode;

    // zero flag
    reg flag_zero;

    // Stop bit
    reg StopBit;

    // ----------------- Signals -----------------

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
	
    // ----------------- I/R Type Simulation -----------------

    // initial begin

    //     #0 
    //     // AND takes 4 stages to complete ( 4 clock cycles )
    //     InstructionType = R_Type;
    //     FunctionCode = AND; 
    //     StopBit = 0;
    //     flag_zero = 0;

    //     #40

    //     // ADDI takes 4 stages to complete ( 4 clock cycles )
    //     InstructionType = I_Type;
    //     FunctionCode = ADDI; 
    //     StopBit = 0;
    //     flag_zero = 0;

    //     #40

    //     // ANDI takes 4 stages to complete ( 4 clock cycles )
    //     InstructionType = I_Type;
    //     FunctionCode = ANDI; 
    //     StopBit = 0;
    //     flag_zero = 0;

    //     #40

    //     // LW takes 5 stages to complete ( 5 clock cycles )
    //     InstructionType = I_Type;
    //     FunctionCode = LW; 
    //     StopBit = 0;
    //     flag_zero = 0;

    //     #50

    //     // SW takes 4 stages to complete ( 4 clock cycles )
    //     InstructionType = I_Type;
    //     FunctionCode = SW; 
    //     StopBit = 0;
    //     flag_zero = 0;

    //     #40 

     
    //     #10 $finish;

    // end

    // ----------------- J/BEQ Simulation -----------------

    initial begin

        #0 
        // AND takes 4 stages to complete ( 4 clock cycles )
        InstructionType = R_Type;
        FunctionCode = AND; 
        StopBit = 0;
        flag_zero = 0;

        #40

        // J takes 2 stages to complete ( 2 clock cycles )
        InstructionType = J_Type;
        FunctionCode = J; 
        StopBit = 0;
        flag_zero = 0;

        #20
        
        // Not-taken branch
        // BEQ takes 3 stages to complete ( 3 clock cycles )
        InstructionType = I_Type;
        FunctionCode = BEQ; 
        StopBit = 0;
        flag_zero = 0;

        #30
        // Taken branch
        // BEQ takes 3 stages to complete ( 3 clock cycles )
        InstructionType = I_Type;
        FunctionCode = BEQ; 
        StopBit = 0;
        flag_zero = 1;

        #30

        // SW takes 4 stages to complete ( 4 clock cycles )
        InstructionType = I_Type;
        FunctionCode = SW; 
        StopBit = 0;
        flag_zero = 0;

        #40 

     
        #10 $finish;

    end


endmodule
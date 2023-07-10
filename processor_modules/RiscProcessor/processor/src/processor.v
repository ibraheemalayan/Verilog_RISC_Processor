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
    wire [4:0] FunctionCode; // function code

    // R-Type
    wire [4:0] Rs1, Rd, Rs2; // register selection

    wire [1:0] InstructionType; // instruction type [ R, S, I, J ]
    wire StopBit; // Stop bit

    // ----------------- Assignment -----------------

    // Function Code
    assign FunctionCode = InstructionReg[0:4];

    // R-Type
    assign Rs1 = InstructionReg[5:9];
    assign Rd = InstructionReg[10:14];
    assign Rs2 = InstructionReg[15:19];
    
    // J-Type
    wire signed [0:23] J_TypeImmediate;
    assign J_TypeImmediate = InstructionReg[5:28];

    // I-Type
    wire signed [0:13] I_TypeImmediate;
    assign I_TypeImmediate = InstructionReg[15:28];

    // S-Type
    wire [0:4] SA;
    assign SA = InstructionReg[20:24];

    // Instruction Type and Stop Bit
    assign InstructionType = InstructionReg[29:30];
    assign StopBit = InstructionReg[31];

    // signed extender for S-Type instructions immediate ( 5 bit to 32 )
    assign Sign_Extended_SA = { {27{SA[0]}}, SA };


    // ----------------- PC Modules -----------------

    // register file wires/registers
    reg [31:0] ReturnAddress;  // input to PC Module from TODO
    wire signed [31:0] Sign_Extended_J_TypeImmediate, Sign_Extended_I_TypeImmediate;  // input to PC Module from decode stage
    wire [31:0] Unsigned_Extended_I_TypeImmediate; // input to ALU Module from decode stage

    // signed extender for J-Type instructions immediate ( 24 bit to 32 )
    assign Sign_Extended_J_TypeImmediate = { {8{J_TypeImmediate[0]}}, J_TypeImmediate };

    // signed extender for I-Type instructions immediate ( 14 bit to 32 )
    assign Sign_Extended_I_TypeImmediate = { {18{I_TypeImmediate[0]}}, I_TypeImmediate };

    // unsigned extender for I-Type instructions immediate ( 14 bit to 32 )
    assign Unsigned_Extended_I_TypeImmediate = { {18{1'b0}}, I_TypeImmediate };
																				
    // ----------------- Register File -----------------
    
    reg [31:0] BusW; // TODO
    wire [31:0] BusA, BusB;

    wire [4:0] RA, RB, RW;

    assign RA = Rs1;
    assign RB = (sig_rb_src == LOW) ? Rs2 : Rd;
    assign RW = Rd;

    // ----------------- ALU -----------------

    reg [31:0] ALU_A, ALU_B; // operands
    wire [31:0] ALU_Output;
    wire flag_zero;
    wire flag_negative;

    assign ALU_A = BusA;

    always @(en_instruction_decode) begin
        case (sig_alu_src)
            ALU_Src_SAi: ALU_B = Sign_Extended_SA;
            ALU_Src_Reg: ALU_B = BusB;
            ALU_Src_SIm: ALU_B = Sign_Extended_I_TypeImmediate;
            ALU_Src_UIm: ALU_B = Unsigned_Extended_I_TypeImmediate;
        endcase    
    end
    

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
	
    // -----------------------------------------------------------------
    // ----------------- Register File -----------------
    // -----------------------------------------------------------------


    // register file ( array of 32 registers )
    // use en_instruction_decode as clock for register file
    registerFile register_file(en_instruction_decode, RA, RB, RW, sig_enable_write, BusW, BusA, BusB);

    // -----------------------------------------------------------------
    // ----------------- ALU -----------------
    // -----------------------------------------------------------------

    ALU alu(en_execute, ALU_A, ALU_B, ALU_Output, flag_zero, flag_negative, sig_alu_op);


endmodule
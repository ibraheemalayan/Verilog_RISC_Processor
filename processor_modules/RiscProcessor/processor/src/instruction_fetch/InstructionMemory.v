// stores program instructions

// instruction formts:

    // R-Type Instruction Format
    // Function_5, Rs1_5, Rd_5, Rs2_5, Unused_9, Type_2, Stop_1
        
    // I-Type Instruction Format
    // Function_5, Rs1_5, Rd_5, Immediate_14, Type_2, Stop_1

    // J-Type Instruction Format
    // Function_5, Signed Immediate_24, Type_2, Stop_1

    // S-Type Instruction Format
    // Function_5, Rs1_5, Rd_5, Rs2_5, SA_5, Unused_4, Type_2, Stop_1


module instructionMemory(clock, AddressBus, InstructionReg);

    // ----------------- INPUTS -----------------

    // clock
    input wire clock;

    // address bus
    input wire [31:0] AddressBus;

    // ----------------- OUTPUTS -----------------

    // instruction register
    output reg [31:0] InstructionReg;

    // ----------------- INTERNALS -----------------

    // instruction memory
    reg [31:0] instruction_memory [0:255];

    // ----------------- LOGIC -----------------

    // read instruction at positive edge of clock
    always  @(*) begin
        InstructionReg <= instruction_memory[AddressBus];
    end

    // ----------------- INITIALIZATION -----------------

    initial begin
        // load instructions from file
        // $readmemh("instructions.txt", instruction_memory);

        
        // ADDI R1, R0, 3; load R1 with 3
        instruction_memory[0] = { ADDI, R0, R1, 14'd3, I_Type, 1'b0 };
        
        // ADDI R2, R0, 5; load R2 with 5
        instruction_memory[1] = { ADDI, R0, R2, 14'd5, I_Type, 1'b0 };
        
        // ADD R3, R1, R2; add R1 and R2 and store in R3
        instruction_memory[2] = { ADD, R1, R3, R2, 9'd0, R_Type, 1'b0 };
        

    end


endmodule
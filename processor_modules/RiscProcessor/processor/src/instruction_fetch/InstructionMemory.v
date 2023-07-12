// stores program instructions ( used 32 bit cells )



module instructionMemory(clock, AddressBus, InstructionReg);

    // ----------------- INPUTS -----------------

    // clock
    input wire clock;

    // address bus
    input wire [31:0] AddressBus;

    // ----------------- OUTPUTS -----------------

    // instruction register
    output reg [0:31] InstructionReg;

    // ----------------- INTERNALS -----------------

    // instruction memory
    reg [31:0] instruction_memory [0:255];


    // ----------------- LOGIC -----------------

    assign InstructionReg = instruction_memory[AddressBus[31:2]]; // drop least significant 2 bits of address since instructions are 32 bits

    // ----------------- INITIALIZATION -----------------

    initial begin
        // load instructions from file
        // $readmemh("instructions.txt", instruction_memory);

        
        // instruction formts:

            // R-Type Instruction Format
            // Function_5, Rs1_5, Rd_5, Rs2_5, Unused_9, Type_2, Stop_1

            // I-Type Instruction Format
            // Function_5, Rs1_5, Rd_5, Immediate_14, Type_2, Stop_1

            // J-Type Instruction Format
            // Function_5, Signed Immediate_24, Type_2, Stop_1

            // S-Type Instruction Format
            // Function_5, Rs1_5, Rd_5, Rs2_5, SA_5, Unused_4, Type_2, Stop_1


        // initial
        instruction_memory[0] = 32'b0;


        // ----------------- Addition Loop Program -----------------
        
        // // R1 = 2
        // instruction_memory[1] = { ADDI, R0, R1, 14'd2, I_Type, 1'b0 };

        //  // R2 = 3
        // instruction_memory[2] = { ADDI, R0, R2, 14'd3, I_Type, 1'b0 };

        // // R3 = R1 + R2
        // instruction_memory[3] = { ADD, R1, R3, R2, 9'd0, R_Type, 1'b0 };

        // // R3 = R3 + R3
        // instruction_memory[4] = { ADD, R3, R3, R3, 9'd0, R_Type, 1'b0 };

        // // Jump -4; jump to instruction_memory[3]
        // instruction_memory[5] = { J, -24'sd4, J_Type, 1'b0 };

        // // SUB R3, R1, R2; subtract R1 and R2 and store in R3
        // instruction_memory[6] = { SUB, R1, R3, R2, 9'd0, R_Type, 1'b0 };


        // ----------------- Shift Loop Program -----------------

        // // R1 = 1000
        // instruction_memory[1] = { ADDI, R0, R1, 14'b1000, I_Type, 1'b0 };

        // // R2 = 1110
        // instruction_memory[2] = { ADDI, R0, R2, 14'b1110, I_Type, 1'b0 };

        // // R3 = R1 & R2 = 'b1000 = 'd8
        // instruction_memory[3] = { AND, R1, R3, R2, 9'd0, R_Type, 1'b0 };

        // // R4 = 2
        // instruction_memory[4] = { ADDI, R0, R4, 14'd2, I_Type, 1'b0 };

        // // R5 = R3 >> 3 = 'b0001 = 'd1
        // instruction_memory[5] = { SLR, R3, R5, 5'd0, 5'd3, 4'd0, S_Type, 1'b0 };

        // // R6 = R3 << R4 = 'b100000 = 'd32
        // instruction_memory[6] = { SLLV, R3, R6, R4, 5'd0, 4'd3, S_Type, 1'b0 };

        // // Jump -4; jump to instruction_memory[5]
        // instruction_memory[7] = { J, -24'sd4, J_Type, 1'b0 };

        // ----------------- Branch Program -----------------

        // R1 = 1000
        instruction_memory[1] = { ADDI, R0, R1, 14'b1000, I_Type, 1'b0 };

        // R2 = 1110
        instruction_memory[2] = { ADDI, R0, R2, 14'b1110, I_Type, 1'b0 };

        // Branch +8 if R1 == R2 ( Not Taken )
        instruction_memory[3] = { BEQ, R1, R2, 5'd0, 9'd8, I_Type, 1'b0 };

        // R1 = 1110
        instruction_memory[4] = { ADDI, R0, R1, 14'b1110, I_Type, 1'b0 };

        // Branch +8 if R1 == R2 ( Taken )
        instruction_memory[5] = { BEQ, R1, R2, 5'd0, 9'd8, I_Type, 1'b0 };

        // dead code should not be executed
        // R4 = 1
        instruction_memory[6] = { ADDI, R0, R4, 14'd1, I_Type, 1'b0 };

        // R5 = 2
        instruction_memory[7] = { ADDI, R0, R5, 14'd2, I_Type, 1'b0 };


        

    end


endmodule
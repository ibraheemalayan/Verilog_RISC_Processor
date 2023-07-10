// outputs control signals and stage enable signals to the rest of the processor
// takes intruction-type, function-code, and flags as inputs

module controlUnit(
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

    // ----------------- INPUTS -----------------

    // clock
    input wire clock;

    // instruction type [ R, S, I, J ]
    input wire [1:0] InstructionType;

    // function code
    input wire [4:0] FunctionCode;

    // zero flag
    input wire flag_zero;

    // Stop bit
    input wire StopBit;

    // ----------------- OUTPUTS -----------------
    
    // Mux signals
    output reg [2:0] sig_alu_op;
    output reg [1:0] sig_pc_src = PC_Src_Dft;
    output reg [1:0] sig_alu_src;
    
    output reg sig_write_back_data_select,
                sig_rb_src;

    // operation enable signals
    output reg sig_rf_enable_write = LOW,
                sig_enable_data_memory_write = LOW,
                sig_enable_data_memory_read = LOW;

    
    // stage enable signals ( used as clock for each stage )
    output reg en_execute = LOW,
                en_instruction_fetch = LOW,
                en_instruction_decode = LOW;

    // ----------------- INTERNALS -----------------

    // binary codes for stages
    `define STG_FTCH 3'b000
    `define STG_DCDE 3'b001
    `define STG_EXEC 3'b010
    `define STG_MEM 3'b011
    `define STG_WRB 3'b100
    `define STG_INIT 3'b101
    

    reg [2:0] current_stage = `STG_INIT;
    reg [2:0] next_stage = `STG_FTCH;

    // ----------------- LOGIC -----------------

    always@(posedge clock) begin // maybe use negative edge

        current_stage = next_stage;

    end

    always@(posedge clock) begin // maybe use negative edge

        case (current_stage)

            `STG_INIT: begin                                    
                en_instruction_fetch = LOW; // fetch after finding PC src
                next_stage <= `STG_FTCH;
            end

            `STG_FTCH: begin 
                // disable previous stage
                en_instruction_decode = LOW;
                en_execute = LOW;

                // disable signals
                sig_rf_enable_write = LOW;
                sig_enable_data_memory_write = LOW;
                sig_enable_data_memory_read = LOW; 

                // enable current stage
                en_instruction_fetch = HIGH; // fetch after finding PC src

                // next stage
                next_stage <= `STG_DCDE;

                // ---------------------------------------------
                // ------------ set control signals ------------
                // ---------------------------------------------

                // ---- PC Source ----

                // here the inputs are the ones from the previous stage
                if (StopBit == HIGH) begin

                    sig_pc_src = PC_Src_Ra; // use return address as PC

                end else if (InstructionType == J_Type) begin

                    sig_pc_src = PC_Src_Jmp; // use JTA as PC

                end else if (InstructionType == I_Type && FunctionCode == BEQ  && flag_zero == HIGH) begin

                    sig_pc_src = PC_Src_BTA; // use BTA as PC if taken branch

                end else begin

                    sig_pc_src = PC_Src_Dft; // use next instruction address as PC

                end
            
            end

            `STG_DCDE: begin 
                // disable previous stage
                en_instruction_fetch = LOW;

                // enable current stage
                en_instruction_decode = HIGH;
                
                 // next stage
                next_stage <= (InstructionType == J_Type && FunctionCode == J) ? `STG_FTCH : `STG_EXEC;

                // ---------------------------------------------
                // ------------ set control signals ------------
                // ---------------------------------------------

                // ---- RB Source ----

                sig_rb_src = (InstructionType == I_Type) ? HIGH : LOW;

                // ---- ALU Source ----
                
                if (InstructionType == S_Type && FunctionCode inside {SLL, SLR} ) begin

                    // shift left or right by immediate in SA
                    sig_alu_src = ALU_Src_SAi; // use extended SA as operand
                
                end else if (InstructionType == S_Type || InstructionType == R_Type) begin

                    // R-Type or S-Type that uses register for shift amount
                    sig_alu_src = ALU_Src_Reg; // use Rb as operand

                end else if (InstructionType == I_Type && FunctionCode == ANDI) begin

                    // ANDI instruction uses unsigned immediate
                    sig_alu_src = ALU_Src_UIm; // use unsigned immediate as operand

                end else if (InstructionType == I_Type) begin

                    // I_Type instruction other than ANDI uses signed immediate
                    sig_alu_src = ALU_Src_SIm; // use signed immediate as operand

                end

            
            end

            `STG_EXEC: begin 
                
                // disable previous stage
                en_instruction_decode = LOW;

                // enable current stage
                en_execute = HIGH;

                // next stage
                if  ( 
                    ( InstructionType == J_Type && FunctionCode == JAL ) || 
                    ( InstructionType == I_Type && FunctionCode inside {LW, SW} ) ) begin 

                    next_stage <= `STG_MEM;

                end else if ( 
                    ( InstructionType == I_Type && FunctionCode == BEQ ) || 
                    ( InstructionType == R_Type && FunctionCode == CMP ) ) begin 

                    next_stage <= `STG_FTCH;

                end else begin

                    next_stage <= `STG_WRB;

                end

                // ---------------------------------------------
                // ------------ set control signals ------------
                // ---------------------------------------------

                // ---- ALU Operation ----

                if (InstructionType == S_Type && FunctionCode inside {SLL, SLLV}) begin

                    sig_alu_op = ALU_SLL; // shift left

                end else if (InstructionType == S_Type && FunctionCode inside {SLR, SLRV}) begin

                    sig_alu_op = ALU_SLR; // shift right

                end else if ( 
                    ( InstructionType == I_Type && FunctionCode == ANDI ) || 
                    ( InstructionType == R_Type && FunctionCode == AND ) ) begin 

                    sig_alu_op = ALU_And; // bitwise AND

                end else if ( 
                    ( InstructionType == I_Type && FunctionCode == BEQ ) || 
                    ( InstructionType == R_Type && FunctionCode inside {SUB, CMP} ) ) begin
                    
                    sig_alu_op = ALU_Sub; // subtract

                end else begin

                    sig_alu_op = ALU_Add; // add

                end

            end

            `STG_MEM: begin 
                // disable previous stage
                en_execute = LOW;
                
                 // next stage
                next_stage <= (InstructionType == I_Type && FunctionCode == LW) ? `STG_WRB : `STG_FTCH;

                // ---------------------------------------------
                // ------------ set control signals ------------
                // ---------------------------------------------

                // ---- Memory Write ----

                sig_enable_data_memory_write = (InstructionType == I_Type && FunctionCode == SW) ? HIGH : LOW;

                // ---- Memory Read ----

                sig_enable_data_memory_read = (InstructionType == I_Type && FunctionCode == LW) ? HIGH : LOW;
            
            end

            `STG_WRB: begin 
                // disable previous stages
                sig_enable_data_memory_write = LOW;
                sig_enable_data_memory_read = LOW;
                en_execute = LOW;                
                
                 // next stage
                next_stage <= `STG_FTCH;

                // ---------------------------------------------
                // ------------ set control signals ------------
                // ---------------------------------------------
                
                // register file write enable
                sig_rf_enable_write = HIGH;

                // write back data source
                sig_write_back_data_select = (InstructionType == I_Type && FunctionCode == LW) ? HIGH : LOW;

            end

        endcase

    end







endmodule
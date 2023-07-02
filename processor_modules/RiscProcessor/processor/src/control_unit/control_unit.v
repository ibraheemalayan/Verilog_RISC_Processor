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
    flag_zero,
    
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

    // ----------------- OUTPUTS -----------------
    
    // Mux signals
    output reg [2:0] sig_alu_op;
    output reg [1:0] sig_pc_src;
    output reg [1:0] sig_alu_src;
    
    output reg sig_write_back_data_select,
                sig_rb_src;

    // operation enable signals
    output reg sig_rf_enable_write,
                sig_enable_data_memory_write,
                sig_enable_data_memory_read;

    
    // stage enable signals ( used as clock for each stage )
    output reg en_execute,
                en_instruction_fetch,
                en_instruction_decode;

    // ----------------- INTERNALS -----------------

    `define HIGH 1'b1
    `define LOW 1'b0

    // binary codes for stages
    `define STG_FTCH 3'b000
    `define STG_DCDE 3'b001
    `define STG_EXEC 3'b010
    `define STG_MEM 3'b011
    `define STG_WRB 3'b100

    reg [2:0] current_stage = STG_FTCH;
    reg [2:0] next_stage = STG_DCDE;

    // ----------------- LOGIC -----------------

    // ! // TODO write psuedo code 

    always@(posedge clock) begin // maybe use negative edge

        case (current_stage)

            `STG_EXEC: begin 
                
                // disable previous stage
                en_instruction_decode <= LOW;

                // enable current stage
                en_execute <= HIGH;

                // next stage
                next_stage <= ? STG_MEM : STG_WRB;
                if (FunctionCode inside {LW, SW, JAL}) begin 

                    next_stage <= STG_MEM;

                end else if (FunctionCode inside {BEQ, CMP}) begin

                    next_stage <= STG_FTCH;

                end else begin

                    next_stage <= STG_WRB;

                end

                // set control signals

                // ---- ALU Source ----
                
                if (InstructionType == S_Type && FunctionCode inside {SLL, SLR} ) begin

                    // shift left or right by immediate in SA
                    sig_alu_src <= ALU_Src_SAi; // use extended SA as operand
                
                end else if (InstructionType == S_Type || InstructionType == R_Type) begin

                    // R-Type or S-Type that uses register for shift amount
                    sig_alu_src <= ALU_Src_Reg; // use Rb as operand

                end else if (InstructionType == I_Type && FunctionCode == ANDI) begin

                    // ANDI instruction uses unsigned immediate
                    sig_alu_src <= ALU_Src_UIm; // use unsigned immediate as operand

                end else if (InstructionType == I_Type) begin

                    // I_Type instruction other than ANDI uses signed immediate
                    sig_alu_src <= ALU_Src_SIm; // use signed immediate as operand

                end

                // ---- ALU Operation ----

                if (FunctionCode inside {SLL, SLLV}) begin

                    sig_alu_op <= ALU_SLL; // shift left

                end else if (FunctionCode inside {SLR, SLRV}) begin

                    sig_alu_op <= ALU_SLR; // shift right

                end else if (FunctionCode inside {ANDI, AND}) begin

                    sig_alu_op <= ALU_And; // bitwise AND

                end else if (FunctionCode inside {SUB, CMP, BEQ}) begin

                    sig_alu_op <= ALU_Sub; // subtract

                end else begin

                    sig_alu_op <= ALU_Add; // add

                end

                


            end




        endcase

        sig_rb_src <= current_stage == `STG_EXEC && ? 1'b1 : 1'b0;

    end







endmodule
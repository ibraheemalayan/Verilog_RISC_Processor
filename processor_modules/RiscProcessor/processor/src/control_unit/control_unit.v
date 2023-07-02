// outputs control signals and stage enable signals to the rest of the processor
// takes intruction-type, function-code, and flags as inputs

module controlUnit(
    clock,

    // signal outputs
    sig_alu_op,
    sig_pc_src,
    sig_rb_src,
    sig_rf_enable_write,
    sig_enable_data_memory_write,
    sig_enable_data_memory_read,
    sig_write_back_data_select,

    // stage enable outputs
    en_instruction_fetch,
    en_instruction_decode,
    en_execute,
    en_memory_access,

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
    output reg [1:0] sig_rb_src;
    output reg sig_write_back_data_select;

    // operation enable signals
    output reg sig_rf_enable_write,
                sig_enable_data_memory_write,
                sig_enable_data_memory_read;

    
    // stage enable signals ( used as clock for each stage )
    output reg en_execute,
                en_memory_access,
                en_instruction_fetch,
                en_instruction_decode;



endmodule
// PC register and its logic

// PC src can be one of the following:
// 1- PC + 4
// 2- Branch target address (if instruction is I-Type & function is BEQ and zero flag is 1)
// 3- Jump target address (if instruction is J-Type: J, JAL)
// 4- link return address (if stop bit is set)

module pcModule(clock, PC, I_TypeImmediate, J_TypeImmediate, ReturnAddress, sig_pc_src);

    // ----------------- INPUTS -----------------

    // clock
    input wire clock;
    
    // PC source signal
    input wire [1:0] sig_pc_src;

    // stack poped return address bus
    input wire [31:0] ReturnAddress;

    // extended I-Type immediate bus
    input wire [31:0] I_TypeImmediate;

    // extended J-Type immediate bus
    input wire signed [31:0] J_TypeImmediate;

    // ----------------- OUTPUTS -----------------

    // PC
    output reg [31:0] PC;

    // ----------------- INTERNALS -----------------

    // PC + 4
    wire [31:0] pc_plus_4;

    // JTA
    wire [31:0] jump_target_address;

    // BTA
    wire [31:0] brach_target_address;
    
    assign pc_plus_4 = PC + 32'd4;
    assign jump_target_address = PC + J_TypeImmediate;
    assign brach_target_address = PC + I_TypeImmediate;

    initial begin
		PC <= 32'd0;
	end


    always @(posedge clock) begin
        case (sig_pc_src)
            PC_Src_Dft: begin
                // default      : PC = PC + 4
                PC <= pc_plus_4;      
            end  
            PC_Src_Ra:  begin
                // return       : PC = Return Address
                PC <= ReturnAddress;  
            end  
            PC_Src_BTA: begin
                // Taken Branch : PC = PC + J_TypeImmediate
                PC <= brach_target_address;
            end  
            PC_Src_Jmp: begin
                // Jump         : PC = PC + I_TypeImmediate
                PC <= jump_target_address;
            end  
        endcase
	end

    

endmodule

parameter

// instruction types
// 2-bit instruction type (00: R-Type, 01: J-Type, 10: I-type, 11: S-type)
 
    R_Type = 2'b00, 
    J_Type = 2'b01, 
    I_Type = 2'b10, 
    S_Type = 2'b11,

// instruction function code
// 5-bit instruction function code

    // R-Type Instructions
    AND = 5'b00000, // Reg(Rd) = Reg(Rs1) & Reg(Rs2) 
    ADD = 5'b00001, // Reg(Rd) = Reg(Rs1) + Reg(Rs2) 
    SUB = 5'b00010, // Reg(Rd) = Reg(Rs1) - Reg(Rs2) 
    CMP = 5'b00011, // zero-signal = Reg(Rs) == Reg(Rs2), negative-signal = Reg(Rs) < Reg(Rs2)

    // I-Type Instructions
    ANDI = 5'b00000, // Reg(Rd) = Reg(Rs1) & Immediate14
    ADDI = 5'b00001, // Reg(Rd) = Reg(Rs1) + Immediate14
    LW   = 5'b00010, // Reg(Rd) = Mem(Reg(Rs1) + Imm_14)
    SW   = 5'b00011, // Mem(Reg(Rs1) + Imm_14) = Reg(Rd)
    BEQ  = 5'b00100, // Branch if (Reg(Rs1) == Reg(Rd))

    // J-Type Instructions
    J    = 5'b00000, // PC = PC + Immediate_24
    JAL  = 5'b00001, // PC = PC + Immediate_24; Stack.Push (PC + 4)

    // S-Type Instructions
    SLL  = 5'b00000, // Reg(Rd) = Reg(Rs1) << SA_5
    SLR  = 5'b00001, // Reg(Rd) = Reg(Rs1) >> SA_5
    SLLV = 5'b00010, // Reg(Rd) = Reg(Rs1) << Reg(Rs2)
    SLRV = 5'b00011, // Reg(Rd) = Reg(Rs1) >> Reg(Rs2)

// ALU function code signal
// 2-bit chip-select for ALU

    ALU_Add = 3'b000, // used in ADD, ADDI, LW, SW, JAL
    ALU_Sub = 3'b001, // used in SUB, CMP, BEQ
    ALU_And = 3'b010, // used in AND, ANDI
    ALU_SLL = 3'b011, // used in SLL, SLLV
    ALU_SLR = 3'b100, // used in SLR, SLRV

// PC source signal
// 2-bit source select for next PC value

    PC_Src_Dft = 2'b00, // PC = PC + 4
    PC_Src_Ra  = 2'b01, // return address from stack
    PC_Src_Jmp = 2'b10, // jump address
    PC_Src_BTA = 2'b11, // branch target address

// ALU source signal
// 2-bit source select for next PC value

    ALU_Src_SIm = 2'b00, // If S-Type instruction && Function is SLL || SLR, SA_5 is used as operand2
    ALU_Src_UIm = 2'b01, // Else If S-Type || R-Type instruction, RB is used as operand2
    ALU_Src_SAi = 2'b10, // Else If I-Type instruction && !ANDI, Signed Immediate14 is used as operand2
    ALU_Src_Reg = 2'b11, // Else If I-Type instruction && Unsigned Immediate14 is used as operand2

// 32 registers
    R0 = 5'd0, // zero register
    R1 = 5'd1, // general purpose register
    R2 = 5'd2, // general purpose register
    R3 = 5'd3, // general purpose register
    R4 = 5'd4, // general purpose register
    R5 = 5'd5, // general purpose register
    R6 = 5'd6, // general purpose register
    R7 = 5'd7, // general purpose register
    R8 = 5'd8, // general purpose register
    R9 = 5'd9, // general purpose register
    R10 = 5'd10, // general purpose register
    R11 = 5'd11, // general purpose register
    R12 = 5'd12, // general purpose register
    R13 = 5'd13, // general purpose register
    R14 = 5'd14, // general purpose register
    R15 = 5'd15, // general purpose register
    R16 = 5'd16, // general purpose register
    R17 = 5'd17, // general purpose register
    R18 = 5'd18, // general purpose register
    R19 = 5'd19, // general purpose register
    R20 = 5'd20, // general purpose register
    R21 = 5'd21, // general purpose register
    R22 = 5'd22, // general purpose register
    R23 = 5'd23, // general purpose register
    R24 = 5'd24, // general purpose register
    R25 = 5'd25, // general purpose register
    R26 = 5'd26, // general purpose register
    R27 = 5'd27, // general purpose register
    R28 = 5'd28, // general purpose register
    R29 = 5'd29, // general purpose register
    R30 = 5'd30, // general purpose register
    R31 = 5'd31; // general purpose register

    

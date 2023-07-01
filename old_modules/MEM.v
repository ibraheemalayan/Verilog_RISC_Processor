
// TODO change into 32 bits words and bigger addresses and more cells
// Sync 128 cell of 16 bits memory

module MEMORY(
    MAR,
    data_in,
    data_out,
    EN, // enable (excute) read or write (according to CS)
    CS, // control signal 0 for read, 1 for write
    clk // clock
);

input wire EN, CS, clk;

// addresses are 8 bits
input wire [7:0] MAR;

// data registers (words are 16 bits)
input wire [23:0] data_in;
output reg [23:0] data_out;

// memory is 384 byte ( 128 cell, each cell is 3 bytes )
reg [23:0] Cells [0:127];

// opcodes
parameter 

    // 0011 LOAD Ri, M; loads the contents of memory location M into Ri, where Ri is the number of the register (Direct Addressing)
    // 0011 LOAD Ri, 8; set Ri to 8 (Immediate Addressing)
    // 0011 LOAD Ri, [[M]]; use the contents of memory location M as a pointer to the operand then load it to Ri, (InDirect Addressing)
    load = 4'b0011,
    
    // 1011 STORE Ri, M; stores the contents of Ri into memory location M. (Direct Addressing)
    store = 4'b1011,

    // 0111 ADD Ri, M; adds the contents of memory location M to the contents of Ri, and stores the result in Ri. (Direct Addressing)
    // 0111 ADD Ri, Rj; Ri = Ri + Rj (Register Addressing)
    add = 4'b0111,

    // 1100 JUMP M; unconditional jump to location M in memory. (Direct Addressing)
    jump = 4'b1100,

    // 1101 CMP Ri, Rj; compare two registers and set zero flag if Ri = Rj (Register Addressing)
    cmp = 4'b1101,

    // 1110 SL Ri, C; applying logical shift left operation to Ri, such that, C is constant (Immediate Addressing) 
    sl = 4'b1110,

    // 1111 SR Ri, C; applying logical shift right operation to Ri,C is constant (Immediate Addressing)
    sr = 4'b1111,

    // 0000 PUSH Ri; Add Ri to the top of the stack (Stack Addressing)
    push = 4'b0000,

    // 0001 POP Ri; Ri = top of the stack then clear the top of the stack (Stack Addressing)
    pop = 4'b0001;

// addressing modes
parameter 
    direct = 3'b000,
    indirect = 3'b001,
    immediate = 3'b010,
    register = 3'b011,
    stack = 3'b100;

always @(posedge clk) begin

    #1;
    if (EN) begin

        if (CS) begin
            // write operation
            Cells[MAR] <= data_in;
            $display("(%0t) Memory Write operation data_written=%0h at %0d ", $time, data_in, MAR);
            
        end else begin
            // read operation
            data_out <= Cells[MAR];
            $display("(%0t) Memory Read operation data_read=%0h from address %0d ", $time, Cells[MAR], MAR);
            
        end
        
    end
    
end

initial begin
    
    $display("(%0t) > initializing memory ...", $time);

    // Instruction Format
    // Opcode (4) Reg (4) Operand (8) Addressing mode (3)

    // For testing

    // //////////////////////////////////////////////////////
    // // simulation 1
    // //////////////////////////////////////////////////////

    // ///////////// Instructions /////////////
    
    // // 20 Load R1,[30]
    // Cells [20] = { load, 4'd1, 8'd30, direct };

    // // 21 Load R2,4
    // Cells [21] = { load, 4'd2, 8'd4, immediate };

    // // 22 Add R1,R2
    // Cells [22] = { add, 4'd1, 8'd2, register };

    // // 23 Store R1, [31]
    // Cells [23] = { store, 4'd1, 8'd31, direct };

    // ///////////// Data /////////////
    
    // // 30 5
    // Cells [30] = 19'd5;


    // //////////////////////////////////////////////////////
    // // simulation 2
    // //////////////////////////////////////////////////////

    // ///////////// Instructions /////////////
    
    // // 20 Load R1,3
    // Cells [20] = { load, 4'd1, 8'd3, immediate };

    // // 21 Add R1,[31]
    // Cells [21] = { add, 4'd1, 8'd31, direct };

    // // 22 Load R2,6
    // Cells [22] = { load, 4'd2, 8'd6, immediate };

    // // 23 CMP R1, R2
    // Cells [23] = { cmp, 4'd1, 8'd2, register };

    // ///////////// Data /////////////
    
    // // 30 5
    // Cells [30] = 19'd5;
    // Cells [31] = 19'd0;

    
    // //////////////////////////////////////////////////////
    // // simulation 3
    // //////////////////////////////////////////////////////

    // ///////////// Instructions /////////////
    
    // // 20 Load R1,[[31]]
    // Cells [20] = { load, 4'd1, 8'd31, indirect };

    // // 21 AShl R1,3
    // Cells [21] = { sl, 4'd1, 8'd3, immediate };

    // ///////////// Data /////////////
    
    // // 30 5
    // Cells [30] = 19'd5;
    // Cells [31] = 19'd32;
    // Cells [32] = 19'd3;


    //////////////////////////////////////////////////////
    // simulation 4
    //////////////////////////////////////////////////////

    ///////////// Instructions /////////////
    
    // 20 Load R1, [30]
    Cells [20] = { load, 4'd1, 8'd30, direct };

    // 21 Push R1
    Cells [21] = { push, 4'd1, 8'd0, stack };

    // 22 Shr R1,1
    Cells [22] = { sr, 4'd1, 8'd1, immediate };

    // 23 Pop R1
    Cells [23] = { pop, 4'd1, 8'd0, stack };

    // 24 Store R1, [33]
    Cells [24] = { store, 4'd1, 8'd33, direct };

    ///////////// Data /////////////
    
    // 30 5
    Cells [30] = 19'd5;
    Cells [31] = 19'd32;
    Cells [32] = 19'd3;

end
    
endmodule
// a stack conating 32 cells, each is 32 bit
module LIFO_Store(clock, DataOut, flag_full, flag_empty, sig_push, sig_pop, DataIn);

  output reg [31:0] DataOut;
  output flag_full, flag_empty;
  input [31:0] DataIn;
  input clock, sig_push, sig_pop;
  
  reg [4:0] stack_pointer; // pointers tracking the stack
  reg [31:0] memory [31:0]; // the stack is 32 bit wide and 32 locations in size
  
  assign flag_full = (stack_pointer == 5'd32) ? 1 : 0;
  assign flag_empty = (stack_pointer == 5'd0) ? 1 : 0;
  
  always @(posedge clock)
  begin
    if (sig_push & !flag_full)
      begin
        memory[stack_pointer] <= DataIn;
        stack_pointer <= stack_pointer + 1;
      end
    else if (sig_pop & !flag_empty)
      begin
        stack_pointer <= stack_pointer - 1;
        DataOut <= memory[stack_pointer];
      end
  end
endmodule
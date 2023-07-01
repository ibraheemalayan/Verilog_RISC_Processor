module TestBench ();

	wire clock;
    
	// generates clock square wave with 10ns period
	ClockGenerator clock_generator(clock);

   reg clk_en = 1; 
   wire [1:0] out;

   initial begin   				 
      #1000 $finish;    // 100 cycle
   end
   
   sample_fsm    m0 (clock, clk_en, out);

   
endmodule
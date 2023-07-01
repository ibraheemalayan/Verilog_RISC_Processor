module sample_fsm (clk, clk_en, Out);
input		wire clk;
input		wire clk_en;
output		reg [1:0] Out;			  

// BINARY ENCODED state machine: Sreg0
// State codes definitions:
`define S1 2'b00
`define S2 2'b01
`define S3 2'b10
`define S4 2'b11

reg [1:0] CurrState_Sreg0 = `S1;
reg [1:0] NextState_Sreg0;				 		   

always @ (CurrState_Sreg0)
begin : Sreg0_NextState
	NextState_Sreg0 = CurrState_Sreg0;				   			
	case (CurrState_Sreg0) // synopsys parallel_case full_case
		`S1:
			NextState_Sreg0 = `S2;
		`S2:
			NextState_Sreg0 = `S4;
		`S3:
			NextState_Sreg0 = `S1;
		`S4:
		    NextState_Sreg0 = `S3;
		default
		    NextState_Sreg0 = `S1;
	endcase
end
										
always @ (posedge clk)
begin : Sreg0_CurrentState
	if (clk_en)
		CurrState_Sreg0 <= NextState_Sreg0;
end

// Copy state register(s) to output port(s)
always @ (CurrState_Sreg0)
	Out = CurrState_Sreg0;

endmodule

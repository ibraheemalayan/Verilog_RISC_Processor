module ALU(clock, A, B, Output, flag_zero, flag_negative, sig_alu_op);

	// ----------------- SIGNALS & INPUTS -----------------

	// clock
    input wire clock;

    // chip select for ALU operation
	input wire [2:0] sig_alu_op;

	// operands
	input wire [31:0] A, B;

	// ----------------- OUTPUTS -----------------

	output reg	[31:0]	Output;
	output reg			flag_zero;
	output reg			flag_negative;

	// ----------------- LOGIC -----------------

	assign flag_zero = (0 == Output);
	assign flag_negative = (Output[31] == 1); // if 2s complement number is negative, MSB is 1

	always @(posedge clock) begin
		#1 // to wait for ALU source mux to select operands
		case (sig_alu_op)
			ALU_Add:  Output <= A + B;
			ALU_Sub:  Output <= A - B;
			ALU_And:  Output <= A & B;
			ALU_SLL:  Output <= A << B;
			ALU_SLR:  Output <= (A >> B);
			default: Output <= 0;
		endcase
	end

endmodule

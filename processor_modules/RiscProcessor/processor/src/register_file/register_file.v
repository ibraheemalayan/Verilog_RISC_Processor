// register file ( array of 32 bit 32 registers )
module registerFile(clock, RA, RB, RW, sig_enable_write, BusW, BusA, BusB);
    
    // ----------------- PORTS -----------------

	// clock
	input wire clock;

    // enable write signal
	input wire sig_enable_write;

    // register selection buses
	input wire [4:0] RA, RB, RW;
    
    // data read buses A & B
	output reg [31:0] BusA, BusB;

    // data write bus
	input wire [31:0] BusW;

    // ----------------- INTERNALS -----------------

	reg [31:0] registers_array [0:31];
    
	// read registers always
	always @(posedge clock) begin
		
		BusA <= registers_array[RA];
		BusB <= registers_array[RB];

		if ( 
                (RW != 0) // write register is not R0
                && 
                (sig_enable_write==1) // write enabled
                
        ) begin
			registers_array[RW] <= BusW;
		end
		
	end

	initial begin
		registers_array[0] <= 32'h00000000;
		registers_array[1] <= 32'h00000000;
		registers_array[2] <= 32'h00000000;
		registers_array[3] <= 32'h00000000;
		registers_array[4] <= 32'h00000000;
		registers_array[5] <= 32'h00000000;
		registers_array[6] <= 32'h00000000;		
		registers_array[7] <= 32'h00000000;		
		registers_array[8] <= 32'h00000000;
		registers_array[9] <= 32'h00000000;
		registers_array[10] <= 32'h00000000;
		registers_array[11] <= 32'h00000000;
		registers_array[12] <= 32'h00000000;
		registers_array[13] <= 32'h00000000;
		registers_array[14] <= 32'h00000000;
		registers_array[15] <= 32'h00000000;
		registers_array[16] <= 32'h00000000;
		registers_array[17] <= 32'h00000000;
		registers_array[18] <= 32'h00000000;
		registers_array[19] <= 32'h00000000;
		registers_array[20] <= 32'h00000000;
		registers_array[21] <= 32'h00000000;
		registers_array[22] <= 32'h00000000;
		registers_array[23] <= 32'h00000000;
		registers_array[24] <= 32'h00000000;
		registers_array[25] <= 32'h00000000;
		registers_array[29] <= 32'h00000000;
		registers_array[31] <= 32'h00000000;
	end

endmodule
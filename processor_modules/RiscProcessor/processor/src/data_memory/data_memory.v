// data memory with 256 cells of 32 bits each
module dataMemory(clock, AddressBus, InputBus, OutputBus, sig_enable_write, sig_enable_read);

    // ----------------- SIGNALS -----------------

    // clock
    input wire clock;

    // enable write signal
	input wire sig_enable_write;
    
    // enable write signal
	input wire sig_enable_read;

    // ----------------- INPUTS -----------------

    // address bus
    input wire [31:0] AddressBus;

    // MBR - in
    input wire [31:0] InputBus;

    // ----------------- OUTPUTS -----------------

    // MBR - out
    output reg [31:0] OutputBus;

    // ----------------- INTERNALS -----------------

    // memory
    reg [31:0] memory [0:255];

    // ----------------- LOGIC -----------------

    // read instruction at positive edge of clock
    always  @(*) begin
        if (sig_enable_read) begin
            OutputBus <= memory[AddressBus];
        end else if (sig_enable_write) begin
            memory[AddressBus] <= InputBus;
        end
    end

    // ----------------- INITIALIZATION -----------------

    initial begin
        
        // store some initial data
        memory[0] = 32'd10;
        memory[1] = 32'd5;
        
    end


endmodule
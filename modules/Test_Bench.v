`include "CLK_GEN.v"
`include "MEM.v"
`include "CPU.v"

module TestBench ();

wire clock;

CLK_GEN clock_generator(clock);

wire [23:0] data_in_mem_out_of_cpu;
wire [23:0] data_out_of_mem_in_cpu;
wire [7:0] MAR;

wire Mem_EN, Mem_CS;

MEMORY Mem(MAR, data_in_mem_out_of_cpu, data_out_of_mem_in_cpu, Mem_EN, Mem_CS, clock);

CPU cpu(
    MAR,
    data_out_of_mem_in_cpu,
    data_in_mem_out_of_cpu,
    Mem_EN,
    Mem_CS,
    clock
);

always @(posedge clock) begin
    $display("\n\n -------------------------- clock positive edge (t=%0t) -------------------------- \n\n", $time);
end

initial begin

    $dumpfile("waves.vcd");
    $dumpvars(0, TestBench);

    $display("(%0t) > running the test bench ...", $time);

    #250 $display("(%0t) > finishing simulation\n\n", $time);

    #1 $finish;       // Finish simulation after 220 nano second

    // some testing stuff /////////////////

    // CS=0;
    // EN=0;

    // // write 99 to cell 4
    // #6 MAR=8'd4;
    // data_in=16'd96;

    // // execute write
    // CS=1;
    // EN=1;

    
    // #10 CS=0;

    // #10 EN=0;

    // $display("> read %0d", data_out);

end

endmodule
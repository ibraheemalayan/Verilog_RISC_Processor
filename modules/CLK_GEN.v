// clock generator (each cycle is 10 ns)

module CLK_GEN (
    clock
);

initial begin
    $display("(%0t) > initializing clock generator ...", $time);
end

output reg clock=0;

always #5 begin
    clock=~clock;
end

 


    

endmodule
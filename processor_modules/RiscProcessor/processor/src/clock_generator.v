// generates clock square wave with 10ns period

module ClockGenerator (
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
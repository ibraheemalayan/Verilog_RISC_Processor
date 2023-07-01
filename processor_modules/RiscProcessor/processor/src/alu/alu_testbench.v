module aluTestBench ();

    // ----------------- ALU -----------------

    reg [31:0] A, B; // operands
    wire [31:0] Output;
    wire flag_zero;
    wire flag_negative;


    // signals
    reg [2:0] sig_alu_op;


    ALU alu(A, B, Output, flag_zero, flag_negative, sig_alu_op);
	
    // ----------------- Simulation -----------------

    initial begin

        #0
        A <= 32'd10;
        B <= 32'd20;
        sig_alu_op <= ALU_Add;

        #5
        $display("(%0t) > A=%0d + B=%0d => Output=%0d | zero_flag=%0b | negative_flag=%0b", $time, A, B, Output, flag_zero, flag_negative);

        A <= 32'd30;
        B <= 32'd20;
        sig_alu_op <= ALU_Sub;

        #5
        $display("(%0t) > A=%0d - B=%0d => Output=%0d | zero_flag=%0b | negative_flag=%0b", $time, A, B, Output, flag_zero, flag_negative);

        A <= 32'h00000F0F;
        B <= 32'h00000FFF;
        sig_alu_op <= ALU_And;

        #5
        $display("(%0t) > A=%0h & B=%0h => Output=%0h | zero_flag=%0b | negative_flag=%0b", $time, A, B, Output, flag_zero, flag_negative);

        A <= 32'h00000F0F;
        B <= 32'h00000004;
        sig_alu_op <= ALU_SLL;

        #5
        $display("(%0t) > A=%0h << B=%0d => Output=%0h | zero_flag=%0b | negative_flag=%0b", $time, A, B, Output, flag_zero, flag_negative);

        A <= 32'h00000F0F;
        B <= 32'h00000004;
        sig_alu_op <= ALU_SLR;

        #5
        $display("(%0t) > A=%0h >> B=%0d => Output=%0h | zero_flag=%0b | negative_flag=%0b", $time, A, B, Output, flag_zero, flag_negative);

        A <= 32'd50;
        B <= 32'd50;
        sig_alu_op <= ALU_Sub;

        #5
        $display("(%0t) > A=%0d - B=%0d => Output=%0d | zero_flag=%0b | negative_flag=%0b", $time, A, B, Output, flag_zero, flag_negative);

        A <= 32'd50;
        B <= 32'd100;
        sig_alu_op <= ALU_Sub;

        #5
        $display("(%0t) > A=%0d - B=%0d => Output=%0d | zero_flag=%0b | negative_flag=%0b", $time, A, B, $signed(Output), flag_zero, flag_negative);


        #5 $finish;
    end

endmodule
`timescale 1ns/1ps

module tb_d_latch();

    // stimulus signal
    reg     clk     ;
    reg     i_d     ;

    // monitor signal
    wire    o_q     ;


    // DUT instantiation
    d_latch DUT(
        .clk(clk),
        .i_d(i_d),
        .o_q(o_q)
    );


    // clock gen
    always #5 clk = ~clk;    // 10ns


    // put stimulus
    initial begin

        // VCD waveform dump
        $dumpfile("d_latch.vcd");
        $dumpvars(0, tb_d_latch);

        clk = 1'b0;
        i_d = 1'b0;

        #15 i_d = 1'b1;  #20 i_d = 1'b0;
        #10 i_d = 1'b1;  #10 i_d = 1'b0;
        #10 i_d = 1'b1;  #15 i_d = 1'b0;

        #50;
        $finish;

    end

endmodule

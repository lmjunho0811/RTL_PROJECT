`timescale 1ns / 1ps

module tb_register (); // top module

    // signal declaration
    reg         rst_n           ;
    reg         clk             ;
    reg         i_in1           ;
    reg  [3:0]  i_in2           ;
    wire        o_out1          ;
    wire [3:0]  o_out2          ;

    /***** DUT instantiation *****/
    register DUT
    (
        .rst_n      ( rst_n  ),
        .clk        ( clk    ),
        .i_in1      ( i_in1  ),
        .i_in2      ( i_in2  ),
        .o_out1     ( o_out1 ),
        .o_out2     ( o_out2 )
    );

    /***** inject stimulus *****/
    initial begin

        // VCD waveform dump
        $dumpfile("register.vcd");
        $dumpvars(0, tb_register);

        // initial value config(t = 0)
        rst_n      = 1'b0           ; // active low rst
        clk        = 1'b0           ;
        i_in1      = 1'b0           ;
        i_in2      = 4'b0000        ;

        // t = 1000ns, rst release
        #1000 rst_n = 1'b1          ;

        // t = 1200ns
        #200 i_in1 = 1'b1           ;

        // t = 1300ns
        #100 i_in2 = 4'b1010        ;

        // t = 1800ns, rst enable: erase all value if registers
        #500 rst_n = 1'b0           ;

        // t = 2000ns
        #200 i_in1 = 1'b0           ;
             i_in2 = 4'd0           ;

        // t = 2300ns
        #300 i_in1 = 1'b1           ;
             i_in2 = 4'b1111        ;

        // t = 2400ns
        #100 rst_n = 1'b1           ;

        // t = 2600ns, terminate sim
        #200 $finish;

    end

    /***** clkgen *****/
    always #5 clk = ~clk;

endmodule

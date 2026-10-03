`timescale 1ns / 1ps

module tb_shift_register_sipo;
    // local parameter
    localparam WIDTH = 8;
    // stimulus signal
    reg                 clk;
    reg                 rst_n;
    reg                 i_serial_in;
    // monitor signal
    wire [WIDTH-1:0]    o_parallel_out;


    // DUT instantiation
    shift_register_sipo uut (
        .clk            (clk),
        .rst_n          (rst_n),
        .i_serial_in    (i_serial_in),
        .o_parallel_out (o_parallel_out)
    );

    // clock gen
    initial begin
        clk = 0;
        forever #5 clk = ~clk;    // 10ns (100MHz)
    end

    // Test Scenario
    initial begin
        // VCD waveform dump
        $dumpfile("shift_register_sipo.vcd");
        $dumpvars(0, tb_shift_register_sipo);
        // t=0: init
        rst_n = 1'b0; i_serial_in = 0;
        #15 rst_n = 1'b1;         // reset off = system on
        // random vector generations
        repeat(WIDTH*2) begin
            @(negedge clk);
            i_serial_in = $random % 2;
        end

        #50 $finish;
    end

    // independent monitoring block
    initial begin
        $monitor("time=%0t | reset=%b | serial_in=%b | parallel_out=%b", $time, rst_n, i_serial_in, o_parallel_out);
    end

endmodule

`timescale 1ns / 1ps

module tb_multiplexed_bus_driver();

    // stimulus signal
    reg     [7:0]   i_data_a    ;
    reg     [7:0]   i_data_b    ;
    reg             i_en_a      ;
    reg             i_en_b      ;

    // monitor signal
    wire    [7:0]   o_bus_data  ;

    // DUT instantiation
    multiplexed_bus_driver uut (
        .i_data_a   (i_data_a)      ,
        .i_data_b   (i_data_b)      ,
        .i_en_a     (i_en_a)        ,
        .i_en_b     (i_en_b)        ,
        .o_bus_data (o_bus_data)
    );

    // Test scenario
    initial begin

        // VCD waveform dump
        $dumpfile("multiplexed_bus_driver.vcd");
        $dumpvars(0, tb_multiplexed_bus_driver);

        $monitor("Time=%0t | en_a=%b, data_a=%b | en_b=%b, data_b=%b | bus_data=%b",
                 $time, i_en_a, i_data_a, i_en_b, i_data_b, o_bus_data);

        // init
        i_data_a = 8'b10101010;
        i_data_b = 8'b11001100;

        // apply stimulus
        i_en_a = 1; i_en_b = 0; #10;
        i_en_a = 0; i_en_b = 1; #10;
        i_en_a = 1; i_en_b = 1; #10;
        i_en_a = 0; i_en_b = 0; #10;

        $finish;
    end

endmodule

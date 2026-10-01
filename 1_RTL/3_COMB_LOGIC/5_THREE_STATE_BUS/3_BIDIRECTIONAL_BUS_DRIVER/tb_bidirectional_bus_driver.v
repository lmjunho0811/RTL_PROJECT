`timescale 1ns / 1ps

module tb_bidirectional_bus_driver();

    // stimulus signal
    reg     [7:0]   i_data_to_bus       ;
    reg             i_send              ;
    reg             i_rcv               ;

    // monitor signal
    wire    [7:0]   io_bus_data         ;
    wire    [7:0]   o_data_from_bus     ;


    // DUT instantiation
    bidirectional_bus_driver uut (
        .i_data_to_bus      (i_data_to_bus)      ,
        .i_send             (i_send)             ,
        .i_rcv              (i_rcv)              ,
        .io_bus_data        (io_bus_data)        ,
        .o_data_from_bus    (o_data_from_bus)
    );


    // internal register
    reg [7:0] r_bus_drive_data;

    assign io_bus_data = (i_rcv) ? r_bus_drive_data : 8'bz;


    // Test scenario
    initial begin

        // VCD waveform dump
        $dumpfile("bidirectional_bus_driver.vcd");
        $dumpvars(0, tb_bidirectional_bus_driver);

        // System task for monitoring
        $monitor("Time=%0t | send=%b | rcv=%b | data_to_bus=%b | bus_data=%b | data_from_bus=%b",
                 $time, i_send, i_rcv, i_data_to_bus, io_bus_data, o_data_from_bus);

        // init
        i_data_to_bus    = 8'b00000000;
        i_send           = 0;
        i_rcv            = 0;
        r_bus_drive_data = 8'b00000000;

        // apply stimulus
        #10;

        // send test (send enable)
        i_send        = 1;
        i_rcv         = 0;
        i_data_to_bus = 8'b10101010;
        #10;

        // receive test (rcv enable)
        i_send           = 0;
        i_rcv            = 1;
        r_bus_drive_data = 8'b11001100;
        #10;

        // send and receive disable
        i_send = 0;
        i_rcv  = 0;
        #10;

        $finish;
    end

endmodule

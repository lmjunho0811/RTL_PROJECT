`timescale 1ns / 1ps

module tb_data_bus_driver();

// stimulus signal
reg [7:0]   i_data_a            ;      
reg [7:0]   i_data_b            ;      
reg         i_en_a              ;              
reg         i_en_b              ;              
// monitor signal
wire [7:0] o_bus_data           ;   

// DUT instantiation 
data_bus_driver uut (
    .i_data_a   (i_data_a   )   ,
    .i_data_b   (i_data_b   )   ,
    .i_en_a     (i_en_a     )   ,
    .i_en_b     (i_en_b     )   ,
    .o_bus_data (o_bus_data )
);

// Dumpfile gen
initial begin
    $dumpfile("./data_bus_driver.vcd"   );
    $dumpvars(0, tb_data_bus_driver     );
end
// Test Scenario 
initial begin
    // system task for monitoring
    $monitor("Time=%0t | en_A=%b, data_A=%b | en_B=%b, data_B=%b | bus_data=%b", 
             $time, i_en_a, i_data_a, i_en_b, i_data_b, o_bus_data);
    // init
    i_data_a <= 8'haa; i_data_b <= 8'hcc;
    // apply stimulus
    i_en_a <= 0; i_en_b <= 0; #10;  
    i_en_a <= 1; i_en_b <= 0; #10; 
    i_en_a <= 0; i_en_b <= 1; #10; 
    i_en_a <= 1; i_en_b <= 1; #10; 
    i_en_a <= 0; i_en_b <= 0; #10; 

    $finish;
end
endmodule

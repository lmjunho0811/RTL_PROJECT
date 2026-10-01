`timescale 1ns / 1ps
module data_bus_driver (
    // port list
    i_data_a            ,
    i_data_b            ,
    i_en_a              ,
    i_en_b              ,
    o_bus_data
);
// port declaration
input   [7:0]       i_data_a    ;    
input   [7:0]       i_data_b    ;    
input               i_en_a      ;            
input               i_en_b      ;            
output  [7:0]       o_bus_data  ;



// modeling
assign o_bus_data = (i_en_a) ? i_data_a : 
                    (i_en_b) ? i_data_b : 
                    8'bz                ;  

endmodule

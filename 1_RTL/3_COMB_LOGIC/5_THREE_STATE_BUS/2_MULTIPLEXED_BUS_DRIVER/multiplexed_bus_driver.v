`timescale 1ns / 1ps

module multiplexed_bus_driver (
    // port list
    i_data_a        ,
    i_data_b        ,
    i_en_a          ,
    i_en_b          ,
    o_bus_data
);
// port declaration
input   [7:0]   i_data_a    ;    
input   [7:0]   i_data_b    ;    
input           i_en_a      ;            
input           i_en_b      ;            
output  [7:0]   o_bus_data  ;  
    
wire        w_select        ;           
wire [7:0]  w_mux_out       ;    

// modeling
assign w_select = i_en_a ^ i_en_b                   ;
// xor (w_select, i_en_a, i_en_b);
    
assign w_mux_out =  (i_en_a) ? i_data_a :
                    (i_en_b) ? i_data_b :
                    8'bz                            ; 

    
assign o_bus_data = (w_select) ? w_mux_out : 8'bz   ;

endmodule

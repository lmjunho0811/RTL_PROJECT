`timescale 1ns/1ps

module d_latch (
    // port list
    clk         ,
    i_d         , 
    o_q
);

input   clk         ;
input   i_d         ;
output  o_q         ;

reg     o_q         ;
always @(*) begin
    if( clk ) o_q <= i_d;
end
    
endmodule
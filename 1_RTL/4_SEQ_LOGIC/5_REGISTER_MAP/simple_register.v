`timescale 1ns / 1ps
module simple_register (
    // port list
    clk,
    rst_n       ,
    wen         , // write enable
    i_wdata     , // wrting data
    o_rdata     , // reding data
);
input           clk         ;            
input           rst_n       ;           
input           wen         ;    
input   [7:0]   i_wdata     ; 
output  [7:0]   o_rdata     ; 

// 8-bit internal register
reg     [7:0]   r_reg8      ;

// modeling
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // init
        r_reg8 <= 8'b0      ; 
    end else if (wen) begin // write enable
        r_reg8 <= i_wdata   ; 
    end
end

    
assign o_rdata = r_reg8     ; 

endmodule

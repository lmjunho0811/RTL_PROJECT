// Based on siliconground/SoC_102 f77f18d88953: 1_RTL/6_FSM/1_MOORE_MACHINE/2_always_output/FSM2.v
// Modified with AI assistance for lmjunho0811: 2026-10-20.
// Changes: deterministic FSM logic; headless self-checking simulation support.
// License: GNU GPL v3; see repository LICENSE. Original source credited above.
`timescale 1ns / 1ps

module FSM2 (
// port list
    clk     ,
    rst_n   ,
    go      ,
    ws      ,
    rd      ,
    ds
);

// port declaration
input   clk         ;
input   rst_n       ;
input   go          ;
input   ws          ;
output  rd          ;
output  ds          ;

// parameters for each state
parameter IDLE  = 2'b00;
parameter READ  = 2'b01;
parameter DLY   = 2'b10;
parameter DONE  = 2'b11;

// internal register to store current state
reg [1:0] state;
reg [1:0] next;


// 1. current state register
reg rd;
reg ds;
always @(posedge clk, negedge rst_n) begin
    if ( !rst_n ) state <= IDLE;
    else          state <= next;
end

// 2.next state logic + output logic(behavioral modeling)
always @(*) begin
    next = IDLE; rd = 1'b0; ds = 1'b0;
    case( state )
        IDLE : if ( go ) next = READ;
               else next = IDLE; // no need output
        READ : begin
                rd = 1'b1; // output: read state = 1
                next = DLY;
               end
        DLY : begin
                rd = 1'b1; // output: read state = 1
                if ( !ws ) next = DONE;
                else next = READ;
              end
        DONE : begin
                ds = 1'b1; // output: done state = 1
                next = IDLE;
               end
        default : next = IDLE;
    endcase
end

endmodule

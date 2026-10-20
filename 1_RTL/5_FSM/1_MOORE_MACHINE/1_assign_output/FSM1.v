// Based on siliconground/SoC_102 f77f18d88953: 1_RTL/6_FSM/1_MOORE_MACHINE/1_assign_output/FSM1.v
// Modified with AI assistance for lmjunho0811: 2026-10-20.
// Changes: deterministic FSM logic; headless self-checking simulation support.
// License: GNU GPL v3; see repository LICENSE. Original source credited above.
`timescale 1ns / 1ps
module FSM1(
    // port list
    clk     ,
    rst_n   ,
    go      ,
    ws      ,
    rd      ,
    ds
);
// port declaration
input clk       ;
input rst_n     ;
input go        ;
input ws        ;
output rd       ;
output ds       ;

// parameters for each state
parameter IDLE  = 2'b00;
parameter READ  = 2'b01;
parameter DLY   = 2'b11;
parameter DONE  = 2'b10;

// internal register to store current state
reg [1:0] state; // current state
reg [1:0] next;

// 1. next state logic
always @(*) begin
    next = IDLE; // safe combinational default
    case ( state ) // read current state
        IDLE : if ( go )    next = READ;
               else         next = IDLE;
        READ :              next = DLY;
        DLY  : if ( !ws )   next = DONE;
               else         next = READ;
        DONE :              next = IDLE;
        default : next = IDLE;
    endcase
end

// 2. current state register
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) state <= IDLE; // reset current state to IDLE
    else state <= next;
end




// 3. output logic(data flow modeling) : Moore Machine
assign rd = (state == READ) || (state == DLY);
assign ds = (state == DONE);

endmodule

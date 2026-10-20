// Based on siliconground/SoC_102 f77f18d88953: 1_RTL/6_FSM/1_MOORE_MACHINE/3_reg_output/FSM3.v
// Modified with AI assistance for lmjunho0811: 2026-10-20.
// Changes: deterministic FSM logic; headless self-checking simulation support.
// License: GNU GPL v3; see repository LICENSE. Original source credited above.
`timescale 1ns / 1ps

module FSM3 (
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
parameter IDLE  = 2'b00                     ;
parameter READ  = 2'b01                     ;
parameter DLY   = 2'b10                     ;
parameter DONE  = 2'b11                     ;

// internal registers to store current state
reg [1:0] state                             ;
reg [1:0] next                              ;


// 1. current state register
reg rd;
reg ds;
always @(posedge clk, negedge rst_n) begin
    if ( !rst_n ) state <= IDLE             ;
    else          state <= next             ;
end

// 2. next state logic
always @(*) begin
    next = IDLE;
    case ( state )
        IDLE : if ( go )    next = READ     ;
               else         next = IDLE     ;
        READ :              next = DLY      ;
        DLY  : if ( !ws )   next = DONE     ;
               else         next = READ     ;
        DONE :              next = IDLE     ;
        default : next = IDLE;
    endcase
end

// 3. output logic(behavioral modeling)
always @(posedge clk, negedge rst_n) begin
    if ( !rst_n ) begin
        rd <= 1'b0                          ;
        ds <= 1'b0                          ;
    end
    else begin
        rd <= (next == READ) || (next == DLY);
        ds <= (next == DONE);
    end
end

endmodule

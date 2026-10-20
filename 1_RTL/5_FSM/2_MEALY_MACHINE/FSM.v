// Based on siliconground/SoC_102 f77f18d88953: 1_RTL/6_FSM/2_MEALY_MACHINE/FSM.v
// Modified with AI assistance for lmjunho0811: 2026-10-20.
// Changes: deterministic FSM logic; headless self-checking simulation support.
// License: GNU GPL v3; see repository LICENSE. Original source credited above.
`timescale 1ns / 1ps

module FSM (
// port list
    clk         ,
    rst_n       ,
    din_bit     ,
    dout_bit
);

// port declaration
input   clk             ;
input   rst_n           ;
input   din_bit         ;
output  dout_bit        ;

// parameters for each state
parameter START     = 3'b000    ;
parameter RD0_ONCE  = 3'b001    ;
parameter RD1_ONCE  = 3'b010    ;
parameter RD0_TWICE = 3'b011    ;
parameter RD1_TWICE = 3'b100    ;

// internal registers to store current state
reg [2:0] state ;
reg [2:0] next  ;

// 1. current state register
always @(posedge clk, negedge rst_n) begin
    if ( !rst_n ) state <= START;
    else          state <= next;
end

// 2. next state logic
always @(*) begin
    case ( state )
        START       :   if      ( din_bit == 0 )        next = RD0_ONCE     ;
                        else if ( din_bit == 1 )        next = RD1_ONCE     ;
                        else                            next = START        ;
        RD0_ONCE    :   if      ( din_bit == 0 )        next = RD0_TWICE    ;
                        else if ( din_bit == 1)         next = RD1_ONCE     ;
                        else                            next = START        ;
        RD0_TWICE   :   if      ( din_bit == 0 )        next = RD0_TWICE    ;
                        else if ( din_bit == 1 )        next = RD1_ONCE     ;
                        else                            next = START        ;
        RD1_ONCE    :   if      ( din_bit == 0 )        next = RD0_ONCE     ;
                        else if ( din_bit == 1 )        next = RD1_TWICE    ;
                        else                            next = START        ;
        RD1_TWICE   :   if      ( din_bit == 0 )        next = RD0_ONCE     ;
                        else if ( din_bit == 1 )        next = RD1_TWICE    ;
                        else                            next = START        ;
        default :                                       next = START        ;
    endcase
end

// 3. output logic(data flow modeling)
assign dout_bit = (((state == RD0_TWICE) && (din_bit == 0)      ||
                    (state == RD1_TWICE) && (din_bit == 1)))    ? 1 : 0;


endmodule

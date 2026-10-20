// Based on the course serial-pattern example; independent run-length reference.
// AI-assisted test extension 2026-10-20. GNU GPL v3; see repository LICENSE.
`timescale 1ns / 1ps
module tb_FSM;
reg clk, rst_n, din_bit, last_bit;
wire dout_bit;
integer run_length, checks, i, old_state, new_state;
reg [24:0] transitions;
FSM DUT(.clk(clk),.rst_n(rst_n),.din_bit(din_bit),.dout_bit(dout_bit));
always #5 clk=~clk;

function integer logical_state;
  begin
    if (run_length==0) logical_state=0;
    else if (!last_bit && run_length==1) logical_state=1;
    else if (last_bit && run_length==1) logical_state=2;
    else if (!last_bit) logical_state=3;
    else logical_state=4;
  end
endfunction

task check;
  input [255:0] label_text;
  reg expected_out;
  reg [2:0] encoded;
  begin
    expected_out=(run_length>=2) && (din_bit==last_bit);
    case(logical_state())
      0: encoded=DUT.START;
      1: encoded=DUT.RD0_ONCE;
      2: encoded=DUT.RD1_ONCE;
      3: encoded=DUT.RD0_TWICE;
      4: encoded=DUT.RD1_TWICE;
      default: $fatal(1,"bad Mealy reference state");
    endcase
    if (dout_bit !== expected_out || DUT.state !== encoded)
      $fatal(1,"FAIL FSM %0s t=%0t state=%b/%b dout=%b/%b",
             label_text,$time,DUT.state,encoded,dout_bit,expected_out);
    checks=checks+1;
    $display("PASS FSM check=%0d phase=%0s state=%b din=%b dout=%b",
             checks,label_text,DUT.state,din_bit,dout_bit);
  end
endtask

task apply_reset;
  begin
    @(negedge clk); rst_n=0; din_bit=0;
    #1; run_length=0; last_bit=0; check("asynchronous_reset");
    @(negedge clk); rst_n=1;
    // Release immediately before the next driven input, without an unmodelled edge.
  end
endtask

task step;
  input bit_value;
  begin
    // Called immediately after reset release or previous checked rising edge.
    // Drive on the current falling edge after reset, otherwise wait for the next one.
    if (clk !== 1'b0 || $time%10 != 0) @(negedge clk);
    din_bit=bit_value;
    #1; check("input_change_between_clocks");
    old_state=logical_state();
    @(posedge clk);
    if (run_length==0 || din_bit!=last_bit) run_length=1;
    else if (run_length<2) run_length=run_length+1;
    last_bit=din_bit; new_state=logical_state();
    transitions[old_state*5+new_state]=1'b1;
    #1; check("after_clock");
  end
endtask

initial begin
  $dumpfile("FSM.vcd"); $dumpvars(0,tb_FSM);
  clk=0; rst_n=1; din_bit=0; last_bit=0;
  run_length=0; checks=0; transitions=0;
  // Assert reset before the first rising edge.
  #1; rst_n=0; #1; check("initial_async_reset");
  @(negedge clk); rst_n=1;
  step(0); step(0); step(0); step(0); step(1); step(0);
  step(1); step(1); step(1); step(1); step(0); step(1);
  for(i=0;i<10;i=i+1) step(i%2);
  apply_reset(); step(1); step(1); apply_reset();
  step(0); step(0); apply_reset();
  for(i=0;i<64;i=i+1) step((i%7)>=3);
  apply_reset(); step(1);
  if ((transitions & 25'h1264986) !== 25'h1264986)
    $fatal(1,"FAIL FSM transition coverage=%h",transitions);
  $display("SUMMARY FSM PASS checks=%0d transitions=10/10",checks);
  $finish;
end
initial begin #20000; $fatal(1,"FAIL FSM timeout"); end
endmodule

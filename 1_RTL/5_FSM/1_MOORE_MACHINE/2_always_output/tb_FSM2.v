// Course FSM stimulus extended with independent checks (AI-assisted, 2026-10-20).
// GNU GPL v3; see repository LICENSE.
`timescale 1ns / 1ps
module tb_FSM2;
reg clk, rst_n, go, ws;
wire rd, ds;
integer model, nxt, checks, i;
reg [15:0] transitions;
FSM2 DUT(.clk(clk), .rst_n(rst_n), .go(go), .ws(ws), .rd(rd), .ds(ds));
always #5 clk = ~clk;

task check;
  input [255:0] label_text;
  reg [1:0] encoded;
  reg expected_rd, expected_ds;
  begin
    case(model)
      0: encoded = DUT.IDLE;
      1: encoded = DUT.READ;
      2: encoded = DUT.DLY;
      3: encoded = DUT.DONE;
      default: $fatal(1,"bad test reference state");
    endcase
    expected_rd = (model == 1 || model == 2);
    expected_ds = (model == 3);
    if (DUT.state !== encoded || rd !== expected_rd || ds !== expected_ds)
      $fatal(1,"FAIL FSM2 %0s t=%0t state=%b expected=%b rd=%b/%b ds=%b/%b",
             label_text,$time,DUT.state,encoded,rd,expected_rd,ds,expected_ds);
    checks = checks + 1;
    $display("PASS FSM2 check=%0d phase=%0s state=%b rd=%b ds=%b",
             checks,label_text,DUT.state,rd,ds);
  end
endtask

task apply_reset;
  begin
    @(negedge clk);
    rst_n = 0; go = 0; ws = 0;
    #1; model = 0; check("asynchronous_reset");
    @(negedge clk); rst_n = 1;
  end
endtask

task step;
  input g, w;
  begin
    @(negedge clk); go = g; ws = w;
    #1; check("input_change_between_clocks");
    case(model)
      0: if (g) nxt=1; else nxt=0;
      1: nxt=2;
      2: if (w) nxt=1; else nxt=3;
      3: nxt=0;
    endcase
    transitions[model*4+nxt] = 1'b1;
    @(posedge clk); #1; model=nxt; check("after_clock");
  end
endtask

initial begin
  $dumpfile("FSM2.vcd"); $dumpvars(0,tb_FSM2);
  clk=0; rst_n=1; go=0; ws=0;
  model=0; checks=0; transitions=0;
  apply_reset();
  step(0,0); step(0,1); step(1,1); step(0,1);
  step(0,1); step(0,1); step(0,0); step(1,0);
  step(1,0); step(0,0); step(0,0); step(0,0);
  // Reset directly from READ, DLY, and DONE, away from the rising edge.
  apply_reset(); step(1,0); apply_reset();
  step(1,0); step(0,0); apply_reset();
  step(1,0); step(0,0); step(0,0); apply_reset();
  for(i=0;i<64;i=i+1) step((i%3)!=0,(i%5)!=0);
  apply_reset(); step(0,0);
  if ((transitions & 16'h1a43) !== 16'h1a43)
    $fatal(1,"FAIL FSM2 transition coverage=%h",transitions);
  $display("SUMMARY FSM2 PASS checks=%0d transitions=6/6",checks);
  $finish;
end
initial begin #20000; $fatal(1,"FAIL FSM2 timeout"); end
endmodule

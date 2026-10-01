`timescale 1ns / 1ps


module tb_comparator();

// stimulus
reg [3:0] i_a, i_b;

// monitor
wire o_greater, o_equal, o_less;

  // DUT instantiation
comparator uut (
  .i_a(i_a),
  .i_b(i_b),
  .o_greater(o_greater),
  .o_equal(o_equal),
  .o_less(o_less)
 );
// Dumpfile gen
initial begin
    $dumpfile("./comparator.vcd"   );
    $dumpvars(0, tb_comparator     );
end

  // Test Scenario
initial begin
  // system task for monitoring
  $monitor("%0t\t %b\t %b\t %b\t %b\t %b", $time, i_a, i_b, o_greater, o_equal, o_less);

  // apply stimulus
  i_a = 4'b0000; i_b = 4'b0000; #10; 
  i_a = 4'b0101; i_b = 4'b0011; #10; 
  i_a = 4'b0010; i_b = 4'b1000; #10; 
  i_a = 4'b1111; i_b = 4'b1111; #10; 
  i_a = 4'b1010; i_b = 4'b0101; #10; 
  i_a = 4'b0111; i_b = 4'b1001; #10; 
  i_a = 4'b1100; i_b = 4'b1100; #10; 
  i_a = 4'b0000; i_b = 4'b1111; #10; 

  // finish simulation
  #10 $finish;
end

endmodule

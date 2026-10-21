`timescale 1ns / 1ps

module tb_FSM ();

// signal def
	// stimulus
	reg clk; 
	reg rst_n;
	reg din_bit;
	// monitor signal
	wire dout_bit;

// DUT instantiation
FSM DUT (
	.clk 		( clk		), 
	.rst_n		( rst_n		), 
	.din_bit	( din_bit	), 
	.dout_bit	( dout_bit	)
);

// clock gen
always #5 clk = ~clk;


// apply stimulus
initial begin
	$dumpfile("FSM.vcd");
	$dumpvars(0, tb_FSM);
	$monitor("time=%0t | rst_n=%b | din_bit=%b | state=%b | dout_bit=%b", $time, rst_n, din_bit, DUT.state, dout_bit);
	// t=0, init
	clk = 1'b0; rst_n = 1'b0; din_bit = 1'b0;

	// reset release(system start)
	#100 rst_n = 1'b1;
	// put stimlus
	#10 din_bit = 1'b0;
	#10 din_bit = 1'b0;
	#10 din_bit = 1'b1;
	#10 din_bit = 1'b1;
	#10 din_bit = 1'b1;
	#10 din_bit = 1'b0;
	#10 din_bit = 1'b0;
	#10 din_bit = 1'b0;
	#10 din_bit = 1'b0;
	#10 din_bit =1'b1;
	#10 din_bit =1'b1;
	#10 din_bit =1'b1;
	#10 din_bit =1'b1;
	#10 din_bit = 1'b1;
	#10 din_bit = 1'b0;
	#100 rst_n = 1'b0;
	#2000; $finish;
end

endmodule

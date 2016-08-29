`timescale 1ns / 1ps

module float_test();
  reg  [31:0] g;
	reg  [31:0] e;
	reg  [31:0] o_expect;
  wire [31:0] o;

	float_add_gc float_add_gc_(g, e, o);

	initial
	begin
		g = 32'h40f00000; // 7.5
		e = 32'h3eae147b; // 0.34
		o_expect = 32'h40fae147; // 7.5 + 0.34 = 7.84
		#5;
		if(o != o_expect) begin
			$display("ERROR: %h == %h", o, o_expect);
		end
		#5;
		g = 32'h48e24500; // 463400
		e = 32'h2fcd9bd2; // 3.74E-10
		o_expect = 32'h48e24500; // 463400 + 3.74E-10 = 463400
		#5;
		if(o != o_expect) begin
			$display("ERROR: %h == %h", o, o_expect);
		end
		$finish;
	end

endmodule

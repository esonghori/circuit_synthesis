`timescale 1ns / 1ps

module float_test();
  reg  [31:0] g;
	reg  [31:0] e;
	reg  [31:0] sum_exp, mul_exp;
  wire [31:0] sum, mul;

	float_add_gc float_add_gc_(g, e, sum);
  float_mul_gc float_mul_gc_(g, e, mul);

	initial
	begin
		g = 32'h40f00000; // 7.5
		e = 32'h3eae147b; // 0.34
		sum_exp = 32'h40fae147; // 7.5 + 0.34 = 7.84
    mul_exp = 32'h40233333; // 7.5 + 0.34 = 2.55
		#5;
		if(sum !== sum_exp) begin
			$display("ERROR: sum %h == %h", sum, sum_exp);
		end
    if(mul !== mul_exp) begin
			$display("ERROR: mul %h == %h", mul, mul_exp);
		end
		#5;
		g = 32'h48e24500; // 463400
		e = 32'h2fcd9bd2; // 3.74E-10
		sum_exp = 32'h48e24500; // 463400 + 3.74E-10 = 463400
    mul_exp = 32'h3935bafa; // 463400 * 3.74E-10 = 1.733116E-4
		#5;
    if(sum !== sum_exp) begin
      $display("ERROR: sum %h == %h", sum, sum_exp);
    end
    if(mul !== mul_exp) begin
      $display("ERROR: mul %h == %h", mul, mul_exp);
    end
    #5;
    g = 32'h48e24500; // 6.961
    e = 32'h0; // 0
    sum_exp = 32'h48e24500; // 6.961 + 0 = 6.961
    mul_exp = 32'h0; // 6.961 * 0 = 0
    #5;
    if(sum !== sum_exp) begin
      $display("ERROR: sum %h == %h", sum, sum_exp);
    end
    if(mul !== mul_exp) begin
      $display("ERROR: mul %h == %h", mul, mul_exp);
    end
		$finish;
	end

endmodule

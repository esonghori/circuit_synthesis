`timescale 1ns / 1ps
// synopsys_ template


module float_mul_gc(g, e, o);
  input  [31:0] g;
  input  [31:0] e;
  output [31:0] o;

  float_mul float_mul_(.mul(o), .a(g), .b(e));

endmodule

module float_mul(mul, a, b);
  input [31:0] a, b;
  output [31:0] mul;

  reg           mulneg;
  reg [7:0]    mulexp;
  reg [50:0]    mulsig;
  assign        mul[31]    = mulneg;
  assign        mul[30:23] = mulexp;
  assign        mul[22:0]  = mulsig[45:23];

  reg [24:0]    asig, bsig;
  reg [7:0]     aexp, bexp;
  reg           aneg, bneg;

  always @( a or b ) begin
    /// Step 1: Break operand into sign (neg), exponent, and significand.
    aneg = a[31];
    bneg = b[31];

    aexp = a[30:23];
    bexp = b[30:23];
    // Put a 0 in bits 24 (later used for overflow).
    // Put a 1 in bit 23 of significand if exponent is non-zero.
    // Copy significand into remaining bits.
    asig = { 1'b0, aexp ? 1'b1 : 1'b0, a[22:0] };
    bsig = { 1'b0, bexp ? 1'b1 : 1'b0, b[22:0] };

    /// Step 2: set sign.
    //
    mulneg = aneg ^ bneg;

    /// Step 3: add exponents.
    //
    mulexp = aexp + bexp - 8'd127;

    /// Step 4: Multiply significands
    //
    mulsig = asig * bsig;

    /// Step 5: Normalize mul.
    //
    if ( mulsig[47] ) begin
      // overflow
      mulexp = mulexp + 1;
      mulsig = mulsig >> 1;
    end else if ( mulsig == 0 ) begin
      // mul is zero.
      mulneg = 0;
      mulexp = 0;
      mulsig = 0;
    end
  end
endmodule

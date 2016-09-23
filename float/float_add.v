`timescale 1ns / 1ps
// synopsys_ template

module float_add(g, e, o);
  parameter sig_width = 23;
  parameter exp_width = 8;
  parameter ieee_compliance = 0;

  input  [sig_width+exp_width:0] g;
  input  [sig_width+exp_width:0] e;
  output [sig_width+exp_width:0] o;

  // Instance of DW_fp_add
  // more info: https://www.synopsys.com/dw/ipdir.php?c=DW_fp_add
  DW_fp_add
  #(
    sig_width,
    exp_width,
    ieee_compliance
  )
  U1
  (
    .a(g),
    .b(e),
    .rnd(3'b0), // rounding mode
    .z(o),
    .status()
  );

endmodule

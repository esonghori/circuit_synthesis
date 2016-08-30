`timescale 1ns / 1ps
// synopsys_ template

/// LSU EE 3755 -- Fall 2012 -- Computer Organization
//
/// Verilog Notes 8 -- Floating Point

// Time-stamp: <18 October 2012, 16:30:53 CDT, koppel@sky.ece.lsu.edu>

/// Contents
//
// Binary Floating-Point Representation and Arithmetic
// IEEE 754 FP Standard
// FP Addition Hardware

/// References
//
// :PH:  Patterson & Hennessy, "Computer Organization & Design", 4th Edition

////////////////////////////////////////////////////////////////////////////////
/// Binary Floating-Point Representation and Arithmetic

// :PH: 3.5

/// Binary Floating-Point (FP) Representations
//
// The floating-point (FP) representations in this section (before
// IEEE 754) are NOT computer representations.
//
// Among other things, that means the number of bits needed to store a
// number is not specified.
//
// Computer representations for FP numbers covered in the next section,
// IEEE 754.


/// Binary Fixed Point Representation
//
//
// Each digit position has a multiplier.
//
//
// FiP Binary Number: 1  0  1  0  1. 1   0   0   1
// Digit Position:    4  3  2  1  0 -1  -2  -3  -4
// Multiplier:       16  8  4  2  1 1/2 1/4 1/8 1/16
//
// Value of number:  1*16 + 0*8 + 1*4 + 0*2 + 1*1 + 1/2 + 0/4 + 0/8 + 1/16
//                   = 21.5625
//
// Other Examples:
//
//     1.1    = 1.5
//     1.01   = 1.25
//     1.11   = 1.75
//     1.001  = 1.125
//  1111.1111 = 15.9375
//
//
// Fixed Point Decimal to Binary Conversion
//
//   To convert decimal number x,  0 < x < 1.
//
//   Method 1:
//
//     For digit position -1:
//        if x >= 1/2, digit is 1,  x = x - 1/2;
//        if x <  1/2, digit is 0,  x unchanged.
//     For digit position -2:
//        if x >= 1/4, digit is 1,  x = x - 1/4
//        if x <  1/4, digit is 0,  x unchanged.
//     Etc.
//
//   Method 2:
//
//     Let r be the number of digits past decimal point desired.
//
//     Convert x * 2^r to binary.
//
//     MSB is first digit past binary point, etc.
//
//     Example:
//       r = 4,  x = .75
//       Convert .75 * 2^4 = 12 to binary: 1100
//       x in binary is: .1100
//
// Examples to 12 digits:
//
//  1.1 = 1.000110011001...     1.1 * 2^12 = 4505 = 1000110011001
//  1.2 = 1.001100110011...
//  1.3 = 1.010011001100...
//  1.4 = 1.011001100110...
//  1.5 = 1.1
//
// Note:
//
// Common numbers such as 0.2 do not have exact representations.


/// Binary Scientific Notation
//
// Binary Scientific Representation Similar to Decimal Scientific Notation
//
//  Decimal: SIGN SIGNIFICAND x 10^{EXPONENT}
//  Binary:  SIGN SIGNIFICAND x 2^{EXPONENT}
//
//  Decimal Examples:
//
//    1.23 x 10^{2}  = 123
//    1.23 x 10^{0}  = 1.23
//    1.23 x 10^{-1} = .123
//    Examples above are normalized, examples below are not.
//    12.3 x 10^{1}  = 123
//    .123 x 10^{1}  = 1.23
//    123 x 10^{-3}  = .123
//
//  Binary Examples
//
//    1 x 2^{0}    = 1 = 1
//    1 x 2^{1}    = 10 = 2
//    1 x 2^{2}    = 100 = 4
//    1.1 x 2^{2}  = 110 = 6
//    1.1 x 2^{1}  = 11 = 3
//    1.1 x 2^{0}  = 1.1 = 1.5
//    1.1 x 2^{-1} = .11 = .75
//    Examples above are normalized, examples below are not.
//    11 x 2^{1}   = 110 = 6
//    11 x 2^{0}   = 11 = 3
//    11 x 2^{-1}  = 1.1 = 1.5
//    11 x 2^{-2}  = .11 = .75

/// Addition Using Scientific Notation
//
// Consider:
//
//   a_scand x 2^{a_exp}
//   b_scand x 2^{b_exp}
//
//   Assume that a > b in magnitude. (That is, |a| > |b|.)
//
//   To add:
//
//     Set b'_exp = a_exp.
//
//     Set b'scand = b_scand / 2^(a_exp - b_exp)
//       That is, right-shift b_scand by (a_exp - b_exp) bits.
//
//       Note that:  b_scand x 2^{b_exp} == b'_scand x 2^{b'_exp}
//
//     Set s_scand = a_scand + b'_scand
//
//     Set s_exp = a_exp
//
//     We now have the sum: s_scand x 2^{s_exp}
//
//
//
//  Example:
//    See text or blackboard example.
//
// Subtraction is similar.


/// Multiplication Using Scientific Notation
//
// Consider:
//
//   a_scand x 2^{a_exp}
//   b_scand x 2^{b_exp}
//
//   To multiply these:
//
//     Set p_scand = a_scand x b_scand
//     Set p_exp = a_exp + b_exp
//     Optional: Normalize p
//
//     Product is p_scand x 2^{p_exp}
//
//  Example:
//    See text or blackboard example.
//


////////////////////////////////////////////////////////////////////////////////
/// IEEE 754 FP Standard

// :PH: 3.5

/// Standard Specifies
//
// Formats of FP numbers. (There are several sizes.)
// Results of arithmetic operations, including rounding.

/// Objectives of Standard
//
// Represent range of numbers in common use. (Of course.)
// Predictable rounding behavior.
// Compare as integers.
//
// The following is NOT an objective:
//
// Keep things simple for an introductory computer class.
// Nevertheless, it's not that bad.

/// Features
//
// Can Represent:
//   Floating-point number.
//   + and - Infinity, and other special values.
//
// Special Properties
//   Positive Zero is 0.
//   Can use signed integer magnitude and equality tests.

/// Sizes
//
// Single: 32 bits.
// Double: 64 bits.
// Extended: Varies, not shown here.

/// Key Ideas
//
// Format Specifies:
//
//  Sign.
//  Exponent.
//  Significand (Fraction)
//
// Slight Complications (but for good reason):
//
//  Exponent is biased.
//  Significand may not include MSB (if not, it's 1).


/// IEEE 754 Single Format
//
// Format:   SEEEEEEEEFFFFFFFFFFFFFFFFFFFFFFF
// 31:    S: Sign bit: 1 negative, 0 positive.
// 30-23: E: Biased Exponent. (Exponent is E-127)
// 22-0:  F: Significand (Fraction)
//
//  Case                    Value formula.
//  0 < E < 255,  S = 0  :    ( 1.0 + F / 2^{23} ) 2^{E-127}
//  0 < E < 255,  S = 1  :  - ( 1.0 + F / 2^{23} ) 2^{E-127}
//  E = 0, S = 0, F = 0  :    0
//  E = 0, S = 1, F = 0  :  - 0
//  E = 255, S = 0, F = 0:    Infinity
//  E = 255, S = 1, F = 0:  - Infinity

/// IEEE 754 Rounding Modes
//
// Format specifies four rounding modes.
// Hardware set to use desired rounding mode.
//
// Rounding Modes:
//
//  Round to even. (Nearest LSB zero.)  Most popular.
//  Round towards zero.
//  Round towards infinity.
//  Round towards -infinity.


/// IEEE 754 Single Format Examples:   IEEE 754 to Value
//
// Single FP:   32h'3fc00000
//            = 32b'00111111110000000000000000000000
//                  SEEEEEEEEFFFFFFFFFFFFFFFFFFFFFFF
//
//                  0 01111111 10000000000000000000000
//                  S EEEEEEEE FFFFFFFFFFFFFFFFFFFFFFF
//
//                  S = 0,  E = 7f = 127,  F 400000 = 4194304
//
// Based on value of S and E, the following case applies:
//
//  0 < E < 255,  S = 0  :    ( 1.0 + F / 2^{23} ) 2^{E-127}
//
//  Value = ( 1.0 + 4194304 / 2^{23} ) 2^{127-127}
//        = ( 1.0 + 0.5 )
//        = 1.5

// Single FP:   32h'456ab000
//            = 32b'01000101011010101011000000000000
//                  SEEEEEEEEFFFFFFFFFFFFFFFFFFFFFFF
//
//                  0 10001010 11010101011000000000000
//                  S EEEEEEEE FFFFFFFFFFFFFFFFFFFFFFF
//
//                  S = 0,  E = 8a = 138,  F 6ab000 = 6991872
//
// Based on value of S and E, the following case applies:
//
//  0 < E < 255,  S = 0  :    ( 1.0 + F / 2^{23} ) 2^{E-127}
//
//  Value = ( 1.0 + 6991872 / 2^{23} ) 2^{138-127}
//        = ( 1.0 + 0.833496 ) 2048
//        = 3755

// Single FP:   32h'c0490fdb
//            = 32b'11000000010010010000111111011011
//                  SEEEEEEEEFFFFFFFFFFFFFFFFFFFFFFF
//
//                  1 10000000 10010010000111111011011
//                  S EEEEEEEE FFFFFFFFFFFFFFFFFFFFFFF
//
//                  S = 1,  E = 80 = 128,  F 490fdb = 4788187
//
// Based on value of S and E, the following case applies:
//
//  0 < E < 255,  S = 1  :  - ( 1.0 + F / 2^{23} ) 2^{E-127}
//
//  Value = - ( 1.0 + 4788187 / 2^{23} ) 2^{128-127}
//        = - ( 1.0 + 0.570796 ) 2
//        = -3.14159

// Single FP:   32h'0
//            = 32b'00000000000000000000000000000000
//                  SEEEEEEEEFFFFFFFFFFFFFFFFFFFFFFF
//
//                  0 00000000 00000000000000000000000
//                  S EEEEEEEE FFFFFFFFFFFFFFFFFFFFFFF
//
//                  S = 0,  E = 0,  F = 0
//
// Based on value of S and E, the following case applies:
//
//  E = 0, S = 0, F = 0  :    0
//
//  Value = 0

// Single FP:   32h'7f800000
//            = 32b'01111111100000000000000000000000
//                  SEEEEEEEEFFFFFFFFFFFFFFFFFFFFFFF
//
//                  0 11111111 00000000000000000000000
//                  S EEEEEEEE FFFFFFFFFFFFFFFFFFFFFFF
//
//                  S = 0,  E = 255,  F = 0
//
// Based on value of S and E, the following case applies:
//
//  E = 255, S = 0, F = 0:    Infinity
//
//  Value = Infinity.

/// IEEE 754 Single Format Examples:   Value to IEEE 754
//
// Value (decimal):        12.75
//   Convert to binary:  1100.11
//   Convert to normalized binary scientific notation:  1.10011 x 2^3
//
//   S = 0  (its positive)
//   E = 127 + 3 = 130 = 100 0010
//   F = 10011 000000000000000000
//
//   Single: 0  1000 0010  10011 000000000000000000
//         = 0100 0001 0100 1100 0000 0000 0000 0000
//         = 0x414c0000


////////////////////////////////////////////////////////////////////////////////
/// FP Addition Hardware

// FP arithmetic hardware simple in principle, but details can be overwhelming.
// Only hardware for FP adder shown.

/// FP Addition Hardware Examples
//
// Add IEEE 754 Doubles
// For simplicity, rounding is not performed correctly by example hardware.
//
// Two Adders
//
//   Combinational. (Unrealistic)
//   Sequential.    (More realistic.  [Real adders would be pipelined.])
//

/// Steps For Addition
//
// To add "a" and "b" (without rounding)
//
// Step 1:
//   If b's exponent is larger than a's, swap a and b.
//
// Step 2:
//   Insert 1 in significand if corresponding exponent not zero.
//
// Step 3:
//   If necessary, un-normalize b so that a and b's exponent are the same.
//
// Step 4:
//   Negate significand if corresponding sign bit is negative.
//
// Step 5:
//   Compute sum of significands.
//
// Step 6:
//   Store sign of sum.  Take absolute value of sum.
//
// Step 7:
//   Normalize sum.


// :Example:
//
// Combinational adder.  Computes the sum of two IEEE 754 singles.
// Does not round correctly and does not handle certain special cases.

module float_add_gc(g, e, o);
  input  [31:0] g;
  input  [31:0] e;
  output [31:0] o;

  float_add float_add_(.sum(o), .a_original(g), .b_original(e));

endmodule

module float_add(sum, a_original, b_original);
   input [31:0] a_original, b_original;
   output [31:0] sum;

   reg           sumneg;
   reg [7:0]    sumexp;
   reg [25:0]    sumsig;
   assign        sum[31]    = sumneg;
   assign        sum[30:23] = sumexp;
   assign        sum[22:0]  = sumsig;

   reg [31:0]    a, b;
   reg [25:0]    asig, bsig;
   reg [7:0]     aexp, bexp;
   reg           aneg, bneg;
   reg [7:0]     diff;

   always @( a_original or b_original )
     begin

        /// Compute IEEE 754 Double Floating-Point Sum in Seven Easy Steps
        //  Note: Rounding and sub-normals not handled properly.

        /// Step 1: Copy inputs to a and b so that a's exponent not smaller than b's.
        //
        if ( a_original[30:23] < b_original[30:23] ) begin

           a = b_original;  b = a_original;

        end else begin

           a = a_original;  b = b_original;

        end

        /// Step 2: Break operand into sign (neg), exponent, and significand.
        //
        aneg = a[31];     bneg = b[31];
        aexp = a[30:23];  bexp = b[30:23];
        // Put a 0 in bits 53 and 54 (later used for sign).
        // Put a 1 in bit 52 of significand if exponent is non-zero.
        // Copy significand into remaining bits.
        asig = { 2'b0, aexp ? 1'b1 : 1'b0, a[22:0] };
        bsig = { 2'b0, bexp ? 1'b1 : 1'b0, b[22:0] };

        /// Step 3: Un-normalize b so that aexp == bexp.
        //
        diff = aexp - bexp;
        bsig = bsig >> diff;
        //
        // Note: bexp no longer used. If it were would need to set bexp = aexp;

        /// Step 4: If necessary, negate significands.
        //
        if ( aneg ) asig = -asig;
        if ( bneg ) bsig = -bsig;

        /// Step 5: Compute sum.
        //
        sumsig = asig + bsig;

        /// Step 6: Take absolute value of sum.
        //
        sumneg = sumsig[25];
        if ( sumneg ) sumsig = -sumsig;

        /// Step 7: Normalize sum. (Three cases.)
        //
        if ( sumsig[24] ) begin
           //
           // Case 1: Sum overflow.
           //         Right shift significand and increment exponent.

           sumexp = aexp + 1;
           sumsig = sumsig >> 1;

        end else if ( sumsig ) begin:A
           //
           // Case 2: Sum is nonzero and did not overflow.
           //         Normalize. (See cases 2a and 2b.)

           integer pos, adj, i;

           // Find position of first non-zero digit.
           pos = 0;
           for (i = 23; i >= 0; i = i - 1 ) if ( !pos && sumsig[i] ) pos = i;

           // Compute amount to shift significand and reduce exponent.
           adj = 23 - pos;
           if ( aexp < adj ) begin
              //
              // Case 2a:
              //   Exponent too small, floating point underflow, set to zero.

              sumexp = 0;
              sumsig = 0;
              sumneg = 0;

           end else begin
              //
              // Case 2b: Adjust significand and exponent.

              sumexp = aexp - adj;
              sumsig = sumsig << adj;

           end

        end else begin
           //
           // Case 3: Sum is zero.

           sumexp = 0;
           sumsig = 0;

        end

     end
endmodule

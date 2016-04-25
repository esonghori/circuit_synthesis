//////////////////////////////////////////////////////////////////
//                                                              //
//  Barrel Shifter for Amber 2 Core                             //
//                                                              //
//  This file is part of the Amber project                      //
//  http://www.opencores.org/project,amber                      //
//                                                              //
//  Description                                                 //
//  Provides 32-bit shifts LSL, LSR, ASR and ROR                //
//                                                              //
//  Author(s):                                                  //
//      - Conor Santifort, csantifort.amber@gmail.com           //
//                                                              //
//////////////////////////////////////////////////////////////////
//                                                              //
// Copyright (C) 2010 Authors and OPENCORES.ORG                 //
//                                                              //
// This source file may be used and distributed without         //
// restriction provided that this copyright statement is not    //
// removed from the file and that any derivative work contains  //
// the original copyright notice and the associated disclaimer. //
//                                                              //
// This source file is free software; you can redistribute it   //
// and/or modify it under the terms of the GNU Lesser General   //
// Public License as published by the Free Software Foundation; //
// either version 2.1 of the License, or (at your option) any   //
// later version.                                               //
//                                                              //
// This source is distributed in the hope that it will be       //
// useful, but WITHOUT ANY WARRANTY; without even the implied   //
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      //
// PURPOSE.  See the GNU Lesser General Public License for more //
// details.                                                     //
//                                                              //
// You should have received a copy of the GNU Lesser General    //
// Public License along with this source; if not, download it   //
// from http://www.opencores.org/lgpl.shtml                     //
//                                                              //
//////////////////////////////////////////////////////////////////



module a23_barrel_shift_testbench();

`include "../a23_localparams.vh"

reg       [31:0]          in;
reg                       carry_in;
reg       [7:0]           shift_amount;
reg                       shift_imm_zero;
reg       [1:0]           funct;
wire      [31:0]          out;
wire                      carry_out;


reg [32:0] golden_value [255:0];



integer i,j,k,t;
initial begin
  $readmemh("barrel_shift_golden.txt", golden_value);
  t = 0;
  for(k=0;k<2;k=k+1) begin
    if(k==0) begin
      in = 32'hdeadbeef;
      carry_in = 1'b0;
    end else begin
      in = 32'h75132312;
      carry_in = 1'b1;
    end
    for(j=0;j<4;j=j+1) begin
      funct = j;
      for(i=0;i<32;i=i+1) begin
        if(i==32) begin
          shift_imm_zero = 1'b1;
          shift_amount = 8'b0;
        end else begin
          shift_imm_zero = 1'b0;
          shift_amount = i;
        end
        #1;
        if({carry_out, out} !== golden_value[t]) begin
          $display("ERROR: %x != %x", {carry_out, out}, golden_value[t]);
          $display("in = %x, carry_in = %x, function = %x, shift_amount = %x", in, carry_in, funct, shift_amount);
        end
        t = t + 1;
      end
    end
  end
  $stop;
end

a23_barrel_shift u_a23_barrel_shift(
  .i_in(in),
  .i_carry_in(carry_in),
  .i_shift_amount(shift_amount),
  .i_shift_imm_zero(shift_imm_zero), 
  .i_function(funct),
  .o_out(out),
  .o_carry_out(carry_out)
);


endmodule

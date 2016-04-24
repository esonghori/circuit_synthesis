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



module a23_barrel_shift_test_bench();

`include "../a23_localparams.vh"

reg       [31:0]          in;
reg                       carry_in;
reg       [7:0]           shift_amount;
reg                       shift_imm_zero;
reg       [1:0]           function;
wire      [31:0]          out;
wire                      carry_out;

integer i,j;
initial begin
  in = 32'hdeadbeef;
  carry_in = 1'b0;
  for(j=0;j<4;j=j+1) begin
    function = j;
    shift_imm_zero = 1;
    $display("%x\n", {carry_out, out});
    shift_imm_zero = 0;
    for(i=0;i<32;i=i+1) begin
      shift_amount = i;
      $display("%x\n", {carry_out, out});
    end
  end
end

a23_barrel_shift (
  .i_in(in),
  .i_carry_in(carry_in),
  .i_shift_amount(shift_amount),
  .i_shift_imm_zero(shift_imm_zero), 
  .i_function(function),
  .o_out(out),
  .o_carry_out(carry_out)
);


endmodule

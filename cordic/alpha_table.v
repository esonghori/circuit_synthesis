`timescale 1ns / 1ps
`include "cordic.vh"

// synopsys_ template
module alpha_table
#( 
  parameter DEC  = 2,
  parameter FRAC = 14,
  parameter MOD = `MOD_CIR // MOD = {`MOD_CIR=1,`MOD_LIN=0,`MOD_HYP=-1}
)
(
  iter,
  alphai
);

  localparam L = DEC + FRAC;
  localparam ITER = FRAC + 1;
  localparam LOG_ITER = $clog2(ITER); 

  input [LOG_ITER-1:0] iter;
  output reg [L-1:0] alphai;


  generate
    if(MOD == `MOD_CIR) begin:CIR
      always @(*) begin
        case(iter)
        0:  alphai = 16'b0011001001000100;
        1:  alphai = 16'b0001110110101100;
        2:  alphai = 16'b0000111110101110;
        3:  alphai = 16'b0000011111110101;
        4:  alphai = 16'b0000001111111111;
        5:  alphai = 16'b0000001000000000;
        6:  alphai = 16'b0000000100000000;
        7:  alphai = 16'b0000000010000000;
        8:  alphai = 16'b0000000001000000;
        9:  alphai = 16'b0000000000100000;
        10: alphai = 16'b0000000000010000;
        11: alphai = 16'b0000000000001000;
        12: alphai = 16'b0000000000000100;
        13: alphai = 16'b0000000000000010;
        14: alphai = 16'b0000000000000001;
        default: alphai = 16'b0;
        endcase
      end
    end else if (MOD == `MOD_LIN) begin:LIN
      always @(*) begin
        case(iter)
        0:  alphai = 16'b0100000000000000;
        1:  alphai = 16'b0010000000000000;
        2:  alphai = 16'b0001000000000000;
        3:  alphai = 16'b0000100000000000;
        4:  alphai = 16'b0000010000000000;
        5:  alphai = 16'b0000001000000000;
        6:  alphai = 16'b0000000100000000;
        7:  alphai = 16'b0000000010000000;
        8:  alphai = 16'b0000000001000000;
        9:  alphai = 16'b0000000000100000;
        10: alphai = 16'b0000000000010000;
        11: alphai = 16'b0000000000001000;
        12: alphai = 16'b0000000000000100;
        13: alphai = 16'b0000000000000010;
        14: alphai = 16'b0000000000000001;
        default: alphai = 16'b0;
        endcase
      end
    end else begin:HYP //if (MOD == `MOD_HYP)
      always @(*) begin
        case(iter)
        0:  alphai = 16'b0010001100101000;
        1:  alphai = 16'b0001000001011001;
        2:  alphai = 16'b0000100000001011;
        3:  alphai = 16'b0000010000000001;
        4:  alphai = 16'b0000001000000000;
        5:  alphai = 16'b0000000100000000;
        6:  alphai = 16'b0000000010000000;
        7:  alphai = 16'b0000000001000000;
        8:  alphai = 16'b0000000000100000;
        9:  alphai = 16'b0000000000010000;
        10: alphai = 16'b0000000000001000;
        11: alphai = 16'b0000000000000100;
        12: alphai = 16'b0000000000000010;
        13: alphai = 16'b0000000000000001;
        14: alphai = 16'b0000000000000001;
        default: alphai = 16'b0;
        endcase
      end
    end
  endgenerate


  /*reg [L-1:0] mem [ITER-1:0];
  generate
    if(MOD == `MOD_CIR) begin:CIR
      initial begin
        $readmemb("tables/circular.txt", mem); 
      end
    end else if (MOD == `MOD_LIN) begin:LIN
      initial begin
        $readmemb("tables/linear.txt", mem); 
      end
    end else begin:HYP //if (MOD == `MOD_HYP)
      initial begin
        $readmemb("tables/hyperbolic.txt", mem); 
      end
    end
  endgenerate
  assign alphai = (iter<ITER)?mem[iter]:0;*/

endmodule

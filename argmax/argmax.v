module argmax
#(
  parameter S, // number of inputs N = S**2
  parameter M // input bit-width
)
(
  input [M*(2**S)-1:0] in,
  output [M-1:0] max,
  output [S-1:0] ind
);

  generate
  if (S==1) begin:S1
    assign ind = (in[M-1:0] > in[2*M-1:M])?1'b0:1'b1;
    assign max = (in[M-1:0] > in[2*M-1:M])?in[M-1:0]:in[2*M-1:M];
  end else begin:SG1
    wire [M-1:0] max1, max0;
    wire [S-2:0] ind1, ind0;

    argmax #(
      .S(S-1),
      .M(M)
    ) X1 (
      .in(in[(2**S)*M-1:(2**S)*M/2]),
      .max(max1),
      .ind(ind1)
    );

    argmax #(
      .S(S-1),
      .M(M)
    ) X0 (
      .in(in[(2**S)*M/2-1:0]),
      .max(max0),
      .ind(ind0)
    );

    assign ind = (max0>max1)?{1'b0, ind0}:{1'b1, ind1};
    assign max = (max0>max1)?max0:max1;
  end
  endgenerate

endmodule

`timescale 1ns / 1ps

 module square_root_comb #(parameter N = 8, M = N/2)(
	input 			[N-1:0]		A,
	output			[N/2-1:0]	O
	);
	
				wire	[N/2-1:0]	Y[0:M];
				wire	[N/2-1:0]	Y0[0:M];
				wire	[N/2-1:0]	Y_mid[0:M];
	
	assign Y[0] = {1'b1,{(N/2-1){1'b0}}};
	assign Y0[0] = {1'b1,{(N/2-1){1'b0}}};
	assign Y_mid[0] = 0;
	
	assign O = Y[M];
	
	genvar gv;
	generate
	for (gv = 0; gv < M; gv = gv + 1)
	begin: sqr_rt
		squar_root_unit #(.N(N)) squar_root_unit(
			.x(A),
			.y_in(Y[gv]), 
			.y0_in(Y0[gv]),
			.y_mid_in(Y_mid[gv]),
			.y(Y[gv+1]), 
			.y0(Y0[gv+1]),
			.y_mid(Y_mid[gv+1])
		);
	end
	endgenerate	
	
endmodule

module square_root_seq #(parameter N = 8, M = N/2)(
	input 							clk,
	input 							rst,
	input 							start,
	input 			[N-1:0]		A,
	output	reg	[N/2-1:0]	O,
	output	reg					ready
	);
	
	function integer log2;
	input integer value;
	begin
	value = value-1;
	for (log2=0; value>0; log2=log2+1)
	value = value>>1;
	end
	endfunction
	
	localparam L = log2(M);
	
				reg	[N-1:0]		x;
				reg	[N/2-1:0]	y_in, y0_in, y_mid_in;
				wire	[N/2-1:0]	y, y0, y_mid;	

	squar_root_unit #(.N(N)) squar_root_unit(
		.x(x),
		.y_in(y_in), 
		.y0_in(y0_in),
		.y_mid_in(y_mid_in),
		.y(y), 
		.y0(y0),
		.y_mid(y_mid)
	);
	
	reg [1:0] state;
	reg [L-1:0] count;
	
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			state	<= 2'b00;
			O		<= 0;
			ready	<= 0;
			x		<= 0;
			y_in	<= 0;
			y0_in	<= 0;
			y_mid_in	<= 0;
			count	<= 0;
		end
		else begin
			case(state)
				2'b00: begin
					state <= {1'b0,start};
				end		
				2'b01: begin
					ready <= 1'b0;
					x <= A;
					y_in <= {1'b1,{(N/2-1){1'b0}}};
					y0_in <= {1'b1,{(N/2-1){1'b0}}};
					y_mid_in	<= 0;
					count <= 0;	
					state <= 2'b10; 					
				end		
				2'b10: begin
					y_in <= y;
					y0_in <= y0;
					y_mid_in <= y_mid;
					count <= count + 1;
					if (count == M-1) begin
						ready <= 1'b1;
						O <= y;
						state <= 2'b00;
					end
				end	
			endcase
		end		
	end

	
	
endmodule


module squar_root_unit #(parameter N = 8)(
	input		[N-1:0]		x,
	input	[N/2-1:0]	y_in, y0_in, y_mid_in,
	output	[N/2-1:0]	y, y0, y_mid
);

	wire 						t;
	wire		[N-1:0]		y_sqr;
	wire		[1:0]		temp;
	
	//assign	y_sqr = y_in * y_in;
	MULT #(.N(N/2), .M(N/2)) MULT1 (.A(y_in), .B(y_in), .O(y_sqr));
	//assign 	t = (y_sqr > x) ? 1 : 0;
	COMP #(.N(N)) COMP1 (.A(x), .B(y_sqr), .O(t));
	//assign	y_min_y0 = y_in - y0_in;
	//SUB_ #(.N(N/2), .M(N/2)) SUB1 (.A(y_in), .B(y0_in), .O({temp[0], y_min_y0}));
	//assign 	y_mid = t? y_min_y0 : y_in;
	MUX #(.N(N/2)) MUX1 (.A(y_mid_in), .B(y_in), .S(t), .O(y_mid));
	assign 	y0 = y0_in >> 1;
	//assign 	y = y_mid + y0;
	ADD_ #(.N(N/2), .M(N/2)) ADD1 (.A(y_mid), .B(y0), .O({temp[1],y}));
	

endmodule

module testbench;
	reg [3:0] n;
	reg [7:0] e;
	reg [3071:0] data;
	reg clk;
	reg reset;
	reg valid;
	reg ready;
	reg hold;
	wire [145:0] sp;
	wire valid_out;

	initial begin
		#1 n=4;e=5;
		#1  data[3:0]=1;
			data[7:4]=2;
			data[11:8]=1;
			data[15:12]=2;
			data[19:16]=3;
			data[23:20]=2;
			data[27:24]=3;
			data[31:28]=4;
			data[35:32]=3;
//			data[39:36]=2;
//			data[43:40]=3;
//			data[47:44]=1;
//			data[51:48]=3;
//			data[55:52]=4;
//			data[59:56]=1;
		#5 reset=1'b0;
		#5 reset=1'b1;
	end	
	
	initial begin
		clk=1'b0;
		forever	#5 clk=~clk;
	end	

	Dijkstra inst(
    	.n(n),
		.e(e), 
		.data(data), 
		.clk(clk), 
		.reset(reset), 
		.valid(valid), 
		.ready(ready), 
		.hold(hold),
		.sp(sp),
		.valid_out(valid_out)
    );

	initial begin
		$monitor( "sp = %b , valid_out = %b", sp, valid_out);
		#500 $finish;
	end

endmodule

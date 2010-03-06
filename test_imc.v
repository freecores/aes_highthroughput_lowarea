`include "timescale.v"
module top();
`include "mix_columns.v"
`include "shift_rows.v"

reg [7:0] a,b,c,d;
wire [7:0] datao;
wire [31:0] data2o;
wire [127:0] data3o;
assign datao[7:0] = inv_byte_mix_columns(a,b,c,d);
assign data2o[31:0] = inv_word_mix_columns({a,b,c,d});
//assign data3o[127:0] = inv_mix_columns(128'h2c21a820306f154ab712c75eee0da04f);
assign data3o = inv_shift_rows(128'haa5ece06ee6e3c56dde68bac2621bebf);

initial
begin
	#10;
	a = 8'h2c;
	b = 8'h21;
	c = 8'ha8;
	d = 8'h20;
	#10;
	$display("datao is %h",datao);
	$display("data2o is %h",data2o);
	$display("data3o is %h",data3o);
	$finish;
end

endmodule

`timescale 1ns / 10ps
module tb ();

reg clk;
reg reset;
reg [7:0] din;
wire [7:0] dout;

reg key_start;
reg [255:0] key_in;
reg data_in_valid;
reg [127:0] data_in;
wire  key_ready;
wire  ready_out;
reg   enable;
initial
begin
	clk = 1'b1;
	key_in = 1'b0;
	key_start = 1'b0;
        data_in_valid = 1'b0;
	reset = 1'b1;
	enable = 1;
	#100;
	reset = 1'b0;
	#100;
	din = 8'hae;
	@ (posedge clk);
	key_start <= 1'b1;
	//key_in[255:128] = 128'h2b7e151628aed2a6abf7158809cf4f3c;
	//key_in[255:64] = 192'h8e73b0f7da0e6452c810f32b809079e562f8ead2522c6b7b;
	//key_in[255:0] = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;
	key_in[255:64] = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;
	//key_in[255:0] = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
	@ (posedge clk);
	key_start <= 1'b0;
	wait (key_ready);
        data_in_valid <= 1'b1;
	//data_in[127:0] = 128'h3243f6a8885a308d313198a2e0370731;
	//data_in[127:0] = 128'h00112233445566778899aabbccddeeff;
	//data_in[127:0] = 128'h8ea2b7ca516745bfeafc49904b496089;
	data_in[127:0] = 128'hdda97ca4864cdfe06eaf70a0ec0d7191;
	//@ (posedge clk);
	//data_in[127:0] = 128'h3243f6a8885a308d313198a2e0370734;
	//@ (posedge clk);
	//data_in_valid <= 1'b0;
	//data_in[127:0] = 128'h3243f6a8885a308d313198a2e0370731;
	//@ (posedge clk);
	//data_in_valid <= 1'b1;
	//data_in[127:0] = 128'h3243f6a8885a308d313198a2e0370734;
	//data_in[127:0] = 128'h00112233445566778899aabbccddeeff;
	@ (posedge clk);
        data_in_valid <= 1'b0;
	repeat (3) @ (posedge clk);
	wait (ready_out);
	@ (posedge clk);
	//data_in_valid <= 1'b1;
	@ (posedge clk);
	data_in_valid <= 1'b0;
	repeat (6) @(posedge clk);
	//enable <= 0;
	//repeat (15) @(posedge clk);
	//enable <= 1;
	#200;
	//$display("dout is %h",dout);
	din = 8'h1e;
	#2000;
	//$display("dout is %h",dout);
	#100;
	$finish;
end

/*sbox u_sbox(
	.clk(clk),
	.reset_n(reset_n),
	.din(din),
	.ende(1'b1),
	.dout(dout));*/
//wire wr;
//wire [4:0] wr_addr;
//wire [63:0] wr_data;

wire [127:0] data_out;
aes dut(
   .clk(clk),
   .reset(reset),
   .i_start(key_start),
   .i_enable(enable), //TBD
   .i_ende(1'b1),
   .i_key(key_in),
   .i_key_mode(2'b01),
   .i_data(data_in),
   .i_data_valid(data_in_valid),
   .o_ready(ready_out),
   .o_data(data_out),
   .o_data_valid(data_out_valid),
   .o_key_ready(key_ready)
);

/*key_exp u_key_exp (
	.clk(clk),
	.reset_n(reset_n),
	.key_in(key_in),
	.key_mode(2'b10),
	.key_start(key_start),
	.wr(wr),
	.wr_addr(wr_addr),
	.wr_data(wr_data)
);*/

always @ (posedge clk)
   if (data_out_valid)
      $display("DATA: %16h",data_out);


always 
	#10 clk = ~clk;

endmodule

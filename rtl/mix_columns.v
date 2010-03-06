//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Mix Columns File                                            ////
////                                                              ////
////  Description:                                                ////
////  Includes functions for mix columns and inverse mix columns  ////
////                                                              ////
////  To Do:                                                      ////
////   - done                                                     ////
////                                                              ////
////  Author(s):                                                  ////
////      - Luo Dongjun,   dongjun_luo@hotmail.com                ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
// Mix columns size: 4 words
function [127:0] mix_columns;
input [127:0] si;
reg [127:0] so;
begin
   so[127:96] = word_mix_columns(si[127:96]);
   so[95:64] = word_mix_columns(si[95:64]);
   so[63:32] = word_mix_columns(si[63:32]);
   so[31:0] = word_mix_columns(si[31:0]);
   mix_columns[127:0] = so[127:0];
end
endfunction

// Inverse Mix columns size: 4 words
function [127:0] inv_mix_columns;
input [127:0] si;
reg [127:0] so;
begin
   so[127:96] = inv_word_mix_columns(si[127:96]);
   so[95:64] = inv_word_mix_columns(si[95:64]);
   so[63:32] = inv_word_mix_columns(si[63:32]);
   so[31:0] = inv_word_mix_columns(si[31:0]);
   inv_mix_columns[127:0] = so[127:0];
end
endfunction

// Mix Columns for encryption word
function [31:0] word_mix_columns;
input [31:0] si;
reg [7:0] si0,si1,si2,si3;
reg [7:0] so0,so1,so2,so3;
begin
	si0[7:0] = si[31:24];
	si1[7:0] = si[23:16];
	si2[7:0] = si[15:8];
	si3[7:0] = si[7:0];
	so0[7:0] = byte_mix_columns(si0[7:0],si1[7:0],si2[7:0],si3[7:0]);
	so1[7:0] = byte_mix_columns(si1[7:0],si2[7:0],si3[7:0],si0[7:0]);
	so2[7:0] = byte_mix_columns(si2[7:0],si3[7:0],si0[7:0],si1[7:0]);
	so3[7:0] = byte_mix_columns(si3[7:0],si0[7:0],si1[7:0],si2[7:0]);
	word_mix_columns[31:0] = {so0[7:0],so1[7:0],so2[7:0],so3[7:0]};
end
endfunction

// inverse Mix Columns for decryption word
function [31:0] inv_word_mix_columns;
input [31:0] si;
reg [7:0] si0,si1,si2,si3;
reg [7:0] so0,so1,so2,so3;
begin
	si0[7:0] = si[31:24];
	si1[7:0] = si[23:16];
	si2[7:0] = si[15:8];
	si3[7:0] = si[7:0];
	so0[7:0] = inv_byte_mix_columns(si0[7:0],si1[7:0],si2[7:0],si3[7:0]);
	so1[7:0] = inv_byte_mix_columns(si1[7:0],si2[7:0],si3[7:0],si0[7:0]);
	so2[7:0] = inv_byte_mix_columns(si2[7:0],si3[7:0],si0[7:0],si1[7:0]);
	so3[7:0] = inv_byte_mix_columns(si3[7:0],si0[7:0],si1[7:0],si2[7:0]);
	inv_word_mix_columns[31:0] = {so0[7:0],so1[7:0],so2[7:0],so3[7:0]};
end
endfunction

function [7:0] byte_mix_columns;
input [7:0] a,b,c,d;
begin
	byte_mix_columns[7:0] = MUL2(a[7:0]) ^ MUL3(b[7:0]) ^ c[7:0] ^ d[7:0];
end
endfunction

function [7:0] inv_byte_mix_columns;
input [7:0] a,b,c,d;
begin
	inv_byte_mix_columns[7:0] = MULE(a[7:0]) ^ MULB(b[7:0]) ^ MULD(c[7:0]) ^ MUL9(d[7:0]);
end
endfunction

//xtimes
function [7:0] xtimes;
input [7:0] d;
reg [3:0] xt;
begin
	xtimes[7:5] = d[6:4];
	xt[3] = d[7];
	xt[2] = d[7];
	xt[1] = 1'b0;
	xt[0] = d[7];
	xtimes[4:1] =xt[3:0]^d[3:0];
	xtimes[0] = d[7];
end
endfunction

// multiply 2
function [7:0] MUL2;
input [7:0] d;
begin
	MUL2[7:0] = xtimes(d[7:0]);
end
endfunction

// multiply 2
function [7:0] MUL3;
input [7:0] d;
begin
	MUL3[7:0] = xtimes(d[7:0]) ^ d[7:0];
end
endfunction

// multiply e
function [7:0] MULE;
input [7:0] d;
begin
	MULE[7:0] = xtimes(xtimes(xtimes(d[7:0])))^xtimes(xtimes(d[7:0]))^xtimes(d[7:0]);
end
endfunction

// multiply b
function [7:0] MULB;
input [7:0] d;
begin
	MULB[7:0] = xtimes(xtimes(xtimes(d[7:0])))^xtimes(d[7:0])^d[7:0];
end
endfunction

// multiply D
function [7:0] MULD;
input [7:0] d;
begin
	MULD[7:0] = xtimes(xtimes(xtimes(d[7:0])))^xtimes(xtimes(d[7:0]))^d[7:0];
end
endfunction

// multiply 9
function [7:0] MUL9;
input [7:0] d;
begin
	MUL9[7:0] =  xtimes(xtimes(xtimes(d[7:0])))^d[7:0];
end
endfunction

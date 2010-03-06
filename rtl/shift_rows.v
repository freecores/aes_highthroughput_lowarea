//////////////////////////////////////////////////////////////////////
////                                                              ////
////  shift rows file                                             ////
////                                                              ////
////  Description:                                                ////
////  Include functions for shift rows and inverse shift rows     ////
////                                                              ////
////  To Do:                                                      ////
////   - done                                                     ////
////                                                              ////
////  Author(s):                                                  ////
////      - Luo Dongjun,   dongjun_luo@hotmail.com                ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
// shift rows for encryption
function [127:0] shift_rows;
input [127:0] si;
reg [127:0]so;
begin
	so[127:96] = {si[127:120],si[87:80],si[47:40],si[7:0]};
	so[95:64] = {si[95:88],si[55:48],si[15:8],si[103:96]};
	so[63:32] = {si[63:56],si[23:16],si[111:104],si[71:64]};
	so[31:0] = {si[31:24],si[119:112],si[79:72],si[39:32]};
	shift_rows[127:0] = so[127:0];
end
endfunction

// inverse shift rows for decryption
function [127:0] inv_shift_rows;
input [127:0] si;
reg [127:0] so;
begin
	so[127:96] = {si[127:120],si[23:16],si[47:40],si[71:64]};
	so[95:64] = {si[95:88],si[119:112],si[15:8],si[39:32]};
	so[63:32] = {si[63:56],si[87:80],si[111:104],si[7:0]};
	so[31:0] = {si[31:24],si[55:48],si[79:72],si[103:96]};
	inv_shift_rows[127:0] = so[127:0];
end
endfunction

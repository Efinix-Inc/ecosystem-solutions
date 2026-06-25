////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2021 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   .v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// ***********************************************************************
// Revisions:
// 1.0 Initial rev
//
// ***********************************************************************
module reset_control (
	external_rstn,
	clk,
	rstn	
);

parameter NUM_EXTERNAL_RESETS = 3;
parameter NUM_DOMAINS = 4;
parameter SEQUENTIAL_RELEASE = 1'b1;

input [NUM_EXTERNAL_RESETS-1:0] external_rstn;
input [NUM_DOMAINS-1:0] clk;
output [NUM_DOMAINS-1:0] rstn;

genvar i;

wire [NUM_EXTERNAL_RESETS-1:0] filtered_rstn;
generate
for (i=0; i<NUM_EXTERNAL_RESETS; i=i+1)
begin : lp0
  reset_filter rf_extern (
    .enable(1'b1),
	.rstn_raw(external_rstn[i]),
	.clk(clk[0]),
	.rstn_filtered(filtered_rstn[i]));
end
endgenerate

wire sys_rstn = &filtered_rstn;

reset_filter rf_sys (
    .enable(1'b1),
	.rstn_raw(sys_rstn),
	.clk(clk[0]),
	.rstn_filtered(rstn[0]));

generate 
for (i=1;i<NUM_DOMAINS;i=i+1)
begin : lp1
    reset_filter rf_out (
	    .enable(SEQUENTIAL_RELEASE ? rstn[i-1] : 1'b1),
	    .rstn_raw(sys_rstn),
	    .clk(clk[i]),
	    .rstn_filtered(rstn[i])
	);
end
endgenerate

endmodule
////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2021 Efinix Inc. All rights reserved.              
//
// This   document  contains  proprietary information  which   is        
// protected by  copyright. All rights  are reserved.  This notice       
// refers to original work by Efinix, Inc. which may be derivitive       
// of other work distributed under license of the authors.  In the       
// case of derivative work, nothing in this notice overrides the         
// original author's license agreement.  Where applicable, the           
// original license agreement is included in it's original               
// unmodified form immediately below this header.                        
//
// WARRANTY DISCLAIMER.                                                  
//     THE  DESIGN, CODE, OR INFORMATION ARE PROVIDED “AS IS” AND        
//     EFINIX MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH               
//     RESPECT THERETO, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES,  
//     INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF          
//     MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR    
//     PURPOSE.  SOME STATES DO NOT ALLOW EXCLUSIONS OF AN IMPLIED       
//     WARRANTY, SO THIS DISCLAIMER MAY NOT APPLY TO LICENSEE.           
//
// LIMITATION OF LIABILITY.                                              
//     NOTWITHSTANDING ANYTHING TO THE CONTRARY, EXCEPT FOR BODILY       
//     INJURY, EFINIX SHALL NOT BE LIABLE WITH RESPECT TO ANY SUBJECT    
//     MATTER OF THIS AGREEMENT UNDER TORT, CONTRACT, STRICT LIABILITY   
//     OR ANY OTHER LEGAL OR EQUITABLE THEORY (I) FOR ANY INDIRECT,      
//     SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES OF ANY    
//     CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF      
//     GOODWILL, DATA OR PROFIT, WORK STOPPAGE, OR COMPUTER FAILURE OR   
//     MALFUNCTION, OR IN ANY EVENT (II) FOR ANY AMOUNT IN EXCESS, IN    
//     THE AGGREGATE, OF THE FEE PAID BY LICENSEE TO EFINIX HEREUNDER    
//     (OR, IF THE FEE HAS BEEN WAIVED, $100), EVEN IF EFINIX SHALL HAVE 
//     BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  SOME STATES DO 
//     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR            
//     CONSEQUENTIAL DAMAGES, SO THIS LIMITATION AND EXCLUSION MAY NOT   
//     APPLY TO LICENSEE.
//
////////////////////////////////////////////////////////////////////////////////

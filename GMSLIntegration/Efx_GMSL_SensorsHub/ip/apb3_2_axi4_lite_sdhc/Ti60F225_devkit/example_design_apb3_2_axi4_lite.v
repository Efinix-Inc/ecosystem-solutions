/////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2020 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   example_design_apb3_2_axi4_lite.v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      apb3_2_axi4_lite_sdhc example design
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
// *******************************
// Revisions:
// 1.0 Initial rev
//
// *******************************
`resetall
`timescale 1ns / 1ps
//`include "default_apb3_2_axi4_lite.v"


  module example_design_apb3_2_axi4_lite (
	 //Output board
	 output wire pll_rst_n_o,
	 output wire [3:0] led_tr, // led T20
     output wire [5:0] led_ti, // led Ti60
	 //Input board
	 input 	     clk,
	 input 	     rstn);
   
   `include "apb3_2_axi4_lite_sdhc_define.vh" 
   //Output
   //APB3
   wire               s_apb3_pready;
   wire [31:0] 	      s_apb3_prdata;
   wire 	      s_apb3_pslverror;
   //AXI4-Lite
   wire [ADDR_WTH-1:0] m_axi_awaddr;
   wire 	       m_axi_awvalid;
   wire [31:0] 	       m_axi_wdata;
   wire 	       m_axi_wvalid;
   wire [ADDR_WTH-1:0] m_axi_araddr;
   wire 	       m_axi_arvalid;
   wire 	       m_axi_rready;
   
   //Input
   //APB3
   reg [ADDR_WTH-1:0] s_apb3_paddr=0;
   reg 		      s_apb3_psel=0;
   reg 		      s_apb3_penable=0;
   reg 		      s_apb3_pwrite=0;//0:rd; 1:wr;
   reg [31:0] 	      s_apb3_pwdata=0;
   //AXI4-Lite
   reg 		      m_axi_awready=0;
   reg 		      m_axi_wready=0;
   reg 		      m_axi_arready=0;
   reg [31:0]         m_axi_rdata=0;
   reg 		      m_axi_rvalid=0;

   //Other signals
   //paramater define
   localparam State_idle    = 3'd0;
   localparam State_wsetup  = 3'd1;
   localparam State_write   = 3'd2;
   localparam State_rsetup  = 3'd3;
   localparam State_read    = 3'd4;
   localparam COUNTSYNC     = 25;
 
   reg [5:0] 	      reset_sync;
   wire 	      a_reset; 	      
   reg [COUNTSYNC:0]  count_sync;
   reg [ADDR_WTH-1:0] addr=0;
   reg [31:0] 	      data=0;
   reg [2:0] 	      cur_state;
   reg [2:0] 	      next_state;
   reg 		      led_raddr;
   reg 		      led_rdata;
   reg 		      led_waddr;
   reg 		      led_wdata;
   wire            led_write;
   wire            led_read; 	      
   
   
   
 	      
	      
   

///////////////////
// Module Instantiation
///////////////////
   	      
   apb3_2_axi4_lite_sdhc  dut_apb3_2_axi4_lite (
			 //Global Signals
			 .clk     (clk),
			 .rstn    (~a_reset),
			 //APB3
			 .s_apb3_paddr               (s_apb3_paddr),
			 .s_apb3_psel                (s_apb3_psel),
			 .s_apb3_penable             (s_apb3_penable),
			 .s_apb3_pready              (s_apb3_pready),
			 .s_apb3_pwrite              (s_apb3_pwrite),
			 .s_apb3_pwdata              (s_apb3_pwdata),
			 .s_apb3_prdata              (s_apb3_prdata),
			 .s_apb3_pslverror           (s_apb3_pslverror),
			 //AXI4-Lite
			 .m_axi_awaddr               (m_axi_awaddr),
			 .m_axi_awvalid              (m_axi_awvalid),
			 .m_axi_awready              (m_axi_awready),
			 .m_axi_wdata                (m_axi_wdata),
			 .m_axi_wvalid               (m_axi_wvalid),
			 .m_axi_wready               (m_axi_wready),
			 .m_axi_araddr               (m_axi_araddr),
			 .m_axi_arvalid              (m_axi_arvalid),
			 .m_axi_arready              (m_axi_arready),
			 .m_axi_rdata                (m_axi_rdata),
			 .m_axi_rvalid               (m_axi_rvalid),
			 .m_axi_rready               (m_axi_rready)
			 );

///////////////////
// Test begin
///////////////////


   //assign reset = ~rstn;
   //reset with aleast 6 cycle.
   always @(posedge clk or negedge rstn)
     if (~rstn)
       reset_sync <= 6'b11_1111;
     else
       reset_sync <= {reset_sync[4:0],1'b0};

   assign a_reset = reset_sync[5];
   assign pll_rst_n_o = 1'b1;
   
   assign led_ti[0] = led_waddr&&led_wdata;
   assign led_ti[1] = led_raddr&&led_rdata;
   assign led_ti[2] = 0;
   assign led_ti[3] = ~s_apb3_pwrite;;
   assign led_ti[4] = 0;
   assign led_ti[5] = 0;
   assign led_tr[0] = ~led_waddr&&led_wdata;
   assign led_tr[1] = ~led_raddr&&led_rdata;
   assign led_tr[2] = s_apb3_pwrite;
   assign led_tr[3] = 1;
   

   always @(posedge clk or posedge a_reset)
     if(a_reset) 
       begin
	  cur_state <= State_idle;
       end
     else 
          cur_state <= next_state;

   always @(*)
     begin
	case(cur_state)
	  State_idle :
		 next_state  = State_wsetup;

	  State_wsetup :
	    if((count_sync == {COUNTSYNC+1{1'b0}}))
	      next_state = State_write;
       	    else
	      next_state = State_wsetup;
	  
	  State_write :
	    if(s_apb3_pready == 1)
	      next_state  = State_rsetup;
	    else
	      next_state = State_write;

	  State_rsetup :
	    if((count_sync == {COUNTSYNC+1{1'b0}}))
	      next_state = State_read;
	    else
	      next_state = State_rsetup;
	  
	  State_read :
	    if(s_apb3_pready == 1)
	      next_state  = State_idle;
	    else
	      next_state = State_read;
	  
	  default :
	    next_state = State_idle;
	  
	  endcase
	  
     end 

   always @(posedge clk or posedge a_reset)
     if(a_reset) 
       begin
	  addr <= 0;
	  data <= 0;
	  count_sync <= {COUNTSYNC+1{1'b1}};
	  s_apb3_paddr <= 0;
	  s_apb3_psel <= 0;
	  s_apb3_penable <= 0;
	  s_apb3_pwrite <= 1'b0;
	  s_apb3_pwdata <= 0;
	  m_axi_awready <= 0;
	  m_axi_wready <= 0;
	  m_axi_arready <= 0;
	  m_axi_rdata <= 0;
	  m_axi_rvalid <= 0;
	  led_rdata <= 0;
	  led_raddr <= 0;
	  led_waddr <= 0;
	  led_wdata <= 0;
       end
     else 
       begin
	  if(cur_state == State_idle)
	    begin
	       s_apb3_paddr <= 0;
	       s_apb3_psel <= 0;
	       s_apb3_penable <= 0;
	       s_apb3_pwdata <= 0;
	       m_axi_awready <= 0;
	       m_axi_wready <= 0;
	       m_axi_arready <= 0;
	       m_axi_rdata <= 0;
	       m_axi_rvalid <= 0;
	       addr <= addr + {{ADDR_WTH-1{1'b0}},1'b1};
	       data <= data + 1'b1;
	    end
	  else if(cur_state == State_wsetup)
	    begin
	       s_apb3_paddr <= addr;
	       s_apb3_pwrite <= 1'b1;
	       s_apb3_psel <= 1'b1;
	       s_apb3_penable <= 0; 
	       s_apb3_pwdata <= data;
	       m_axi_arready <= 1'b0;
	       m_axi_rvalid  <= 1'b0;
	       count_sync <= count_sync - 1'b1;
	    end
	  else if(cur_state == State_write)
	    begin
	       led_rdata <= 0;
	       led_raddr <= 0;
	       s_apb3_penable <= 1;  
	       m_axi_awready <= 1'b1;
               m_axi_wready <= 1'b1;
	       if(m_axi_awaddr == s_apb3_paddr)
		 led_waddr <= 1;
	       else
		 led_waddr <= 0;
	       if(m_axi_wdata == s_apb3_pwdata)
		 led_wdata <= 1;
	       else
		 led_wdata <= 0;
	    end // if (cur_state == State_write)
	  
	  else if(cur_state == State_rsetup)
	    begin
	       s_apb3_paddr <= addr;
	       m_axi_rdata <= data;
	       s_apb3_pwrite <= 1'b0;
	       s_apb3_psel <= 1'b1;
	       s_apb3_penable <= 1'b0; 
	       m_axi_arready <= 1'b0;
	       m_axi_rvalid  <= 1'b0;
	       m_axi_awready <= 1'b0;
               m_axi_wready <= 1'b0;
	       count_sync <= count_sync - 1'b1;	       
	    end // if (cur_state == State_rsetup)

	  else if(cur_state == State_read)
	    begin
	       led_waddr <= 0;
	       led_wdata <= 0;
	       s_apb3_penable <= 1;  
	       m_axi_rvalid  <= 1'b1;
	       m_axi_arready <= 1'b1;
	       if(m_axi_araddr == s_apb3_paddr)
		 led_raddr <= 1;
	       else
		 led_raddr <= 0;
	       if(s_apb3_prdata == m_axi_rdata)
		 led_rdata <= 1;
	       else
		 led_rdata <= 0;
       
	    end // if (cur_state == State_read)	 
       end // else: !if(~a_reset)
endmodule 
//////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2019 Efinix Inc. All rights reserved.
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
/////////////////////////////////////////////////////////////////////////////
       

   

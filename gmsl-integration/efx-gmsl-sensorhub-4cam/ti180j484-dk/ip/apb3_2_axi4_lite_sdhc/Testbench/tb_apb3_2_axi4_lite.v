////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2020 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   tb_apb3_2_axi4_lite.v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /    
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
`define FINISHTIME 1000
//`include "default_apb3_2_axi4_lite.v"



module tb_apb3_2_axi4_lite;
   //Parameter
  // parameter ADDR_WTH = `ADDR_WTH;
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
   //Global
   logic rstn;
   logic clk;
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

   //test bench signal
   reg [ADDR_WTH-1:0] addr = 0;
   reg [31:0] 	      data = 0;
   reg [31:0] 	      com_read_data=0;
   reg [31:0] 	      com_write_data=0;
   reg [ADDR_WTH-1:0] com_read_address=0;
   reg [ADDR_WTH-1:0] com_write_address=0;
   integer 	      n=0;
   integer 	      m=0;
   integer        i;

///////////////////
// Module Instantiation
///////////////////

   apb3_2_axi4_lite_sdhc  dut_apb3_2_axi4_lite (
			 //Global Signals
			 .clk     (clk),
			 .rstn    (rstn),
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

   //Try your test here
   initial
     begin
	rstn = 0;
	repeat (2) @(posedge clk);
	rstn = 1;
	
	//random data
	apb3_write($random, $random);
	apb3_read($random, $random);
	//key in data
	apb3_write(10, 500);
	apb3_read(20, 300);
	//Other functions
	//Continous
	continous_write(); //default 8 times
	continous_read(); //default 8 times
	//Wait on write or read
	apb3_write_wait(30, 600);//default wait 5 clock, don more than 125 clocks
	apb3_read_wait(50, 799);//default wait 5 clock, don more than 125 clocks
	//Write then read
	write_and_read(1, 100); //will increment 1 on read
	//Error test
	error_test(2, 300);
	$finish;
     end
   
   
   initial
     begin
	clk = 0;
	forever begin
	   #(10) clk = ~clk;
	end
     end


   initial begin
      forever begin
	 @(posedge clk)
	   begin
	      com_read_data <= m_axi_rdata;
	      com_write_data <= s_apb3_pwdata;
	      com_read_address <= s_apb3_paddr;
	      com_write_address <= s_apb3_paddr;
	   end 
      end // forever begin
   end // initial begin  
   
   //write address
   always @(posedge clk or negedge rstn)
     begin
	@(negedge clk)
	  begin
	     if(m_axi_awvalid == 1)
	       begin
		  if(com_write_address != m_axi_awaddr)
		    $error("\t %t- FAIL! the output write address is no correct", $time);
		  else
		    $display("\t %t- PASS! the output write address is correct", $time);
	       end
	  end
     end

   //write data
   always @(posedge clk or negedge rstn)
     begin
	@(negedge clk)
	  begin
	     if(m_axi_wvalid == 1)
	       begin
		  if(com_write_data != m_axi_wdata)
		    $error("\t %t- FAIL! the output write data is no correct", $time);
		  else
		    $display("\t %t- PASS! the output write data is correct", $time);
	       end
	  end
     end

   //read 
   always @(posedge clk or negedge rstn)
     begin
	@(negedge clk)
	  begin
	     if(m_axi_arvalid == 1)
	       begin
		  if(com_read_address != m_axi_araddr)
		    $error("\t %t- FAIL! the output read address is no correct", $time);
		  else
		    $display("\t %t- PASS! the output read address is correct", $time);
	       end
	  end
     end // always @ (posedge clk or negedge rstn)
   
   always @(posedge clk or negedge rstn)
     begin
	if(m_axi_rvalid == 1)
	  begin
	     @(posedge clk)
	       begin
		  if(com_read_data != s_apb3_prdata)
		    $error("\t %t- FAIL! the output read data is no correct" , $time);
		  else
		    $display("\t %t- PASS! the output read data is correct", $time);
	       end
	  end
     end
   


   always @(posedge clk or negedge rstn)
     begin
	@(negedge clk)
	  begin

		  if((s_apb3_pslverror == 1'b1) && (s_apb3_pready == 1'b1))
		    $display("\t %t- PASS! the signal is correct on State Error", $time);

	  end
     end
   
   /*initial
     begin
	$shm_open("tb_apb3_2_axi4_lite.shm");
	$shm_probe(tb_apb3_2_axi4_lite,"ACMTF");
     end*/
     
     initial begin
      $dumpfile("tb_apb3_2_axi4_lite.vcd");
      $dumpvars(0, tb_apb3_2_axi4_lite);
   end

   
   

   task apb3_write;
      input [ADDR_WTH-1:0] awaddr;
      input [31:0] 	   wdata;
      begin
	 @(posedge clk);
		s_apb3_paddr <= awaddr;
	        s_apb3_pwrite <= 1'b1;
	        s_apb3_psel <= 1'b1;
	        s_apb3_pwdata <= wdata;
	 @(posedge clk);
          	s_apb3_penable <= 1;  
	        m_axi_awready <= 1'b1;
                m_axi_wready <= 1'b1;
	 wait(s_apb3_pready);
	 @(posedge clk);
	        //s_apb3_paddr <= 0;
	        s_apb3_pwrite <= 0;
	        s_apb3_psel <= 0;
	        //s_apb3_pwdata <= 1'b0;
	 	s_apb3_penable <= 0;
	        m_axi_awready <= 1'b0;
                m_axi_wready <= 1'b0;
	 @(posedge clk);
      end
   endtask // wait

   task continous_write;
      begin
	 for (i = 0; i < 8; i++)
	   begin
	      addr = $random;
	      data = $random;
	      apb3_write(addr, data);
	   end // for (integer i = 0; i < 32; i++)
	 
      end
   endtask // for

   task apb3_write_wait;
      input [ADDR_WTH-1:0] awaddr;
      input [31:0] 	   wdata;
      begin
	 @(posedge clk);
		s_apb3_paddr <= awaddr;
	        s_apb3_pwrite <= 1'b1;
	        s_apb3_psel <= 1'b1;
	        s_apb3_pwdata <= wdata;
	 @(posedge clk);
          	s_apb3_penable <= 1;
	 repeat (5) @(posedge clk);
	        m_axi_awready <= 1'b1;
                m_axi_wready <= 1'b1;
	 wait(s_apb3_pready);
	 @(posedge clk);
	        //s_apb3_paddr <= 0;
	        s_apb3_pwrite <= 0;
	        s_apb3_psel <= 0;
	        //s_apb3_pwdata <= 1'b0;
	 	s_apb3_penable <= 0;
	        m_axi_awready <= 1'b0;
                m_axi_wready <= 1'b0;
	 @(posedge clk);
      end
   endtask // wait

   task apb3_read;
      input [ADDR_WTH-1:0] araddr;
      input [31:0] 	   rdata;
      begin
	 @(posedge clk);
		s_apb3_paddr <= araddr;
	        m_axi_rdata <= rdata;
	        s_apb3_pwrite <= 1'b0;
	        s_apb3_psel <= 1'b1;
	        m_axi_arready <= 1'b0;
	        m_axi_rvalid  <= 1'b0;
	@(posedge clk);
          	s_apb3_penable <= 1;
	        m_axi_rvalid  <= 1'b1;
	        m_axi_arready <= 1'b1;
	 wait(s_apb3_pready);
	@(posedge clk);
	        s_apb3_paddr <= 0;
	        s_apb3_pwrite <= 0;
	        s_apb3_psel <= 0;
	 	s_apb3_penable <= 0;
	        m_axi_arready <= 1'b0;
	        m_axi_rdata <= 1'b0;
	        m_axi_rvalid  <= 1'b0;
	@(posedge clk);

      end
   endtask

   task continous_read;
      begin
	 for (i = 0; i < 8; i++)
	   begin
	      addr = $random;
	      data = $random;
	      apb3_read(addr, data);
	   end // for (integer i = 0; i < 32; i++)
      end
   endtask // for

   task apb3_read_wait;
      input [ADDR_WTH-1:0] araddr;
      input [31:0] 	   rdata;
      begin
	 @(posedge clk);
		s_apb3_paddr <= araddr;
	        m_axi_rdata <= rdata;
	        s_apb3_pwrite <= 1'b0;
	        s_apb3_psel <= 1'b1;
	        m_axi_arready <= 1'b0;
	        m_axi_rvalid  <= 1'b0;
	@(posedge clk);
          	s_apb3_penable <= 1;
	 repeat(5) @(posedge clk);
	        m_axi_rvalid  <= 1'b1;
	        m_axi_arready <= 1'b1;
	 wait(s_apb3_pready);
	@(posedge clk);
	        s_apb3_paddr <= 0;
	        s_apb3_pwrite <= 0;
	        s_apb3_psel <= 0;
	 	s_apb3_penable <= 0;
	        m_axi_arready <= 1'b0;
	        m_axi_rdata <= 1'b0;
	        m_axi_rvalid  <= 1'b0;
	@(posedge clk);

      end
   endtask

   task write_and_read;
      input [ADDR_WTH-1:0] addr;
      input [31:0] 	   data;
      begin
	 @(posedge clk);
		s_apb3_paddr <= addr;
	        s_apb3_pwrite <= 1'b1;
	        s_apb3_psel <= 1'b1;
	        s_apb3_pwdata <= data;
	 @(posedge clk);
          	s_apb3_penable <= 1;  
	        m_axi_awready <= 1'b1;
                m_axi_wready <= 1'b1;
	 wait(s_apb3_pready);
	 @(posedge clk);
	 @(posedge clk);
		s_apb3_paddr <= (addr+1);
	        m_axi_rdata <= (data+1);
	        s_apb3_pwrite <= 1'b0;
	        s_apb3_psel <= 1'b1;
	        m_axi_arready <= 1'b0;
	        m_axi_rvalid  <= 1'b0;
	        s_apb3_penable <= 1'b0;
	        m_axi_awready <= 1'b1;
                m_axi_wready <= 1'b1;
	 @(posedge clk);
          	s_apb3_penable <= 1;
	        m_axi_rvalid  <= 1'b1;
	        m_axi_arready <= 1'b1;
	 wait(s_apb3_pready);
	 @(posedge clk);
	        s_apb3_paddr <= 0;
	        s_apb3_pwrite <= 0;
	        s_apb3_psel <= 0;
	 	s_apb3_penable <= 0;
	        m_axi_arready <= 1'b0;
	        m_axi_rdata <= 1'b0;
	        m_axi_rvalid  <= 1'b0;
	@(posedge clk);
      end
   endtask
 
   task error_test;
      input [ADDR_WTH-1:0] addr;
      input [31:0] 	   data;
	 begin
	    @(posedge clk);
	    s_apb3_paddr <= addr;
	    s_apb3_pwrite <= 1'b1;
	    s_apb3_penable <= 0;
	    s_apb3_psel <= 1'b1;
	    s_apb3_pwdata <= data;
	    @(posedge clk);
	    s_apb3_penable <= 0;  
	    m_axi_awready <= 1'b0;
            m_axi_wready <= 1'b0;
	    wait(s_apb3_pready);
	    @(posedge clk);
	 end
   endtask //
   
endmodule

////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2020 Efinix Inc. All rights reserved.              
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

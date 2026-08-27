////////////////////////////////////////////////////////////////////////////
//           _____       
//          / _______    Copyright (C) 2013-2021 Efinix Inc. All rights reserved.
//         / /       \   
//        / /  ..    /   csi_rx_controllers.v
//       / / .'     /    
//    __/ /.'      /     Description:
//   __   \       /      Module for Apb3 registers/Ports Control Block for SOC in TI180M484 OOB development Kit Example Design
//  /_/ /\ \_____/ /     
// ____/  \_______/      
//
/////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

/*
`define APB3_SLV_REG0_OFFSET   0  //constant ID
`define APB3_SLV_REG1_OFFSET   4  //LED control
`define APB3_SLV_REG2_OFFSET   8  //Streaming control
`define APB3_SLV_REG3_OFFSET   12 //RGB Gain Control
`define APB3_SLV_REG4_OFFSET   16 //Debug Register
`define APB3_SLV_REG5_OFFSET   20 //switch Input

`define APB3_SLV_REG6_OFFSET   24 //uvc status
`define APB3_SLV_REG7_OFFSET   28 //uvc control
`define APB3_SLV_REG8_OFFSET   32 //uvc x_start
`define APB3_SLV_REG9_OFFSET   36 //uvc x_end
`define APB3_SLV_REG10_OFFSET  40 //uvc y_start
`define APB3_SLV_REG11_OFFSET  44 //uvc y_end

`define APB3_SLV_REG12_OFFSET  48 //I2C Sel
`define APB3_SLV_REG13_OFFSET  52 //Debayer Sel
*/

`define APB3_SLV_REG_CONSTANT_ID         0
`define APB3_SLV_REG_LED_CONTROL         1
`define APB3_SLV_REG_STREAM_COTNROL      2      //preserved 
`define APB3_SLV_REG_DEBAYER_RGB_GAIN    3
`define APB3_SLV_REG_DEBUG_REG           4
`define APB3_SLV_REG_SWITCH_INPUT        5
`define APB3_SLV_REG_UVC_STATUS          6      //preserved 
`define APB3_SLV_REG_UVC_CONTROL         7      //preserved 
`define APB3_SLV_REG_UVC_X_START         8      //preserved 
`define APB3_SLV_REG_UVC_X_END           9      //preserved 
`define APB3_SLV_REG_UVC_Y_START         10     //preserved 
`define APB3_SLV_REG_UVC_Y_END           11     //preserved
`define APB3_SLV_REG_I2C_SEL             12     //preserved 
`define APB3_SLV_REG_DEBAYER_SEL         13     //preserved

`define APB3_SLV_REG_STREAM_IN           14     
`define APB3_SLV_REG_STREAM_OUT          15     
`define APB3_SLV_REG_HARD_CONFIG         16


`define APB3_SLV_REG_SIZE                `APB3_SLV_REG_HARD_CONFIG +1     

 










module apb3_slave_oob #(
	// user parameter starts here
	//
	parameter	ADDR_WIDTH	= 12,
	parameter	DATA_WIDTH	= 32,
	parameter	NUM_REG		= `APB3_SLV_REG_SIZE
) (
	//apb3 port
	input				clk,
	input				resetn,
	input	[ADDR_WIDTH-1:0]	PADDR,
	input				PSEL,
	input				PENABLE,
	output				PREADY,
	input				PWRITE,
	input 	[DATA_WIDTH-1:0] 	PWDATA,
	output	[DATA_WIDTH-1:0] 	PRDATA,
	output				PSLVERROR,
	
	// user logic starts here
	//Input Ports		
	input 	[31:0]		i_id,					//Bit [31:0]		
	
	//Output Ports
	//Reg 0	LED Control
	output	[5:0]		o_LED,					//Bit [3:0]
	//Reg 1 Streaming control
	output 	[3:0]       o_start_dma_stream_in,	//Bit [0]
	output 	[3:0]	    o_start_dma_stream_out,	//Bit [1]
    output  [1:0]       o_start_vga_gen, 
    output  [0:0]       o_start_minip_tx,	    //Bit [1]
    output  [0:0]       o_start_minip_rx,	    //Bit [1]
    
	output 				o_uvc_resetn,			//Bit [2]

	//Reg 2 RGB Gain Control
	output 	[2:0]		o_red_gain,				//Bit [2:0]
	output 	[2:0]		o_green_gain,			//Bit [6:4]
	output 	[2:0]		o_blue_gain,			//Bit [10:8]
	
	//output				apb3MemoryStart,
	//output				apb3Interrupt,
	output 	[31:0] debug_reg,
	
	input	[5:0]		i_switch,
	input 	[2:0]		i_uvc_status,
	output 	[2:0]		o_uvc_control,
	
	output [12:0]	o_uvc_X_START,
	output [12:0]	o_uvc_X_WIN,
	output [12:0]	o_uvc_Y_START,
	output [12:0]	o_uvc_Y_WIN,
	
	output [1:0]    o_i2c_sel,
    
    output [4:0]    o_debayer_sel,
    input  [31:0]   i_hard_config
	
);


///////////////////////////////////////////////////////////////////////////////

localparam [1:0]	IDLE   = 2'b00,
			SETUP  = 2'b01,
			ACCESS = 2'b10;

reg [1:0] 		busState, 
			busNext;
(* async_reg = "true" *)  reg [DATA_WIDTH-1:0]	slaveReg [0:NUM_REG-1];
reg [DATA_WIDTH-1:0]	slaveRegOut;
reg			slaveReady;
wire	 		actWrite,
			actRead;
integer			byteIndex;


///////////////////////////////////////////////////////////////////////////////

	always@(posedge clk or negedge resetn)
	begin
		if(!resetn) 
			busState <= IDLE; 
		else
			busState <= busNext; 
	end

	always@(*)
	begin
		busNext = busState;

		case(busState)
			IDLE:
			begin
				if(PSEL && !PENABLE)
					busNext = SETUP;
				else
					busNext = IDLE;
			end
			SETUP:
			begin
				if(PSEL && PENABLE)
					busNext = ACCESS;
				else
					busNext = IDLE;
			end
			ACCESS:
			begin
				if(PREADY)
					busNext = IDLE;
				else
					busNext = ACCESS;
			end
			default:
			begin
				busNext = IDLE;
			end
		endcase
	end


	assign actWrite = PWRITE  & (busState == ACCESS);
	assign actRead  = !PWRITE & (busState == ACCESS);
	assign PSLVERROR = 1'b0; //FIXME
	assign PRDATA = slaveRegOut;
	assign PREADY = slaveReady & & (busState !== IDLE);

	always@ (posedge clk)
	begin
		slaveReady <= actWrite | actRead;
	end

	always@ (posedge clk or negedge resetn)
	begin
		if(!resetn)
			for(byteIndex = 0; byteIndex < NUM_REG; byteIndex = byteIndex + 1)
			slaveReg[byteIndex] <= {{DATA_WIDTH}{1'b0}};
		else begin
			for(byteIndex = 0; byteIndex < NUM_REG; byteIndex = byteIndex + 1)
			if(actWrite && (PADDR[ADDR_WIDTH-1:0] == (byteIndex*4)))
				slaveReg[byteIndex] <= PWDATA;
			else
				slaveReg[byteIndex] <= slaveReg[byteIndex];
				
		end

	end

	always@ (posedge clk or negedge resetn)
	begin
		if(!resetn)
			slaveRegOut <= {{DATA_WIDTH}{1'b0}};
		else begin
			if(actRead)
			begin
				case(PADDR[6:2])
				`APB3_SLV_REG_CONSTANT_ID  : slaveRegOut <= i_id;   		//Read Only
				`APB3_SLV_REG_SWITCH_INPUT : slaveRegOut <= {26'd0,i_switch[5:0]};   		
				`APB3_SLV_REG_UVC_STATUS   : slaveRegOut <= {29'd0,i_uvc_status[2:0]};   	
                `APB3_SLV_REG_HARD_CONFIG  : slaveRegOut <= i_hard_config;  //Read Only
				default: 
				begin 
					slaveRegOut <= slaveReg[PADDR[6:2]];
				end
				endcase
			end 
			else
			begin
				slaveRegOut <= slaveRegOut;
			end
		end

	end

	//custom logic starts here
	//assign apb3LED 		= slaveReg[0][0];
	//assign apb3MemoryStart 	= slaveReg[0][1];
	//assign apb3Interrupt 	= slaveReg[0][2];
	
	assign o_LED =                  slaveReg[`APB3_SLV_REG_LED_CONTROL][5:0];
	assign o_uvc_resetn =           slaveReg[`APB3_SLV_REG_STREAM_COTNROL][2];
	
	assign o_red_gain =             slaveReg[`APB3_SLV_REG_DEBAYER_RGB_GAIN][2:0];
	assign o_green_gain =           slaveReg[`APB3_SLV_REG_DEBAYER_RGB_GAIN][6:4];
	assign o_blue_gain  =           slaveReg[`APB3_SLV_REG_DEBAYER_RGB_GAIN][10:8];
	assign debug_reg =              slaveReg[`APB3_SLV_REG_DEBUG_REG][31:0];

	assign o_uvc_control =          slaveReg[`APB3_SLV_REG_UVC_CONTROL][2:0];
	
	assign o_uvc_X_START =          slaveReg[`APB3_SLV_REG_UVC_X_START][12:0];
	assign o_uvc_X_WIN   =          slaveReg[`APB3_SLV_REG_UVC_X_END][12:0];
	assign o_uvc_Y_START =          slaveReg[`APB3_SLV_REG_UVC_Y_START][12:0];
	assign o_uvc_Y_WIN   =          slaveReg[`APB3_SLV_REG_UVC_Y_END][12:0];
	
    assign o_i2c_sel     =          slaveReg[`APB3_SLV_REG_I2C_SEL][1:0];
    
    assign o_debayer_sel =          slaveReg[`APB3_SLV_REG_DEBAYER_SEL][4:0];


	assign o_start_dma_stream_in  = slaveReg[`APB3_SLV_REG_STREAM_IN][3:0];
    assign o_start_minip_rx       = slaveReg[`APB3_SLV_REG_STREAM_IN][4];
	assign o_start_dma_stream_out = slaveReg[`APB3_SLV_REG_STREAM_OUT][3:0];
    assign o_start_vga_gen        = slaveReg[`APB3_SLV_REG_STREAM_OUT][5:4];
    assign o_start_minip_tx       = slaveReg[`APB3_SLV_REG_STREAM_OUT][6];

    
    
endmodule

//////////////////////////////////////////////////////////////////////////////
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
/////////////////////////////////////////////////////////////////////////////

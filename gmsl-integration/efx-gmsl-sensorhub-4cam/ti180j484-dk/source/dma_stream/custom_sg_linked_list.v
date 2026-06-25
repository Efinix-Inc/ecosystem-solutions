module custom_sg_linked_list #(
    parameter   NUM_CHANNEL     = 7,
    parameter   NUM_DESCRIPTIOR = 4,
    parameter   CTRL_WIDTH      = 8,
     
	parameter	APB3_ADDR_WIDTH	= 12,
	parameter	APB3_DATA_WIDTH	= 32,
	parameter	APB3_NUM_REG	= 4*NUM_CHANNEL*NUM_DESCRIPTIOR
    // Offset 0 Control    : 
    // Offset 1 Source Address
    // Offset 2 destination Address    
    // Offset 3 Number of Bytes
) (
    input                 clk,
    input                 reset,
    input                 ctrl_clk,
    input                 ctrl_reset,
    
    input   wire          sg_cmd_valid,
    output  wire          sg_cmd_ready,
    input   wire          sg_cmd_read,
    input   wire          sg_cmd_write,
    input   wire [2:0]    sg_cmd_channelId,
    input   wire [26:0]   sg_cmd_bytesDone,
    input   wire          sg_cmd_endOfPacket,
    input   wire          sg_cmd_completed,
    output  reg           sg_rsp_valid,
    output  reg [2:0]     sg_rsp_channelId,
    output  reg [31:0]    sg_rsp_srcAddress,
    output  reg [31:0]    sg_rsp_dstAddress,
    output  reg [25:0]    sg_rsp_bytes,
    output  reg           sg_rsp_last,
    output  reg           sg_rsp_stallout,

    output  reg [NUM_CHANNEL*CTRL_WIDTH-1:0] sg_out_control,
    input  wire [NUM_CHANNEL*CTRL_WIDTH-1:0] sg_in_control,
    

	//apb3 port
	input	[APB3_ADDR_WIDTH-1:0]	PADDR,
	input	PSEL,
	input	PENABLE,
	output	PREADY,
	input	PWRITE,
	input 	[APB3_DATA_WIDTH-1:0] 	PWDATA,
	output	[APB3_DATA_WIDTH-1:0] 	PRDATA,
	output  PSLVERROR
    
    
    
    
		
);

  
/////////////////////////////////////////////////////////////////////////////

  reg        [15:0]   srcLine;
  reg        [31:0]   srcPtr;
  wire                srcIsLast;
  wire                srcIsStall;

  reg        [15:0]   dstLine;
  reg        [31:0]   dstPtr;
  wire                dstIsLast;
  wire                dstIsStall;
/////////////////////////////////////////////////////////////////////////////

assign sg_cmd_ready  = 1'b1;    
    
wire  [APB3_DATA_WIDTH*APB3_NUM_REG-1:0]    w_descriptor_regs;    
reg   [7:0]   r_descriptor_ptr  [NUM_CHANNEL-1:0]; 

wire  [APB3_DATA_WIDTH-1:0]    w_descriptor_ctrl_word;  
wire  [APB3_DATA_WIDTH-1:0]    w_descriptor_src_addr;  
wire  [APB3_DATA_WIDTH-1:0]    w_descriptor_dst_addr;  
wire  [APB3_DATA_WIDTH-1:0]    w_descriptor_nBytes;  
 

wire  [CTRL_WIDTH-1:0]  w_descriptor_sel;
 
    
apb3_dma_sg_slave_oob #(
	// user parameter starts here
	//
	.ADDR_WIDTH	(APB3_ADDR_WIDTH	),
	.DATA_WIDTH	(APB3_DATA_WIDTH	),
	.NUM_REG	(APB3_NUM_REG	    )   //
) inst_apb3 (
	//apb3 port
	.clk      (ctrl_clk),
	.resetn   (~ctrl_reset),
	.PADDR    (PADDR    ),
	.PSEL     (PSEL     ),
	.PENABLE  (PENABLE  ),
	.PREADY   (PREADY   ),
	.PWRITE   (PWRITE   ),
	.PWDATA   (PWDATA   ),
	.PRDATA   (PRDATA   ),
	.PSLVERROR(PSLVERROR),
    .reg_out  (w_descriptor_regs)

	
);

wire [31:0] w_regs_debug_0;
wire [31:0] w_regs_debug_1;
wire [31:0] w_regs_debug_2;
wire [31:0] w_regs_debug_3;
wire [31:0] w_regs_debug_4;
wire [31:0] w_regs_debug_5;
wire [31:0] w_regs_debug_6;
wire [31:0] w_regs_debug_7;
wire [31:0] w_regs_debug_8;
wire [31:0] w_regs_debug_9;
wire [31:0] w_regs_debug_a;
wire [31:0] w_regs_debug_b;
wire [31:0] w_regs_debug_c;
wire [31:0] w_regs_debug_d;
wire [31:0] w_regs_debug_e;
wire [31:0] w_regs_debug_f;

assign w_regs_debug_0 = w_descriptor_regs[ (0 +0)*32 +: 32];
assign w_regs_debug_1 = w_descriptor_regs[ (0 +1)*32 +: 32];
assign w_regs_debug_2 = w_descriptor_regs[ (0 +2)*32 +: 32];
assign w_regs_debug_3 = w_descriptor_regs[ (0 +3)*32 +: 32];
assign w_regs_debug_4 = w_descriptor_regs[ (0 +4)*32 +: 32];
assign w_regs_debug_5 = w_descriptor_regs[ (0 +5)*32 +: 32];
assign w_regs_debug_6 = w_descriptor_regs[ (0 +6)*32 +: 32];
assign w_regs_debug_7 = w_descriptor_regs[ (0 +7)*32 +: 32];

assign w_regs_debug_8 = w_descriptor_regs[ (0 +8)*32 +: 32];
assign w_regs_debug_9 = w_descriptor_regs[ (0 +9)*32 +: 32];
assign w_regs_debug_a = w_descriptor_regs[ (0 +10)*32 +: 32];
assign w_regs_debug_b = w_descriptor_regs[ (0 +11)*32 +: 32];
assign w_regs_debug_c = w_descriptor_regs[ (0 +12)*32 +: 32];
assign w_regs_debug_d = w_descriptor_regs[ (0 +13)*32 +: 32];
assign w_regs_debug_e = w_descriptor_regs[ (0 +14)*32 +: 32];
assign w_regs_debug_f = w_descriptor_regs[ (0 +15)*32 +: 32];

reg [NUM_CHANNEL*CTRL_WIDTH-1:0] r_sg_in_control;

assign w_descriptor_sel = r_sg_in_control[sg_cmd_channelId*CTRL_WIDTH +: CTRL_WIDTH];
 
always@(posedge clk or posedge reset)
begin
    if (reset)
    begin 
        
        r_sg_in_control <= 'd0;
    end 
    else 
    begin 
        r_sg_in_control <= sg_in_control;
    end 
end     


wire [ CTRL_WIDTH-1:0] w_in_ch0;
wire [ CTRL_WIDTH-1:0] w_in_ch1;
wire [ CTRL_WIDTH-1:0] w_in_ch2;
wire [ CTRL_WIDTH-1:0] w_in_ch3;
wire [ CTRL_WIDTH-1:0] w_in_ch4;
wire [ CTRL_WIDTH-1:0] w_in_ch5;
wire [ CTRL_WIDTH-1:0] w_in_ch6;

wire [ CTRL_WIDTH-1:0] w_out_ch0;
wire [ CTRL_WIDTH-1:0] w_out_ch1;
wire [ CTRL_WIDTH-1:0] w_out_ch2;
wire [ CTRL_WIDTH-1:0] w_out_ch3;
wire [ CTRL_WIDTH-1:0] w_out_ch4;
wire [ CTRL_WIDTH-1:0] w_out_ch5;
wire [ CTRL_WIDTH-1:0] w_out_ch6;
   
assign w_in_ch0 = r_sg_in_control[ 0*CTRL_WIDTH +: CTRL_WIDTH];
assign w_in_ch1 = r_sg_in_control[ 1*CTRL_WIDTH +: CTRL_WIDTH];
assign w_in_ch2 = r_sg_in_control[ 2*CTRL_WIDTH +: CTRL_WIDTH];
assign w_in_ch3 = r_sg_in_control[ 3*CTRL_WIDTH +: CTRL_WIDTH];
assign w_in_ch4 = r_sg_in_control[ 4*CTRL_WIDTH +: CTRL_WIDTH];
assign w_in_ch5 = r_sg_in_control[ 5*CTRL_WIDTH +: CTRL_WIDTH];
assign w_in_ch6 = r_sg_in_control[ 6*CTRL_WIDTH +: CTRL_WIDTH];

assign w_out_ch0 = sg_out_control[ 0*CTRL_WIDTH +: CTRL_WIDTH];
assign w_out_ch1 = sg_out_control[ 1*CTRL_WIDTH +: CTRL_WIDTH];
assign w_out_ch2 = sg_out_control[ 2*CTRL_WIDTH +: CTRL_WIDTH];
assign w_out_ch3 = sg_out_control[ 3*CTRL_WIDTH +: CTRL_WIDTH];
assign w_out_ch4 = sg_out_control[ 4*CTRL_WIDTH +: CTRL_WIDTH];
assign w_out_ch5 = sg_out_control[ 5*CTRL_WIDTH +: CTRL_WIDTH];
assign w_out_ch6 = sg_out_control[ 6*CTRL_WIDTH +: CTRL_WIDTH];

reg [20:0] r_cmd_count;

//assign w_descriptor_ctrl_word = w_descriptor_regs[(sg_cmd_channelId*NUM_DESCRIPTIOR*4*APB3_DATA_WIDTH + r_descriptor_ptr[sg_cmd_channelId]*4*APB3_DATA_WIDTH + 0*APB3_DATA_WIDTH ) +: APB3_DATA_WIDTH  ]; 
//assign w_descriptor_src_addr  = w_descriptor_regs[(sg_cmd_channelId*NUM_DESCRIPTIOR*4*APB3_DATA_WIDTH + r_descriptor_ptr[sg_cmd_channelId]*4*APB3_DATA_WIDTH + 1*APB3_DATA_WIDTH ) +: APB3_DATA_WIDTH  ];  
//assign w_descriptor_dst_addr  = w_descriptor_regs[(sg_cmd_channelId*NUM_DESCRIPTIOR*4*APB3_DATA_WIDTH + r_descriptor_ptr[sg_cmd_channelId]*4*APB3_DATA_WIDTH + 2*APB3_DATA_WIDTH ) +: APB3_DATA_WIDTH  ]; 
//assign w_descriptor_nBytes    = w_descriptor_regs[(sg_cmd_channelId*NUM_DESCRIPTIOR*4*APB3_DATA_WIDTH + r_descriptor_ptr[sg_cmd_channelId]*4*APB3_DATA_WIDTH + 3*APB3_DATA_WIDTH ) +: APB3_DATA_WIDTH  ];     


assign w_descriptor_ctrl_word = w_descriptor_regs[(sg_cmd_channelId*NUM_DESCRIPTIOR*4*APB3_DATA_WIDTH + w_descriptor_sel*4*APB3_DATA_WIDTH + 0*APB3_DATA_WIDTH ) +: APB3_DATA_WIDTH  ]; 
assign w_descriptor_src_addr  = w_descriptor_regs[(sg_cmd_channelId*NUM_DESCRIPTIOR*4*APB3_DATA_WIDTH + w_descriptor_sel*4*APB3_DATA_WIDTH + 1*APB3_DATA_WIDTH ) +: APB3_DATA_WIDTH  ];  
assign w_descriptor_dst_addr  = w_descriptor_regs[(sg_cmd_channelId*NUM_DESCRIPTIOR*4*APB3_DATA_WIDTH + w_descriptor_sel*4*APB3_DATA_WIDTH + 2*APB3_DATA_WIDTH ) +: APB3_DATA_WIDTH  ]; 
assign w_descriptor_nBytes    = w_descriptor_regs[(sg_cmd_channelId*NUM_DESCRIPTIOR*4*APB3_DATA_WIDTH + w_descriptor_sel*4*APB3_DATA_WIDTH + 3*APB3_DATA_WIDTH ) +: APB3_DATA_WIDTH  ];     

    
    always@(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            sg_rsp_valid       <= 1'b0;
            sg_rsp_channelId   <= 3'b00;
            sg_rsp_srcAddress  <= 0;
            sg_rsp_dstAddress  <= 0;
            sg_rsp_bytes       <= 0;
            sg_rsp_last        <= 0;
            sg_rsp_stallout    <= 0;                      
           
            r_cmd_count        <= 'd0; 
        end
        else 
        begin
          
          if( (sg_cmd_valid) && (sg_cmd_channelId < NUM_CHANNEL) )
          begin
              sg_rsp_valid       <= 1'b1;
              sg_rsp_channelId   <= sg_cmd_channelId;
              sg_rsp_srcAddress  <= w_descriptor_src_addr;
              sg_rsp_dstAddress  <= w_descriptor_dst_addr;
              sg_rsp_bytes       <= w_descriptor_nBytes;
              sg_rsp_last        <= w_descriptor_ctrl_word[2];
              sg_rsp_stallout    <= w_descriptor_ctrl_word[3];  
              sg_out_control[sg_cmd_channelId*CTRL_WIDTH +: CTRL_WIDTH]      <= sg_in_control[sg_cmd_channelId*CTRL_WIDTH +: CTRL_WIDTH];
              r_cmd_count       <= r_cmd_count +'d1;
              
              
              if (w_descriptor_ctrl_word[0]) 
              begin 
                    r_descriptor_ptr[sg_cmd_channelId] <= 'd0;
                
              end
              else if (w_descriptor_ctrl_word[1])
              begin
                    if (r_descriptor_ptr[sg_cmd_channelId] ==  NUM_DESCRIPTIOR-1)
                    begin
                        r_descriptor_ptr[sg_cmd_channelId] <= 'd0;
                    end 
                    else 
                    begin
                        r_descriptor_ptr[sg_cmd_channelId] <= r_descriptor_ptr[sg_cmd_channelId] +1'b1;
                    end 
              end  
              
              
              
          end 
          else
          begin
              sg_rsp_valid       <= 1'b0;
              sg_rsp_channelId   <= 3'b00;
              sg_rsp_srcAddress  <= 0;
              sg_rsp_dstAddress  <= 0;
              sg_rsp_bytes       <= 0;
              sg_rsp_last        <= 0;
              sg_rsp_stallout    <= 0;           
          end   
          
        end
    end 

  

endmodule







module apb3_dma_sg_slave_oob #(
	// user parameter starts here
	//
	parameter	ADDR_WIDTH	= 12,
	parameter	DATA_WIDTH	= 32,
	parameter	NUM_REG		= 4
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
	
    output  [DATA_WIDTH*NUM_REG-1:0]    reg_out

	
);


///////////////////////////////////////////////////////////////////////////////

localparam [1:0]	IDLE   = 2'b00,
			SETUP  = 2'b01,
			ACCESS = 2'b10;

reg [1:0] 		busState, 
			busNext;
(* async_reg = "true" *)  reg [NUM_REG*DATA_WIDTH-1:0]	slaveReg;
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
    
    reg [NUM_REG-1:0] r_debug_write;

	always@ (posedge clk)
	begin
		slaveReady <= actWrite | actRead;
	end

	always@ (posedge clk or negedge resetn)
	begin
		if(!resetn)
        begin
           r_debug_write <= 'd0; 
            
			for(byteIndex = 0; byteIndex < NUM_REG; byteIndex = byteIndex + 1)
                slaveReg[byteIndex*DATA_WIDTH +: DATA_WIDTH] <= {{DATA_WIDTH}{1'b0}};

        end 
        else begin
        
			for(byteIndex = 0; byteIndex < NUM_REG; byteIndex = byteIndex + 1)
			if(actWrite && (PADDR[ADDR_WIDTH-1:0] == (byteIndex*4)))
            begin
				slaveReg[byteIndex*DATA_WIDTH +: DATA_WIDTH] <= PWDATA;
                r_debug_write[byteIndex] <= 1'b1;
            end 
			else
            begin
				slaveReg[byteIndex*DATA_WIDTH +: DATA_WIDTH] <= slaveReg[byteIndex*DATA_WIDTH +: DATA_WIDTH];
                r_debug_write[byteIndex] <= 1'b0;
            end 
		end

	end

    assign reg_out = slaveReg;
	
    
endmodule

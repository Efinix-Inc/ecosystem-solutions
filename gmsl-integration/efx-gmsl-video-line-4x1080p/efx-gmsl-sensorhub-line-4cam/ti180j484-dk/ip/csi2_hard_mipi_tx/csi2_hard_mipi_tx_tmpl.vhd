--------------------------------------------------------------------------------
-- Copyright (C) 2013-2025 Efinix Inc. All rights reserved.              
--
-- This   document  contains  proprietary information  which   is        
-- protected by  copyright. All rights  are reserved.  This notice       
-- refers to original work by Efinix, Inc. which may be derivitive       
-- of other work distributed under license of the authors.  In the       
-- case of derivative work, nothing in this notice overrides the         
-- original author's license agreement.  Where applicable, the           
-- original license agreement is included in it's original               
-- unmodified form immediately below this header.                        
--                                                                       
-- WARRANTY DISCLAIMER.                                                  
--     THE  DESIGN, CODE, OR INFORMATION ARE PROVIDED “AS IS” AND        
--     EFINIX MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH               
--     RESPECT THERETO, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES,  
--     INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF          
--     MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR    
--     PURPOSE.  SOME STATES DO NOT ALLOW EXCLUSIONS OF AN IMPLIED       
--     WARRANTY, SO THIS DISCLAIMER MAY NOT APPLY TO LICENSEE.           
--                                                                       
-- LIMITATION OF LIABILITY.                                              
--     NOTWITHSTANDING ANYTHING TO THE CONTRARY, EXCEPT FOR BODILY       
--     INJURY, EFINIX SHALL NOT BE LIABLE WITH RESPECT TO ANY SUBJECT    
--     MATTER OF THIS AGREEMENT UNDER TORT, CONTRACT, STRICT LIABILITY   
--     OR ANY OTHER LEGAL OR EQUITABLE THEORY (I) FOR ANY INDIRECT,      
--     SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES OF ANY    
--     CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF      
--     GOODWILL, DATA OR PROFIT, WORK STOPPAGE, OR COMPUTER FAILURE OR   
--     MALFUNCTION, OR IN ANY EVENT (II) FOR ANY AMOUNT IN EXCESS, IN    
--     THE AGGREGATE, OF THE FEE PAID BY LICENSEE TO EFINIX HEREUNDER    
--     (OR, IF THE FEE HAS BEEN WAIVED, $100), EVEN IF EFINIX SHALL HAVE 
--     BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  SOME STATES DO 
--     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR            
--     CONSEQUENTIAL DAMAGES, SO THIS LIMITATION AND EXCLUSION MAY NOT   
--     APPLY TO LICENSEE.                                                
--
--------------------------------------------------------------------------------
------------- Begin Cut here for COMPONENT Declaration ------
component csi2_hard_mipi_tx is
port (
    reset_byte_HS_n : in std_logic;
    clk_byte_HS : in std_logic;
    reset_pixel_n : in std_logic;
    clk_pixel : in std_logic;
    vsync_vc5 : in std_logic;
    vsync_vc0 : in std_logic;
    irq : out std_logic;
    pixel_data_valid : in std_logic;
    frame_num : in std_logic_vector(15 downto 0);
    hsync_vc3 : in std_logic;
    hsync_vc9 : in std_logic;
    hsync_vc11 : in std_logic;
    hsync_vc2 : in std_logic;
    hsync_vc1 : in std_logic;
    hsync_vc7 : in std_logic;
    vsync_vc3 : in std_logic;
    vsync_vc2 : in std_logic;
    vsync_vc1 : in std_logic;
    vsync_vc12 : in std_logic;
    vsync_vc13 : in std_logic;
    vsync_vc14 : in std_logic;
    vsync_vc9 : in std_logic;
    vsync_vc15 : in std_logic;
    vsync_vc10 : in std_logic;
    vsync_vc11 : in std_logic;
    vsync_vc8 : in std_logic;
    vsync_vc4 : in std_logic;
    hsync_vc6 : in std_logic;
    hsync_vc5 : in std_logic;
    hsync_vc13 : in std_logic;
    hsync_vc10 : in std_logic;
    hsync_vc0 : in std_logic;
    line_num : in std_logic_vector(15 downto 0);
    haddr : in std_logic_vector(15 downto 0);
    pixel_data : in std_logic_vector(63 downto 0);
    datatype : in std_logic_vector(5 downto 0);
    hsync_vc12 : in std_logic;
    hsync_vc15 : in std_logic;
    hsync_vc14 : in std_logic;
    hsync_vc4 : in std_logic;
    axi_rready : in std_logic;
    axi_rvalid : out std_logic;
    axi_rdata : out std_logic_vector(31 downto 0);
    axi_arready : out std_logic;
    axi_arvalid : in std_logic;
    axi_araddr : in std_logic_vector(5 downto 0);
    axi_bready : in std_logic;
    axi_bvalid : out std_logic;
    axi_wready : out std_logic;
    axi_wvalid : in std_logic;
    axi_wdata : in std_logic_vector(31 downto 0);
    vsync_vc7 : in std_logic;
    hsync_vc8 : in std_logic;
    axi_awready : out std_logic;
    axi_clk : in std_logic;
    axi_reset_n : in std_logic;
    axi_awaddr : in std_logic_vector(5 downto 0);
    axi_awvalid : in std_logic;
    reset_esc_n : in std_logic;
    clk_esc : in std_logic;
    TxUlpsClk : out std_logic;
    TxUlpsExitClk : out std_logic;
    TxUlpsActiveClkNot : in std_logic;
    TxUlpsEsc : out std_logic_vector(3 downto 0);
    TxSkewCalHS : out std_logic_vector(3 downto 0);
    TxUlpsExit : out std_logic_vector(3 downto 0);
    TxRequestEsc : out std_logic_vector(3 downto 0);
    TxStopStateD : in std_logic_vector(3 downto 0);
    TxStopStateC : in std_logic;
    TxUlpsActiveNot : in std_logic_vector(3 downto 0);
    TxReadyHS : in std_logic_vector(3 downto 0);
    TxRequestHS : out std_logic_vector(3 downto 0);
    TxRequestHSc : out std_logic;
    TxDataHS0 : out std_logic_vector(15 downto 0);
    TxDataHS1 : out std_logic_vector(15 downto 0);
    TxDataHS2 : out std_logic_vector(15 downto 0);
    TxDataHS3 : out std_logic_vector(15 downto 0);
    TxDataHS4 : out std_logic_vector(15 downto 0);
    TxDataHS5 : out std_logic_vector(15 downto 0);
    TxDataHS6 : out std_logic_vector(15 downto 0);
    TxDataHS7 : out std_logic_vector(15 downto 0);
    TxReqValidHS0 : out std_logic_vector(1 downto 0);
    TxReqValidHS1 : out std_logic_vector(1 downto 0);
    TxReqValidHS2 : out std_logic_vector(1 downto 0);
    TxReqValidHS3 : out std_logic_vector(1 downto 0);
    TxReqValidHS4 : out std_logic_vector(1 downto 0);
    TxReqValidHS5 : out std_logic_vector(1 downto 0);
    TxReqValidHS6 : out std_logic_vector(1 downto 0);
    TxReqValidHS7 : out std_logic_vector(1 downto 0);
    vsync_vc6 : in std_logic;
    mipi_debug_in : in std_logic_vector(31 downto 0);
    mipi_debug_out : out std_logic_vector(31 downto 0)
);
end component csi2_hard_mipi_tx;

---------------------- End COMPONENT Declaration ------------
------------- Begin Cut here for INSTANTIATION Template -----
u_csi2_hard_mipi_tx : csi2_hard_mipi_tx
port map (
    reset_byte_HS_n => reset_byte_HS_n,
    clk_byte_HS => clk_byte_HS,
    reset_pixel_n => reset_pixel_n,
    clk_pixel => clk_pixel,
    vsync_vc5 => vsync_vc5,
    vsync_vc0 => vsync_vc0,
    irq => irq,
    pixel_data_valid => pixel_data_valid,
    frame_num => frame_num,
    hsync_vc3 => hsync_vc3,
    hsync_vc9 => hsync_vc9,
    hsync_vc11 => hsync_vc11,
    hsync_vc2 => hsync_vc2,
    hsync_vc1 => hsync_vc1,
    hsync_vc7 => hsync_vc7,
    vsync_vc3 => vsync_vc3,
    vsync_vc2 => vsync_vc2,
    vsync_vc1 => vsync_vc1,
    vsync_vc12 => vsync_vc12,
    vsync_vc13 => vsync_vc13,
    vsync_vc14 => vsync_vc14,
    vsync_vc9 => vsync_vc9,
    vsync_vc15 => vsync_vc15,
    vsync_vc10 => vsync_vc10,
    vsync_vc11 => vsync_vc11,
    vsync_vc8 => vsync_vc8,
    vsync_vc4 => vsync_vc4,
    hsync_vc6 => hsync_vc6,
    hsync_vc5 => hsync_vc5,
    hsync_vc13 => hsync_vc13,
    hsync_vc10 => hsync_vc10,
    hsync_vc0 => hsync_vc0,
    line_num => line_num,
    haddr => haddr,
    pixel_data => pixel_data,
    datatype => datatype,
    hsync_vc12 => hsync_vc12,
    hsync_vc15 => hsync_vc15,
    hsync_vc14 => hsync_vc14,
    hsync_vc4 => hsync_vc4,
    axi_rready => axi_rready,
    axi_rvalid => axi_rvalid,
    axi_rdata => axi_rdata,
    axi_arready => axi_arready,
    axi_arvalid => axi_arvalid,
    axi_araddr => axi_araddr,
    axi_bready => axi_bready,
    axi_bvalid => axi_bvalid,
    axi_wready => axi_wready,
    axi_wvalid => axi_wvalid,
    axi_wdata => axi_wdata,
    vsync_vc7 => vsync_vc7,
    hsync_vc8 => hsync_vc8,
    axi_awready => axi_awready,
    axi_clk => axi_clk,
    axi_reset_n => axi_reset_n,
    axi_awaddr => axi_awaddr,
    axi_awvalid => axi_awvalid,
    reset_esc_n => reset_esc_n,
    clk_esc => clk_esc,
    TxUlpsClk => TxUlpsClk,
    TxUlpsExitClk => TxUlpsExitClk,
    TxUlpsActiveClkNot => TxUlpsActiveClkNot,
    TxUlpsEsc => TxUlpsEsc,
    TxSkewCalHS => TxSkewCalHS,
    TxUlpsExit => TxUlpsExit,
    TxRequestEsc => TxRequestEsc,
    TxStopStateD => TxStopStateD,
    TxStopStateC => TxStopStateC,
    TxUlpsActiveNot => TxUlpsActiveNot,
    TxReadyHS => TxReadyHS,
    TxRequestHS => TxRequestHS,
    TxRequestHSc => TxRequestHSc,
    TxDataHS0 => TxDataHS0,
    TxDataHS1 => TxDataHS1,
    TxDataHS2 => TxDataHS2,
    TxDataHS3 => TxDataHS3,
    TxDataHS4 => TxDataHS4,
    TxDataHS5 => TxDataHS5,
    TxDataHS6 => TxDataHS6,
    TxDataHS7 => TxDataHS7,
    TxReqValidHS0 => TxReqValidHS0,
    TxReqValidHS1 => TxReqValidHS1,
    TxReqValidHS2 => TxReqValidHS2,
    TxReqValidHS3 => TxReqValidHS3,
    TxReqValidHS4 => TxReqValidHS4,
    TxReqValidHS5 => TxReqValidHS5,
    TxReqValidHS6 => TxReqValidHS6,
    TxReqValidHS7 => TxReqValidHS7,
    vsync_vc6 => vsync_vc6,
    mipi_debug_in => mipi_debug_in,
    mipi_debug_out => mipi_debug_out
);

------------------------ End INSTANTIATION Template ---------

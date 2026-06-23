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
component xgmac is
port (
    mac_reset_n : in std_logic;
    mac10gbe_clk : in std_logic;
    init_clk : in std_logic;
    init_rst_n : in std_logic;
    PMA_CMN_READY : in std_logic;
    PMA_XCVR_PLLCLK_EN_ACK : in std_logic;
    PMA_XCVR_POWER_STATE_ACK : in std_logic_vector(3 downto 0);
    PMA_RX_SIGNAL_DETECT : in std_logic;
    PMA_XCVR_PLLCLK_EN : out std_logic;
    PMA_XCVR_POWER_STATE_REQ : out std_logic_vector(3 downto 0);
    phy_init_done : out std_logic;
    tx_axis_mac_tdata : in std_logic_vector(63 downto 0);
    tx_axis_mac_tvalid : in std_logic;
    tx_axis_mac_tlast : in std_logic;
    tx_axis_mac_tkeep : in std_logic_vector(7 downto 0);
    tx_axis_mac_tuser : in std_logic;
    tx_axis_mac_tready : out std_logic;
    rx_axis_mac_tdata : out std_logic_vector(63 downto 0);
    rx_axis_mac_tvalid : out std_logic;
    rx_axis_mac_tlast : out std_logic;
    rx_axis_mac_tkeep : out std_logic_vector(7 downto 0);
    rx_axis_mac_tuser : out std_logic;
    rx_pause_ignore : in std_logic;
    tx_pause_gen : in std_logic;
    tx_pause_busy : out std_logic;
    tx_pause_quant : in std_logic_vector(15 downto 0);
    rx_address_filtering_mask : in std_logic_vector(47 downto 0);
    cnt_rst_n : in std_logic;
    cnt_tx_frame_transmitted_good : out std_logic_vector(31 downto 0);
    cnt_tx_frame_pause_mac_ctrl : out std_logic_vector(31 downto 0);
    cnt_tx_frame_error_txfifo_overflow : out std_logic_vector(31 downto 0);
    cnt_tx_frame_is_fe : out std_logic_vector(31 downto 0);
    cnt_rx_frame_received_good : out std_logic_vector(31 downto 0);
    cnt_rx_frame_error_fcs : out std_logic_vector(31 downto 0);
    cnt_rx_frame_pause_mac_ctrl : out std_logic_vector(31 downto 0);
    cnt_rx_frame_errors : out std_logic_vector(31 downto 0);
    cnt_rx_frame_received_total : out std_logic_vector(31 downto 0);
    cnt_rx_frame_undersized : out std_logic_vector(31 downto 0);
    cnt_rx_frame_oversized : out std_logic_vector(31 downto 0);
    cnt_rx_frame_mismatched_length : out std_logic_vector(31 downto 0);
    cnt_rx_frame_filtered_by_address : out std_logic_vector(31 downto 0);
    XGMII_TXD : out std_logic_vector(63 downto 0);
    XGMII_TXC : out std_logic_vector(7 downto 0);
    XGMII_RXD : in std_logic_vector(63 downto 0);
    XGMII_RXC : in std_logic_vector(7 downto 0);
    rpt_rx_frame_length : out std_logic_vector(13 downto 0)
);
end component xgmac;

---------------------- End COMPONENT Declaration ------------
------------- Begin Cut here for INSTANTIATION Template -----
u_xgmac : xgmac
port map (
    mac_reset_n => mac_reset_n,
    mac10gbe_clk => mac10gbe_clk,
    init_clk => init_clk,
    init_rst_n => init_rst_n,
    PMA_CMN_READY => PMA_CMN_READY,
    PMA_XCVR_PLLCLK_EN_ACK => PMA_XCVR_PLLCLK_EN_ACK,
    PMA_XCVR_POWER_STATE_ACK => PMA_XCVR_POWER_STATE_ACK,
    PMA_RX_SIGNAL_DETECT => PMA_RX_SIGNAL_DETECT,
    PMA_XCVR_PLLCLK_EN => PMA_XCVR_PLLCLK_EN,
    PMA_XCVR_POWER_STATE_REQ => PMA_XCVR_POWER_STATE_REQ,
    phy_init_done => phy_init_done,
    tx_axis_mac_tdata => tx_axis_mac_tdata,
    tx_axis_mac_tvalid => tx_axis_mac_tvalid,
    tx_axis_mac_tlast => tx_axis_mac_tlast,
    tx_axis_mac_tkeep => tx_axis_mac_tkeep,
    tx_axis_mac_tuser => tx_axis_mac_tuser,
    tx_axis_mac_tready => tx_axis_mac_tready,
    rx_axis_mac_tdata => rx_axis_mac_tdata,
    rx_axis_mac_tvalid => rx_axis_mac_tvalid,
    rx_axis_mac_tlast => rx_axis_mac_tlast,
    rx_axis_mac_tkeep => rx_axis_mac_tkeep,
    rx_axis_mac_tuser => rx_axis_mac_tuser,
    rx_pause_ignore => rx_pause_ignore,
    tx_pause_gen => tx_pause_gen,
    tx_pause_busy => tx_pause_busy,
    tx_pause_quant => tx_pause_quant,
    rx_address_filtering_mask => rx_address_filtering_mask,
    cnt_rst_n => cnt_rst_n,
    cnt_tx_frame_transmitted_good => cnt_tx_frame_transmitted_good,
    cnt_tx_frame_pause_mac_ctrl => cnt_tx_frame_pause_mac_ctrl,
    cnt_tx_frame_error_txfifo_overflow => cnt_tx_frame_error_txfifo_overflow,
    cnt_tx_frame_is_fe => cnt_tx_frame_is_fe,
    cnt_rx_frame_received_good => cnt_rx_frame_received_good,
    cnt_rx_frame_error_fcs => cnt_rx_frame_error_fcs,
    cnt_rx_frame_pause_mac_ctrl => cnt_rx_frame_pause_mac_ctrl,
    cnt_rx_frame_errors => cnt_rx_frame_errors,
    cnt_rx_frame_received_total => cnt_rx_frame_received_total,
    cnt_rx_frame_undersized => cnt_rx_frame_undersized,
    cnt_rx_frame_oversized => cnt_rx_frame_oversized,
    cnt_rx_frame_mismatched_length => cnt_rx_frame_mismatched_length,
    cnt_rx_frame_filtered_by_address => cnt_rx_frame_filtered_by_address,
    XGMII_TXD => XGMII_TXD,
    XGMII_TXC => XGMII_TXC,
    XGMII_RXD => XGMII_RXD,
    XGMII_RXC => XGMII_RXC,
    rpt_rx_frame_length => rpt_rx_frame_length
);

------------------------ End INSTANTIATION Template ---------

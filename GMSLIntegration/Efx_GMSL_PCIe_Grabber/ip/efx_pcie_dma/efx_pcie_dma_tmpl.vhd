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
component efx_pcie_dma is
port (
    axi_clk : in std_logic;
    dma_rstn : in std_logic;
    apb_clk : in std_logic;
    m_apb_pcie_pready : in std_logic;
    m_apb_pcie_psel : out std_logic;
    m_apb_pcie_pwrite : out std_logic;
    m_apb_pcie_penable : out std_logic;
    m_apb_pcie_paddr : out std_logic_vector(23 downto 0);
    m_apb_pcie_pwdata : out std_logic_vector(31 downto 0);
    m_apb_pcie_pwdata_par : out std_logic_vector(3 downto 0);
    m_apb_pcie_pstrb : out std_logic_vector(3 downto 0);
    m_apb_pcie_pstrb_par : out std_logic;
    m_apb_pcie_prdata : in std_logic_vector(31 downto 0);
    m_apb_pcie_prdata_par : in std_logic_vector(3 downto 0);
    m_apb_pcie_pslverror : in std_logic;
    m_axi_pcie_awaddr : out std_logic_vector(63 downto 0);
    m_axi_pcie_awid : out std_logic_vector(7 downto 0);
    m_axi_pcie_awlen : out std_logic_vector(7 downto 0);
    m_axi_pcie_awsize : out std_logic_vector(2 downto 0);
    m_axi_pcie_awvalid : out std_logic;
    m_axi_pcie_awready : in std_logic;
    m_axi_pcie_wlast : out std_logic;
    m_axi_pcie_wvalid : out std_logic;
    m_axi_pcie_wready : in std_logic;
    m_axi_pcie_bresp : in std_logic_vector(1 downto 0);
    m_axi_pcie_bid : in std_logic_vector(7 downto 0);
    m_axi_pcie_bvalid : in std_logic;
    m_axi_pcie_bready : out std_logic;
    m_axi_pcie_arid : out std_logic_vector(7 downto 0);
    m_axi_pcie_araddr : out std_logic_vector(63 downto 0);
    m_axi_pcie_arlen : out std_logic_vector(7 downto 0);
    m_axi_pcie_arsize : out std_logic_vector(2 downto 0);
    m_axi_pcie_arvalid : out std_logic;
    m_axi_pcie_arready : in std_logic;
    m_axi_pcie_rid : in std_logic_vector(7 downto 0);
    m_axi_pcie_rresp : in std_logic_vector(1 downto 0);
    m_axi_pcie_rlast : in std_logic;
    m_axi_pcie_rvalid : in std_logic;
    m_axi_pcie_rready : out std_logic;
    s_axi_pcie_awid : in std_logic_vector(7 downto 0);
    s_axi_pcie_awvalid : in std_logic;
    s_axi_pcie_awaddr : in std_logic_vector(63 downto 0);
    s_axi_pcie_awlen : in std_logic_vector(7 downto 0);
    s_axi_pcie_awsize : in std_logic_vector(2 downto 0);
    s_axi_pcie_awready : out std_logic;
    s_axi_pcie_wvalid : in std_logic;
    s_axi_pcie_wdata : in std_logic_vector(255 downto 0);
    s_axi_pcie_wstrb : in std_logic_vector(31 downto 0);
    s_axi_pcie_wlast : in std_logic;
    s_axi_pcie_wready : out std_logic;
    s_axi_pcie_bid : out std_logic_vector(7 downto 0);
    s_axi_pcie_bresp : out std_logic_vector(1 downto 0);
    s_axi_pcie_bvalid : out std_logic;
    s_axi_pcie_bready : in std_logic;
    s_axi_pcie_arid : in std_logic_vector(7 downto 0);
    s_axi_pcie_arvalid : in std_logic;
    s_axi_pcie_araddr : in std_logic_vector(63 downto 0);
    s_axi_pcie_arlen : in std_logic_vector(7 downto 0);
    s_axi_pcie_arsize : in std_logic_vector(2 downto 0);
    s_axi_pcie_arready : out std_logic;
    s_axi_pcie_rid : out std_logic_vector(7 downto 0);
    s_axi_pcie_rvalid : out std_logic;
    s_axi_pcie_rdata : out std_logic_vector(255 downto 0);
    s_axi_pcie_rlast : out std_logic;
    s_axi_pcie_rresp : out std_logic_vector(1 downto 0);
    s_axi_pcie_rready : in std_logic;
    cfg_msi_enable : in std_logic;
    cfg_msix_enable : in std_logic;
    legacy_irq : out std_logic_vector(3 downto 0);
    legacy_irq_ack : in std_logic;
    cfg_max_payload_size : in std_logic_vector(2 downto 0);
    cfg_max_read_req_size : in std_logic_vector(2 downto 0);
    m_apb_usr_penable : out std_logic;
    m_apb_usr_paddr : out std_logic_vector(31 downto 0);
    m_apb_usr_pwdata : out std_logic_vector(31 downto 0);
    s_apb_usr_prdata : out std_logic_vector(31 downto 0);
    s_apb_usr_pready : out std_logic;
    s_apb_usr_pslverror : out std_logic;
    m_axi_pcie_wdata : out std_logic_vector(33'sd255 downto 0);
    m_axi_pcie_wdata_par : out std_logic_vector(33'sd31 downto 0);
    m_axi_pcie_wstrb : out std_logic_vector(33'sd31 downto 0);
    m_axi_pcie_rdata : in std_logic_vector(33'sd255 downto 0);
    m_axi_pcie_rdata_par : in std_logic_vector(33'sd31 downto 0);
    cth_sts : out std_logic_vector(65'sd7 downto 0);
    htc_sts : out std_logic_vector(65'sd7 downto 0);
    usr_irq : in std_logic_vector(33'sd3 downto 0);
    usr_irq_ack : out std_logic_vector(33'sd3 downto 0);
    apb_rstn : in std_logic;
    m_apb_usr_pready : in std_logic;
    m_apb_usr_prdata : in std_logic_vector(31 downto 0);
    m_apb_usr_pslverror : in std_logic;
    s_apb_usr_paddr : in std_logic_vector(31 downto 0);
    s_apb_usr_penable : in std_logic;
    s_apb_usr_psel : in std_logic;
    s_apb_usr_pwdata : in std_logic_vector(31 downto 0);
    s_apb_usr_pwrite : in std_logic;
    m_axi_usr_arready : in std_logic;
    m_axi_usr_awready : in std_logic;
    m_axi_usr_bid : in std_logic_vector(7 downto 0);
    m_axi_usr_bresp : in std_logic_vector(1 downto 0);
    m_axi_usr_bvalid : in std_logic;
    m_axi_usr_rid : in std_logic_vector(7 downto 0);
    m_axi_usr_rlast : in std_logic;
    m_axi_usr_rresp : in std_logic_vector(1 downto 0);
    m_axi_usr_rvalid : in std_logic;
    m_axi_usr_wready : in std_logic;
    m_axi_usr_rdata : in std_logic_vector(33'sd255 downto 0);
    m_axi_usr_araddr : out std_logic_vector(63 downto 0);
    m_axi_usr_arid : out std_logic_vector(7 downto 0);
    m_axi_usr_arlen : out std_logic_vector(7 downto 0);
    m_axi_usr_arsize : out std_logic_vector(2 downto 0);
    m_axi_usr_arvalid : out std_logic;
    m_axi_usr_awid : out std_logic_vector(7 downto 0);
    m_axi_usr_awlen : out std_logic_vector(7 downto 0);
    m_axi_usr_awsize : out std_logic_vector(2 downto 0);
    m_axi_usr_wvalid : out std_logic;
    m_axi_usr_wlast : out std_logic;
    m_axi_usr_rready : out std_logic;
    m_axi_usr_bready : out std_logic;
    m_axi_usr_awvalid : out std_logic;
    m_axi_usr_awaddr : out std_logic_vector(63 downto 0);
    m_axi_usr_wdata : out std_logic_vector(33'sd255 downto 0);
    m_axi_usr_wstrb : out std_logic_vector(33'sd31 downto 0);
    m_apb_usr_psel : out std_logic;
    m_apb_usr_pwrite : out std_logic
);
end component efx_pcie_dma;

---------------------- End COMPONENT Declaration ------------
------------- Begin Cut here for INSTANTIATION Template -----
u_efx_pcie_dma : efx_pcie_dma
port map (
    axi_clk => axi_clk,
    dma_rstn => dma_rstn,
    apb_clk => apb_clk,
    m_apb_pcie_pready => m_apb_pcie_pready,
    m_apb_pcie_psel => m_apb_pcie_psel,
    m_apb_pcie_pwrite => m_apb_pcie_pwrite,
    m_apb_pcie_penable => m_apb_pcie_penable,
    m_apb_pcie_paddr => m_apb_pcie_paddr,
    m_apb_pcie_pwdata => m_apb_pcie_pwdata,
    m_apb_pcie_pwdata_par => m_apb_pcie_pwdata_par,
    m_apb_pcie_pstrb => m_apb_pcie_pstrb,
    m_apb_pcie_pstrb_par => m_apb_pcie_pstrb_par,
    m_apb_pcie_prdata => m_apb_pcie_prdata,
    m_apb_pcie_prdata_par => m_apb_pcie_prdata_par,
    m_apb_pcie_pslverror => m_apb_pcie_pslverror,
    m_axi_pcie_awaddr => m_axi_pcie_awaddr,
    m_axi_pcie_awid => m_axi_pcie_awid,
    m_axi_pcie_awlen => m_axi_pcie_awlen,
    m_axi_pcie_awsize => m_axi_pcie_awsize,
    m_axi_pcie_awvalid => m_axi_pcie_awvalid,
    m_axi_pcie_awready => m_axi_pcie_awready,
    m_axi_pcie_wlast => m_axi_pcie_wlast,
    m_axi_pcie_wvalid => m_axi_pcie_wvalid,
    m_axi_pcie_wready => m_axi_pcie_wready,
    m_axi_pcie_bresp => m_axi_pcie_bresp,
    m_axi_pcie_bid => m_axi_pcie_bid,
    m_axi_pcie_bvalid => m_axi_pcie_bvalid,
    m_axi_pcie_bready => m_axi_pcie_bready,
    m_axi_pcie_arid => m_axi_pcie_arid,
    m_axi_pcie_araddr => m_axi_pcie_araddr,
    m_axi_pcie_arlen => m_axi_pcie_arlen,
    m_axi_pcie_arsize => m_axi_pcie_arsize,
    m_axi_pcie_arvalid => m_axi_pcie_arvalid,
    m_axi_pcie_arready => m_axi_pcie_arready,
    m_axi_pcie_rid => m_axi_pcie_rid,
    m_axi_pcie_rresp => m_axi_pcie_rresp,
    m_axi_pcie_rlast => m_axi_pcie_rlast,
    m_axi_pcie_rvalid => m_axi_pcie_rvalid,
    m_axi_pcie_rready => m_axi_pcie_rready,
    s_axi_pcie_awid => s_axi_pcie_awid,
    s_axi_pcie_awvalid => s_axi_pcie_awvalid,
    s_axi_pcie_awaddr => s_axi_pcie_awaddr,
    s_axi_pcie_awlen => s_axi_pcie_awlen,
    s_axi_pcie_awsize => s_axi_pcie_awsize,
    s_axi_pcie_awready => s_axi_pcie_awready,
    s_axi_pcie_wvalid => s_axi_pcie_wvalid,
    s_axi_pcie_wdata => s_axi_pcie_wdata,
    s_axi_pcie_wstrb => s_axi_pcie_wstrb,
    s_axi_pcie_wlast => s_axi_pcie_wlast,
    s_axi_pcie_wready => s_axi_pcie_wready,
    s_axi_pcie_bid => s_axi_pcie_bid,
    s_axi_pcie_bresp => s_axi_pcie_bresp,
    s_axi_pcie_bvalid => s_axi_pcie_bvalid,
    s_axi_pcie_bready => s_axi_pcie_bready,
    s_axi_pcie_arid => s_axi_pcie_arid,
    s_axi_pcie_arvalid => s_axi_pcie_arvalid,
    s_axi_pcie_araddr => s_axi_pcie_araddr,
    s_axi_pcie_arlen => s_axi_pcie_arlen,
    s_axi_pcie_arsize => s_axi_pcie_arsize,
    s_axi_pcie_arready => s_axi_pcie_arready,
    s_axi_pcie_rid => s_axi_pcie_rid,
    s_axi_pcie_rvalid => s_axi_pcie_rvalid,
    s_axi_pcie_rdata => s_axi_pcie_rdata,
    s_axi_pcie_rlast => s_axi_pcie_rlast,
    s_axi_pcie_rresp => s_axi_pcie_rresp,
    s_axi_pcie_rready => s_axi_pcie_rready,
    cfg_msi_enable => cfg_msi_enable,
    cfg_msix_enable => cfg_msix_enable,
    legacy_irq => legacy_irq,
    legacy_irq_ack => legacy_irq_ack,
    cfg_max_payload_size => cfg_max_payload_size,
    cfg_max_read_req_size => cfg_max_read_req_size,
    m_apb_usr_penable => m_apb_usr_penable,
    m_apb_usr_paddr => m_apb_usr_paddr,
    m_apb_usr_pwdata => m_apb_usr_pwdata,
    s_apb_usr_prdata => s_apb_usr_prdata,
    s_apb_usr_pready => s_apb_usr_pready,
    s_apb_usr_pslverror => s_apb_usr_pslverror,
    m_axi_pcie_wdata => m_axi_pcie_wdata,
    m_axi_pcie_wdata_par => m_axi_pcie_wdata_par,
    m_axi_pcie_wstrb => m_axi_pcie_wstrb,
    m_axi_pcie_rdata => m_axi_pcie_rdata,
    m_axi_pcie_rdata_par => m_axi_pcie_rdata_par,
    cth_sts => cth_sts,
    htc_sts => htc_sts,
    usr_irq => usr_irq,
    usr_irq_ack => usr_irq_ack,
    apb_rstn => apb_rstn,
    m_apb_usr_pready => m_apb_usr_pready,
    m_apb_usr_prdata => m_apb_usr_prdata,
    m_apb_usr_pslverror => m_apb_usr_pslverror,
    s_apb_usr_paddr => s_apb_usr_paddr,
    s_apb_usr_penable => s_apb_usr_penable,
    s_apb_usr_psel => s_apb_usr_psel,
    s_apb_usr_pwdata => s_apb_usr_pwdata,
    s_apb_usr_pwrite => s_apb_usr_pwrite,
    m_axi_usr_arready => m_axi_usr_arready,
    m_axi_usr_awready => m_axi_usr_awready,
    m_axi_usr_bid => m_axi_usr_bid,
    m_axi_usr_bresp => m_axi_usr_bresp,
    m_axi_usr_bvalid => m_axi_usr_bvalid,
    m_axi_usr_rid => m_axi_usr_rid,
    m_axi_usr_rlast => m_axi_usr_rlast,
    m_axi_usr_rresp => m_axi_usr_rresp,
    m_axi_usr_rvalid => m_axi_usr_rvalid,
    m_axi_usr_wready => m_axi_usr_wready,
    m_axi_usr_rdata => m_axi_usr_rdata,
    m_axi_usr_araddr => m_axi_usr_araddr,
    m_axi_usr_arid => m_axi_usr_arid,
    m_axi_usr_arlen => m_axi_usr_arlen,
    m_axi_usr_arsize => m_axi_usr_arsize,
    m_axi_usr_arvalid => m_axi_usr_arvalid,
    m_axi_usr_awid => m_axi_usr_awid,
    m_axi_usr_awlen => m_axi_usr_awlen,
    m_axi_usr_awsize => m_axi_usr_awsize,
    m_axi_usr_wvalid => m_axi_usr_wvalid,
    m_axi_usr_wlast => m_axi_usr_wlast,
    m_axi_usr_rready => m_axi_usr_rready,
    m_axi_usr_bready => m_axi_usr_bready,
    m_axi_usr_awvalid => m_axi_usr_awvalid,
    m_axi_usr_awaddr => m_axi_usr_awaddr,
    m_axi_usr_wdata => m_axi_usr_wdata,
    m_axi_usr_wstrb => m_axi_usr_wstrb,
    m_apb_usr_psel => m_apb_usr_psel,
    m_apb_usr_pwrite => m_apb_usr_pwrite
);

------------------------ End INSTANTIATION Template ---------

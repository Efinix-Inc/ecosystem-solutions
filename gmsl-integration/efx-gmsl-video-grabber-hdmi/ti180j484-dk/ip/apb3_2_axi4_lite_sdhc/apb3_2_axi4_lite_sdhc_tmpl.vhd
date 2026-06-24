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
component apb3_2_axi4_lite_sdhc is
port (
    s_apb3_paddr : in std_logic_vector(9 downto 0);
    s_apb3_psel : in std_logic;
    s_apb3_penable : in std_logic;
    s_apb3_pwrite : in std_logic;
    s_apb3_pwdata : in std_logic_vector(31 downto 0);
    s_apb3_pready : out std_logic;
    s_apb3_prdata : out std_logic_vector(31 downto 0);
    s_apb3_pslverror : out std_logic;
    clk : in std_logic;
    rstn : in std_logic;
    m_axi_awready : in std_logic;
    m_axi_wready : in std_logic;
    m_axi_arready : in std_logic;
    m_axi_rdata : in std_logic_vector(31 downto 0);
    m_axi_rvalid : in std_logic;
    m_axi_awaddr : out std_logic_vector(9 downto 0);
    m_axi_awvalid : out std_logic;
    m_axi_wdata : out std_logic_vector(31 downto 0);
    m_axi_wvalid : out std_logic;
    m_axi_araddr : out std_logic_vector(9 downto 0);
    m_axi_arvalid : out std_logic;
    m_axi_rready : out std_logic
);
end component apb3_2_axi4_lite_sdhc;

---------------------- End COMPONENT Declaration ------------
------------- Begin Cut here for INSTANTIATION Template -----
u_apb3_2_axi4_lite_sdhc : apb3_2_axi4_lite_sdhc
port map (
    s_apb3_paddr => s_apb3_paddr,
    s_apb3_psel => s_apb3_psel,
    s_apb3_penable => s_apb3_penable,
    s_apb3_pwrite => s_apb3_pwrite,
    s_apb3_pwdata => s_apb3_pwdata,
    s_apb3_pready => s_apb3_pready,
    s_apb3_prdata => s_apb3_prdata,
    s_apb3_pslverror => s_apb3_pslverror,
    clk => clk,
    rstn => rstn,
    m_axi_awready => m_axi_awready,
    m_axi_wready => m_axi_wready,
    m_axi_arready => m_axi_arready,
    m_axi_rdata => m_axi_rdata,
    m_axi_rvalid => m_axi_rvalid,
    m_axi_awaddr => m_axi_awaddr,
    m_axi_awvalid => m_axi_awvalid,
    m_axi_wdata => m_axi_wdata,
    m_axi_wvalid => m_axi_wvalid,
    m_axi_araddr => m_axi_araddr,
    m_axi_arvalid => m_axi_arvalid,
    m_axi_rready => m_axi_rready
);

------------------------ End INSTANTIATION Template ---------

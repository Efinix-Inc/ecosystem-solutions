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
component I2C_SLAVE is
port (
    slv_scl_in : in std_logic;
    slv_sda_in : in std_logic;
    slv_scl_out : out std_logic;
    slv_scl_oe : out std_logic;
    slv_sda_out : out std_logic;
    slv_sda_oe : out std_logic;
    clk : in std_logic;
    rst : in std_logic;
    slv_read : in std_logic;
    slv_write : in std_logic;
    slv_busy : out std_logic;
    slv_ready_to_wr : out std_logic;
    slv_ready_to_rd : out std_logic;
    slv_rddata_valid : out std_logic;
    slv_command_byte : out std_logic_vector(7 downto 0);
    slv_data_out : out std_logic_vector(7 downto 0);
    slv_din : in std_logic_vector(7 downto 0)
);
end component I2C_SLAVE;

---------------------- End COMPONENT Declaration ------------
------------- Begin Cut here for INSTANTIATION Template -----
u_I2C_SLAVE : I2C_SLAVE
port map (
    slv_scl_in => slv_scl_in,
    slv_sda_in => slv_sda_in,
    slv_scl_out => slv_scl_out,
    slv_scl_oe => slv_scl_oe,
    slv_sda_out => slv_sda_out,
    slv_sda_oe => slv_sda_oe,
    clk => clk,
    rst => rst,
    slv_read => slv_read,
    slv_write => slv_write,
    slv_busy => slv_busy,
    slv_ready_to_wr => slv_ready_to_wr,
    slv_ready_to_rd => slv_ready_to_rd,
    slv_rddata_valid => slv_rddata_valid,
    slv_command_byte => slv_command_byte,
    slv_data_out => slv_data_out,
    slv_din => slv_din
);

------------------------ End INSTANTIATION Template ---------

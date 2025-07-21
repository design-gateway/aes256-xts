----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     AES256XTSTOP.vhd
-- Title        Top
--
-- Company      Design Gateway Co., Ltd.
-- Project      AES256XTS
-- PJ No.       
-- Syntax       VHDL
-- Note         
--
-- Version      1.00
-- Author       Tan T.
-- Date         21/Jul/2025
-- Remark       New Creation
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity AES256XTSTOP is
    port
    (
        ExtRstBIn : in    std_logic;
        Clk100In  : in    std_logic;

        LED       : out std_logic_vector(2 downto 0)
    );
end entity AES256XTSTOP;
architecture rtl of AES256XTSTOP is
----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------
    component AES256XTSDemo is
    port
    (
        ExtRstB : in std_logic; -- extenal Reset, Active Low
        Clk     : in std_logic;

        LED     : out std_logic_vector(1 downto 0)
    );
    end component AES256XTSDemo;

	Component UserPLL is
	Port 
	(
		rst       : in  std_logic;
		refclk    : in  std_logic;
		locked    : out std_logic;
		outclk_0  : out std_logic
	);
	End component UserPLL;
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
    signal ExtRst    : std_logic;
    signal ExtRstB   : std_logic;
    signal IPClk     : std_logic;
begin
----------------------------------------------------------------------------------
-- Component mapping 
----------------------------------------------------------------------------------
    ExtRst <= not ExtRstBIn;
    LED(2) <= ExtRstB;

    c_UserPLL : UserPLL
    port map
    (
        rst       => ExtRst,
        refclk    => Clk100In,

        outclk_0  => IPClk,
        locked    => ExtRstB
    );

    c_AES256XTSDemo : AES256XTSDemo
    port map
    (
        ExtRstB => ExtRstB,
    
        Clk     => IPClk,
        LED     => LED(1 downto 0)
    );

end architecture rtl;

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Filename     AES256XTSDemo.vhd
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

entity AES256XTSDemo is
    port
    (
        ExtRstB : in std_logic; -- extenal Reset, Active Low
        Clk     : in std_logic;

        LED     : out std_logic_vector(1 downto 0)
    );
end entity AES256XTSDemo;
architecture rtl of AES256XTSDemo is
----------------------------------------------------------------------------------
-- Component declaration
----------------------------------------------------------------------------------
    component AES256XTSENC is
    port
    (
        RstB         : in std_logic;
        Clk          : in std_logic;
        version      : out std_logic_vector(31 downto 0);

        EKeyInValid  : in std_logic;
        EKeyInBusy   : out std_logic;
        EKeyInFinish : out std_logic;
        EKeyIn       : in std_logic_vector(255 downto 0);

        TKeyInValid  : in std_logic;
        TKeyInBusy   : out std_logic;
        TKeyInFinish : out std_logic;
        TKeyIn       : in std_logic_vector(255 downto 0);

        InitStart    : in std_logic;
        Busy         : out std_logic;
        Finish       : out std_logic;

        IvIn         : in std_logic_vector(127 downto 0);
        DataInCount  : in std_logic_vector(23 downto 0);

        DataInRd     : out std_logic;
        DataIn       : in std_logic_vector(127 downto 0);

        DataOutValid : out std_logic;
        DataOut      : out std_logic_vector(127 downto 0)
    );
    end component AES256XTSENC;

    component AES256XTSDEC is
    port
    (
        RstB         : in std_logic;
        Clk          : in std_logic;
        version      : out std_logic_vector(31 downto 0);

        EKeyInValid  : in std_logic;
        EKeyInBusy   : out std_logic;
        EKeyInFinish : out std_logic;
        EKeyIn       : in std_logic_vector(255 downto 0);

        TKeyInValid  : in std_logic;
        TKeyInBusy   : out std_logic;
        TKeyInFinish : out std_logic;
        TKeyIn       : in std_logic_vector(255 downto 0);

        InitStart    : in std_logic;
        Busy         : out std_logic;
        Finish       : out std_logic;

        IvIn         : in std_logic_vector(127 downto 0);
        DataInCount  : in std_logic_vector(23 downto 0);

        DataInRd     : out std_logic;
        DataIn       : in std_logic_vector(127 downto 0);

        DataOutValid : out std_logic;
        DataOut      : out std_logic_vector(127 downto 0)
    );
    end component AES256XTSDEC;
----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------
    signal rExtRstBCnt      : std_logic_vector(20 downto 0);
    signal RstB             : std_logic;

    signal EKeyInBusyEnc    : std_logic;
    signal EKeyInFinishEnc  : std_logic;
    signal EKeyInEnc        : std_logic_vector(255 downto 0);
    signal TKeyInBusyEnc    : std_logic;
    signal TKeyInFinishEnc  : std_logic;
    signal TKeyInEnc        : std_logic_vector(255 downto 0);
    signal BusyEnc          : std_logic;
    signal FinishEnc        : std_logic;
    signal IvInEnc          : std_logic_vector(127 downto 0);
    signal DataInCountEnc   : std_logic_vector(23 downto 0);
    signal DataInRdEnc      : std_logic;
    signal rDataInRdEnc      : std_logic;
    signal DataInEnc        : std_logic_vector(127 downto 0);
    signal DataOutValidEnc  : std_logic;
    signal DataOutEnc       : std_logic_vector(127 downto 0);

    signal EKeyInBusyDec    : std_logic;
    signal EKeyInFinishDec  : std_logic;
    signal EKeyInDec        : std_logic_vector(255 downto 0);
    signal TKeyInBusyDec    : std_logic;
    signal TKeyInFinishDec  : std_logic;
    signal TKeyInDec        : std_logic_vector(255 downto 0);
    signal BusyDec          : std_logic;
    signal FinishDec        : std_logic;
    signal IvInDec          : std_logic_vector(127 downto 0);
    signal DataInCountDec   : std_logic_vector(23 downto 0);
    signal DataInRdDec      : std_logic;
    signal DataInDec        : std_logic_vector(127 downto 0);
    signal DataOutValidDec  : std_logic;
    signal DataOutDec       : std_logic_vector(127 downto 0);

    signal rKeyInValid      : std_logic;
    signal rCounter         : std_logic_vector(31 downto 0);
    signal PatternIn        : std_logic_vector(127 downto 0);
    signal rVerifyCnt       : std_logic_vector(31 downto 0);
    signal VerifyOut        : std_logic_vector(127 downto 0);
    signal rWrong           : std_logic;

    signal rTestCnt         : std_logic_vector(15 downto 0);
    signal rStartEnc        : std_logic;
    signal rStartDec        : std_logic;
    signal rStartEnc1       : std_logic;
    signal rStartDec1       : std_logic;
    signal rIpRunning       : std_logic;

begin
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
    LED <= rWrong & rIpRunning;
----------------------------------------------------------------------------------
-- Component mapping 
----------------------------------------------------------------------------------
    c_AES256XTSENCEnc : AES256XTSENC
    port map
    (
        version       => open,

        RstB          => RstB,
        Clk           => Clk,

        EKeyInValid   => rKeyInValid,
        EKeyInBusy    => EKeyInBusyEnc,
        EKeyInFinish  => EKeyInFinishEnc,
        EKeyIn        => EKeyInEnc,

        TKeyInValid   => rKeyInValid,
        TKeyInBusy    => TKeyInBusyEnc,
        TKeyInFinish  => TKeyInFinishEnc,
        TKeyIn        => TKeyInEnc,

        InitStart     => rStartEnc,
        Busy          => BusyEnc,
        Finish        => FinishEnc,
        IvIn          => IvInEnc,
        DataInCount   => DataInCountEnc,

        DataInRd      => DataInRdEnc,
        DataIn        => DataInEnc,

        DataOutValid  => DataOutValidEnc,
        DataOut       => DataOutEnc
    );

    PatternIn       <= rCounter & rCounter & rCounter & rCounter;
    VerifyOut       <= rVerifyCnt & rVerifyCnt & rVerifyCnt & rVerifyCnt;
    -- Encryption Parameter
    EKeyInEnc       <= x"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";
    TKeyInEnc       <= x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100";
    IvInEnc         <= x"00112233445566778899aabbccddeeff";
    DataInCountEnc  <= x"001000";
    DataInEnc       <= PatternIn;
    -- Decryption Parameter
    EKeyInDec       <= x"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";
    TKeyInDec       <= x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100";
    IvInDec         <= x"00112233445566778899aabbccddeeff";
    DataInCountDec  <= x"001000";
    DataInDec       <= DataOutEnc;

    c_AES256XTSDECDec : AES256XTSDEC
    port map
    (
        version       => open,
        
        RstB          => RstB,
        Clk           => Clk,
        
        EKeyInValid   => rKeyInValid,
        EKeyInBusy    => EKeyInBusyDec,
        EKeyInFinish  => EKeyInFinishDec,
        EKeyIn        => EKeyInDec,

        TKeyInValid   => rKeyInValid,
        TKeyInBusy    => TKeyInBusyDec,
        TKeyInFinish  => TKeyInFinishDec,
        TKeyIn        => TKeyInDec,
        
        InitStart     => rStartDec,
        Busy          => BusyDec,
        Finish        => FinishDec,
        IvIn          => IvInDec,
        DataInCount   => DataInCountDec,
        
        DataInRd      => DataInRdDec,
        DataIn        => DataInDec,
        
        DataOutValid  => DataOutValidDec,
        DataOut       => DataOutDec
    );
----------------------------------------------------------------------------------
-- Logics 
----------------------------------------------------------------------------------
    u_rExtRstBCnt : process (Clk) is
    begin
        if (rising_edge(Clk)) then
            if (ExtRstB = '0') then
                rExtRstBCnt(20 downto 0) <= (others => '0');
            else
                -- Use bit20 to debounce about 10 ms (Clk = 100 MHz)
                if (rExtRstBCnt(20) = '0') then
                    rExtRstBCnt(20 downto 0) <= rExtRstBCnt(20 downto 0) + 1;
                else
                    rExtRstBCnt(20 downto 0) <= rExtRstBCnt(20 downto 0);
                end if;
            end if;
        end if;
    end process u_rExtRstBCnt;

    RstB <= rExtRstBCnt(20);

    p_Enc : process (Clk) is
    begin
        if (rising_edge(Clk)) then
            if (RstB = '0') then
                rCounter <= (others => '0');
            else
                rCounter <= rCounter + 1;
            end if;

            rDataInRdEnc <= DataInRdEnc;
            if (RstB = '0') then
                rVerifyCnt <= (others => '0');
            else
                if (rDataInRdEnc = '0' and DataInRdEnc = '1') then
                    rVerifyCnt <= rCounter;
                elsif (DataOutValidDec = '1') then
                    rVerifyCnt <= rVerifyCnt + 1;
                else
                    rVerifyCnt <= rVerifyCnt;
                end if;
            end if;

            if (RstB = '0') then
                rTestCnt <= (others => '0');
            else
                if (rTestCnt = x"0202") then
                    rTestCnt <= (others => '0');
                else
                    rTestCnt <= rTestCnt + 1;
                end if;
            end if;

            if (RstB = '0') then
                rKeyInValid <= '0';
            else
                if (rTestCnt = 2) then
                    rKeyInValid <= '1';
                else
                    rKeyInValid <= '0';
                end if;
            end if;

            rStartEnc1  <=  rStartEnc;
            if (RstB = '0') then
                rStartEnc <= '0';
            else
                if (rTestCnt = x"0028") then
                    rStartEnc <= '1';
                else
                    rStartEnc <= '0';
                end if;
            end if;

            rStartDec1  <=  rStartDec;
            if (RstB = '0') then
                rStartDec <= '0';
            else
                if (rTestCnt = x"0038") then
                    rStartDec <= '1';
                else
                    rStartDec <= '0';
                end if;
            end if;

            -- To detect IP Core still running, after 'InitStart' is actived, 'Busy' must be actived.
            if ( RstB='0' ) then
                rIpRunning  <=  '0';
            else
                if ( rStartEnc1='1' ) then
                    if ( BusyEnc='1' ) then
                        rIpRunning  <=  '1';
                    else
                        rIpRunning  <=  '0';
                    end if;
                elsif ( rStartDec1='1' ) then
                    if ( BusyDec='1' ) then
                        rIpRunning  <=  '1';
                    else
                        rIpRunning  <=  '0';
                    end if;
                else
                    rIpRunning  <=  rIpRunning;
                end if;
            end if;

            if (RstB = '0') then
                rWrong <= '0';
            else
                if (DataOutValidDec = '1') then
                    if (not(DataOutDec = VerifyOut)) then
                        rWrong <= '1';
                    else
                        rWrong <= rWrong;
                    end if;
                else
                    rWrong <= rWrong;
                end if;
            end if;
        end if;
    end process p_Enc;

end architecture rtl;

-------------------------------------------------------
--! @file
--! @brief CRC component for the Ethernet 802.3 standard
--! @author Dominik Meyer, Rudolf Blunk
--! @email dmeyer@hsu-hh.de
--! @date 2016-09-16
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


--! simple CRC component

entity EthernetCRC is
  port(

    -- user interface
    icWe                  : in  std_logic;
    icRestart             : in  std_logic;
    idData                : in  std_logic_vector(7 downto 0);
    odData                : out std_logic_vector(31 downto 0);


    -- Clock and Reset Signals
    iClk                  : in  std_logic;
    icReset               : in  std_logic

      );
end EthernetCRC;

-------------------------------------------------------------------------------
-- ARCHITECTURE
-------------------------------------------------------------------------------
  architecture imp_crc of EthernetCRC is
    signal lfsr_q: std_logic_vector (31 downto 0);
    signal lfsr_c: std_logic_vector (31 downto 0);
    signal newbyte : std_logic_vector( 7 downto 0);
  begin

    newbyte(7) <= idData(0);                  -- reversing the bitorder of the incoming data
    newbyte(6) <= idData(1);
    newbyte(5) <= idData(2);
    newbyte(4) <= idData(3);
    newbyte(3) <= idData(4);
    newbyte(2) <= idData(5);
    newbyte(1) <= idData(6);
    newbyte(0) <= idData(7);


    gen0: for i in 7 downto 0 generate        --- reversing the bitorder for the final CrC
      odData(31-i)  <= not(lfsr_q(24+i));
      odData(23-i)  <= not(lfsr_q(16+i));
      odData(15-i)  <= not(lfsr_q(8+i));
      odData(7-i)  <= not(lfsr_q(i));

    end generate;


      lfsr_c(0) <= lfsr_q(24) xor lfsr_q(30) xor newbyte(0) xor newbyte(6);
      lfsr_c(1) <= lfsr_q(24) xor lfsr_q(25) xor lfsr_q(30) xor lfsr_q(31) xor newbyte(0) xor newbyte(1) xor newbyte(6) xor newbyte(7);
      lfsr_c(2) <= lfsr_q(24) xor lfsr_q(25) xor lfsr_q(26) xor lfsr_q(30) xor lfsr_q(31) xor newbyte(0) xor newbyte(1) xor newbyte(2) xor newbyte(6) xor newbyte(7);
      lfsr_c(3) <= lfsr_q(25) xor lfsr_q(26) xor lfsr_q(27) xor lfsr_q(31) xor newbyte(1) xor newbyte(2) xor newbyte(3) xor newbyte(7);
      lfsr_c(4) <= lfsr_q(24) xor lfsr_q(26) xor lfsr_q(27) xor lfsr_q(28) xor lfsr_q(30) xor newbyte(0) xor newbyte(2) xor newbyte(3) xor newbyte(4) xor newbyte(6);
      lfsr_c(5) <= lfsr_q(24) xor lfsr_q(25) xor lfsr_q(27) xor lfsr_q(28) xor lfsr_q(29) xor lfsr_q(30) xor lfsr_q(31) xor newbyte(0) xor newbyte(1) xor newbyte(3) xor newbyte(4) xor newbyte(5) xor newbyte(6) xor newbyte(7);
      lfsr_c(6) <= lfsr_q(25) xor lfsr_q(26) xor lfsr_q(28) xor lfsr_q(29) xor lfsr_q(30) xor lfsr_q(31) xor newbyte(1) xor newbyte(2) xor newbyte(4) xor newbyte(5) xor newbyte(6) xor newbyte(7);
      lfsr_c(7) <= lfsr_q(24) xor lfsr_q(26) xor lfsr_q(27) xor lfsr_q(29) xor lfsr_q(31) xor newbyte(0) xor newbyte(2) xor newbyte(3) xor newbyte(5) xor newbyte(7);
      lfsr_c(8) <= lfsr_q(0) xor lfsr_q(24) xor lfsr_q(25) xor lfsr_q(27) xor lfsr_q(28) xor newbyte(0) xor newbyte(1) xor newbyte(3) xor newbyte(4);
      lfsr_c(9) <= lfsr_q(1) xor lfsr_q(25) xor lfsr_q(26) xor lfsr_q(28) xor lfsr_q(29) xor newbyte(1) xor newbyte(2) xor newbyte(4) xor newbyte(5);
      lfsr_c(10) <= lfsr_q(2) xor lfsr_q(24) xor lfsr_q(26) xor lfsr_q(27) xor lfsr_q(29) xor newbyte(0) xor newbyte(2) xor newbyte(3) xor newbyte(5);
      lfsr_c(11) <= lfsr_q(3) xor lfsr_q(24) xor lfsr_q(25) xor lfsr_q(27) xor lfsr_q(28) xor newbyte(0) xor newbyte(1) xor newbyte(3) xor newbyte(4);
      lfsr_c(12) <= lfsr_q(4) xor lfsr_q(24) xor lfsr_q(25) xor lfsr_q(26) xor lfsr_q(28) xor lfsr_q(29) xor lfsr_q(30) xor newbyte(0) xor newbyte(1) xor newbyte(2) xor newbyte(4) xor newbyte(5) xor newbyte(6);
      lfsr_c(13) <= lfsr_q(5) xor lfsr_q(25) xor lfsr_q(26) xor lfsr_q(27) xor lfsr_q(29) xor lfsr_q(30) xor lfsr_q(31) xor newbyte(1) xor newbyte(2) xor newbyte(3) xor newbyte(5) xor newbyte(6) xor newbyte(7);
      lfsr_c(14) <= lfsr_q(6) xor lfsr_q(26) xor lfsr_q(27) xor lfsr_q(28) xor lfsr_q(30) xor lfsr_q(31) xor newbyte(2) xor newbyte(3) xor newbyte(4) xor newbyte(6) xor newbyte(7);
      lfsr_c(15) <= lfsr_q(7) xor lfsr_q(27) xor lfsr_q(28) xor lfsr_q(29) xor lfsr_q(31) xor newbyte(3) xor newbyte(4) xor newbyte(5) xor newbyte(7);
      lfsr_c(16) <= lfsr_q(8) xor lfsr_q(24) xor lfsr_q(28) xor lfsr_q(29) xor newbyte(0) xor newbyte(4) xor newbyte(5);
      lfsr_c(17) <= lfsr_q(9) xor lfsr_q(25) xor lfsr_q(29) xor lfsr_q(30) xor newbyte(1) xor newbyte(5) xor newbyte(6);
      lfsr_c(18) <= lfsr_q(10) xor lfsr_q(26) xor lfsr_q(30) xor lfsr_q(31) xor newbyte(2) xor newbyte(6) xor newbyte(7);
      lfsr_c(19) <= lfsr_q(11) xor lfsr_q(27) xor lfsr_q(31) xor newbyte(3) xor newbyte(7);
      lfsr_c(20) <= lfsr_q(12) xor lfsr_q(28) xor newbyte(4);
      lfsr_c(21) <= lfsr_q(13) xor lfsr_q(29) xor newbyte(5);
      lfsr_c(22) <= lfsr_q(14) xor lfsr_q(24) xor newbyte(0);
      lfsr_c(23) <= lfsr_q(15) xor lfsr_q(24) xor lfsr_q(25) xor lfsr_q(30) xor newbyte(0) xor newbyte(1) xor newbyte(6);
      lfsr_c(24) <= lfsr_q(16) xor lfsr_q(25) xor lfsr_q(26) xor lfsr_q(31) xor newbyte(1) xor newbyte(2) xor newbyte(7);
      lfsr_c(25) <= lfsr_q(17) xor lfsr_q(26) xor lfsr_q(27) xor newbyte(2) xor newbyte(3);
      lfsr_c(26) <= lfsr_q(18) xor lfsr_q(24) xor lfsr_q(27) xor lfsr_q(28) xor lfsr_q(30) xor newbyte(0) xor newbyte(3) xor newbyte(4) xor newbyte(6);
      lfsr_c(27) <= lfsr_q(19) xor lfsr_q(25) xor lfsr_q(28) xor lfsr_q(29) xor lfsr_q(31) xor newbyte(1) xor newbyte(4) xor newbyte(5) xor newbyte(7);
      lfsr_c(28) <= lfsr_q(20) xor lfsr_q(26) xor lfsr_q(29) xor lfsr_q(30) xor newbyte(2) xor newbyte(5) xor newbyte(6);
      lfsr_c(29) <= lfsr_q(21) xor lfsr_q(27) xor lfsr_q(30) xor lfsr_q(31) xor newbyte(3) xor newbyte(6) xor newbyte(7);
      lfsr_c(30) <= lfsr_q(22) xor lfsr_q(28) xor lfsr_q(31) xor newbyte(4) xor newbyte(7);
      lfsr_c(31) <= lfsr_q(23) xor lfsr_q(29) xor newbyte(5);


      process (iClk) begin
        if (rising_edge(iClk)) then
          if (icReset = '1') then
            lfsr_q <= b"11111111111111111111111111111111";
          else
            if (icRestart = '1') then
                lfsr_q <= b"11111111111111111111111111111111";
            elsif (icWe = '1') then
              lfsr_q <= lfsr_c;
         	  end if;
          end if;
        end if;
      end process;
  end architecture imp_crc;

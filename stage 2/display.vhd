----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:23:59 12/06/2010 
-- Design Name: 
-- Module Name:    display - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display is
    Port ( segs : out  STD_LOGIC_VECTOR (7 downto 0);
           number : in  STD_LOGIC_VECTOR (7 downto 0));
end display;

architecture Behavioral of display is

begin
   segs(7) <= '0';
    with number SELect
   segs(6 downto 0)<= "1111001" when "00000001",   --1
         "0100100" when "00000010",   --2
         "0110000" when "00000011",   --3
         "0011001" when "00000100",   --4
         "0010010" when "00000101",   --5
         "0000010" when "00000110",   --6
         "1111000" when "00000111",   --7
         "0000000" when "00001000",   --8
         "0010000" when "00001001",   --9
         "0001000" when "00001010",   --A
         "0000011" when "00001011",   --b
         "1000110" when "00001100",   --C
         "0100001" when "00001101",   --d
         "0000110" when "00001110",   --E
         "0001110" when "00001111",   --F
         "1000000" when others;   --0
 
    
				

end Behavioral;


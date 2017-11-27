----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Konstantinos Tsimpoukas
-- 
-- Create Date:    18:23:11 11/21/2010 
-- Design Name: 		assignment stage 1
-- Module Name:    assign - Behavioral 
-- Project Name: 
-- Target Devices: Spartan 3
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
use ieee.std_logic_unsigned.all;

entity assign is
    Port ( clock : in  STD_LOGIC;
           buttons : in  STD_LOGIC_VECTOR (3 downto 0);
           switches : in  STD_LOGIC_VECTOR (7 downto 0);    --switches(7)=reset /// switches(3 downto 0)=input
           leds : out  STD_LOGIC_VECTOR (7 downto 0);
           digit : out  STD_LOGIC_VECTOR (3 downto 0);
           segments : out  STD_LOGIC_VECTOR (7 downto 0));
			  
			  -- Assign inputs and outputs to appropriate pins on FPGA
         attribute LOC : string ;
         attribute LOC of clock : signal is "T9";
         attribute LOC of switches : signal is "K13,K14,J13,J14,H13,H14,G12,F12";
         attribute LOC of buttons : signal is "L14,L13,M14,M13";
         attribute LOC of leds : signal is "P11,P12,N12,P13,N14,L12,P14,K12";
         attribute LOC of digit : signal is "E13,F14,G14,D14";
         attribute LOC of segments : signal is "P16,N16,F13,R16,P15,N15,G13,E14";
			  
end assign;

architecture Behavioral of assign is

	component display
    Port ( segs : out  STD_LOGIC_VECTOR (7 downto 0);
           number : in  STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	signal state,state_next : STD_LOGIC_VECTOR(3 downto 0);  
	signal signal_clk:std_logic;
	
	signal count:STD_LOGIC_VECTOR(31 downto 0); 
	constant MAX_VALUE:STD_LOGIC_VECTOR(31 downto 0):=X"01FFFFFF";
	
	constant S0 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	constant S1 : STD_LOGIC_VECTOR(3 downto 0) := "0001";
	constant S2 : STD_LOGIC_VECTOR(3 downto 0) := "0010";
	constant S3 : STD_LOGIC_VECTOR(3 downto 0) := "0011";
	constant S4 : STD_LOGIC_VECTOR(3 downto 0) := "0100";
	constant S5 : STD_LOGIC_VECTOR(3 downto 0) := "0101";
	constant S6 : STD_LOGIC_VECTOR(3 downto 0) := "0110";
	constant S7 : STD_LOGIC_VECTOR(3 downto 0) := "0111";
	constant S8 : STD_LOGIC_VECTOR(3 downto 0) := "1000";
	constant S9 : STD_LOGIC_VECTOR(3 downto 0) := "1001";
	constant S10 : STD_LOGIC_VECTOR(3 downto 0) := "1010";
	constant S11 : STD_LOGIC_VECTOR(3 downto 0) := "1011";
	constant S12 : STD_LOGIC_VECTOR(3 downto 0) := "1100";
	constant S13 : STD_LOGIC_VECTOR(3 downto 0) := "1101";
	constant S14 : STD_LOGIC_VECTOR(3 downto 0) := "1110";
	constant S15 : STD_LOGIC_VECTOR(3 downto 0) := "1111";

begin


leds(3 downto 0)<=state;

--Initializing Unused Outputs
leds(6 downto 4)<="000";   
digit(3 downto 0)<="1110";
--segments(7 downto 0)<=X"FF";
dd : display port map(segs => segments, number => state);

pr1: process (signal_clk,switches)
		begin
			
			if(switches(7)='1') then            --switches(7)=reset
				state<=switches(3 downto 0);     --S1 as the idle state
			elsif (rising_edge(signal_clk)) then			
				state<=state_next;
					if(state_next=S6) then
						leds(7)<='1';
					else
						leds(7)<='0';
					end if;
			end if;
		end process;

pr2:	process
		begin
		wait until signal_clk'event and signal_clk='1';
		
		if (state=S1) then
			state_next<=S15;	
		elsif (state=S15) then
			state_next<=S2;	
		elsif (state=S2) then
			state_next<=S13;	
		elsif (state=S13) then
			state_next<=S3;	
		elsif (state=S3) then
			state_next<=S12;	
		elsif (state=S12) then
			state_next<=S4;
		elsif (state=S4) then
			state_next<=S10;	
		elsif (state=S10) then
			state_next<=S5;	
		elsif (state=S5) then
			state_next<=S9;
		elsif (state=S9) then
			state_next<=S6;	
		elsif (state=S6) then
			state_next<=S7;	
		elsif (state=S7) then
			state_next<=S1;	
		else
			state_next<=S1;  --S1 idle State
			
		end if;
		end process;

pr3: process(clock)
		begin
		if rising_edge(clock) then
		count<=count+1;
		
			if count=MAX_VALUE then
				signal_clk<='1';
				count<=(others=>'0');
			else
				signal_clk<='0';
			end if;
		end if;
		end process;

end Behavioral;


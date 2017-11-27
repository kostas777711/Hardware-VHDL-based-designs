----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Konstantinos Tsimpoukas
-- 
-- Create Date:    18:23:11 11/21/2010 
-- Design Name: 		assignment stage 4
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
		generic (choice:std_logic_vector(7 downto 0):=X"12"); --18 mine
    Port ( clock : in  STD_LOGIC;
           buttons : in  STD_LOGIC_VECTOR (3 downto 0);
           switches : in  STD_LOGIC_VECTOR (7 downto 0);    
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
	signal signal_clk:std_logic;         			--this is the new delayed clock
	--signal choice:std_logic_vector(7 downto 0):=X"01";   			--choose the student's ID with this variable
	signal count:STD_LOGIC_VECTOR(31 downto 0):=(others=>'0'); 
	
	constant MAX_VALUE:STD_LOGIC_VECTOR(31 downto 0):=X"01FFFFFF";  --delay in order to see the changes in the LEDS
	
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

dd:display port map (segs=>segments, number=>state);
leds(3 downto 0)<=state;

--Initializing Unused Outputs
leds(6 downto 4)<="000";   
digit(3 downto 0)<="1110";
--segments(7 downto 0)<=X"FF";

pr1: process (signal_clk,buttons)
		begin
			
			if (rising_edge(signal_clk)) then 
			
				if(buttons="0001") then     --this is button 0        --force unused (switches must be already set in the right positions)
					state<=switches(3 downto 0);                 --i have to push reset for a big amount of time to go to the next that i already picked quickly
				--elsif (buttons="0010") then	  --this is button 1    --select choice (switches must be already set in the right positions)
				  --choice<=switches(7 downto 0);
				else 
					state<=state_next;      
				end if;
			end if;
		end process;

pr2: process(clock,count)
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

choice_process:
	process(signal_clk)
	begin
	if (rising_edge(signal_clk)) then
		
		if ( choice=X"01" or choice=X"02" or choice=X"03" or choice=X"13" 
					or choice=X"16" or choice=X"17" or choice=X"19" or choice=X"1A" 
					or choice=X"1C" or choice=X"1F" or choice=X"22") then
						if(state_next=S13) then
							leds(7)<='1';
						else
							leds(7)<='0';
						end if;
				elsif(choice=X"04" or choice=X"05" or choice=X"06" or choice=X"14" or choice=X"1B"
					or choice=X"1D" or choice=X"1E" or choice=X"20" ) then
						if(state_next=S12) then
							leds(7)<='1';
						else
							leds(7)<='0';
						end if;
				elsif(choice=X"07" or choice=X"08" or choice=X"15" or choice=X"18" or choice=X"21") then
						if(state_next=S11) then
							leds(7)<='1';
						else
							leds(7)<='0';
						end if;
				elsif(choice=X"09" or choice=X"0A" or choice=X"0B" or choice=X"0C") then
						if(state_next=S10) then
							leds(7)<='1';
						else
							leds(7)<='0';
						end if;
				elsif(choice=X"0D" ) then
						if(state_next=S7)then
							leds(7)<='1';
						else
							leds(7)<='0';
						end if;
				elsif(choice=X"0E" or choice=X"0F" ) then
						if(state_next=S8) then
							leds(7)<='1';
						else
							leds(7)<='0';
						end if;
				elsif (choice=X"10" or choice=X"11" or choice=X"12") then
						if(state_next=S6) then
							leds(7)<='1';
						else
							leds(7)<='0';
						end if;
				else 
					if(state_next=S12) then
							leds(7)<='1';
						else
							leds(7)<='0';
						end if;
				end if;	
		
		if (choice="00000001") then     --n=1
			if (state=S2) then state_next<=S13;		
			elsif (state=S13) then state_next<=S4;		
			elsif (state=S4) then state_next<=S12;		
			elsif (state=S12) then state_next<=S5;		
			elsif (state=S5) then state_next<=S11;		
			elsif (state=S11) then state_next<=S7;	
			elsif (state=S7) then state_next<=S9;		
			elsif (state=S9) then state_next<=S8;		
			elsif (state=S8) then state_next<=S2;		
			else state_next<=S2;  --S2 idle State
			end if;
		elsif (choice="00000010") then  --n=2
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S3;		
			elsif (state=S3) then state_next<=S14;		
			elsif (state=S14) then state_next<=S5;		
			elsif (state=S5) then state_next<=S13;		
			elsif (state=S13) then state_next<=S7;	
			elsif (state=S7) then state_next<=S12;		
			elsif (state=S12) then state_next<=S8;		
			elsif (state=S8) then state_next<=S11;
			elsif (state=S11) then state_next<=S10;
			elsif (state=S10) then state_next<=S1;			
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00000011") then  --n=3
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S14;		
			elsif (state=S14) then state_next<=S4;		
			elsif (state=S4) then state_next<=S13;		
			elsif (state=S13) then state_next<=S5;	
			elsif (state=S5) then state_next<=S12;		
			elsif (state=S12) then state_next<=S7;		
			elsif (state=S7) then state_next<=S11;
			elsif (state=S11) then state_next<=S8;
			elsif (state=S8) then state_next<=S10;		
			elsif (state=S10) then state_next<=S1;		
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00000100") then	--n=4
			if (state=S3) then state_next<=S13;			
			elsif (state=S13) then state_next<=S4;		
			elsif (state=S4) then state_next<=S12;		
			elsif (state=S12) then state_next<=S5;		
			elsif (state=S5) then state_next<=S11;	
			elsif (state=S11) then state_next<=S9;		
			elsif (state=S9) then state_next<=S7;		
			elsif (state=S7) then state_next<=S8;
			elsif (state=S8) then state_next<=S3;		
			else state_next<=S3;  --S3 idle State
			end if;
		elsif (choice="00000101") then	--n=5
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S14;		
			elsif (state=S14) then state_next<=S4;		
			elsif (state=S4) then state_next<=S13;		
			elsif (state=S13) then state_next<=S6;	
			elsif (state=S6) then state_next<=S12;		
			elsif (state=S12) then state_next<=S8;		
			elsif (state=S8) then state_next<=S10;
			elsif (state=S10) then state_next<=S9;
			elsif (state=S9) then state_next<=S1;				
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00000110") then  --n=6
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S14;		
			elsif (state=S14) then state_next<=S3;		
			elsif (state=S3) then state_next<=S13;		
			elsif (state=S13) then state_next<=S5;	
			elsif (state=S5) then state_next<=S12;		
			elsif (state=S12) then state_next<=S6;		
			elsif (state=S6) then state_next<=S11;
			elsif (state=S11) then state_next<=S9;
			elsif (state=S9) then state_next<=S8;		
			elsif (state=S8) then state_next<=S1;		
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00000111") then  --n=7
			if (state=S3) then state_next<=S13;		
			elsif (state=S13) then state_next<=S5;		
			elsif (state=S5) then state_next<=S12;		
			elsif (state=S12) then state_next<=S6;		
			elsif (state=S6) then state_next<=S11;		
			elsif (state=S11) then state_next<=S7;	
			elsif (state=S7) then state_next<=S9;		
			elsif (state=S9) then state_next<=S8;		
			elsif (state=S8) then state_next<=S3;		
			else state_next<=S3;  --S3 idle State
			end if;
		elsif (choice="00001000") then	--n=8
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S14;		
			elsif (state=S14) then state_next<=S3;		
			elsif (state=S3) then state_next<=S13;		
			elsif (state=S13) then state_next<=S5;	
			elsif (state=S5) then state_next<=S11;		
			elsif (state=S11) then state_next<=S7;		
			elsif (state=S7) then state_next<=S10;
			elsif (state=S10) then state_next<=S9;
			elsif (state=S9) then state_next<=S1;				
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00001001") then	--n=9
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S14;		
			elsif (state=S14) then state_next<=S3;		
			elsif (state=S3) then state_next<=S13;		
			elsif (state=S13) then state_next<=S4;	
			elsif (state=S4) then state_next<=S12;		
			elsif (state=S12) then state_next<=S6;		
			elsif (state=S6) then state_next<=S10;
			elsif (state=S10) then state_next<=S7;
			elsif (state=S7) then state_next<=S9;		
			elsif (state=S9) then state_next<=S1;		
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00001010") then	--n=10
			if (state=S3) then state_next<=S13;		
			elsif (state=S13) then state_next<=S5;		
			elsif (state=S5) then state_next<=S12;				
			elsif (state=S12) then state_next<=S6;		
			elsif (state=S6) then state_next<=S11;	
			elsif (state=S11) then state_next<=S7;		
			elsif (state=S7) then state_next<=S10;		
			elsif (state=S10) then state_next<=S8;
			elsif (state=S8) then state_next<=S3;		
			else state_next<=S3;  --S3 idle State
			end if;
		elsif (choice="00001011") then	--n=11
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S14;		
			elsif (state=S14) then state_next<=S3;		
			elsif (state=S3) then state_next<=S12;		
			elsif (state=S12) then state_next<=S4;	
			elsif (state=S4) then state_next<=S11;		
			elsif (state=S11) then state_next<=S6;		
			elsif (state=S6) then state_next<=S10;
			elsif (state=S10) then state_next<=S8;
			elsif (state=S8) then state_next<=S1;			
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00001100") then	--n=12
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S14;		
			elsif (state=S14) then state_next<=S3;		
			elsif (state=S3) then state_next<=S13;		
			elsif (state=S13) then state_next<=S4;	
			elsif (state=S4) then state_next<=S11;		
			elsif (state=S11) then state_next<=S5;		
			elsif (state=S5) then state_next<=S10;
			elsif (state=S10) then state_next<=S7;
			elsif (state=S7) then state_next<=S8;		
			elsif (state=S8) then state_next<=S1;		
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00001101") then	--n=13
			if (state=S3) then state_next<=S14;		
			elsif (state=S14) then state_next<=S5;		
			elsif (state=S5) then state_next<=S12;		
			elsif (state=S12) then state_next<=S6;		
			elsif (state=S6) then state_next<=S11;		
			elsif (state=S11) then state_next<=S7;	
			elsif (state=S7) then state_next<=S10;		
			elsif (state=S10) then state_next<=S8;		
			elsif (state=S8) then state_next<=S3;		
			else state_next<=S3;  --S3 idle State
			end if;
		elsif (choice="00001110") then	--n=14
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S13;		
			elsif (state=S13) then state_next<=S3;		
			elsif (state=S3) then state_next<=S12;		
			elsif (state=S12) then state_next<=S4;	
			elsif (state=S4) then state_next<=S10;		
			elsif (state=S10) then state_next<=S5;		
			elsif (state=S5) then state_next<=S8;
			elsif (state=S8) then state_next<=S6;
			elsif (state=S6) then state_next<=S1;				
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00001111") then	--n=15
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S14;		
			elsif (state=S14) then state_next<=S3;		
			elsif (state=S3) then state_next<=S12;		
			elsif (state=S12) then state_next<=S4;	
			elsif (state=S4) then state_next<=S11;		
			elsif (state=S11) then state_next<=S5;		
			elsif (state=S5) then state_next<=S9;
			elsif (state=S9) then state_next<=S6;
			elsif (state=S6) then state_next<=S8;		
			elsif (state=S8) then state_next<=S1;		
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00010000") then	--n=16
			if (state=S3) then state_next<=S14;		
			elsif (state=S14) then state_next<=S5;		
			elsif (state=S5) then state_next<=S13;		
			elsif (state=S13) then state_next<=S6;		
			elsif (state=S6) then state_next<=S11;		
			elsif (state=S11) then state_next<=S7;	
			elsif (state=S7) then state_next<=S10;		
			elsif (state=S10) then state_next<=S8;		
			elsif (state=S8) then state_next<=S3;
			else state_next<=S3;  --S3 idle State
			end if;
		elsif (choice="00010001") then	--n=17
			if (state=S1) then state_next<=S14;		
			elsif (state=S14) then state_next<=S2;		
			elsif (state=S2) then state_next<=S13;		
			elsif (state=S13) then state_next<=S3;		
			elsif (state=S3) then state_next<=S11;		
			elsif (state=S11) then state_next<=S4;	
			elsif (state=S4) then state_next<=S9;		
			elsif (state=S9) then state_next<=S5;		
			elsif (state=S5) then state_next<=S7;
			elsif (state=S7) then state_next<=S6;
			elsif (state=S6) then state_next<=S1;			
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00010010") then	--n=18
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S13;		
			elsif (state=S13) then state_next<=S3;		
			elsif (state=S3) then state_next<=S12;		
			elsif (state=S12) then state_next<=S4;	
			elsif (state=S4) then state_next<=S10;		
			elsif (state=S10) then state_next<=S5;		
			elsif (state=S5) then state_next<=S9;
			elsif (state=S9) then state_next<=S6;
			elsif (state=S6) then state_next<=S7;		
			elsif (state=S7) then state_next<=S1;		
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00010011") then	--n=19
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S3;		
			elsif (state=S3) then state_next<=S14;		
			elsif (state=S14) then state_next<=S5;		
			elsif (state=S5) then state_next<=S13;		
			elsif (state=S13) then state_next<=S7;	
			elsif (state=S7) then state_next<=S11;		
			elsif (state=S11) then state_next<=S9;		
			elsif (state=S9) then state_next<=S1;		
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00010100") then	--n=20
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S3;		
			elsif (state=S3) then state_next<=S14;		
			elsif (state=S14) then state_next<=S5;		
			elsif (state=S5) then state_next<=S13;		
			elsif (state=S13) then state_next<=S7;	
			elsif (state=S7) then state_next<=S12;		
			elsif (state=S12) then state_next<=S8;		
			elsif (state=S8) then state_next<=S11;
			elsif (state=S11) then state_next<=S9;
			elsif (state=S9) then state_next<=S1;				
			else state_next<=S1;  --S1 idle State
			end if;		
		elsif (choice="00010101") then	--n=21
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S13;		
			elsif (state=S13) then state_next<=S3;		
			elsif (state=S3) then state_next<=S11;		
			elsif (state=S11) then state_next<=S4;	
			elsif (state=S4) then state_next<=S10;		
			elsif (state=S10) then state_next<=S5;		
			elsif (state=S5) then state_next<=S8;
			elsif (state=S8) then state_next<=S6;
			elsif (state=S6) then state_next<=S7;
			elsif (state=S7) then state_next<=S1;				
			else state_next<=S1;  --S1 idle State
			end if;	
		elsif (choice="00010110") then	--n=22
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S3;		
			elsif (state=S3) then state_next<=S13;		
			elsif (state=S13) then state_next<=S5;		
			elsif (state=S5) then state_next<=S12;		
			elsif (state=S12) then state_next<=S7;	
			elsif (state=S7) then state_next<=S11;		
			elsif (state=S11) then state_next<=S9;		
			elsif (state=S9) then state_next<=S1;				
			else state_next<=S1;  --S1 idle State
			end if;	
		elsif (choice="00010111") then	--n=23
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S14;		
			elsif (state=S14) then state_next<=S4;		
			elsif (state=S4) then state_next<=S13;		
			elsif (state=S13) then state_next<=S6;	
			elsif (state=S6) then state_next<=S10;		
			elsif (state=S10) then state_next<=S7;		
			elsif (state=S7) then state_next<=S9;
			elsif (state=S9) then state_next<=S8;		
			elsif (state=S8) then state_next<=S1;				
			else state_next<=S1;  --S1 idle State
			end if;	
		elsif (choice="00011000") then	--n=24
			if (state=S1) then state_next<=S14;		
			elsif (state=S14) then state_next<=S2;		
			elsif (state=S2) then state_next<=S13;		
			elsif (state=S13) then state_next<=S3;		
			elsif (state=S3) then state_next<=S11;		
			elsif (state=S11) then state_next<=S4;	
			elsif (state=S4) then state_next<=S9;		
			elsif (state=S9) then state_next<=S5;		
			elsif (state=S5) then state_next<=S8;
			elsif (state=S8) then state_next<=S6;		
			elsif (state=S6) then state_next<=S7;
			elsif (state=S7) then state_next<=S1;				
			else state_next<=S1;  --S1 idle State
			end if;	
		elsif (choice="00011001") then	--n=25
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S13;		
			elsif (state=S13) then state_next<=S3;		
			elsif (state=S3) then state_next<=S11;		
			elsif (state=S11) then state_next<=S5;	
			elsif (state=S5) then state_next<=S9;		
			elsif (state=S9) then state_next<=S7;		
			elsif (state=S7) then state_next<=S1;				
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00011010") then	--n=26
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S14;		
			elsif (state=S14) then state_next<=S3;		
			elsif (state=S3) then state_next<=S13;		
			elsif (state=S13) then state_next<=S5;	
			elsif (state=S5) then state_next<=S11;		
			elsif (state=S11) then state_next<=S7;				
			elsif (state=S7) then state_next<=S10;
			elsif (state=S10) then state_next<=S9;	
			elsif (state=S9) then state_next<=S1;			
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00011011") then	--n=27
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S14;		
			elsif (state=S14) then state_next<=S4;		
			elsif (state=S4) then state_next<=S13;		
			elsif (state=S13) then state_next<=S5;	
			elsif (state=S5) then state_next<=S12;		
			elsif (state=S12) then state_next<=S7;				
			elsif (state=S7) then state_next<=S11;
			elsif (state=S11) then state_next<=S8;	
			elsif (state=S8) then state_next<=S9;
			elsif (state=S9) then state_next<=S1;			
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00011100") then	--n=28
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S3;		
			elsif (state=S3) then state_next<=S13;		
			elsif (state=S13) then state_next<=S4;		
			elsif (state=S4) then state_next<=S11;		
			elsif (state=S11) then state_next<=S5;	
			elsif (state=S5) then state_next<=S9;		
			elsif (state=S9) then state_next<=S7;				
			elsif (state=S7) then state_next<=S1;			
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00011101") then	--n=29
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S13;		
			elsif (state=S13) then state_next<=S3;		
			elsif (state=S3) then state_next<=S12;		
			elsif (state=S12) then state_next<=S4;	
			elsif (state=S4) then state_next<=S11;		
			elsif (state=S11) then state_next<=S6;				
			elsif (state=S6) then state_next<=S10;
			elsif (state=S10) then state_next<=S8;		
			elsif (state=S8) then state_next<=S1;							
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00011110") then	--n=30
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S14;		
			elsif (state=S14) then state_next<=S3;		
			elsif (state=S3) then state_next<=S13;		
			elsif (state=S13) then state_next<=S5;	
			elsif (state=S5) then state_next<=S12;		
			elsif (state=S12) then state_next<=S6;				
			elsif (state=S6) then state_next<=S10;
			elsif (state=S10) then state_next<=S8;		
			elsif (state=S8) then state_next<=S9;
			elsif (state=S9) then state_next<=S1;							
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00011111") then	--n=31
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S3;		
			elsif (state=S3) then state_next<=S13;		
			elsif (state=S13) then state_next<=S5;		
			elsif (state=S5) then state_next<=S11;		
			elsif (state=S11) then state_next<=S6;	
			elsif (state=S6) then state_next<=S9;		
			elsif (state=S9) then state_next<=S7;				
			elsif (state=S7) then state_next<=S1;						
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00100000") then	--n=32
			if (state=S1) then state_next<=S14;		
			elsif (state=S14) then state_next<=S2;		
			elsif (state=S2) then state_next<=S13;		
			elsif (state=S13) then state_next<=S3;		
			elsif (state=S3) then state_next<=S12;		
			elsif (state=S12) then state_next<=S4;	
			elsif (state=S4) then state_next<=S10;		
			elsif (state=S10) then state_next<=S5;				
			elsif (state=S5) then state_next<=S8;
			elsif (state=S8) then state_next<=S6;		
			elsif (state=S6) then state_next<=S1;							
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00100001") then	--n=33
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S2;		
			elsif (state=S2) then state_next<=S14;		
			elsif (state=S14) then state_next<=S3;		
			elsif (state=S3) then state_next<=S13;		
			elsif (state=S13) then state_next<=S4;	
			elsif (state=S4) then state_next<=S11;		
			elsif (state=S11) then state_next<=S6;				
			elsif (state=S6) then state_next<=S10;
			elsif (state=S10) then state_next<=S7;		
			elsif (state=S7) then state_next<=S9;
			elsif (state=S9) then state_next<=S1;							
			else state_next<=S1;  --S1 idle State
			end if;
		elsif (choice="00100010") then	--n=34
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S3;		
			elsif (state=S3) then state_next<=S13;		
			elsif (state=S13) then state_next<=S5;		
			elsif (state=S5) then state_next<=S11;		
			elsif (state=S11) then state_next<=S7;	
			elsif (state=S7) then state_next<=S9;		
			elsif (state=S9) then state_next<=S8;				
			elsif (state=S8) then state_next<=S1;						
			else state_next<=S1;  --S1 idle State
			end if;	
		else 	--n=35
			if (state=S1) then state_next<=S15;		
			elsif (state=S15) then state_next<=S3;		
			elsif (state=S3) then state_next<=S14;		
			elsif (state=S14) then state_next<=S5;		
			elsif (state=S5) then state_next<=S13;		
			elsif (state=S13) then state_next<=S7;	
			elsif (state=S7) then state_next<=S12;		
			elsif (state=S12) then state_next<=S8;				
			elsif (state=S8) then state_next<=S10;
			elsif (state=S10) then state_next<=S9;		
			elsif (state=S9) then state_next<=S1;							
			else state_next<=S1;  --S1 idle State
			end if;

		end if;
	end if;
	
	
	end process;

end Behavioral;


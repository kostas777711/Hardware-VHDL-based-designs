----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Konstantinos Tsimpoukas
-- 
-- Create Date:    18:23:11 11/21/2010 
-- Design Name: 		assignment stage 2
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
           buttons : in  STD_LOGIC_VECTOR (3 downto 0);     --button0=reset button1=restart button2=set the n*1/4 sec to action
           switches : in  STD_LOGIC_VECTOR (7 downto 0);    --switches for 2 purposes (force state and input n binary number)
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
				  number : in  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	signal state,state_next : STD_LOGIC_VECTOR(3 downto 0);  
	signal signal_clk:std_logic;                         --this is the delayed clock that i program
	signal n:STD_LOGIC_VECTOR(7 downto 0):=X"01";                --here i will store the n binary number 
	signal TOTAL_DELAY:STD_LOGIC_VECTOR(39 downto 0):=X"0000BEBC20";    --here i will store the n*1/4 seconds  (40 bits=8 bits x 32 bits)
	signal count:STD_LOGIC_VECTOR(31 downto 0);                --this is the counter variable to delay the clock
	constant DELAY:STD_LOGIC_VECTOR(31 downto 0):=X"00BEBC20";  --delay 1/4 sec (50000000/4->to HEX=BEBC20)
	
	--definition of the states
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


TOTAL_DELAY<=n*DELAY;
--states always look to the first 4 LEDS
leds(3 downto 0)<=state;

--Initializing Unused Outputs
leds(6 downto 4)<="000";   
digit(3 downto 0)<="1110";
--segments(7 downto 0)<=X"FF";

dd : display port map(segs => segments, number => n);

pr1: process (signal_clk,switches)
		begin
			
			if(buttons="0001") then          --if (button(0)=ON) force state from the position that the switches (3 downto 0) have
				state<=switches(3 downto 0);   --S1 as the idle state in our FSM Design
			elsif (buttons="0010") then       --if (button(1)=ON) take the n binary number from the positions of the switches that they already have
			   n<=switches(7 downto 0);        
			--elsif (buttons="0100") then      --if (button(2)=ON) Give TOTAL_DELAY the final price
				--TOTAL_DELAY<=n+DELAY;
			elsif (rising_edge(signal_clk)) then		--here is the main function of the program	
				state<=state_next;							--state_next looks always in the state
					if(state_next=S6) then						--if (state=S6)--> Output(leds(7))='1'
						leds(7)<='1';								--else Output(leds(7))='0'
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
			state_next<=S1;        --use S1 as the Idle State
			
		end if;
		end process;

pr3: process(clock)             --this is the process in which i produce the delayed clock(signal_clk)
		begin
		if rising_edge(clock) then
		count<=count+1;
		
			if (count=TOTAL_DELAY) then      --TOTAL_DELAY = n*DELAY = n*1/4 seconds 
				signal_clk<='1';
				count<=(others=>'0');
			elsif(count>TOTAL_DELAY) then
				count<=(others=>'0');
			elsif(count<TOTAL_DELAY) then
				signal_clk<='0';
			end if;
		end if;
		end process;
		
		

end Behavioral;


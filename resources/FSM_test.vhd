LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

ENTITY FSM_test IS
	PORT(
		clk,reset  	  : IN std_logic;
		gameSel		  : IN std_logic;
		trainSel		  : IN std_logic;
		pauseSel      : IN std_logic;
		winState      : IN std_logic;
		loseState     : IN std_logic;
		menuSel			: IN std_logic;
		replaySel		: IN std_logic;
		trainingM   	: OUT std_logic;
		output			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END ENTITY FSM_test;

architecture Mealy of FSM_test is 
type state_type is (main_menu, pause, gameplay, win, lose, training);
signal state, next_state : state_type;
signal trainingMode : STD_LOGIC;
signal test: STD_LOGIC;

constant mainOut 		: STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
constant trainOut 	: STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
constant gameOut 		: STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
constant pauseOut 	: STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
constant winOut 		: STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
constant loseOut 		: STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";

BEGIN
	trainingM <= test;
	
	SYNC_PROC: process(clk)
	BEGIN
		if rising_edge(clk) then
			if(reset = '1') then
				state <= main_menu;
		else 
			state <= next_state;
		end if;
	end if;
end process;

OUTPUT_DECODE : process(state)
	variable vtrainingMode : STD_LOGIC := '0';
BEGIN
	
	output <= mainOut;
	case(state) is 	
		when main_menu =>
			output <= mainOut;
			
		when training => 
			vtrainingMode := '1';
			output <= trainOut;
			
		when gameplay =>
			vtrainingMode := '0';
			output <= gameOut;
			
		when pause => 
			output <= pauseOut;
			
		when win => 
			output <= winOut;
			
		when lose => 
			output <= loseOut;
			
		when others =>
			output <= mainOut;
	end case;
	
	trainingMode <= vtrainingMode;
end process;

NEXT_STATE_DECODE : process(state, gameSel, trainSel, pauseSel, winState, loseState, menuSel, replaySel)
BEGIN
	next_state <= main_menu;
	case(state) is 
	
		when main_menu =>
			if gameSel = '1' and trainSel = '0' then
				next_state <= gameplay;
			elsif gameSel = '0' and trainSel = '1' then
				next_state <= training;
			else
				next_state <= main_menu;
			end if;
		
		when training => 
			if pauseSel = '1' then
				next_state <= pause;
			else
				next_state <= training;
			end if;
			
		when gameplay =>
			if pauseSel = '1' and winState = '0' and loseState = '0' then
				next_state <= pause;
			elsif winState = '1' and loseState = '0' then
				next_state <= win;
			elsif winState = '0' and loseState = '1' then
				next_state <= lose;
			else
				next_state <= gameplay;
			end if; 
			
		when pause => 
			if gameSel = '1' and trainSel = '0' and trainingMode = '1' then
				next_state <= training;
			elsif gameSel = '1' and trainSel = '0' and trainingMode = '0' then
				next_state <= gameplay;
			elsif menuSel = '1' then
				next_state <= main_menu;
			else
				next_state <= pause;
			end if;
			
		when win => 
			if menuSel = '1' and replaySel = '0' then
				next_state <= main_menu;
			elsif menuSel = '0' and replaySel = '1' then
				next_state <= gameplay;
			else
				next_state <= win;
			end if;
			
		when lose => 
			if menuSel = '1' and replaySel = '0' then
				next_state <= main_menu;
			elsif menuSel = '0' and replaySel = '1' then
				next_state <= gameplay;
			else
				next_state <= lose;
			end if;
		when others =>
			next_state <= main_menu;
	end case;
end process;
end Mealy;
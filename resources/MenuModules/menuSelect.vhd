LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

ENTITY menuSelect IS

	PORT(	
		selected                                                                         : IN STD_logic_VECTOR(2 DOWNTO 0);
		title_1, title_2, title_3, title_4, options_1, options_2, options_3, options_4  	: IN std_logic;
		title, option								                                             : OUT std_logic
	);
END ENTITY menuSelect;

architecture behaviour of menuSelect is
	BEGIN
	
	-- Assign corresponding titles and option texts to the start component depending on the FSM input
	title  <= title_1 when selected = "000" else
	          title_2 when selected = "011" else
				 title_3 when selected = "101" else
			  	 title_4 when selected = "100" else
				 '0';
				
	option <= options_1 when selected = "000" else
	          options_2 when selected = "011" else
				 options_3 when selected = "101" else
			  	 options_4 when selected = "100" else
				 '0';
				 
END architecture behaviour;
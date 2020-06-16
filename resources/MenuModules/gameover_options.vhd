LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

ENTITY gameover_options IS
	GENERIC (
		INT_ADDRESS 		: integer range 0 to 77 := 2;
		TEXT_POS_X 			: integer range 0 to 20 := 8;
		TEXT_POS_Y 			: integer range 0 to 20 := 8
	);
	
	PORT(
		pixel_column, pixel_row 	: IN STD_logic_VECTOR(9 DOWNTO 0);
		address							: OUT std_logic_vector(5 DOWNTO 0);
		text_row, text_column		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END ENTITY gameover_options;

architecture behaviour of gameover_options is

	signal outOn_Sig : std_logic;
	signal MENU_POS_X : integer range 0 to 10 ;
	
	type menu_array is array (0 to 3) of STD_logic_VECTOR(5 downto 0);
	signal MENU_word : menu_array := (0 => CONV_STD_LOGIC_VECTOR(13, 6), 
												 1 => CONV_STD_LOGIC_VECTOR(5, 6), 
												 2 => CONV_STD_LOGIC_VECTOR(14, 6), 
												 3 => CONV_STD_LOGIC_VECTOR(21, 6));
												 
												 
	type replay_array is array (0 to 5) of STD_logic_VECTOR(5 downto 0);
	signal REPLAY_word : replay_array := (0 => CONV_STD_LOGIC_VECTOR(18, 6), 
												   1 => CONV_STD_LOGIC_VECTOR(5, 6), 
												   2 => CONV_STD_LOGIC_VECTOR(16, 6), 
												   3 => CONV_STD_LOGIC_VECTOR(12, 6),
													4 => CONV_STD_LOGIC_VECTOR(1, 6),
													5 => CONV_STD_LOGIC_VECTOR(25, 6));
	
	BEGIN
		MENU_POS_X <= TEXT_POS_X - 1;
		
		outOn_Sig <= '1' when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR(TEXT_POS_X, 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 10))) else
						 '1' when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +1), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 10)))   else 
						 '1' when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +2), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 10)))   else 
						 '1' when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +3), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 10)))   else 
						 
						 '1' when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR(MENU_POS_X, 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y+3), 10)))   else 
						 '1' when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((MENU_POS_X +1), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y+3), 10)))   else 
						 '1' when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((MENU_POS_X +2), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y+3), 10)))   else 
						 '1' when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((MENU_POS_X +3), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y+3), 10)))   else 
						 '1' when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((MENU_POS_X +4), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y+3), 10)))   else 
						 '1' when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((MENU_POS_X +5), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y+3), 10)))   else 
						 
					    '0';
					
		text_column	<= pixel_column(4 DOWNTO 2) when outOn_Sig = '1' else
							"000";
							
		text_row		<= pixel_row(4 DOWNTO 2) when outOn_Sig = '1' else
							"000";
		ADDRESS <= MENU_word(0) when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR(TEXT_POS_X, 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 10))) else
					  MENU_word(1) when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +1), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 10))) else
					  MENU_word(2) when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +2), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 10))) else
					  MENU_word(3) when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +3), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 10))) else
					  
					  REPLAY_word(0) when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR(MENU_POS_X, 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y + 3), 10))) else
					  REPLAY_word(1) when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((MENU_POS_X +1), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y + 3), 10))) else
					  REPLAY_word(2) when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((MENU_POS_X +2), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y + 3), 10))) else
					  REPLAY_word(3) when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((MENU_POS_X +3), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y + 3), 10))) else
					  REPLAY_word(4) when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((MENU_POS_X +4), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y + 3), 10))) else
					  REPLAY_word(5) when ((pixel_column(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((MENU_POS_X +5), 10)) and (pixel_row(9 DOWNTO 5) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y + 3), 10))) else
					  
					  
					  "000000";
					 
end architecture behaviour;

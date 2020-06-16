LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

ENTITY paused_title IS
	GENERIC (
		INT_ADDRESS 		: integer range 0 to 77 := 2;
		TEXT_POS_X 			: integer range 0 to 10 := 2;
		TEXT_POS_Y 			: integer range 0 to 10 := 1
	);
	
	PORT(
		pixel_column, pixel_row 	: IN STD_logic_VECTOR(9 DOWNTO 0);
		address							: OUT std_logic_vector(5 DOWNTO 0);
		text_row, text_column		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END ENTITY paused_title;

architecture behaviour of paused_title is

	signal outOn_Sig : std_logic;
	
	type paused_array is array (0 to 5) of STD_logic_VECTOR(5 downto 0);
	signal PAUSED_word : paused_array := (0 => CONV_STD_LOGIC_VECTOR(16, 6), 
													  1 => CONV_STD_LOGIC_VECTOR(1, 6), 
													  2 => CONV_STD_LOGIC_VECTOR(21, 6), 
													  3 => CONV_STD_LOGIC_VECTOR(19, 6), 
													  4 => CONV_STD_LOGIC_VECTOR(5, 6), 
													  5 => CONV_STD_LOGIC_VECTOR(4, 6));
	
	
	BEGIN
		
		outOn_Sig <= '1' when ((pixel_column(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR(TEXT_POS_X, 4)) and (pixel_row(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR(TEXT_POS_Y, 4))) else
						 '1' when ((pixel_column(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +1), 4)) and (pixel_row(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 4)))   else 
						 '1' when ((pixel_column(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +2), 4)) and (pixel_row(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 4)))   else 
						 '1' when ((pixel_column(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +3), 4)) and (pixel_row(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 4)))   else 
						 '1' when ((pixel_column(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +4), 4)) and (pixel_row(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 4)))   else 
						 '1' when ((pixel_column(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +5), 4)) and (pixel_row(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 4)))   else 
						 
					    '0';
					
		text_column	<= pixel_column(5 DOWNTO 3) when outOn_Sig = '1' else
							"000";
							
		text_row		<= pixel_row(5 DOWNTO 3) when outOn_Sig = '1' else
							"000";
		ADDRESS <= PAUSED_word(0) when ((pixel_column(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR(TEXT_POS_X, 4)) and (pixel_row(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR(TEXT_POS_Y, 4))) else
					  PAUSED_word(1) when ((pixel_column(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +1), 4)) and (pixel_row(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 4))) else
					  PAUSED_word(2) when ((pixel_column(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +2), 4)) and (pixel_row(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 4))) else
					  PAUSED_word(3) when ((pixel_column(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +3), 4)) and (pixel_row(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 4))) else
				     PAUSED_word(4) when ((pixel_column(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +4), 4)) and (pixel_row(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 4))) else
					  PAUSED_word(5) when ((pixel_column(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_X +5), 4)) and (pixel_row(9 DOWNTO 6) = CONV_STD_LOGIC_VECTOR((TEXT_POS_Y), 4))) else
					 
					"000000";
					 
end architecture behaviour;

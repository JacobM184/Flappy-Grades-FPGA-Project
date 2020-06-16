LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
--640 wide x 450 high

ENTITY start IS

	GENERIC (
		cursor_size_int 					: integer range 0 to 649 := 2;
		selectionBox_height_int 		: integer range 0 to 449 := 30;
		selectionBox_width_int 			: integer range 0 to 649 := 150;
		gap_size_int 						: integer range 0 to 649 := 90;
		GamePlayText_x_pos_int			: integer range 0 to 649 := 320;
		GamePlayText_y_pos_int			: integer range 0 to 649 := 270;
		reduce_int							: integer range 0 to 649 := 140
	);
	
	
	PORT
		(SIGNAL clk			 														: IN std_logic;
		 SIGNAL pixel_row, pixel_column, ball_y_pos, ball_x_pos		: IN std_logic_vector(9 DOWNTO 0);
		 SIGNAL left_button, right_button, title, options				: IN std_logic;
		 SIGNAL red_out, green_out, blue_out								: OUT std_logic_vector(3 DOWNTO 0);		
		 SIGNAL topBttn, bottomBttn, white 						         : OUT std_logic);		
END start;


architecture behavior of start is

SIGNAL cursor_on					: std_logic;

SIGNAL Training_on				: std_logic;
SIGNAL GamePlay_on				: std_logic;

SIGNAL GameplayHover_on 		: std_logic;
SIGNAL trainingHover_on 		: std_logic;


SIGNAL cursor_size, selectionBox_height, selectionBox_width, gap_size, GamePlayText_x_pos, GamePlayText_y_pos, TrainingText_x_pos, TrainingText_y_pos, reduce : std_logic_vector(9 DOWNTO 0); 			

SIGNAL situation        : std_logic_vector(7 DOWNTO 0);

SIGNAL red, green, blue : std_logic_vector(3 DOWNTO 0);

BEGIN           
cursor_size						<= CONV_STD_LOGIC_VECTOR(cursor_size_int,10);
selectionBox_height 			<= CONV_STD_LOGIC_VECTOR(selectionBox_height_int,10);
selectionBox_width 			<= CONV_STD_LOGIC_VECTOR(selectionBox_width_int,10);
gap_size 						<= CONV_STD_LOGIC_VECTOR(gap_size_int,10);
GamePlayText_x_pos 			<= CONV_STD_LOGIC_VECTOR(GamePlayText_x_pos_int,10);
GamePlayText_y_pos 			<= CONV_STD_LOGIC_VECTOR(GamePlayText_y_pos_int,10);
TrainingText_x_pos 			<= GamePlayText_x_pos;
TrainingText_y_pos 			<= GamePlayText_y_pos + gap_size;
reduce                     <= CONV_STD_LOGIC_VECTOR(reduce_int,10);


-- Defines the reigon where the cursor will be drawn
cursor_on <= '1' when ( ('0' & ball_x_pos <= pixel_column + cursor_size) and 
							  ('0' & pixel_column <= ball_x_pos + cursor_size) and
							  ('0' & ball_y_pos <= pixel_row + cursor_size)    and 
							  ('0' & pixel_row <= ball_y_pos + cursor_size) )  else
		    	'0';
				
				
-- Defines the reigon where the bottom button will be drawn				
Training_on <= '1' when ( ((('0' & TrainingText_x_pos - selectionBox_width <= pixel_column) and ('0' & pixel_column <= TrainingText_x_pos - reduce)) or
									(('0' & TrainingText_x_pos + reduce <= pixel_column) and ('0' & pixel_column <= TrainingText_x_pos + selectionBox_width))) and
									 ('0' & TrainingText_y_pos <= pixel_row + selectionBox_height) and ('0' & pixel_row <= TrainingText_y_pos + selectionBox_height) )  else	
					'0';
					
-- Defines the reigon where the top button will be drawn		
GamePlay_on <= '1' when ( ((('0' & GamePlayText_x_pos - selectionBox_width <= pixel_column) and ('0' & pixel_column <= GamePlayText_x_pos - reduce)) or
							  (('0' & GamePlayText_x_pos + reduce <= pixel_column) and ('0' & pixel_column <= GamePlayText_x_pos + selectionBox_width))) and
							  ('0' & GamePlayText_y_pos <= pixel_row + selectionBox_height) and ('0' & pixel_row <= GamePlayText_y_pos + selectionBox_height) )  else	
					'0';


-- Defines the reigon where the hovering will be drawn	
GameplayHover_on <= '1' when ( ( '0' & ball_x_pos <= GamePlayText_x_pos + selectionBox_width) and	
							  
							  ('0' & GamePlayText_x_pos <= ball_x_pos + selectionBox_width) and
							  
							  ('0' & ball_y_pos <= GamePlayText_y_pos + selectionBox_height) and	
							  
							  ('0' & GamePlayText_y_pos <= ball_y_pos + selectionBox_height) ) else
		    	        '0';

-- Defines the reigon where the hovering will be drawn
trainingHover_on <= '1' when ( ( '0' & ball_x_pos <= TrainingText_x_pos + selectionBox_width) and	
							  
							  ('0' & TrainingText_x_pos <= ball_x_pos + selectionBox_width) and
							  
							  ('0' & ball_y_pos <= TrainingText_y_pos + selectionBox_height) and	
							  
							  ('0' & TrainingText_y_pos <= ball_y_pos + selectionBox_height) ) else
		    	        '0';
					
-- Concatonates all the elements/conditions that exists in the menu
situation <= cursor_on & Training_on & GamePlay_on & GameplayHover_on & trainingHover_on & left_button & title & options;


red   	<= "1111" when ((situation = "10000000") or (situation = "10000100")) else -- (red) display cursor even when clicking 
				"0000" when situation = "00110000" else -- (green) display top button selection bars when hovering over
				"0000" when situation = "01001000" else -- (blue) display bottom button selection bars when hovering over
				"1111" when situation = "10010000" else -- (red) display cursor even when hovering over top button
				"1111" when situation = "10001000" else -- (red) display cursor even when hovering over bottom button
				"0000" when situation = "00110100" else -- (green + blue) display top button selection bars when hovering over and clicking
				"0000" when situation = "01001100" else -- (green + blue) display bottom button selection bars when hovering over and clicking
				
				"1111" when situation = "00000110" else -- (red) display title even when clicking
				"1111" when situation = "00000101" else -- (red) display options even when clicking
				
				
				-- title 
				"1111" when situation = "00000010" else -- (red + blue) display title 
				"1111" when situation = "00001010" else -- (red + blue) display title when hovering over bottom button
				"1111" when situation = "00010010" else -- (red + blue) display title when hovering over top button
				"1111" when situation = "00001110" else -- (red + blue) display title when hovering over bottom button and clicking
				"1111" when situation = "00010110" else -- (red + blue) display title when hovering over top button and clicking
				
				-- options
				"1111" when situation = "00000001" else -- (red + blue) display options 
				"1111" when situation = "00001001" else -- (red + blue) display options when hovering over bottom button
				"1111" when situation = "00010001" else -- (red + blue) display options when hovering over top button
				"1111" when situation = "00001101" else -- (red + blue) display options when hovering over bottom button and clicking
				"1111" when situation = "00010101" else -- (red + blue) display options when hovering over top button and clicking
				
				"1111"; -- (white) blank screen otherwise
				
---------------------------------------- same situations to green and blue ----------------------------------------------------------------
				
green 	<= "0000" when ((situation = "10000000") or (situation = "10000100")) else
				"1111" when situation = "00110000" else
				"0000" when situation = "01001000" else
				"0000" when situation = "10010000" else
				"0000" when situation = "10001000" else
				"1111" when situation = "00110100" else
				"1111" when situation = "01001100" else
				
				"0000" when situation = "00000110" else
				"0000" when situation = "00000101" else
				
				"0000" when situation = "00000010" else
				"0000" when situation = "00001010" else
				"0000" when situation = "00010010" else
				"0000" when situation = "00001110" else
				"0000" when situation = "00010110" else
				
				"0000" when situation = "00000001" else
				"0000" when situation = "00001001" else
				"0000" when situation = "00010001" else
				"0000" when situation = "00001101" else
				"0000" when situation = "00010101" else
				
				"1111";
				
blue  	<= "0000" when ((situation = "10000000") or (situation = "10000100")) else
				"0000" when situation = "00110000" else
				"1111" when situation = "01001000" else
				"0000" when situation = "10010000" else
				"0000" when situation = "10001000" else
				"1111" when situation = "00110100" else
				"1111" when situation = "01001100" else
				
				"0000" when situation = "00000110" else
				"1111" when situation = "00000101" else
				
				"0000" when situation = "00000010" else
				"0000" when situation = "00001010" else
				"0000" when situation = "00010010" else
				"0000" when situation = "00001110" else
				"0000" when situation = "00010110" else
				
				"1111" when situation = "00000001" else
				"1111" when situation = "00001001" else
				"1111" when situation = "00010001" else
				"1111" when situation = "00001101" else
				"1111" when situation = "00010101" else
				
				"1111";

-- Button press detection
topBttn 		 <= '0' when situation = "00110100" else 
					'1';
bottomBttn 	 <= '0' when situation = "01001100" else
					'1';

-- White detection			
white <= '1' when (red = "1111") and (green = "1111") and (blue = "1111") else
			'0';

-- Assign final Red Green and Blue values to output 
red_out    <= red;
green_out  <= green;
blue_out   <= blue;

END behavior;
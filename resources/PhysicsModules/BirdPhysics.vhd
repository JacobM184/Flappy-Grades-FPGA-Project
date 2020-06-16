library ieee;
use  ieee.std_logic_1164.all;
use  ieee.std_logic_arith.all;
use  ieee.std_logic_unsigned.all;


entity birdPhysics is
	port(v_sync, controlSig, Reset: in std_logic;
		 FSM : in std_logic_vector(2 downto 0);
		  rowOut : out signed(10 downto 0));
end entity birdPhysics;

architecture behaviour of birdPhysics is

	constant STARTINGROW : integer range 100 to 300 := 200; -- the starting row position of the bird
	constant TOPLIM : integer range 0 to 10 := 7; -- top limit of the bird (NOTE: This is designed assuming that row corresponds to top of bird)
	constant BOTTOMLIM : integer range 368 to 400 := 368; -- bottom limit of the bird (NOTE: This is designed assuming that row corresponds to top of bird)

	--placeholder signals for row and column of main character
	signal row : integer range 0 to 479 := STARTINGROW; -- set row to initial pos
	signal prevCntrl : std_logic := controlSig; -- set prevCntrl to control signal's value
	signal Pause : std_logic := '0';
	
begin

	Pause <= '1' when (FSM = "011") else
			 '0';
	
	-- process for motion of the main character
	process(v_sync)
	
		variable edgeDetect : std_logic := '0'; -- variable to signify edge
		variable jumpNum :integer := 0; -- variable to hold on to edge 
		variable start : std_logic := '0'; -- start signal
		variable enable : std_logic := '0'; --enable signal
		 
	begin
		-- on rising edge of divided clock
		if(rising_edge(v_sync)) then
		
			--if statement to check FSM State
			if((FSM = "001") or (FSM = "010")) then
				enable := '1';
			else
				enable := '0';
			end if;

			-- if statements to detect and hold on rising edge. 
			-- NOTE: currently set up to detect rising edge. Change controlSig and prevCntrl values to make it falling edge.
			if((controlSig = '1') and (prevCntrl = '0')) then
				edgeDetect := '1';
				start := '1';
				jumpNum := 0;
			else
				null;
			end if;
			
			-- If statement to reset bird position on low reset signal
			--NOTE: change condition to = '1' to use high reset signal
			if((Reset = '1')) then
				start := '0';
			end if;
			
			
			
			-- conditions for what happens when the required edge is detected
			if((edgeDetect = '1') and (row < BOTTOMLIM) and (row > TOPLIM) and (start = '1') and (enable = '1')) then
			
				-- parabolic function : (7 + (x^2)/5) range: 3 >= x >= 0 				
				for ii in 0 to 3 loop
					row <= row - (7 + (((3-ii) * (3-ii))/5));
				end loop;
				
				-- If statement to decide when to make edgeDetect low.
				-- currently set to high for 4 v_sync edges
				if(jumpNum > 4) then
					edgeDetect := '0';
				-- Disables jumping if row reaches top limit
				elsif (row < TOPLIM) then
					edgeDetect := '0';
				else
				-- increases jumpNum every cycle
					jumpNum := jumpNum + 1;
				end if;
			
				
			-- code for when bird reaches bottom or top limits
			elsif(((row >= BOTTOMLIM) or (row < TOPLIM)) and (start = '1')and (enable = '1')) then
				
				-- if statement to keep bird stuck to top or bottom as required
				if(row >= BOTTOMLIM) then
					row <= BOTTOMLIM;
				else
					row <= 0;
				end if;
				
			-- code for bird's falling motion	
			elsif((start = '1') and (row <= BOTTOMLIM) and (enable = '1')) then
			
				-- parabolic function : ((x^2)/5) range: 0 <= x <= 5
				for jj in 0 to 5 loop
					row <= row + (((jj) * (jj))/5);
				end loop;
				
			-- When Paused
			elsif(Pause = '1') then
				row <= row;
				
			-- code for all other conditions (i.e. start = '0')	
			else
				row <= STARTINGROW;	
			end if;
			
			-- update the previous state once the if statement is completed
			prevCntrl <= controlSig;
			
		else
			null;
		end if;
	end process;
	
	-- apply signal value to output
	rowOut <= conv_signed(row, 11);
	
end architecture behaviour;
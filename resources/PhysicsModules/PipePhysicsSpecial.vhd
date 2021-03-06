library ieee;
use  ieee.std_logic_1164.all;
use  ieee.std_logic_arith.all;
use  ieee.std_logic_unsigned.all;


entity pipePhysicsSpecial is
	generic(STARTROW : signed(10 downto 0) := conv_signed(250, 11);
			  STARTCOL : signed(10 downto 0) := conv_signed(639, 11);
			  STARTDIR : std_logic := '0'); -- gap starting position 
	port(v_sync, Reset: in std_logic;
		FSM : in std_logic_vector(2 downto 0);
		 rowOut, colOut : out signed(10 downto 0);
		 upScroll : out std_logic);
end entity pipePhysicsSpecial;

architecture behaviour of pipePhysicsSpecial is

	constant UPPERLIM : signed(10 downto 0) := conv_signed(160, 11); -- upper limit for bottom pipe's top
	constant LOWERLIM : signed(10 downto 0) := conv_signed(360, 11); -- lower limit for bottom pipe's top
	
	--placeholder signals for row and column of bottom pipe's top right corner
	signal col : signed(10 downto 0) := STARTCOL;
	signal row : signed(10 downto 0) := STARTROW;
	signal Pause : std_logic := '0';
	signal lfsr : std_logic_vector(5 downto 0) := conv_std_logic_vector(STARTROW, 6);
	signal subtractFRow : std_logic_vector(4 downto 0) := lfsr(5 downto 1);
	
begin

	Pause <= '1' when (FSM = "011") else
			 '0';
			 
	subtractFRow <= lfsr(5 downto 1);
	
	-- process for motion of the pipes
	process(v_sync)
		variable down : std_logic := STARTDIR; -- dictates direction of gap movement
		variable moveActive : std_logic := '1'; -- dictates when gap position changes
		variable enable : std_logic := '0';
		variable scrollspeed : signed(10 downto 0) := conv_signed(1, 11);-- change vector size if necessary)
		variable first : std_logic := '0';
		variable count : integer range 0 to 10 := 0;
	begin
		if(rising_edge(v_sync)) then
		
			--if statement to check FSM State
			if((FSM = "001") or (FSM = "010")) then
				enable := '1';
			else
				enable := '0';
			end if;
			
			if((Pause = '0') and (enable = '1')) then
				lfsr(5) <= lfsr(1) xor lfsr(2);
				lfsr(4) <= lfsr(5);
				lfsr(3) <= lfsr(4);
				lfsr(2) <= lfsr(3) xor lfsr(4);
				lfsr(1) <= lfsr(2);
			else
				null;
			end if;

		
			-- logic for moving gap between pillars
			-- when below upper limit
			if((row > UPPERLIM) and (down = '0') and (moveActive = '0') and (Pause = '0') and (enable = '1')) then
				row <= row - conv_signed(conv_integer(subtractFRow), 11);
				moveActive := '1';
			-- when above lower limit
			elsif((row < LOWERLIM) and (down = '1') and (moveActive = '0') and (Pause = '0') and (enable = '1')) then
				row <= row + conv_signed(conv_integer(subtractFRow), 11);
				moveActive := '1';
			-- when pipe is moving
			elsif(moveActive = '1') then
				row <= row;
			-- when below lower limit
			elsif((row >= LOWERLIM) and (moveActive = '0') and (Pause = '0') and (enable = '1')) then
				down := '0';
				row <= row - conv_signed(conv_integer(subtractFRow), 11);
				moveActive := '1';
			-- when above upper limit
			elsif((row <= UPPERLIM) and (moveActive = '0') and (Pause = '0') and (enable = '1')) then
				down := '1';
				row <= row + conv_signed(conv_integer(subtractFRow), 11);
				moveActive := '1';
			else
				null;	
			end if;
		
		
			-- logic for moving pipe across the screen
			-- when pipe has not reached left end of screen
			if((moveActive = '1') and (col > 0) and (Reset = '0') and (Pause = '0') and (enable = '1')) then
				col <= col - scrollspeed;
				upScroll <= '0';
			-- when pipe has reached left end of screen
			elsif((moveActive = '1') and (col < 1) and (Reset = '0') and (Pause = '0') and (enable = '1')) then
				moveActive := '0';
				
				if(first = '1') then
					col <= conv_signed(639, 11);
				else
					col <= conv_signed(STARTCOL, 11);
				end if;
				
				count := count +1;
				
				if (count >= 7) then 
					upScroll <= '1';
					count := 0;
					scrollspeed := scrollspeed +1;
				else
					upScroll <= '0';
				end if;
				
				first := '1';
				
			elsif (Reset = '1') then
				col <= conv_signed(STARTCOL, 11);
				row <= STARTROW;
				--first := '0';
			else
				null;
			end if;
		else
			null;
		end if;	
	end process;
	
	-- set outputs [put these before the "end process;" if need be]
	rowOut <= row;
	colOut <= col;
	
end architecture behaviour;

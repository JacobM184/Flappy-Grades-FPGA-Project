LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

ENTITY livesLevel IS
	PORT(
		vsync,collision	: in std_logic;
		state					: in std_logic_vector(2 DOWNTO 0);
		speedVal 			: out integer range 0 to 10;
		lives					: out std_logic_vector(3 DOWNTO 0);
		level					: out  std_logic_vector(3 DOWNTO 0);
		win  					: out std_logic;
		lose 					: out std_logic
	);
END ENTITY livesLevel;

architecture Behaviour OF livesLevel IS
	
begin
	

	vert : PROCESS(vsync)
	variable prevVert : STD_LOGIC := '0';
	variable count : integer range 0 to 700 := 0;
	variable vSpeed : integer range 0 to 10 := 2;
	variable vLives : std_logic_vector(3 DOWNTO 0);
	variable vLevel : std_logic_vector(3 DOWNTO 0);
	variable vWin, vLose : std_logic := '0';
	BEGIn
	
		
		IF rising_edge(vsync) THEN
			-- reset values if state not gameplay
			if state = "000" or state = "100" or state = "101" then
				vSpeed := 2;
				vLives := "0011";
				vLevel := "0001";
				vWin := '0';
				vLose := '0';
			else
				null;
			end if;
		
			-- conditions for when state is gameplay
			if state = "010" then
				
				-- counter to increase scrolling speed and level
				if count >= 600 then
					count := 0;
					vSpeed := vSpeed + 1;
					vLevel := vLevel + 1;
				else
					count := count + 1;
				end if;
				
				-- checking if user wins
				if vLevel = "101" then
					vWin := '1';
				else
				 null;
				end if;
				
				-- changing lives value
				if collision = '1' then
					vLives := vLives - 1;
				else
					null;
				end if;
				
				--checking if user lost
				if vLives = "0000" then
					vlose := '1';
				else
					null;
				end if;
			else
				null;
			end if;
			
			--set outputs
			speedVal <= vspeed;
			lives <= vLives;
			level <= vLevel;
			win <= vWin;
			lose <= vLose;
		END IF;
	
	END PROCESS vert;
end architecture Behaviour;
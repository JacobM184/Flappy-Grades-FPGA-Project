library ieee;
use  ieee.std_logic_1164.all;
use  ieee.std_logic_arith.all;
use  ieee.std_logic_unsigned.all;

entity collisionDetect is
	port(v_sync : in std_logic;
		 pipeCol, pipeRow, pipeCol2, pipeRow2, pipeCol3, pipeRow3, birdRow : in signed(10 downto 0);
		 collision : out std_logic := '0');
end entity collisionDetect;

architecture behaviour of collisionDetect is

	constant TOPLIM : signed(10 downto 0) := conv_signed(0,11); -- top limit of screen
	constant BOTTOMLIM : signed(10 downto 0) := conv_signed(368,11); -- bottom limit of screen (or top of bird)
	constant BIRDCOL_R : signed(10 downto 0) := conv_signed(132,11); -- right column of the bird
	constant BIRDCOL_L : signed(10 downto 0) := conv_signed(132,11); -- left column of the bird
	constant BIRDLEN : signed(10 downto 0) := conv_signed(32,11); -- height of the bird
	constant GAPSIZE : signed(10 downto 0) := conv_signed(150,11); -- pipe gap height
	constant PIPELEN : signed(10 downto 0) := conv_signed(60,11); -- pipe width

	signal boundaryCond : BOOLEAN; -- boolean to check if bird within upper and lower lims
	signal pipeCond : BOOLEAN; -- boolean to check if bird not in contact with pipe
	signal pipeCond2 : BOOLEAN; -- boolean to check if bird not in contact with pipe
	signal pipeCond3 : BOOLEAN; -- boolean to check if bird not in contact with pipe
	
begin

	boundaryCond <= ((TOPLIM < birdRow) and (BOTTOMLIM > birdRow)); -- check if bird row at 0 or 368
	
	pipeCond <= ((pipeCol-PIPELEN > BIRDCOL_R) or (pipeCol < BIRDCOL_L) or -- check if pipe before or after bird
					((birdRow > pipeRow - GAPSIZE) and (birdRow + BIRDLEN < pipeRow))); --check if bird within the pipe gap
					
	pipeCond2 <= ((pipeCol2-PIPELEN > BIRDCOL_R) or (pipeCol2 < BIRDCOL_L) or -- check if pipe before or after bird
					((birdRow > pipeRow2 - GAPSIZE) and (birdRow + BIRDLEN < pipeRow2))); --check if bird within the pipe gap
					
	pipeCond3 <= ((pipeCol3-PIPELEN > BIRDCOL_R) or (pipeCol3 < BIRDCOL_L) or -- check if pipe before or after bird
					((birdRow > pipeRow3 - GAPSIZE) and (birdRow + BIRDLEN < pipeRow3))); --check if bird within the pipe gap
				
	collision <= '0' when (pipeCond and pipeCond2 and pipeCond3 and boundaryCond) else -- condition if bird within all limits
				 '1'; -- condition when the bird collides
	
end architecture behaviour;
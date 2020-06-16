--------------------------------------------------------------------------
--																								--
--    SPRITE CONTROLLER w/ BACKGROUND/FOREGROUND IMPLEMENTATION    		--
--																								--
--			- 	This code takes in different sprites and outputs				--
--       	which ever sprite needs to displayed at a given moment		--
--																								--
--       -	Also implements its own still background and foreground     --
--																								--
--------------------------------------------------------------------------

LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY spriteController IS
	GENERIC(
		GROUND_HEIGHT 					 : INTEGER RANGE 0 TO 100 := 80
		
	);
	
	PORT(
		clk25Hz					: IN	STD_LOGIC;
		state 					: IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
		pixel_row, pixel_col	: IN	STD_LOGIC_VECTOR(9 DOWNTO 0);
		R0, G0, B0				: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		A0							: IN  STD_LOGIC;
		
		R1, G1, B1				: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		A1							: IN  STD_LOGIC;
		
		R2, G2, B2				: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		A2							: IN  STD_LOGIC;
		
		R3, G3, B3				: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		A3							: IN  STD_LOGIC;
		
		Rmenu, Gmenu, Bmenu  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		Amenu						: IN STD_LOGIC;
		
		R, G, B    			   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END ENTITY spriteController;

architecture drawBehaviour OF spriteController IS
	SIGNAL R_back, G_back, B_back : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL grass, dirt, edge		: STD_LOGIC;
begin
	R <= 	"0000" when edge = '1' and grass = '0' and dirt = '0'  else
			"0110" when edge = '0' and grass = '1' and dirt = '0' else
			"0011" when edge = '0' and grass = '0' and dirt = '1' else
			Rmenu when Amenu = '0' and grass = '0' and dirt = '0' and edge = '0' and (state = "000" or state = "100" or state = "101" or state = "011")  else
			R0 when A0 = '1' and grass = '0' and dirt = '0' and edge = '0' and (state = "010" or state = "001" or state = "011") else
			R1 when A1 = '1' and grass = '0' and dirt = '0' and edge = '0' and (state = "010" or state = "001" or state = "011")  else
			R2 when A2 = '1' and grass = '0' and dirt = '0' and edge = '0' and (state = "010" or state = "001" or state = "011")else
			R3 when A3 = '1' and grass = '0' and dirt = '0' and edge = '0' and (state = "010" or state = "001" or state = "011")else
			R_back;
			
	G <=  "0000" when edge = '1' and grass = '0' and dirt = '0'  else
			"0101" when edge = '0' and grass = '1' and dirt = '0' else
			"1100" when edge = '0' and grass = '0' and dirt = '1' else
			Rmenu when Amenu = '0' and grass = '0' and dirt = '0' and edge = '0' and (state = "000" or state = "100" or state = "101" or state = "011")  else
			G0 when A0 = '1' and grass = '0' and dirt = '0' and edge = '0' and (state = "010" or state = "001" or state = "011")else
			G1 when A1 = '1' and grass = '0' and dirt = '0' and edge = '0' and (state = "010" or state = "001" or state = "011")else
			G2 when A2 = '1' and grass = '0' and dirt = '0' and edge = '0' and (state = "010" or state = "001" or state = "011")else
			G3 when A3 = '1' and grass = '0' and dirt = '0' and edge = '0' and (state = "010" or state = "001" or state = "011")else
			G_back;
			
	B <= 	"0000" when edge = '1' and grass = '0' and dirt = '0'  else
			"0010" when edge = '0' and grass = '1' and dirt = '0' else
			"0011" when edge = '0' and grass = '0' and dirt = '1' else
			Bmenu when Amenu = '0' and grass = '0' and dirt = '0' and edge = '0' and (state = "000" or state = "100" or state = "101" or state = "011") else
			B0 when A0 = '1' and grass = '0' and dirt = '0' and edge = '0' and (state = "010" or state = "001" or state = "011")else
			B1 when A1 = '1' and grass = '0' and dirt = '0' and edge = '0' and (state = "010" or state = "001" or state = "011")else
			B2 when A2 = '1' and grass = '0' and dirt = '0' and edge = '0' and (state = "010" or state = "001" or state = "011")else
			B3 when A3 = '1' and grass = '0' and dirt = '0' and edge = '0' and (state = "010" or state = "001" or state = "011")else
			B_back;
	
	backAndFore : PROCESS(pixel_row, clk25Hz)
		VARIABLE prevInt	: INTEGER RANGE 0 TO 377 := 8;
		VARIABLE currInt 	: INTEGER RANGE 0 TO 377 := 13;
		VARIABLE plh 		: INTEGER RANGE 0 TO 377 := 0;
		VARIABLE colour  	: STD_LOGIC_VECTOR(2 DOWNTO 0) := "111";
		
		CONSTANT THICKNESS : INTEGER RANGE 0 TO 11 := 10;
	BEGIN
		IF rising_edge(clk25Hz) THEN
			IF '0' & pixel_row >= '0' & CONV_STD_LOGIC_VECTOR(410, 10) THEN
				grass <= '1';
				dirt <= '0';
				edge <= '0';
			ELSIF '0' & pixel_row >= '0' & CONV_STD_LOGIC_VECTOR(410-2, 10) THEN
				grass <= '0';
				dirt <= '0';
				edge <= '1';
			ELSIF '0' & pixel_row >= '0' & CONV_STD_LOGIC_VECTOR(400, 10) THEN
				grass <= '0';
				dirt <= '1';
				edge <= '0';
			ELSIF '0' & pixel_row >= '0' & CONV_STD_LOGIC_VECTOR(400-2, 10) THEN
				grass <= '0';
				dirt <= '0';
				edge <= '1';
			ELSE
				grass <= '0';
				dirt <= '0';
				edge <= '0';
			END IF;
			
			IF pixel_row = CONV_STD_LOGIC_VECTOR(0, 10) THEN
				prevInt := 8;
				currInt := 13;
				colour := "111";
			ELSE
				null;
			END IF;
			
			IF pixel_row >= CONV_STD_LOGIC_VECTOR(currInt, 10) and currInt /= 377 THEN
				plh := currInt;
				currInt := currInt + prevInt;
				prevInt := plh;
				
				colour := colour - CONV_STD_LOGIC_VECTOR(1, 3);
			
			ELSE
				null;
			END IF;
		END IF;
		R_back <= colour & "1";
		G_back <= "1" & colour;
		B_back <= "1111";
	END PROCESS backAndFore;
	
end architecture drawBehaviour;
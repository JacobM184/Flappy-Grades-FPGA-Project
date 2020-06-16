library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_segment_decoder_hex is
    Port ( number_in : in STD_LOGIC_VECTOR (3 downto 0);-- 4 Anode signals
           LED_out : out STD_LOGIC_VECTOR (7 downto 0));-- Cathode patterns of 7-segment display
end seven_segment_decoder_hex;

architecture behaviour of seven_segment_decoder_hex is
  begin
    process(number_in)
      begin
        case number_in is
          when "0000" => LED_out <= "11000000"; -- "0"     
          when "0001" => LED_out <= "11111001"; -- "1" 
          when "0010" => LED_out <= "10100100"; -- "2" 
          when "0011" => LED_out <= "10110000"; -- "3" 
          when "0100" => LED_out <= "10011001"; -- "4" 
          when "0101" => LED_out <= "10010010"; -- "5" 
          when "0110" => LED_out <= "10000010"; -- "6" 
          when "0111" => LED_out <= "11111000"; -- "7" 
          when "1000" => LED_out <= "10000000"; -- "8"     
          when "1001" => LED_out <= "10011000"; -- "9" 
          when "1010" => LED_out <= "10001000"; -- a
          when "1011" => LED_out <= "10000011"; -- b
          when "1100" => LED_out <= "11000110"; -- C
          when "1101" => LED_out <= "10100001"; -- d
          when "1110" => LED_out <= "10000110"; -- E
          when "1111" => LED_out <= "10001110"; -- F
          when others => LED_out <= "11111111";
       end case;
    end process;
end architecture;
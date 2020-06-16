library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_segment_decoder_Lives is
    Port ( number_in : in STD_LOGIC_VECTOR (3 downto 0);-- 4 Anode signals
           LED_out : out STD_LOGIC_VECTOR (7 downto 0));-- Cathode patterns of 7-segment display
end seven_segment_decoder_Lives;

architecture behaviour of seven_segment_decoder_Lives is
  begin
    process(number_in)
      begin
        case number_in is
          when "0011" => LED_out <= "10001000"; -- a
          when "0010" => LED_out <= "10000011"; -- b
          when "0001" => LED_out <= "11000110"; -- C
          when "0000" => LED_out <= "10100001"; -- d
          when others => LED_out <= "11111111";
       end case;
    end process;
end architecture;
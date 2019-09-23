Library IEEE;
	Use IEEE.std_logic_1164.all;
	
Entity display_7 is
	port(
		A: in std_logic_vector(3 downto 0);
		S: out std_logic_vector(6 downto 0)	
	);
end display_7;

Architecture arch_display_7 of display_7 is
begin
	S <=
		"0000001" WHEN a="0000" ELSE
		"1001111" WHEN a="0001" ELSE
		"0010010" WHEN a="0010" ELSE
		"0000110" WHEN a="0011" ELSE
		"1001100" WHEN a="0100" ELSE
		"0100100" WHEN a="0101" ELSE
		"0100000" WHEN a="0110" ELSE
		"0001111" WHEN a="0111" ELSE
		"0000000" WHEN a="1000" ELSE
		"0000100" WHEN a="1001" ELSE
		"0001000" WHEN a="1010" ELSE
		"1100000" WHEN a="1011" ELSE
		"0110001" WHEN a="1100" ELSE
		"1000010" WHEN a="1101" ELSE
		"0110000" WHEN a="1110" ELSE
		"0111000" WHEN a="1111";		
end arch_display_7;
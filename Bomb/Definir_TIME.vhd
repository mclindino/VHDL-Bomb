LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY Definir_TIME IS
port(
	CLK, reset, clock_ini: in std_logic;
	Saida: out std_logic_vector(15 downto 0)
	);
end Definir_TIME;

architecture ARCH_TIME of Definir_TIME is
signal newclock, newclock16x: std_logic;
component Divisor_Freq
	port (
		CLK: in std_logic;
		sel, sel_time: in std_logic_vector(1 downto 0);
		COUT: out std_logic
);
 end component;
Begin

 DIV: Divisor_Freq
	port map(CLK => clock_ini, sel => "00", sel_time => "11", COUT => newclock);
process (CLK, reset)
variable A, B, C, D: std_logic_vector(3 downto 0) := "0000";
begin
	if reset = '1' then
		A := "0000";
		B := "0000";
		C := "0000";
		D := "0000";
	elsif(newclock'EVENT and newclock = '1') then
		if (CLK = '1') then
			A := A + 1;
			if(A = "1001") then
				A := "0000";
				B := B + 1;
				if(B = "0110") then
					B := "0000";
					C := C + 1;
					if C = "1001" then
						C := "0000";
						D := D + 1;
						if D = "0110" then
							D := "0000";
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
	Saida(3 downto 0) <= A;
	Saida(7 downto 4) <= B;
	Saida(11 downto 8) <= C;
	Saida(15 downto 12) <= D;
end process;
end ARCH_TIME;
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY Contador_Sincrono_Dividido IS
port(
	reset: in std_logic;
	clock, comeco: in std_logic;
	Ain, Bin, Cin, Din: std_LOGIC_VECTOR(3 downto 0);
	sel: in std_logic_vector(1 downto 0);
	explodir, aumentar_x16: out std_logic := '0';
	Q0, Q1, Q2, Q3: out std_logic_vector(6 downto 0)
	);
end Contador_Sincrono_Dividido;

architecture arch_Contador_Sincrono_Dividido of Contador_Sincrono_Dividido is
signal new_clock: std_logic := '0';
signal A, B, C, D : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";

component display_7
port(
		A: in std_logic_vector(3 downto 0);
		S: out std_logic_vector(6 downto 0)	
	);
end component;

component Divisor_Freq
port(
		 CLK: in std_logic;
		 sel: in std_logic_vector(1 downto 0);
		 COUT: out std_logic
	);
end component;

begin
Divisor: Divisor_Freq
	port map(CLK => clock, cout => new_clock, sel => sel);

process (new_clock)
variable para, aux: std_logic := '0';
begin
	if reset = '1' then
		aux := '0';
		para := '0';
		A <= "0000";
		B <= "0000";
		C <= "0000";
		D <= "0000";
		aumentar_x16 <= '0';
	elsif (comeco = '1') and (aux = '0') then
		A <= Ain;
		B <= Bin;
		C <= Cin;
		D <= Din;
	elsif(para = '0') then
		if(new_clock'EVENT and new_clock = '1') then
			aux := '1';
			if(D = "0000")then
				if(C = "0000")then
					if(B = "0001")then
						if(A = "0000")then
							aumentar_x16 <= '1';
						end if;
					end if;
				end if;
			end if;
			if(A = "0000") then
				if(B = "0000") then
					if(C = "0000") then
						if(D = "0000") then
							para := '1';
						else
							D <= D - 1;
							C <= "1001";
							B <= "0101";
							A <= "1001";
						end if;
					else
						C <= C - 1;
						B <= "0101";
						A <= "1001";
					end if;
				else
					B <= B - 1;
					A <= "1001";
				end if;
			A <= "1001";
			if(para = '1') then
				A <= "0000";
			end if;
			else
				A <= A - 1;
			end if;
		end if;
	end if;
	explodir <= para;
end process;

SEGUNDOS: display_7
	port map(A => A, S => Q0);
SEGUNDOS2: display_7
	port map(A => B, S => Q1);
MINUTOS: display_7
	port map(A => C, S => Q2);
MINUTOS2: display_7
	port map(A => D, S => Q3);


end arch_Contador_Sincrono_Dividido;

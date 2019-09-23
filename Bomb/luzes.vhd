Library IEEE;
Use IEEE.std_logic_1164.all;

ENTITY luzes is
	port(
		Clock: in std_logic;
		Controle, Controle_time: in std_logic_vector(1 downto 0);
		Apitador: out std_logic;
		LuzesVerme: out std_logic_vector(17 downto 0)
	);
end luzes;

architecture arch_luzes of luzes is
component Divisor_Freq
	port(
		 CLK: in std_logic;
		 sel, sel_time: in std_logic_vector(1 downto 0);
		 COUT: out std_logic
);
end component;
signal Seg: std_logic;
Begin

Um_Seg: Divisor_Freq
	port map(CLK => Clock, sel => Controle, sel_time => Controle_time, COUT => Seg);
	
process(Seg)
	Begin
	if Seg = '1' then
		LuzesVerme <= "111111111111111111";
	else 
		LuzesVerme <= "000000000000000000";
	end if;
	Apitador <= Seg;
end process;
end arch_luzes;
		
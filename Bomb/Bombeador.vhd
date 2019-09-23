Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.std_logic_arith.all;
Use IEEE.std_logic_unsigned.all;

ENTITY Bombeador is
	port(
		clock_ini, ENTER, control, enter_code, TEMPO, reset : in std_logic := '0';
		code: in std_logic_vector(3 downto 0);
		red, green, blue, orange, purple: in std_logic := '0';
		Apitador: out std_logic;
		LUZES_VERD: out std_LOGIC_VECTOR(7 downto 0) := "00000000";
		LUZES_VERME: out std_LOGIC_VECTOR(17 downto 0) := "000000000000000000";
		Zerar_display, Zerar_display2: out std_logic_vector(6 downto 0) := "1111111";
		Saida_final: out std_logic_vector(41 downto 0)
	);
end entity;
	
architecture arch_Bombeador of Bombeador is
signal sel_fios, Controle_time, sel_fios_luzes: std_logic_vector(1 downto 0) := "00";
signal tempcode: std_logic_vector(3 downto 0) := "0000";
signal acabou, aumentar_x16, errou, clock_denied: std_logic := '0';
signal sA, sB, sC, sD: std_logic_VECTOR(3 downto 0);
signal SQ0, SQ1, SQ2, SQ3, mostrar_code: std_logic_vector(6 downto 0) := "1111111";
signal VERMELHAO: std_LOGIC_VECTOR(17 downto 0);

component display_7 is
	port(
		A: in std_logic_vector(3 downto 0);
		S: out std_logic_vector(6 downto 0)	
	);
end component;

component Contador_Sincrono_Dividido
port (
	 reset: in std_logic;
	 clock, comeco: in std_logic;
	 Ain, Bin, Cin, Din: std_LOGIC_VECTOR(3 downto 0);
	 sel: in std_logic_vector(1 downto 0);
	 explodir, aumentar_x16: out std_logic := '0';
	 Q0, Q1, Q2, Q3: out std_logic_vector(6 downto 0)
		 );
 end component;
 
component Divisor_Freq
	port (
		CLK: in std_logic;
		sel, sel_time: in std_logic_vector(1 downto 0);
		COUT: out std_logic
);
 end component;
 
component Definir_TIME 
port(
	CLK, reset, clock_ini: in std_logic;
	Saida: out std_logic_vector(15 downto 0)
	);
end component;

component luzes is
	port(
		Clock: in std_logic;
		Controle, Controle_time: in std_logic_vector(1 downto 0);
		Apitador: out std_logic;
		LuzesVerme: out std_logic_vector(17 downto 0)
	);
end component;

begin
 Display_code: display_7
	port map(A => code, S => mostrar_code);
 DEFINIR_TEMPO: Definir_TIME
	port map(clock_ini => clock_ini, CLK => TEMPO, reset => reset, Saida(3 downto 0) => sA, Saida(7 downto 4) => sB, Saida(11 downto 8) => sC, Saida(15 downto 12) => sD);
 Contador_final: Contador_Sincrono_Dividido
	port map(reset => reset, comeco => TEMPO, clock => clock_ini, sel => sel_fios, Ain => sA, Bin => sB, Cin => sC, Din => sD, Q0 => SQ0, Q1 => SQ1, Q2 => SQ2, Q3 => SQ3, explodir => acabou, aumentar_x16 => aumentar_x16);
 Luzes_def: luzes
	port map(Clock => clock_ini, Controle => sel_fios_luzes, Controle_time => Controle_time, LuzesVerme => VERMELHAO, Apitador => Apitador);
 --Denied: Divisor_Freq
	--port map(CLK => clock_ini, sel => "01", sel_time => "00", COUT => clock_denied);
 
 --Controle de fios
 --Ordem na placa: red, purple, orange, green, blue;
 --red e blue: para a bomba;
 --purple em qualquer caso: dobra o tempo;
 --orange, green e purple: quadruplica o tempo*/
	
 process(clock_ini, reset)
	variable again: integer := 0;
	variable defuse, detonate, aux, primeira_vez, tentativa: std_logic := '0';
	variable attempt: integer := 0; 
	begin
		if reset = '1' then
			aux := '0';
			errou <= '0';
			again := 0;
			defuse := '0';
			detonate := '0';
			attempt := 0;
			primeira_vez := '0';
			tentativa := '0';
			LuzES_VERME <= "000000000000000000";
			LuzES_VERD <= "00000000";
			tempcode <= "0000";
			Saida_final(6 downto 0) <= "1111110";
			Saida_final(13 downto 7) <= "1111110";
			Saida_final(20 downto 14) <= "1111110";
			Saida_final(27 downto 21) <= "1111110";
			Saida_final(34 downto 28) <= "1111110";
			Saida_final(41 downto 35) <= "1111110";
			Zerar_display <= "1111110";
			Zerar_display2 <= "1111110";
	elsif(clock_ini'event and clock_ini = '1')then
		if (ENTER = '0') or (aux = '1') then
			aux := '1';
			LuzES_VERD(0) <= '0';
			if(primeira_vez = '0')then
				primeira_vez := '1';
				sel_fios <= "01";
				Zerar_display <= "1001111";
			end if;
			if control = '1' then
				tentativa := '0';
				if again = 0 then
					if((red = '1' or blue = '1') and (purple = '0') and (green = '0'))then
						if((red and (not green) and (not purple) and (not orange) and (not blue)) = '1')then
							detonate := '0';
						elsif((blue and (not green) and (not purple) and (not orange) and (not red)) = '1')then
							detonate := '0';
						elsif(red and blue and (not green) and (not purple) and (not orange)) = '1' then
						defuse := '1';
						again := 1;
						else
							detonate := '1';
							again := 1;
						end if;
					elsif((purple = '1') and ((sel_fios = "01") or (sel_fios = "10")))then
						if(((not red) and (not green) and (not orange) and (not blue)) = '1')then
							sel_fios <= "10";
							Zerar_display <= "0010010";
						elsif((red and purple and (not green) and (not orange) and (not blue)) = '1')then
							detonate := '0';
						elsif((blue and (not green) and (not orange) and (not red)) = '1')then
							detonate := '0';
						elsif(red and blue and (not green) and (not orange)) = '1' then
							defuse := '1';
							again := 1;
						elsif(((not red) and green and (not orange) and (not blue)) = '1')then
							sel_fios <= "11";
							Zerar_display <= "1001100";
						else
							detonate := '1';
							again := 1;
						end if;
					elsif((purple = '1') and (green = '1'))then
						if(((not orange) and (not blue) and (not red)) = '1')then
							detonate := '0';
						elsif((red and (not orange)) = '1')then
							if((blue and red and (not orange)) = '1')then
								defuse := '1';
								again := 1;
							end if;
						elsif((blue and (not orange)) = '1')then
							if((blue and red and (not orange)) = '1')then
								defuse := '1';
								again := 1;
							end if;
						else
							detonate := '1';
							again := 1;
						end if;
					elsif(green = '1')then
						if(((not red) and (not purple) and (not orange) and (not blue)) = '1')then
							sel_fios <= "11";
							Zerar_display <= "1001100";
						elsif((red and (not orange)) = '1')then
							if((blue and red and (not orange)) = '1')then
								defuse := '1';
								again := 1;
							end if;
						elsif((blue and (not orange)) = '1')then
							if((blue and red and (not orange)) = '1')then
								defuse := '1';
								again := 1;
							end if;
						else
							detonate := '1';
							again := 1;
						end if;
					end if;
				end if;
			else
				if again = 0 then
					if tentativa = '0' then
						if(code = tempcode) then
							defuse := '1';
							again := 1;
						else
							attempt := attempt + 1;
							tentativa := '1';
							errou <= '1';
						end if;
						if attempt = 1 then
							sel_fios <= "10";
							Zerar_display <= "0010010";
						end if;
						if attempt = 2 then
							sel_fios <= "11";
							Zerar_display <= "1001100";
						end if;
						if attempt = 3 then
							sel_fios <= "00";
							detonate := '1';
							again := 1;
						end if;						
					end if;
				end if;
			end if;
		end if;
		
		if(aumentar_x16 = '1')then
			if detonate = '1'  then
				sel_fios_luzes <= "11";
				Controle_time <= "11";
			elsif defuse = '1' then
				sel_fios_luzes <= "00";
				Controle_time <= "00";
			else 
				sel_fios_luzes <= "00";
				Controle_time <= "11";
			end if;
		else
			if detonate = '1'  then
				sel_fios_luzes <= "11";
				Controle_time <= "11";
			elsif defuse = '1' then
				sel_fios_luzes <= "00";
				Controle_time <= "00";
			else
				sel_fios_luzes <= sel_fios;
				Controle_time <= "00";
			end if;
		end if;

		
		
		if(acabou and aux) = '1' then
			detonate := '1';
		end if;
		if(defuse = '1')then
			sel_fios <= "00";
		end if;
		if (ENTER = '1') and (aux = '0') then
			sel_fios <= "00";
			if (enter_code = '0') then
				tempcode <= code;
				LuzES_VERD(0) <= '1';
			end if;
		end if;
--		if(errou = '1')then
--			Saida_final(6 downto 0) <= "0110000";
--			Saida_final(13 downto 7) <= "1000010";
--			Saida_final(20 downto 14) <= "1111111";
--			Saida_final(27 downto 21) <= "1111111";
--			Saida_final(34 downto 28) <= "1001111";
--			Saida_final(41 downto 35) <= "0001001";
--			Zerar_display2 <= "0110000";
--			Zerar_display <= "1000010";
--			LuzES_VERME <= VERMELHAO;
		if(enter = '1' and aux = '0')then
			Saida_final(6 downto 0) <= SQ0;
			Saida_final(13 downto 7) <= SQ1;
			Saida_final(20 downto 14) <= SQ2;
			Saida_final(27 downto 21) <= SQ3;
			Saida_final(34 downto 28) <= "1111111";
			Saida_final(41 downto 35) <= "1111111";
			LuzES_VERME <= VERMELHAO;
			zerar_display2 <= mostrar_code;
		elsif(defuse = '0' and detonate = '0' and aux = '1')then
			Saida_final(6 downto 0) <= SQ0;
			Saida_final(13 downto 7) <= SQ1;
			Saida_final(20 downto 14) <= SQ2;
			Saida_final(27 downto 21) <= SQ3;
			Saida_final(34 downto 28) <= "1111111";
			Saida_final(41 downto 35) <= "1111111";
			Zerar_display2 <= "1111111";
			LuzES_VERME <= VERMELHAO;
		elsif(defuse = '1' and detonate = '0')then
			Saida_final(6 downto 0) <= "1000001";
			Saida_final(13 downto 7) <= "0111000";
			Saida_final(20 downto 14) <= "0110000";
			Saida_final(27 downto 21) <= "1000010";
			Saida_final(34 downto 28) <= "0100100";
			Saida_final(41 downto 35) <= "0110000";
			Zerar_display <= "1111111";
			Zerar_display2 <= "1000010";
			LuzES_VERD <= "11111111";
			LuzES_VERME <= "000000000000000000";
		elsif(defuse = '0' and detonate = '1')then
			Saida_final(6 downto 0) <= "1111111";
			Saida_final(13 downto 7) <= "1111111";     
			Saida_final(20 downto 14) <= "1111111";
			Saida_final(27 downto 21) <= "1111111";
			Saida_final(34 downto 28) <= "1100000";
			Saida_final(41 downto 35) <= "1000001";
			Zerar_display <= "0001001";
			Zerar_display2 <= "1000001";
			LuzES_VERME <= "111111111111111111";
		end if;
	end if;
end process;
end arch_Bombeador;
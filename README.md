# Bomb_VHDL



1. Switches, Push Bottons e Displays
	

	1.1 Swiches
		
		SW0 a SW4 – Fios
		SW5 a SW8 – Código de 4 bits para desarme
		SW16 – Reset geral
		SW17 - Aumentar tempo inicial

	1.2 Push Bottons
		
		KEY0 – Start
		KEY1 – Set código de desarme
		KEY2 – Testar código de desarma

	1.3 Displays
		
		HEX0 – Velocidade do clock
		HEX1 – Código de 4 bits a ser armazenado (quando bomba não iniciada)
		HEX4 a HEX7 – Tempo




2. Como Começar
	

	2.1 - Definir o código que será usado para desarme, usando os switches SW5 a SW8 e pressionando o Push Botton KEY1 para armazenar.
	
	2.2 – Usar o switch SW17 para definir o tempo inicial, mantendo-o em ‘1’ para incrementar.
	
	2.3 – Pressionar o switch KEY0 para começar a contagem.
	
	

3. Desarme


	3.1 – Ao cortar um fio errado dos switches SW0 a SW4, 	penalidades irão ser aplicadas, acelerando a contagem ou explodindo a bomba.

	3.2 – O código pode ser testado três vezes, sendo que a cada tentativa a contagem acelera, e na terceira a bomba explode.
	
		
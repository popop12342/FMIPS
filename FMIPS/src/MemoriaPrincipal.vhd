library ieee;
use ieee.std_logic_1164.all;	
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity MemoriaPrincipal is
	port(
	ender: in std_logic_vector(31 downto 0);
	dados_in: in std_logic_vector(31 downto 0);
	dados_out : out std_logic_vector(31 downto 0);
	rw: in std_logic;
	enable: in std_logic;
	pronto: out std_logic
	);
end MemoriaPrincipal;

architecture behavioral of MemoriaPrincipal is

type mem_array is array(0 to 2**14-1) of std_logic_vector(7 downto 0);

-- inicializa a memoria com um arquivo txt
impure function initMem (filename: in string) return mem_array is
file memfile : text;
variable memfileline, dataline : line;		   
variable mem : mem_array;	 
variable start_pos, word: std_logic_vector(31 downto 0);
variable n_words: integer;
begin 
	file_open(memfile, filename, read_mode);			 
	
	while (not endfile(memfile)) loop
		readline(memfile, memfileline);	-- linha de cabecalho
		hread(memfileline, start_pos);	-- endereco inicial
		read(memfileline, n_words);    -- numero de palavras
		readline(memfile, dataline);    -- linha com dados
		for i in 0 to n_words-1 loop					 
			hread(dataline, word);
			mem(conv_integer(start_pos) + 4*i) := word(31 downto 24);
			mem(conv_integer(start_pos) + 4*i + 1) := word(23 downto 16);
			mem(conv_integer(start_pos) + 4*i + 2) := word(15 downto 8);
			mem(conv_integer(start_pos) + 4*i + 3) := word(7 downto 0);
			
		end loop;
	end loop;
				
	return mem;
end function;

signal mem: mem_array := initMem("teste.txt");	
constant Tmem: time := 40 ns;			   
	
begin	   

	process(enable, ender, rw)					   
	variable pos : integer;
	variable b1, b2, b3, b4 : std_logic_vector(7 downto 0);
	begin
		if enable = '1' then 
			pos := to_integer(unsigned(ender));
			case rw is
				when '0' => -- Leitura					 
					b1 := mem(pos);
					b2 := mem(pos + 1);
					b3 := mem(pos + 2);
					b4 := mem(pos + 3);
					dados_out <= b1 & b2 & b3 & b4 after Tmem;
					pronto <= '1' after Tmem;
				when '1' => -- Escrita 
					mem(pos) <= dados_in(31 downto 24) after Tmem;
					mem(pos + 1) <= dados_in(23 downto 16) after Tmem;
					mem(pos + 2) <= dados_in(15 downto 8) after Tmem;
					mem(pos + 3) <= dados_in(7 downto 0) after Tmem;
					pronto <= '1' after Tmem;
				when others => -- Invalido
					Null;
			end case;
		end if;		 
		
		if enable = '0' then
			pronto <= '0';
			dados_out <= (others => 'Z') after Tmem;
		end if;
		
	end process;
	--dados <= mem(to_integer(unsigned(ender))) after Tmem when enable = '1' and rw = '0';	  
	--mem(to_integer(unsigned(ender))) <= dados after Tmem when enable = '1' and rw = '1';
	--dados_out <= mem(to_integer(unsigned(ender))) after Tmem when enable ='1';   
	--dados <= dados_out when rw = '0' else (others => 'Z');
	
	
end behavioral;

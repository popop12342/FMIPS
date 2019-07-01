-- Projeto FMIP, Hierarquia de Memoria, Cache de Instrucoes
-- Felipe Pinna

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Cache de Instrucoes
entity CacheInstrucoes_FD is
	port (
	ender     : in std_logic_vector(31 downto 0);
	dados_in  : in std_logic_vector(31 downto 0);
	rw        : in std_logic; 
	clock     : in std_logic;
	dados_out : out std_logic_vector(31 downto 0);
	hit       : out std_logic					
	);
end CacheInstrucoes_FD;

architecture CacheInstrucoesArc of CacheInstrucoes_FD is
-- 256 blocos x 16 palavras  x 32 bits
type dados_array is array(0 to 255, 0 to 15) of std_logic_vector(31 downto 0);
type v_array is array(0 to 255) of std_logic;
type tag_array is array(0 to 255) of std_logic_vector(16 downto 0);

-- Tirar essa inicializacao para inciar o cache vazio
signal dados_cache : dados_array:= (others => (x"00000000", x"11111111", x"22222222", x"33333333", x"44444444", x"55555555", x"66666666", x"77777777", x"88888888", x"99999999", x"AAAAAAAA", x"BBBBBBBB", x"CCCCCCCC", x"DDDDDDDD", x"EEEEEEEE", x"FFFFFFFF"));
signal v_cache : v_array := (others => '1');
signal tag_cache : tag_array:= (others => '0' & x"0000");

signal tag : integer;
signal index_bloco : integer range 0 to 255;
signal index_palavra : integer range 0 to 15;
constant Tcache : time := 5 ns;
signal valid_tag : std_logic;

begin					 			   				
	tag <= to_integer(unsigned(ender(31 downto 15)));
	index_bloco <= to_integer(unsigned(ender(14 downto 7)));
	index_palavra <= to_integer(unsigned(ender(6 downto 2)));
	
	valid_tag <= '1' when to_integer(unsigned(tag_cache(index_bloco))) = tag else '0';
		
	process (clock, rw)
	begin
		if rising_edge(clock) then
			if rw = '0' then -- leitura											  				
				hit <= v_cache(index_bloco) and valid_tag after Tcache;
				dados_out <= dados_cache(index_bloco, index_palavra) after Tcache;
			else -- escrita
				dados_cache(index_bloco, index_palavra) <= dados_in after Tcache; -- escreve palavra
				v_cache(index_bloco) <= '1';									  -- marca V
				tag_cache(index_bloco) <= ender(31 downto 15);                    -- atualiza 
			end if;
		end if;
	end process;
		
end CacheInstrucoesArc;
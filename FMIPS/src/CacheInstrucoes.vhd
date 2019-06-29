-- Projeto FMIP, Hierarquia de Memoria, Cache de Instrucoes
-- Felipe Pinna

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Cache de Instrucoes
entity CacheInstrucoes is
	port (
	ender     : in std_logic_vector(31 downto 0);
	dados_out : out std_logic_vector(31 downto 0);
	clock     : in std_logic;
	hit       : out std_logic
	);
end CacheInstrucoes;

architecture CacheInstrucoesArc of CacheInstrucoes is
-- define o tipo da memoria
type mem_array is array(0 to 4095) of std_logic_vector(31 downto 0); 

signal mem: mem_array := (others => x"FFFFFFFF");

begin
	process(clock)
	begin			  
		hit <= '0';
		if (rising_edge(clock)) then
			dados_out <= mem(to_integer(unsigned(ender)));	
			hit <= '1';
		end if;
	end process;
end CacheInstrucoesArc;
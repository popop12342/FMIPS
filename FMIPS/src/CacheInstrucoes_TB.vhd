-- Projeto FMIPS, Hierarquia de Memoria, Cache de Instrucoes
-- Felipe Pinna

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Bancada de teste do Cache de Instrucoes
entity CacheInstrucoes_TB is
end CacheInstrucoes_TB;

architecture CacheInstrucoes_TB_arc of CacheInstrucoes_TB is

-- Declaracao de componentes
component CacheInstrucoes
	port (
	ender: in std_logic_vector(31 downto 0);
	dados_out: out std_logic_vector(31 downto 0);
	clock: in std_logic;
	hit: out std_logic
	);
end component;

-- inputs
signal ender : std_logic_vector(31 downto 0) := (others => '0');
signal clock : std_logic := '0';

-- outputs
signal dados_out : std_logic_vector(31 downto 0);
signal hit : std_logic;

begin
	
	-- Instancia do ICache
	IC: CacheInstrucoes port map (
		ender => ender,
		dados_out => dados_out,
		clock => clock,
		hit => hit
	);
	
	-- Clock process
	clock_process :process
	begin
		clock <= '0';
		wait for 5 ns;
		clock <= '1';
		wait for 5 ns;
	end process;

	ender <= x"00000000";
	
end;

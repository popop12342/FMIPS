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
component CacheInstrucoes is
	port(			   
	clock     : in std_logic;
	ender     : in std_logic_vector(31 downto 0);
	dadosMP   : in std_logic_vector(31 downto 0);
	pronto    : in std_logic;
	enderMP   : out std_logic_vector(31 downto 0);
	enableMP  : out std_logic;
	dados_out : out std_logic_vector(31 downto 0);
	hit       : out std_logic
	);
end component;

component MemoriaPrincipal is
	port(
	ender: in std_logic_vector(31 downto 0);
	dados_in: in std_logic_vector(31 downto 0);
	dados_out : out std_logic_vector(31 downto 0);
	rw: in std_logic;
	enable: in std_logic;
	pronto: out std_logic
	);
end component;

-- inputs
signal ender, dados_in : std_logic_vector(31 downto 0) := (others => '0');
signal clock : std_logic;	   

-- outputs
signal dados_out, enderFD, enderMP, dadosMP : std_logic_vector(31 downto 0);
signal hit, pronto, enableMP : std_logic;					 	 

begin
	
	-- Instancia do ICache
	IC : CacheInstrucoes port map (
		clock => clock,
		ender => ender,
		dadosMP => dadosMP,
		pronto => pronto,
		enderMP => enderMP,
		enableMP => enableMP,
		dados_out => dados_out,
		hit => hit
	); 	
	
	MP : MemoriaPrincipal port map(
		ender => enderMP,
		dados_in => x"00000000",
		dados_out => dadosMP,
		rw => '0',
		enable => enableMP,
		pronto => pronto
	);
	
	process
	begin
		clock <= '0';
		wait for 5 ns;
		clock <= '1';
		wait for 5 ns;
	end process;
	
	process
	begin			
		ender <= x"00000000";
		wait for 10 ns;
		ender <= x"00000004";
		wait for 10 ns;			
		ender <= x"00008008";
		wait until hit = '1';
	end process;
	
end;

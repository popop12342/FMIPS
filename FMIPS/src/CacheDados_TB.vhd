library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Bancada de teste do Cache de Dados
entity CacheDados_TB is
end CacheDados_TB;					 

architecture CacheDados_TB_Arc of CacheDados_TB is

component CacheDados_FD is
	port(
	ender     : in std_logic_vector(31 downto 0);
	dados_in  : in std_logic_vector(31 downto 0);
	rw        : in std_logic; 
	clock     : in std_logic;
	conjunto  : in std_logic_vector(1 downto 0);
	dados_out : out std_logic_vector(31 downto 0);
	hit       : out std_logic;					
	lru_out   : out std_logic
	);
end component;

component CacheDados_UC is
	port(
	clock   : in std_logic;
	hit     : in std_logic;
	rw      : in std_logic;
	lru     : in std_logic;
	dados_in: in std_logic_vector(31 downto 0);
	ender   : in std_logic_vector(31 downto 0);
	dadosMP : in std_logic_vector(31 downto 0);
	pronto  : in std_logic;
	enderFD : out std_logic_vector(31 downto 0);
	enderMP : out std_logic_vector(31 downto 0);
	enableMP: out std_logic;
	rwFD    : out std_logic;
	conjunto: out std_logic_vector(1 downto 0);
	dados   : out std_logic_vector(31 downto 0)
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

signal ender, dados_in, dados_out, enderFD, dadosFD, dadosMP, enderMP : std_logic_vector(31 downto 0);
signal rw, clock, hit, lru, rwFD, pronto, enableMP : std_logic;
signal conjunto : std_logic_vector(1 downto 0);

begin		  
	
	CDFD : CacheDados_FD port map(
	ender => enderFD,
	dados_in => dadosFD,
	rw => rwFD,
	clock => clock,						
	conjunto => conjunto,
	dados_out => dados_out,
	hit => hit,			 
	lru_out => lru
	);
	
	CDUC : CacheDados_UC port map(
	clock => clock,
	hit => hit,
	rw => rw,
	lru => lru,
	dados_in => dados_in,
	ender => ender,
	dadosMP => dadosMP,
	pronto => pronto,
	enderFD => enderFD,
	enderMP => enderMP,
	enableMP => enableMP,
	rwFD => rwFD,
	conjunto => conjunto,
	dados => dadosFD
	);
	
	MP : MemoriaPrincipal port map(
		ender => enderMP,
		dados_in => x"00000000",
		dados_out => dadosMP,
		rw => '0',
		enable => enableMP,
		pronto => pronto
	);
	
	Clock_process: process
	begin
		clock <= '0';
		wait for 5 ns;
		clock <= '1';
		wait for 5 ns;
	end process;
	
	Data_process: process
	begin		  
		ender <= x"00000000";
		rw <= '0';
		wait for 10 ns;
		ender <= x"00000004"; -- primiero conjunto
		wait for 10 ns;
		ender <= x"00010004"; -- segundo conjunto
		wait for 10 ns;
		rw <= '1';
		dados_in <= x"A0A0A0A0";
		wait for 10 ns;
		rw <= '0';
		wait for 10 ns;
		ender <= x"00008000";
		wait until hit = '1';
	end process;
	
end CacheDados_TB_Arc;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CacheDados is
	port(			   
	clock     : in std_logic;
	ender     : in std_logic_vector(31 downto 0);
	dadosMP   : in std_logic_vector(31 downto 0);
	pronto    : in std_logic;
	enderMP   : out std_logic_vector(31 downto 0);
	enableMP  : out std_logic;
	dados_out : out std_logic_vector(31 downto 0); 
	dados_outMP : out std_logic_vector(31 downto 0);
	hit       : out std_logic;
	rwCD	  : in std_logic;
	dados_inCD : in std_logic_vector(31 downto 0)
	);
end CacheDados;	

architecture CacheDados_Arc of CacheDados is

component CacheDados_FD
	port (
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

component CacheDados_UC 
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

component WriteBuffer 
	port (
	dados_in  : in std_logic_vector(31 downto 0);
	dados_out : out std_logic_vector(31 downto 0)
	);
end component;

signal rw, h : std_logic;
signal dados_in, enderFD : std_logic_vector(31 downto 0);
signal conjuntoS : std_logic_vector(1 downto 0);
signal lruS : std_logic;

begin		  
	
	-- Instancia do DCache
	DC: CacheDados_FD port map (
		ender => enderFD,	--in
		dados_in => dados_in,	--in
		rw => rw,				--in
		clock => clock,			--in fora
		conjunto => conjuntoS,	--in
		dados_out => dados_out,	--out fora
		hit => h,				--out
		lru_out => lruS			--out
	);
	
	--DCUC: CacheDados_UC port map(
--		clock => clock,	  --in fora
--		hit => h,		  --in interno e fora
--		rw  => rwCD,	  --in fora
--		lru  => lruS,  --in interno
--		dados_in => dados_inCD, --in	  fora
--		ender => ender,	  --in	 fora
--		dadosMP => dadosMP,	  --in	 fora
--		pronto => pronto,	  --in	 fora
--		enderFD => enderFD,	  --out	 interno
--		enderMP => enderMP,	  --out	 fora
--		enableMP => enableMP, --out	 fora
--		rwFD => rw,			  --out	 interno
--		conjunto => conjuntoS,--out	 interno
--		dados => dados_in	  --out	 interno
--	);
	
	--WB: WriteBuffer	port map(
--	dados_in => dados_in,
--	dados_out => dados_outMP
--	);
	
	hit <= h;
	
end CacheDados_Arc;
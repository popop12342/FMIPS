library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CacheInstrucoes is
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
end CacheInstrucoes;	

architecture CacheInstrucoes_Arc of CacheInstrucoes is

component CacheInstrucoes_FD
	port (
	ender: in std_logic_vector(31 downto 0);
	dados_in : in std_logic_vector(31 downto 0);
	rw : in std_logic;
	clock : in std_logic;
	dados_out: out std_logic_vector(31 downto 0);
	hit: out std_logic						   
	);
end component;

component CacheInstrucoes_UC
	port (
	clock : in std_logic;
	hit : in std_logic;
	ender : in std_logic_vector(31 downto 0);
	dadosMP : in std_logic_vector(31 downto 0);
	pronto : in std_logic;
	enderFD : out std_logic_vector(31 downto 0);
	enderMP : out std_logic_vector(31 downto 0);
	enableMP : out std_logic;
	rw : out std_logic;
	dados : out std_logic_vector(31 downto 0)
	);
end component;

signal rw, h : std_logic;
signal dados_in, enderFD : std_logic_vector(31 downto 0);

begin		  
	
	-- Instancia do ICache
	IC: CacheInstrucoes_FD port map (
		ender => enderFD,
		dados_in => dados_in,
		rw => rw,
		clock => clock,
		dados_out => dados_out,	 
		hit => h
	);
	
	ICUC: CacheInstrucoes_UC port map(
		clock => clock,
		hit => h,
		ender => ender,
		dadosMP => dadosMP,
		pronto => pronto,
		enderFD => enderFD,
		enderMP => enderMP,
		enableMP => enableMP,
		rw => rw,
		dados => dados_in
	);
	
	hit <= h;
	
end CacheInstrucoes_Arc;
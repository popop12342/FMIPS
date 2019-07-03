library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CacheDados is
	port(			   
	clock     : in std_logic;
	ender     : in std_logic_vector(31 downto 0);
	rw        : in std_logic;
	dados_in  : in std_logic_vector(31 downto 0);
	hit       : out std_logic;
	dados_out : out std_logic_vector(31 downto 0);
	prontoMPBuffer : in std_logic;
	enableMPBuffer : out std_logic;
	enderMPBuffer  : out std_logic_vector(31 downto 0);
	dadosMPBuffer  : out std_logic_vector(31 downto 0);
	rwMPBuffer     : out std_logic;
	prontoMPUC : in std_logic;
	dadosMPUC  : in std_logic_vector(31 downto 0);
	enderMPUC  : out std_logic_vector(31 downto 0);
	enableMPUC : out std_logic
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
	lru_out   : out std_logic;
	sujo1	  : out std_logic_vector(127 downto 0);
	sujo2    : out std_logic_vector(127 downto 0);
	go_buffer : in std_logic;	-- daqui para baixo eh do buffer 
	pronto    : in std_logic;
	buffer_cheio : out std_logic;
	enableMP  : out std_logic;
	enderMP   : out std_logic_vector(31 downto 0); 
	dadosMP   : out std_logic_vector(31 downto 0);
	conjuntoBuf  : in std_logic_vector(1 downto 0);
	rwMP      : out std_logic
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
	buffer_cheio  : in std_logic;
	enderFD : out std_logic_vector(31 downto 0);
	enderMP : out std_logic_vector(31 downto 0);
	enableMP: out std_logic;
	go_buffer: out std_logic;
	rwFD    : out std_logic;
	conjunto: out std_logic_vector(1 downto 0);
	conjuntoBuf: out std_logic_vector(1 downto 0);
	dados   : out std_logic_vector(31 downto 0);
	sujo1	  : in std_logic_vector(127 downto 0);
	sujo2    : in std_logic_vector(127 downto 0)
	);
end component;	

signal enderFD, dados : std_logic_vector(31 downto 0);
signal rwFD, h, lru, buffer_cheio, go_buffer : std_logic;
signal conjunto, conjuntoBuf : std_logic_vector(1 downto 0);
signal sujo1, sujo2 : std_logic_vector(127 downto 0);

begin		  
	
	hit <= h;
	
	-- Instancia do DCache
	DC: CacheDados_FD port map (
	ender     => enderFD,
	dados_in  => dados,
	rw        => rwFD, 
	clock     => clock,
	conjunto  => conjunto,
	dados_out => dados_out,
	hit       => h,
	lru_out   => lru,
	sujo1	  => sujo1,
	sujo2     => sujo2,
	go_buffer => go_buffer,	-- daqui para baixo eh do buffer 
	pronto    => prontoMPBuffer,
	buffer_cheio => buffer_cheio,
	enableMP  => enableMPBuffer,
	enderMP   => enderMPBuffer, 
	dadosMP   => dadosMPBuffer,
	conjuntoBuf => conjuntoBuf,
	rwMP      =>rwMPBuffer
	);
	
	DCUC: CacheDados_UC port map(
	clock   => clock,
	hit     => h,
	rw      => rw,
	lru     => lru,
	dados_in=> dados_in,
	ender   => ender,
	dadosMP => dadosMPUC,
	pronto  => prontoMPUC,
	buffer_cheio  => buffer_cheio,
	enderFD => enderFD,
	enderMP => enderMPUC,
	enableMP=> enableMPUC,
	go_buffer => go_buffer,
	rwFD    => rwFD,
	conjunto=> conjunto,
	conjuntoBuf => conjuntoBuf,
	dados   => dados,
	sujo1	  => sujo1,
	sujo2     => sujo2
	);
	
	
	hit <= h;
	
end CacheDados_Arc;
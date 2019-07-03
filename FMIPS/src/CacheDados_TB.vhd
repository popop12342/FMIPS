library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Bancada de teste do Cache de Dados
entity CacheDados_TB is
end CacheDados_TB;					 

architecture CacheDados_TB_Arc of CacheDados_TB is

component CacheDados is
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
end component;

component MemDriver is
	port(
		 enableMPBuffer : in STD_LOGIC;
		 enableMPUC : in STD_LOGIC;
		 rwMPBuffer : in STD_LOGIC;
		 enderMPUC : in STD_LOGIC_VECTOR(31 downto 0);
		 enderMPBuffer : in STD_LOGIC_VECTOR(31 downto 0);
		 dadosMPBuffer : in STD_LOGIC_VECTOR(31 downto 0);
		 prontoMP : in STD_LOGIC;
		 dados_outMP : in STD_LOGIC_VECTOR(31 downto 0);
		 rwMP : out STD_LOGIC;
		 enableMP : out STD_LOGIC;
		 dados_inMP : out STD_LOGIC_VECTOR(31 downto 0);
		 enderMP : out STD_LOGIC_VECTOR(31 downto 0);
		 prontoMPBuffer : out STD_LOGIC;
		 prontoMPUC : out STD_LOGIC;
		 dadosMPUC : out STD_LOGIC_VECTOR(31 downto 0)
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

signal  ender, dados_in, dados_out, dadosMPBuffer, enderMPBuffer, dadosMPUC, enderMPUC, enderMP, dados_inMP, dados_outMP : std_logic_vector(31 downto 0);
signal  clock, rw, hit, prontoMPBuffer, rwMPBuffer, enableMPBuffer, prontoMPUC, enableMPUC, rwMP, enableMP,prontoMP : std_logic;

begin		  
	
	CD : Cachedados port map(
	clock     => clock,
	ender     => ender,
	rw        => rw,
	dados_in  => dados_in,
	hit       => hit,
	dados_out => dados_out,
	prontoMPBuffer => prontoMPBuffer,
	enableMPBuffer => enableMPBuffer,
	enderMPBuffer  => enderMPbuffer,
	dadosMPBuffer  => dadosMPBuffer,
	rwMPBuffer     => rwMPBuffer,
	prontoMPUC => prontoMPUC,
	dadosMPUC  => dadosMPUC,
	enderMPUC  => enderMPUC,
	enableMPUC => enableMPUC
	);
	
	MD : MemDriver port map(
		enableMPBuffer => enableMPBuffer,
		 enableMPUC => enableMPUC,
		 rwMPBuffer => rwMPBuffer,
		 enderMPUC => enderMPUC,
		 enderMPBuffer => enderMPBuffer,
		 dadosMPBuffer => dadosMPBuffer,
		 prontoMP => prontoMP,
		 dados_outMP => dados_outMP,
		 rwMP => rwMP,
		 enableMP => enableMP,
		 dados_inMP => dados_inMP,
		 enderMP => enderMP,
		 prontoMPBuffer => prontoMPBuffer,
		 prontoMPUC => prontoMPUC,
		 dadosMPUC => dadosMPUC
	     );
	
	MP : MemoriaPrincipal port map(
		ender => enderMP,
		dados_in => dados_inMP,
		dados_out => dados_outMP,
		rw => rwMP,
		enable => enableMP,
		pronto => prontoMP
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
		rw <= '1';
		dados_in <= x"ABBAABBA";
		wait for 10 ns;
		ender <= x"00008000";
		wait for 5 ns;
		wait until hit = '1';
		ender <= x"00004000";
		wait until hit = '1';
	--	ender <= x"00000000";
--		rw <= '0';
--		wait for 10 ns;
--		rw <= '1';
--		dados_in <= x"ABBAABBA";
--		wait for 10 ns;
--		ender <= x"00000008"; -- primiero conjunto
--		wait for 10 ns;
--		ender <= x"00010004"; -- segundo conjunto
--		wait for 10 ns;
--		rw <= '1';
--		dados_in <= x"A0A0A0A0";
--		wait for 10 ns;
--		rw <= '0';
--		wait for 10 ns;
--		ender <= x"00008000";
--		wait until hit = '1';
	end process;
	
end CacheDados_TB_Arc;
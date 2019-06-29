library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
										  
entity MemoriaPrincipal_TB is
end MemoriaPrincipal_TB;

architecture MemoriaPrincipal_TB_arc of MemoriaPrincipal_TB is

-- Declaracao de componentes
component MemoriaPrincipal
	port (
	ender: in std_logic_vector(31 downto 0);
	dados_in: in std_logic_vector(31 downto 0);
	dados_out : out std_logic_vector(31 downto 0);
	rw: in std_logic;
	enable: in std_logic;
	pronto: out std_logic
	);
end component;

-- inputs
signal ender : std_logic_vector(31 downto 0) := (others => '0');
signal enable : std_logic := '1';
signal rw : std_logic := '0';

-- outputs
signal dados_in, dados_out : std_logic_vector(31 downto 0) := (others => 'Z');
signal pronto : std_logic;
									 

begin
	
	-- Instancia da MP
	MP: MemoriaPrincipal port map (
		ender => ender,
		dados_in => dados_in,
		dados_out => dados_out,
		rw => rw,
		enable => enable,
		pronto => pronto
	);	  
	
	MP_process: process
	begin
		ender <= x"00000000";
		enable <= '1';
		rw <= '0';
		wait for 50ns;
		ender <= x"00000004";
		wait for 50ns;			 
		ender <= x"00000010";
		wait for 50ns;
		rw <= '1';
		dados_in <= x"01010101";
		wait for 50 ns;
		rw <= '0';
		wait for 50 ns;
	end process;
	
		
end;

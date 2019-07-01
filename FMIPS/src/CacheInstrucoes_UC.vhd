library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CacheInstrucoes_UC is
	port(			   
	clock   : in std_logic;
	hit     : in std_logic;
	ender   : in std_logic_vector(31 downto 0);
	dadosMP : in std_logic_vector(31 downto 0);
	pronto  : in std_logic;
	enderFD : out std_logic_vector(31 downto 0);
	enderMP : out std_logic_vector(31 downto 0);
	enableMP : out std_logic;
	rw      : out std_logic;
	dados   : out std_logic_vector(31 downto 0)
	);
end CacheInstrucoes_UC;						 

architecture CacheInstrucoes_UC_Arc of CacheInstrucoes_UC is

constant Tcache : time := 5 ns;


begin					   
	
	process
	variable last_ender, pos_bloco : std_logic_vector(31 downto 0);
	variable tag : integer;
	variable index_bloco : integer range 0 to 255;
	begin 
		wait for 0 ns;
		enderFD <= ender;
		rw <= '0';
		wait until rising_edge(clock);					
		last_ender := ender;						
		tag := to_integer(unsigned(ender(31 downto 15)));
		index_bloco := to_integer(unsigned(ender(14 downto 7)));
		wait for Tcache;
		if hit = '0' then -- Miss
			for i in 0 to 15 loop
				enableMP <= '1';
				pos_bloco := last_ender(31 downto 7) & "0000000";
				enderMP <= pos_bloco + std_logic_vector(to_unsigned(4*i, ender'length)); -- Pede palavra para MP
				wait until pronto = '1';
				rw <= '1';  -- Escreve no cache
				enderFD <= pos_bloco + std_logic_vector(to_unsigned(4*i, ender'length));
				dados <= dadosMP;
				enableMP <= '0';
				wait for 5 ns;
			end loop;
			rw <= '0'; -- Repete acesso
			enderFD <= last_ender;
		end if;
	end process;
	
end CacheInstrucoes_UC_Arc;
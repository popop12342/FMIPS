library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WriteBuffer is
	port (
	dados_in  : in std_logic_vector(31 downto 0);
	clock : in std_logic;
	prontoMP	: in std_logic;
	goBuffer	: in std_logic;
	dados_out : out std_logic_vector(31 downto 0);
	prontoBuffer  : out std_logic;
	rwMP	: out std_logic;
	enableMP : out std_logic
	);
end WriteBuffer;

architecture WriteBuffer_Arc of WriteBuffer is

begin
	process--(clock,goBuffer)
	begin		  
		wait until rising_edge(clock);
		-- Escrita na Memoria, contando com que o endereço tenha sido setado certo na UC
		if goBuffer = '1' then
			rwMP <= '1';
			enableMP <= '1';
			dados_out <= dados_in;
			wait until prontoMP = '1';
			enableMP <= '0';
			wait for 5 ns;
			prontoBuffer <= '1';
		end if;
	
		if goBuffer = '0' then
			prontoBuffer <= '0';
			dados_out <= (others => 'Z'); 
		end if;
		
	end process;
	
end WriteBuffer_Arc;
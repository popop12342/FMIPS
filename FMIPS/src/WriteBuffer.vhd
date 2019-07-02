library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WriteBuffer is
	port (
	dados_in  : in std_logic_vector(31 downto 0);
	dados_out : out std_logic_vector(31 downto 0);
	);
end WriteBuffer;

architecture WriteBuffer_Arc of WriteBuffer is

begin
	dados_out <= dados_in;	
end WriteBuffer_Arc;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CacheDados_UC is
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
end CacheDados_UC;

architecture CacheDados_UC_Arc of CacheDados_UC is

constant Tcache : time := 5 ns;

begin
	-- Nao esta considerando dados sujos no cache! Ajustar depois
	process		
	variable last_ender, pos_bloco, last_dados_in : std_logic_vector(31 downto 0);
	variable tag : integer;
	variable index_bloco : integer range 0 to 127;
	variable last_rw : std_logic;
	begin
		wait for 0 ns;
		enderFD <= ender;
		rwFD <= rw;	
		dados <= dados_in;
		conjunto <= "00"; -- Qualquer um
		wait until rising_edge(clock);
		last_ender := ender;					 
		last_dados_in := dados_in;
		last_rw := rw;
		tag := to_integer(unsigned(ender(31 downto 13)));
		index_bloco := to_integer(unsigned(ender(12 downto 6)));
		wait for Tcache;
		if hit = '0' then -- Miss 
			
			--wait until buffer_cheio = '0';
			if buffer_cheio = '1' then
				wait until buffer_cheio = '0';
			end if;
			if (lru = '0' and sujo1(index_bloco) = '1') or (lru = '1' and sujo2(index_bloco) = '1') then
				go_buffer <= '1';
				if lru = '0' then
				   conjuntoBuf <= "01";
			   else
				   conjuntoBuf <= "10";
			   end if;
		   end if;
			
			pos_bloco := last_ender(31 downto 6) & "000000";
			for i in 0 to 15 loop  
				-- copia para buffer
				--enderMP <= pos_bloco + std_logic_vector(to_unsigned(4*i, ender'length)); -- Pede palavra para MP para ser escrito pelo buffer
				--goBuffer <= '1';
				--if (lru = '0' and sujo1(index_bloco) = '1') or (lru = '1' and sujo2(index_bloco) = '1') then 
				--	wait until prontoBuffer = '1'; -- se ainda não tiver terminado de escrever o comando anterior
				--	rwFD <= '0';
			   	--	enderFD <= pos_bloco + std_logic_vector(to_unsigned(4*i, ender'length));
			   	--	dadosBuffer <= dados_in after Tcache;			   		
			   --end if;	
			   -- Busca da Memoria
			   enableMP <= '1';
			   pos_bloco := last_ender(31 downto 6) & "000000";
			   enderMP <= pos_bloco + std_logic_vector(to_unsigned(4*i, ender'length)); -- Pede palavra para MP
			   wait until pronto = '1';
			   -- Escreve no cache
			   rwFD <= '1';
			   enderFD <= pos_bloco + std_logic_vector(to_unsigned(4*i, ender'length));
			   dados <= dadosMP;
			   if lru = '0' then
				   conjunto <= "01";
			   else
				   conjunto <= "10";
			   end if;
			   enableMP <= '0';
			   wait for 5 ns;
			end loop;
			if (buffer_cheio = '0') then
				go_buffer <= '0';
			end if;
			-- Repete acesso
			rwFD <= last_rw;
			enderFD <= last_ender;
			dados <= last_dados_in;
		end if;
	end process;
	
end CacheDados_UC_Arc;
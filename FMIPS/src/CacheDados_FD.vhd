library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Cache de Dados
entity CacheDados_FD is
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
end CacheDados_FD;

architecture CacheDados_FD_Arc of CacheDados_FD is
-- 127 blocos x 16 palavras x 32 bits
type dados_array is array(0 to 127, 0 to 15) of std_logic_vector(31 downto 0);
type bloco is array(0 to 15) of std_logic_vector(31 downto 0);
type v_array is array(0 to 127) of std_logic;
type tag_array is array(0 to 127) of std_logic_vector(18 downto 0);
type lru_array is array(0 to 127) of std_logic;
type dirty_array is array(0 to 127) of std_logic;

signal dados1: dados_array := (others => (x"10000000", x"11111111", x"12222222", x"13333333", x"14444444", x"15555555", x"16666666", x"17777777", x"18888888", x"19999999", x"1AAAAAAA", x"1BBBBBBB", x"1CCCCCCC", x"1DDDDDDD", x"1EEEEEEE", x"1FFFFFFF"));
signal dados2: dados_array := (others => (x"20000000", x"21111111", x"22222222", x"23333333", x"24444444", x"25555555", x"26666666", x"27777777", x"28888888", x"29999999", x"2AAAAAAA", x"2BBBBBBB", x"2CCCCCCC", x"2DDDDDDD", x"2EEEEEEE", x"2FFFFFFF"));
signal v1, v2 : v_array := (others => '1');		 
signal dirty1, dirty2 : std_logic_vector(127 downto 0) := (others => '0');
signal tag1 : tag_array := (others => x"0000" & "000"); 
signal tag2 : tag_array := (others => x"0001" & "000");
signal lru : lru_array := (others => '0');

signal tag : integer;
signal index_bloco : integer range 0 to 127;
signal index_palavra : integer range 0 to 15;
constant Tcache : time := 5 ns;
signal valid_tag1, valid_tag2 : std_logic; 

begin
	
	tag <= to_integer(unsigned(ender(31 downto 13)));
	index_bloco <= to_integer(unsigned(ender(12 downto 6)));
	index_palavra <= to_integer(unsigned(ender(5 downto 2)));
	
	valid_tag1 <= '1' when to_integer(unsigned(tag1(index_bloco))) = tag else '0';
	valid_tag2 <= '1' when to_integer(unsigned(tag2(index_bloco))) = tag else '0';
			
	process (clock, rw)
	begin
		if rising_edge(clock) then
			if rw = '0' then -- leitura
				if (valid_tag1 and v1(index_bloco)) = '1' then                    -- esta no conjunto 1
					hit <= '1' after Tcache;
					dados_out <= dados1(index_bloco, index_palavra) after Tcache;
					lru(index_bloco) <= '0';
				elsif (valid_tag2 and v2(index_bloco)) = '1' then                 -- esta no conjunto 2
					hit <= '1' after Tcache;
					dados_out <= dados2(index_bloco, index_palavra) after Tcache;
					lru(index_bloco) <= '1';
				else   
					hit <= '0' after Tcache;									  -- miss 
					lru_out <= lru(index_bloco);
					dados_out <= (others => 'X') after Tcache;
				end if;
			else -- escrita
				dados_out <= (others => 'X') after Tcache;
				if conjunto = "00" then -- escrito normal
					if (valid_tag1 and v1(index_bloco)) = '1' then					  -- esta no conjunto 1
						hit <= '1' after Tcache;
						dados1(index_bloco, index_palavra) <= dados_in after Tcache;
						lru(index_bloco) <= '0';
						dirty1(index_bloco) <= '1';
					elsif (valid_tag2 and v2(index_bloco)) = '1' then				  -- esta no conjunto 2
						hit <= '1' after Tcache;
						dados2(index_bloco, index_palavra) <= dados_in after Tcache;					   
						lru(index_bloco) <= '1';   
						dirty2(index_bloco) <= '1';
					else															  -- miss
						hit <= '0' after Tcache;											
						lru_out <= lru(index_bloco);
					end if;
				elsif conjunto = "01" then -- escrita da UC no conjunto 1
					dados1(index_bloco, index_palavra) <= dados_in after Tcache;
					v1(index_bloco) <= '1';
					tag1(index_bloco) <= ender(31 downto 13);
				elsif conjunto = "10" then -- escrita da UC no conjunto 2
					dados2(index_bloco, index_palavra) <= dados_in after Tcache;
					v2(index_bloco) <= '1';
					tag2(index_bloco) <= ender(31 downto 13);
				end if;
			end if;
		end if;
		sujo1 <= dirty1;
		sujo2 <= dirty2;
	end process;
	
	WriteBuffer : process
	variable dados : bloco;
	variable pos_bloco_w, last_ender_w : std_logic_vector(31 downto 0);
	variable index_bloco_w, index_palavra_w : integer;
	begin
		wait for 0 ns;
		buffer_cheio <= '0';
		wait until go_buffer = '1';
		-- Salva dados
		last_ender_w := ender;						  
		index_bloco_w := to_integer(unsigned(ender(13 downto 6)));
		index_palavra_w := to_integer(unsigned(ender(5 downto 2)));
		pos_bloco_w := ender(31 downto 6) & "000000";
		if conjuntoBuf = "01" then
			for i in 0 to 15 loop
				dados(i) := dados1(index_bloco_w, i);
			end loop;
		elsif conjuntoBuf = "10" then
			for i in 0 to 15 loop
				dados(i) := dados2(index_bloco_w, i);
			end loop;
		end if;
		buffer_cheio  <= '1';
		--  Grava na mem
		for i in 0 to 15 loop
			enableMP <= '1';		
			rwMP <= '1';
			enderMP <= pos_bloco_w + std_logic_vector(to_unsigned(4*i, ender'length));
			dadosMP <= dados(index_palavra_w);
			wait until pronto = '1';
			enableMP <= '0';
			wait for 5 ns;
		end loop;
		-- sinaliza buffer vazio
		buffer_cheio <= '0';  
	end process;
	
end CacheDados_FD_Arc;
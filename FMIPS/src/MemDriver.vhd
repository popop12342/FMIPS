-------------------------------------------------------------------------------
--
-- Title       : Fub2
-- Design      : FMIPS
-- Author      : felipepinna
-- Company     : poli
--
-------------------------------------------------------------------------------
--
-- File        : d:\My_Designs\FMIPS\FMIPS\src\MemDriver.vhd
-- Generated   : Tue Jul  2 19:11:18 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {Fub2} architecture {MemDriver}}

library IEEE;
use IEEE.std_logic_1164.all;

entity MemDriver is
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
end MemDriver;

--}} End of automatically maintained section

architecture MemDriver of MemDriver is

signal sel : std_logic_vector(1 downto 0);

begin									  
	
	sel <= enableMPUC & enableMPBuffer;

	-- enter your statements here -- 
	with sel select
		enableMP <= '1' when "01" | "10" | "11",
		'0' when others;			 
		
	with sel select
		rwMP <= '0' when "10" | "11",
		rwMPBuffer when "01",
		'0' when others;
		
	with sel select
		dados_inMP <= dadosMPBuffer when "01",
		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" when others;		   
		
	with sel select
		enderMP <= enderMPUC when "10" | "11",
		enderMPBuffer when "01",
		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" when others;	   
		
	with sel select
		prontoMPBuffer <= prontoMP when "01",
		'0' when others;				   
		
	with sel select
		prontoMPUC <= prontoMP when "10" | "11",
		'0' when others;				   
		
	with sel select
		dadosMPUC <= dados_outMP when "10" | "11",
		"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" when others;
		
end MemDriver;

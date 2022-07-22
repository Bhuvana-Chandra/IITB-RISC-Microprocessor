library ieee;
use ieee.std_logic_1164.all;
library work;
use work.basic_components.all;
entity nand_16 is
	port(a,b: in std_logic_vector(15 downto 0);
		op: out std_logic_vector(15 downto 0));
end entity;


-- Responsible for nanding two 16 bit numbers . 

architecture comp_nand of nand_16 is

begin
	op <= a nand b;
end comp_nand;


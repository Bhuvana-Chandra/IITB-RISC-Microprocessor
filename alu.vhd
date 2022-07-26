library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;

-- this is the arthimetic logic unit responsible for all the arthimetic operations . 
----------------------------------------------------------------------------------
entity alu is 
	port( x,y : in std_logic_vector(15 downto 0);
		typ : in std_logic ;
		cout, eq: out std_logic;
		z : out std_logic_vector(15 downto 0));
end entity;
-----------------------------------------------------------------------------------
architecture arc of alu is
	signal t1,t2: std_logic_vector(15 downto 0);
	signal carry1, carry2 : std_logic :='0';

	component adder16 is
      port (a,b: in std_logic_vector(15 downto 0);
		cin: in std_logic; cout: out std_logic;
		sum: out std_logic_vector(15 downto 0));
   end component adder16;

	component nand_16 is
	   port(a,b: in std_logic_vector(15 downto 0);
		op: out std_logic_vector(15 downto 0));
   end component nand_16;

begin
	p_1: adder16 port map (a => x, b => y,  cin => '0',sum => t1, cout => carry1);
	p_2: nand_16 port map (a => x, b => y, op => t2);

	-- if typ is '0' we add  the two numbers

	-- else we nand the two numbers

	process (typ, t1, t2, carry1, carry2)
	begin
		if (typ = '0') then
			z <= t1; 
			cout <= carry1;
			eq <= not (t1(0) or t1(1) or t1(2) or t1(3) or t1(4) or t1(5) or t1(6) or t1(7) or t1(8) or t1(9) or t1(10) or t1(11) or t1(12) or t1(13) or t1(14) or t1(15));
		elsif (typ = '1') then
			z <= t2; 
			cout <= carry2;
			eq <= not (t2(0) or t2(1) or t2(2) or t2(3) or t2(4) or t2(5) or t2(6) or t2(7) or t2(8) or t2(9) or t2(10) or t2(11) or t2(12) or t2(13) or t2(14) or t2(15));
	   end if;
	end process;

end arc;
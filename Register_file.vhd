library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;                    ------using standard libraries
use ieee.numeric_std.all; 

entity register_file is 
	port( adrress1,adrress2,adrress3 : in std_logic_vector(2 downto 0);
		  data3, data_pc: in std_logic_vector(15 downto 0);
		  
		clk,writer,pc_writer, reset: in std_logic ; 
		data1, data2: out std_logic_vector(15 downto 0));
end entity;

architecture arc of register_file is 
 
type regfile is array(0 to 7) of std_logic_vector(15 downto 0);
signal regs: regfile;
 
begin 

-- Register file for manipulation of variables and data includes temporary registers 

-- also 

process (clk)
begin 
	if((clk'event and clk = '0')) then
		if (reset = '1') then
			for i in 0 to 7 loop
				regs(i) <= "0000000000000000";
			end loop;
		else
             	if (writer = '1') then
		   		if (pc_writer = '1'and (not (adrress3 = "111"))) then
		   			regs(7) <= data_pc;
		   			regs(to_integer(unsigned(adrress3))) <= data3;
		   		elsif (pc_writer = '1' and adrress3 = "111") then
		   		   regs(7) <= data_pc;
		   		else
		   		   regs(to_integer(unsigned(adrress3))) <= data3;
		   		end if;
		   	end if;
		end if;
	end if;
end process;

process (adrress1, adrress2)
begin
	data1 <= regs(to_integer(unsigned(adrress1)));
	data2 <= regs(to_integer(unsigned(adrress2)));
end process;		  
end arc;
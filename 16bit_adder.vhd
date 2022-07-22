library ieee;
use ieee.std_logic_1164.all;
library work;
use work.basic_components.all;
entity adder16 is
  port (a,b: in std_logic_vector(15 downto 0);cin: in std_logic; cout: out std_logic; sum: out std_logic_vector(15 downto 0));
end entity adder16; 

--  Implemented as a 16 bit carry ripple adder . 

--  By using 16 full adders . 

architecture arc of adder16 is
  signal ti1, ti2,ti3,ti4,ti5,ti6,ti7,ti8,ti9,ti10,ti11,ti12,ti13,ti14,ti15: std_logic;
component Full_Adder  is
  port (a, b, cin: in std_logic; s, cout: out std_logic);
end component Full_Adder;
begin
        

       full_adder0: Full_Adder
       port map (a => a(0), b => b(0) , cin=>cin, s => sum(0), cout => ti1 );
       full_adder1: Full_Adder
       port map (a => a(1), b => b(1) , cin=> ti1, s => sum(1), cout => ti2 );
       full_adder2: Full_Adder
       port map (a => a(2), b => b(2) , cin=> ti2, s => sum(2), cout => ti3 );
		 full_adder3: Full_Adder
       port map (a => a(3), b => b(3) , cin=> ti3, s => sum(3), cout => ti4 );
		 full_adder4: Full_Adder
       port map (a => a(4), b => b(4) , cin=> ti4, s => sum(4), cout => ti5 );
		 full_adder5: Full_Adder
       port map (a => a(5), b => b(5) , cin=> ti5, s => sum(5), cout => ti6 );
		 full_adder6: Full_Adder
       port map (a => a(6), b => b(6) , cin=> ti6, s => sum(6), cout => ti7 );
		 full_adder7: Full_Adder
       port map (a => a(7), b => b(7) , cin=> ti7, s => sum(7), cout => ti8 );
		 full_adder8: Full_Adder
       port map (a => a(8), b => b(8) , cin=> ti8, s => sum(8), cout => ti9 );
		 full_adder9: Full_Adder
       port map (a => a(9), b => b(9) , cin=> ti9, s => sum(9), cout => ti10 );
		 full_adder10: Full_Adder
       port map (a => a(10), b => b(10) , cin=> ti10, s => sum(10), cout => ti11 );
		 full_adder11: Full_Adder
       port map (a => a(11), b => b(11) , cin=> ti11, s => sum(11), cout => ti12 );
		 full_adder12: Full_Adder
       port map (a => a(12), b => b(12) , cin=> ti12, s => sum(12), cout => ti13 );
		 full_adder13: Full_Adder
       port map (a => a(13), b => b(13) , cin=> ti13, s => sum(13), cout => ti14 );
		 full_adder14: Full_Adder
       port map (a => a(14), b => b(14) , cin=> ti14, s => sum(14), cout => ti15 );
		 full_adder15: Full_Adder
       port map (a => a(15), b => b(15) , cin=> ti15, s => sum(15), cout => cout );

       
end arc;
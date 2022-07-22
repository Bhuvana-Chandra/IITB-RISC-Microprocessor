library ieee;
use ieee.std_logic_1164.all;
library work;
use work.basic_components.all;
entity Full_Adder  is
  port (a, b, cin: in std_logic; s, cout: out std_logic);
end entity Full_Adder;

-- The full adder is designed using one half adder 

-- one And gate and one Or Gate and one Xor Gate . 

architecture arc of Full_Adder is
  signal  t,tc, ts: std_logic;
begin
   half_1: Half_Adder 
       port map (a => a, b => b, s => ts, C => tc);

  and_1: And_2 port map (a => ts, b => cin, Y => t);
  or_1: Or_2  port map (a => t, b => tc, Y => cout);

  xor_1: Xor_2 port map (a => ts, b => cin, Y => s);
end arc;
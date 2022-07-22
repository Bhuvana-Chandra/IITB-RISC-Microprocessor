library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 

-- This is the main file . 

entity RISC is
	port (clk,rst : in  std_logic);
end entity;


architecture behave of RISC is
component alu is 
	port( x,y : in std_logic_vector(15 downto 0);
		   typ : in std_logic ;
		   cout, eq: out std_logic;
		   z : out std_logic_vector(15 downto 0));
end component alu;

component imm_9bit is
	port ( x: in std_logic_vector(8 downto 0);
			typ: in std_logic;
			y: out std_logic_vector(15 downto 0));
end component imm_9bit;

component imm_6bit is
   port ( x: in std_logic_vector(5 downto 0);
         y: out std_logic_vector(15 downto 0));
end component imm_6bit;

component memory is 
	port ( writer,reader,clk : in std_logic; 
			adrress_in, data_in: in std_logic_vector(15 downto 0);
			data_out: out std_logic_vector(15 downto 0)); 
end component memory; 

component register_file is 
	port( adrress1,adrress2,adrress3 : in std_logic_vector(2 downto 0);
		   data3, data_pc: in std_logic_vector(15 downto 0);
		   clk,writer,pc_writer, reset: in std_logic ; 
		   data1, data2: out std_logic_vector(15 downto 0));
end component register_file;


type FSMState is (Sres, Sup, state1, state2, state3, state4, state5, state6, state7, state8, state9, state10, state11, state12, state13, state14, state15, state16, state17, state18, state19, state20, state21, state22,state23);
signal state: FSMState;
signal t1, t2, t3, t4, ir, sel9_out,sel6_out, mem_add, mem_din, mem_dout, alu_x, alu_y, alu_out, rdata3, rdata_PC, rdata1, rdata2 :std_logic_vector(15 downto 0):="0000000000000000";
signal mem_rd, sel9_type, mem_wr, alu_op ,rpc_wr,zero_out, car_out, z_out, rf_rst, carry, zero, rwr :std_logic:='0';
signal sel9_in : std_logic_vector(8 downto 0);
signal sel6_in : std_logic_vector(5 downto 0);
signal rA1, rA2, rA3: std_logic_vector(2 downto 0);
signal op_code : std_logic_vector(3 downto 0);
signal mem_addr: std_logic_vector(15 downto 0):="0000000000000000";

begin

sel9_reg : imm_9bit port map (sel9_in, sel9_type, sel9_out);
sel6_reg : imm_6bit port map (sel6_in, sel6_out);

register_file_main : register_file port map (rA1, rA2, rA3, rdata3,rdata_PC, clk, rwr,rpc_wr, rf_rst, rdata1, rdata2);
alu_main : alu port map (alu_x, alu_y, alu_op, car_out, z_out, alu_out);
mem_main : memory port map (mem_wr, mem_rd,clk, mem_add, mem_din, mem_dout);


process(clk,state)	
     variable next_state : FSMState;
	  variable t1_v, t2_v, t3_v, t4_v, ir_v, next_ip: std_logic_vector(15 downto 0);
	  variable z, car : std_logic;
	  variable op_v : std_logic_vector(3 downto 0);
	  
begin
	   next_state :=state;
		t1_v :=t1; t2_v :=t2; t3_v :=t3; t4_v :=t4; ir_v :=ir; op_v := op_code;
		z :=zero; car :=carry;
		next_ip :=mem_addr;
  case state is
       	when Sres =>
		    mem_wr <= '0';
		    mem_rd <= '0';
			rwr <= '0';
			rf_rst <= '1';
        	z := '0';
			car :='0';
        	t1_v := "0000000000000000";
        	t2_v := "0000000000000000";
        	t3_v := "0000000000000000";
			ir_v := "0000000000000000";
			next_state := state1;

		when state1 =>
		    mem_wr <= '0';
		    mem_rd <= '1';
			rwr <= '0';
			rf_rst <='0';
          	t1_v := "0000000000000000";
          	t2_v := "0000000000000000";
          	t3_v := "0000000000000000";
			mem_add <= mem_addr;
			ir_v := mem_dout;
			op_v := ir_v(15 downto 12);
			
			
			 
			case (op_v) is
				when "0001" =>
					next_state :=state4;
				when "0000" =>
					next_state :=state7;
				when "0010" =>
					next_state :=state4;
				when "0011" =>
					next_state :=state2;
				when "0111" =>
					next_state :=state8;
				when "0101" =>
					next_state :=state8;
				when "1100" =>
					next_state :=state9;
				when "1010" =>
					next_state :=state13;
				when "1000" =>
					next_state :=state4;
				when "1001" =>
				  	next_state :=state13;
				when "1101" =>
					next_state :=state9;
				when "1011" =>
				  	next_state :=state13;
			   when others => null;
          	end case; 

		when state4 =>
			mem_wr <= '0';
			mem_rd <= '0';
			rwr <= '0';
			rA1 <=ir_v(11 downto 9);       ------actions done when we are in state4
			rA2 <=ir_v(8 downto 6);
			t1_v := rdata1;
			t2_v := rdata2;
			next_state :=state5;

				
		when state5 =>
		    mem_wr <= '0';
		    mem_rd <= '0';
			rwr <= '0';                           ------actions done when we are in state5
		    alu_x <= t1_v;
			alu_y <= t2_v;
			if(op_v="0010") then
				alu_op <='1';
			else 
				alu_op <= '0';
			end if;
			t3_v := alu_out;
			
			case (op_v) is
				when "0001" =>
					next_state :=state6;
				when "0000" =>
					next_state :=state21;                  -------choosing nexxt state depending on the input
				when "0010" =>
					next_state :=state6;
				when "0111" =>
					next_state :=state19;
				when "0101" =>
					next_state :=state20;
				when "1000" =>
					if(t1_v=t2_v) then
					    next_state :=state18;
					else
						next_state :=Sup;
					end if;
				when others => null;
            end case; 
		 
		when state6 =>
			mem_wr <= '0';
		    mem_rd <= '0';
			rwr <= '1';
			if(ir_v(1 downto 0)="00") then
				rdata3<=t3_v;
				rA3<=ir_v(5 downto 3);
				if(op_v="0001" or op_v="0000" or op_v="0010" or op_v="0111") then
					z :=z_out;
				end if;
				if(op_v="0001" or op_v="0000") then
					car:=car_out;
				end if;
			elsif(ir_v(1 downto 0)="10" and car='1') then
				rdata3<=t3_v;
				rA3<=ir_v(5 downto 3);
				if(op_v="0001" or op_v="0000" or op_v="0010" or op_v="0111") then
					z :=z_out;
				end if;
				if(op_v="0001" or op_v="0000") then
				car:=car_out;
				end if;
         elsif(ir_v(1 downto 0)="01" and z='1') then
				rdata3<=t3_v;
				rA3<=ir_v(5 downto 3);
				if(op_v="0001" or op_v="0000" or op_v="0010" or op_v="0111") then
					z :=z_out;
				end if;
				if(op_v="0001" or op_v="0000") then
					car:=car_out;
				end if;
			elsif(ir_v(1 downto 0)="11" and z='1') then
			    t1_v:=rdata1;
				t2_v:=rdata2(14 downto 0)&'0';
				alu_x <= t1_v;
			    alu_y <= t2_v;
				alu_op <='0';
				t3_v := alu_out;
				rdata3<=t3_v;
				rA3<=ir_v(5 downto 3);
				if(op_v="0001" or op_v="0000" or op_v="0010" or op_v="0111") then
				    z :=z_out;
				end if;
				if(op_v="0001" or op_v="0000") then
				    car:=car_out;
				end if;
		    end if;
			next_state :=Sup;

		when state7 =>
			mem_wr <= '0';
		    mem_rd <= '0';
			rwr <= '0';
		    rA1 <=ir_v(11 downto 9);           ------actions done when we are in state7
			t1_v := rdata1;
			sel6_in <=ir_v(5 downto 0);
			t2_v := sel6_out;
			next_state :=state5;

				
		when state21 =>
			mem_wr <= '0';
			mem_rd <= '0';
			rwr <= '1';
			if(op_v="0001" or op_v="0000" or op_v="0010" or op_v="0111") then
				z :=z_out;
			end if;
			if(op_v="0001" or op_v="0000") then
				car:=car_out;
			end if;
			rdata3<=t3_v;
			rA3<=ir_v(8 downto 6);
        	next_state :=Sup;

				
		when state2 =>
			mem_wr <= '0';
			mem_rd <= '0';
			rwr <= '0';
			sel9_in <= ir_v(8 downto 0);
			sel9_type<='1';
			t1_v := sel9_out;
			next_state :=state3;

		when state3 =>
			mem_wr <= '0';
		    mem_rd <= '0';                          ------actions done when we are in state2
		    rwr <= '1';
			rdata3<=t1_v;
			rA3<=ir_v(11 downto 9);
        	next_state :=Sup;

				
        when state8 =>
        	mem_wr <= '0';
		    mem_rd <= '0';
		   	rwr <= '0';
		    rA1 <=ir_v(8 downto 6);
			t1_v := rdata1;
			sel6_in <=ir_v(5 downto 0);
			t2_v := sel6_out;
			next_state :=state5;

		when state19 =>
			mem_rd <='1';
			if(op_v="0001" or op_v="0000" or op_v="0010" or op_v="0111") then
				z :=z_out;
			end if;
			if(op_v="0001" or op_v="0000") then
				car:=car_out;
			end if;
			mem_add <= t3_v;
			t1_v := mem_dout;                     ------actions done when we are in state19
			rwr <= '1';
			rdata3<=t1_v;
			rA3<=ir_v(11 downto 9);
            next_state :=Sup;

		when state20 =>
    		mem_wr <= '1';
			mem_rd <= '0';
			rwr <= '0';
			rA1 <=ir_v(11 downto 9);
			t2_v := rdata1;
			mem_add <= t3_v;
			mem_din <= t2_v;
			next_state :=Sup;

				
	    when state9 =>
			mem_wr <= '0';
		    mem_rd <= '0';
			rwr <= '0';
		    rA1 <=ir_v(11 downto 9);
			t1_v := rdata1;
			if(op_v="1100") then                       ------actions done when we are in state9
				next_state :=state10;
			else
				next_state :=state16;
			end if;

		when state10 =>
			mem_wr <= '0';
		    mem_rd <= '1';
			rwr <= '0';
		    mem_add <= t1_v;
			t3_v := mem_dout;
			next_state :=state11;

		when state11 =>
			rwr <= '1';
			rdata3<=t3_v;
			rA3<=t2_v(2 downto 0);
			alu_x <= t2_v;
			alu_y <= "0000000000000001";
			alu_op <= '0';
			t2_v := alu_out;
			next_state :=state12;
 
        when state12 =>
		   	alu_x <= t1_v;
			alu_y <= "0000000000000001";
			alu_op <= '0';
			t1_v := alu_out;
			if(unsigned(t2_v)<8) then
				if(op_v="1100") then
					if (ir_v(to_integer(unsigned(t2_v))) = '1') then
			    		next_state :=state10;
				 	end if; 
					
			  	else                             ------actions done when we are in state12
			    	next_state :=state16;
			  	end if;
			else
				next_state :=Sup;
			end if;
			
		when state16 =>
			mem_wr <= '1';
		    mem_rd <= '0';
			rwr <= '0';
		    rA2 <=t2_v(2 downto 0);
			if (ir_v(to_integer(unsigned(t2_v))) = '1') then
				t3_v := rdata2;		
	        	mem_din <= t3_v;
			end if;
			mem_add <= t1_v;
	        next_state :=state15;

		when state15 =>
			alu_x <= t2_v;
			alu_y <= "0000000000000001";
			alu_op <='0';
			t2_v :=alu_out;
			next_state :=state12;

				
        when state13 =>
			mem_wr <= '0';
			mem_rd <= '0';
			rwr <= '1';
			rdata3<=mem_addr;
			rA3<=ir_v(11 downto 9);
			if(op_v="1010") then               ------actions done when we are in state13
				next_state :=state14;
			elsif(op_v="1011") then
				next_state :=state23;
			else
				next_state :=state22;
			end if;
				
		when state23 =>
			mem_wr <= '0';
			mem_rd <='0';
			rwr <= '0';
			rA2<=ir_v(11 downto 9);
			t1_v:=rdata2;
			alu_x <= t1_v;
			sel9_in <=ir_v(8 downto 0);
			sel9_type <='0';
			alu_y <=sel9_out;
			alu_op <= '0';
			next_ip:=alu_out;
			next_state :=state1;

				
        when state14 =>
            mem_wr <= '0';
		    mem_rd <= '0';
			rwr <= '0';
		    rA1 <=ir_v(8 downto 6);
			next_ip := rdata1;
	        next_state :=state1;

		when state22 =>
			mem_wr <= '0';
		    mem_rd <= '0';
			rwr <= '0';
			alu_x <=next_ip;
			sel9_in <=ir_v(8 downto 0);
			sel9_type <='0';
			alu_y <=sel9_out;
			alu_op <= '0';
			next_ip:=alu_out;
			next_state :=state1;

				
        when state18 =>
        	alu_x <= mem_addr;
	        sel6_in <= ir_v(5 downto 0);
	        alu_y <= sel6_out;
			alu_op<='0';
			next_ip:=alu_out;
			next_state :=state1;

		when Sup =>
			mem_wr <= '0';
			mem_rd <= '0';
			rwr <= '0';
			rpc_wr <='1';
			alu_x <= mem_addr;
			alu_y <= "0000000000000001";
			alu_op <= '0';
			next_ip := alu_out;
			rdata_pc <= alu_out;
			next_state :=state1;
		when others => null;
  end case;		
  
 if(clk'event and clk = '0') then
          if(rst = '1') then
             state <= Sres;
          else
             state <= next_state;
				 t1<=t1_v;t2<=t2_v;t3<=t3_v;t4<=t4_v;
				 zero<=z; carry<=car;
				 ir<=ir_v;
				 op_code<=op_v;
				 mem_addr<=next_ip;
          end if;
     end if;
end process;
end behave;
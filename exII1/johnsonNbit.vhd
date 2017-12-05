-- File : johnsonNbit.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity johnsonNbit_rtl is
	generic(N : integer := 3);
	port (
		signal clk_i : in std_logic;
		signal rst_i : in std_logic;
		signal max_o : out std_logic;
		signal out_o : out std_logic_vector(N downto 0)
	);
end entity johnsonNbit_rtl;

architecture rtl of johnsonNbit_rtl is
	signal next_state : std_logic_vector(out_o'range);
begin
	process(rst_i,clk_i)
		variable v : signed(out_o'range);
		variable msb : std_logic;
	begin
		v := signed(next_state);
		if rst_i = '1' then
			v := (v'range => '0');
		elsif rising_edge(clk_i) then
			msb := v(v'high);
			v := v sll 1;
			v(v'low) := not msb;
		end if;
		next_state <= std_logic_vector(v);
	end process;

	process(rst_i,clk_i,next_state)
	begin
		-- Default values
		max_o <= '0';
		out_o <= next_state;
		if rst_i = '0' then
			out_o <= next_state;
			if next_state = '1' & (next_state'high-1 downto 0 => '0') then
				max_o <= '1';
			end if;
		end if;
	end process;

end architecture rtl;

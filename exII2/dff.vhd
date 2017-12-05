-- File : dff.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity dff is
	port (
		signal clk_i : in std_logic;
		signal rst_i : in std_logic;
		signal d_i : in std_logic;
		signal out_o : out std_logic
	);
end entity dff;

architecture rtl of dff is
begin
	process(rst_i,clk_i)
		variable v : signed(out_o'range);
		variable msb : std_logic;
	begin
		if rst_i = '1' then
			out_o <= '0';
		elsif rising_edge(clk_i) then
			out_o <= d_i;
		end if;
	end process;

end architecture rtl;

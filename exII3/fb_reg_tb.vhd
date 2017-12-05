-- File : fb_reg_tb.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fb_reg_tb is end;

architecture bench_direct of fb_reg_tb is
	constant CLK_T : time := 10 ns;

	signal clk_tb : std_logic := '0';
	signal res_tb : std_logic := '1';
	signal out_tb : std_logic_vector(7 downto 0) := (others => '0');
	signal sequence : std_logic_vector((2 ** (out_tb'high+1))-1 downto 0) := (others => '0');
begin
	DUV : entity work.fb_reg_2
		port map (
			clk_i => clk_tb,
			rst_i => res_tb,
			out_o => out_tb
		);

	process 
		-- Generate clock
		procedure clock_gen(cycle : natural) is
		begin
			for i in cycle-1 downto 0 loop
				clk_tb <= not clk_tb;
				wait for CLK_T;
			end loop;
		end procedure clock_gen;
	begin
		res_tb <= '1';
		clock_gen(1);
		res_tb <= '0';

		for i in sequence'high*2/2 downto 0 loop
			clock_gen(2);
			assert '0' = sequence(to_integer(unsigned(out_tb)))
				report "Failed";
			sequence(to_integer(unsigned(out_tb))) <= '1';
		end loop;
		wait;
	end process;

end architecture bench_direct;
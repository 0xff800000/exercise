-- File : async_counter_tb.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity async_counter_tb is end;

architecture bench_direct of async_counter_tb is
	constant CLK_T : time := 10 ns;

	signal clk_tb : std_logic := '0';
	signal res_tb : std_logic := '1';
	signal out_tb : std_logic := '0';
begin
	DUV : entity work.async_counter
		generic map (M => 4)
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
		clock_gen(40);
		wait;
	end process;

end architecture bench_direct;
-- File : async_counter.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity async_counter is
		generic(
			M : integer := 2;
			REG_DELAY : natural := 1
		);
		port (
				signal clk_i : in std_logic;
				signal rst_i : in std_logic;
				signal out_o : out std_logic
		);
end entity async_counter;

architecture rtl of async_counter is
	signal q_s : std_logic_vector(M downto 0);
	signal not_q_s : std_logic_vector(M downto 0);
	signal clk_in_s : std_logic_vector(M downto 0);
	signal d_in : std_logic_vector(M downto 0);
begin
	-- Create D flip-flop
	FOR1 : for i in 0 to M generate
		process (clk_in_s(i), rst_i) is
		begin
			if rst_i = '1' then
				q_s(i) <= '0';
			elsif rising_edge(clk_in_s(i)) then
				q_s(i) <= d_in(i) after 1 ns;
			end if;
		end process;
		not_q_s(i) <= not q_s(i);
	end generate FOR1;

	-- Manage other signals
	d_in <= not_q_s;
	clk_in_s(M downto 1) <= q_s(M-1 downto 0);
	clk_in_s(0) <= clk_i;

	-- Resync the output with master clock
	process(rst_i, clk_i)
	begin
		if rst_i = '1' then
			out_o <= '0';
		elsif rising_edge(clk_i) then
			out_o <= q_s(q_s'high);
		end if;
	end process;

end architecture rtl;
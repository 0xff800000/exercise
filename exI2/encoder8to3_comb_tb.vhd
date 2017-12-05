-- File: encoder8to3_comb_tb_direct.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity encoder8to3_comb_tb is end;

architecture bench_direct of encoder8to3_comb_tb is
	constant WAIT_TIME : time := 2 ns;

	signal req_tb : std_logic_vector(7 downto 0);

	signal code_comb : std_logic_vector(2 downto 0);
	signal valid_comb : std_logic;

	signal code_algo : std_logic_vector(2 downto 0);
	signal valid_algo : std_logic;
begin

	DUV1 : entity work.encoder8to3_comb
		port map(
			req => req_tb,
			code => code_comb,
			valid => valid_comb);

	DUV2 : entity work.encoder8to3_combAlgo
		generic map (N => 3)
		port map(
			req => req_tb,
			code => code_algo,
			valid => valid_algo);

	STIM : process
	begin
		for i in 0 to 255 loop
			req_tb <= std_logic_vector(to_unsigned(i, req_tb'length));
			wait for WAIT_TIME;
		end loop;
		wait;
	end process STIM;

end architecture bench_direct;
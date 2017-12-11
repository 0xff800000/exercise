-- File . barrelshift8_rtl.vhd
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity barrelshift8_rtl2 is
	generic (N : integer := 8);
	port (
		signal in_i : in std_logic_vector(N-1 downto 0);
		signal cmd_i : in std_logic_vector(1 downto 0);
		signal amt_i : in std_logic_vector(integer(ceil(log2(real(N)))) - 1 downto 0);
		signal out_o : out std_logic_vector(N-1 downto 0)
	);
end entity barrelshift8_rtl2;

architecture rtl of barrelshift8_rtl2 is-- Shift right logic
	type std_logic_matrix is array (integer range <>) of std_logic_vector(in_i'range);
	signal right_part,lsr_res,asr_res,rr_res : std_logic_matrix(in_i'range);
	signal mat_index : integer;
	--signal right_part,lsr_res,asr_res,rr_res : std_logic_vector(in_i'range); -- Procedural
begin
	FOR1 : for i in in_i'range generate
		-- Create right part - common for all ops
		right_part(i)(in_i'high downto i) <= in_i(in_i'high downto i);
		right_part(i)(i-1 downto in_i'low) <= (i-1 downto in_i'low => '0');
		-- Logic shift right
		lsr_res(i) <= (i-1 downto in_i'low => '0') & right_part(i)(in_i'high downto i);
		-- Arithmetic shift right
		asr_res(i) <= (i-1 downto in_i'low => in_i(in_i'high)) & right_part(i)(in_i'high downto i);
		-- Rotate right
		rr_res(i) <= in_i(i-1 downto in_i'low) & right_part(i)(in_i'high downto i);
	end generate FOR1;

	mat_index <= to_integer(unsigned(amt_i));

	with cmd_i select out_o <=
		lsr_res(mat_index) when "00",
		asr_res(mat_index) when "01",
		rr_res(mat_index) when "10",
		(out_o'range => '0') when others;	

	-- Procedural aproach
	-- Create right part - common for all ops
	--process(in_i,amt_i)
	--	variable index : integer;
	--begin
	--	index := to_integer(unsigned(amt_i));
	--	right_part(in_i'high downto index) <= in_i(in_i'high downto index);
	--	right_part(index-1 downto in_i'low) <= (index-1 downto in_i'low => '0');
	--end process;

	--process(in_i,amt_i,right_part)
	--	variable index : integer;
	--begin
	--	index := to_integer(unsigned(amt_i));
	--	---- Logic shift right
	--	lsr_res(in_i'range) <= (index-1 downto in_i'low => '0') & right_part(in_i'high downto index);
	--	---- Arithmetic shift right
	--	asr_res(in_i'range) <= (index-1 downto in_i'low => in_i(in_i'high)) & right_part(in_i'high downto index);
	--	---- Rotate right
	--	rr_res(in_i'range) <= in_i(index-1 downto in_i'low) & right_part(in_i'high downto index);
	--end process;

	--with cmd_i select out_o <=
	--	lsr_res when "00",
	--	asr_res when "01",
	--	rr_res when "10",
	--	(out_o'range => '0') when others;

end architecture rtl;
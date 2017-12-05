-- File : barrelshift8_rtl1.vhd
library ieee;
use ieee.std_logic_1164.all;

entity barrelshift8_rtl1 is
	port (
		signal in_i : in std_logic_vector(7 downto 0);
		signal cmd_i : in std_logic_vector(1 downto 0);
		signal amt_i : in std_logic_vector(2 downto 0);
		signal out_o : out std_logic_vector(7 downto 0)
	);
end entity barrelshift8_rtl1;

architecture rtl of barrelshift8_rtl1 is
	signal lsr_res,asr_res,rr_res : std_logic_vector(in_i'range);
begin
	-- Shift right logic
	with amt_i select lsr_res <=
		in_i when "000",
		"0" & in_i(7 downto 1) when "001",
		"00" & in_i(7 downto 2) when "010",
		"000" & in_i(7 downto 3) when "011",
		"0000" & in_i(7 downto 4) when "100",
		"00000" & in_i(7 downto 5) when "101",
		"000000" & in_i(7 downto 6) when "110",
		"0000000" & in_i(7) when others;

	-- Arithmetic shift right
	with amt_i select asr_res <=
		in_i when "000",
		in_i(7) & in_i(7 downto 1) when "001",
		in_i(7) & in_i(7) & in_i(7 downto 2) when "010",
		in_i(7) & in_i(7) & in_i(7) & in_i(7 downto 3) when "011",
		in_i(7) & in_i(7) & in_i(7) & in_i(7) & in_i(7 downto 4) when "100",
		in_i(7) & in_i(7) & in_i(7) & in_i(7) & in_i(7) & in_i(7 downto 5) when "101",
		in_i(7) & in_i(7) & in_i(7) & in_i(7) & in_i(7) & in_i(7) & in_i(7 downto 6) when "110",
		(others => in_i(7)) when others;

	-- Rotate right
	with amt_i select rr_res <=
		in_i when "000",
		in_i(0) & in_i(7 downto 1) when "001",
		in_i(1 downto 0) & in_i(7 downto 2) when "010",
		in_i(2 downto 0) & in_i(7 downto 3) when "011",
		in_i(3 downto 0) & in_i(7 downto 4) when "100",
		in_i(4 downto 0) & in_i(7 downto 5) when "101",
		in_i(5 downto 0) & in_i(7 downto 6) when "110",
		in_i(6 downto 0) & in_i(7) when others;

	-- Select output
	with cmd_i select out_o <=
		lsr_res when "00",
		asr_res when "01",
		rr_res when "10",
		(out_o'range => '0') when others;
end architecture rtl;
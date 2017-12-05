-- File: encoder8to3_combinational.vhd
library ieee;
use ieee.std_logic_1164.all;

entity encoder8to3_comb is
port (
	signal req : in std_logic_vector(7 downto 0);
	signal code : out std_logic_vector(2 downto 0);
	signal valid : out std_logic);
end entity encoder8to3_comb;

architecture comb of encoder8to3_comb is
signal valid_s : std_logic;
signal code_s : std_logic_vector(code'range);
begin
	code <= code_s when valid_s = '1' else (code'range => '0');
	code_s(2) <= req(7) or req(6) or req(5) or req(4);
	code_s(1) <= req(7) or req(6) or req(3) or req(2);
	code_s(0) <= req(7) or req(5) or req(3) or req(1);

	valid <= valid_s;
	valid_s <= '1' when 
		req = "10000000" or
		req = "01000000" or
		req = "00100000" or
		req = "00010000" or
		req = "00001000" or
		req = "00000100" or
		req = "00000010" or
		req = "00000001"
	else '0';
end architecture comb;
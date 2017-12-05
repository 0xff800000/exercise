-- File: encoder8to3_combinational.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use IEEE.math_real.all; -- Used for power function

entity encoder8to3_combAlgo is
port (
	signal req : in std_logic_vector(7 downto 0);
	signal code : out std_logic_vector(2 downto 0);
	signal valid : out std_logic);
end entity encoder8to3_combAlgo;

architecture comb of encoder8to3_combAlgo is
begin
	--process(req)
	--	variable c : std_logic;
	--	variable a : integer;
	--begin
	--	c := '0';
	--	for i in code'range loop
	--		c:='0';
	--		for k in req'range loop
	--			if (k/(2 ** i)) mod 2 = 1 then
	--				c := c or req(k);
	--			end if;
	--		end loop;
	--		code(i) <= c;
	--	end loop;
	--end process;

	for i in code'range generate
		for k in req'range generate
			if (k/(2 ** i)) mod 2 = 1 then
				code(i) := code(i) or req(k);
			end if;
		end generate;
	end generate;

	valid <= '1' when 
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
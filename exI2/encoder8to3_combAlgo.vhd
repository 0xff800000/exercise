-- File: encoder8to3_combinational.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity encoder8to3_combAlgo is
generic (N : integer := 4);
port (
	signal req : in std_logic_vector((2**N - 1) downto 0);
	signal code : out std_logic_vector(N-1 downto 0);
	signal valid : out std_logic);
end entity encoder8to3_combAlgo;


architecture comb of encoder8to3_combAlgo is
	type std_logic_matrix is array (integer range <>) of std_logic_vector(req'range);

	signal code_s : std_logic_vector(code'range);
	signal valid_s : std_logic;

	signal mask : std_logic_matrix(code'range);
	signal compute : std_logic_matrix(code'range);

	signal valid_out : std_logic_matrix(req'range);
signal check_valid : std_logic_vector(req'range);
begin

	-- Generate mask
	FOR1:for i in code'range generate
		FOR2:for k in req'range generate
			IF1:if (k/(2 ** i)) mod 2 = 1 generate
				mask(i)(k) <= '1';
			end generate IF1;
			IF2:if (k/(2 ** i)) mod 2 = 0 generate
				mask(i)(k) <= '0';
			end generate IF2;
		end generate FOR2;
	end generate FOR1;

	-- Compute the masked input
	FOR3:for i in code'range generate
		code(i) <= '0' when compute(i) = (compute(i)'range => '0') else '1';
	end generate FOR3;

	FOR4:for i in code'range generate
		compute(i) <= req and mask(i) when valid_s = '1' else (compute(i)'range => '0');
	end generate FOR4;

	-- Generate the valid outputs
	FOR5:for i in req'range generate
		valid_out(i) <= std_logic_vector(to_unsigned(2**i,valid_out'length));
		check_valid(i) <= '1' when req = valid_out(i) else '0';
	end generate FOR5;
	valid_s <= '0' when check_valid = (check_valid'range => '0') else '1';
	valid <= valid_s;



	-- Process solution
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

	-- Manage the valid output
	--valid <= valid_s;
	--process(req)
	--variable v : integer;
	--begin
	--	v := 0;
	--	for i in req'range loop
	--		if req(i) = '1' then
	--			v := v + 1;
	--		end if;
	--	end loop;
	--	if v = 1 then
	--		valid_s <= '1';
	--	else
	--		valid_s <= '0';
	--	end if;
	--end process;

end architecture comb;

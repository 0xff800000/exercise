-- File : johnson4bit.vhd
library ieee;
use ieee.std_logic_1164.all;

entity johnson4bit_rtl is
	port (
		signal clk_i : in std_logic;
		signal rst_i : in std_logic;
		signal max_o : out std_logic;
		signal out_o : out std_logic_vector(3 downto 0)
	);
end entity johnson4bit_rtl;

architecture rtl of johnson4bit_rtl is
	signal next_state : std_logic_vector(out_o'range);
begin
	process(rst_i,clk_i)
	begin
		if rst_i = '1' then
			next_state <= (next_state'range => '0');
		elsif rising_edge(clk_i) then
			if next_state = "0000" then
				next_state <= "0001";
			elsif next_state = "0001" then
				next_state <= "0011";
			elsif next_state = "0011" then
				next_state <= "0111";
			elsif next_state = "0111" then
				next_state <= "1111";
			elsif next_state = "1111" then
				next_state <= "1110";
			elsif next_state = "1110" then
				next_state <= "1100";
			elsif next_state = "1100" then
				next_state <= "1000";
			else
				next_state <= "0000";
			end if;
		end if;
	end process;

	process(rst_i,clk_i,next_state)
	begin
		-- Default values
		max_o <= '0';
		out_o <= next_state;
		if rst_i = '0' then
			out_o <= next_state;
			if next_state = "1000" then
				max_o <= '1';
			end if;
		end if;
	end process;

end architecture rtl;

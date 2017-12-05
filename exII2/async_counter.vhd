-- File : async_counter.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity async_counter is
	generic(M : integer := 2);
	port (
		signal clk_i : in std_logic;
		signal rst_i : in std_logic;
		signal out_o : out std_logic
	);
end entity async_counter;

architecture rtl of async_counter is
	signal out_s : std_logic;
begin
	process(rst_i,clk_i)
		variable shift_reg : unsigned(2 ** (M-1)-1 downto 0);
		variable msb : std_logic;
	begin
		if rst_i = '1' then
			shift_reg := (shift_reg'high downto shift_reg'low+1 => '0') & '1';
			out_s <= '0';
		elsif rising_edge(clk_i) then
			msb := shift_reg(shift_reg'high);
			shift_reg := shift_reg sll 1;
			shift_reg(shift_reg'low) := msb; 
			if msb = '1' then
				out_s <= not out_s;
			end if;
		end if;
	end process;

	-- Resynchronize the output with next rising edge of master clock
	process(rst_i,clk_i)
	begin
	if rising_edge(clk_i) then
		out_o <= out_s;
	end if;
	end process;

end architecture rtl;

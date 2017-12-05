-- File : fb_reg.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fb_reg is
	--generic(M : integer := 2);
	port (
		signal clk_i : in std_logic;
		signal rst_i : in std_logic;
		signal out_o : out std_logic_vector(7 downto 0)
	);
end entity fb_reg;

architecture rtl of fb_reg is
	constant val_init : std_logic_vector(out_o'range) := (out_o'high downto out_o'low+1 => '0') & '1';

	signal msb : std_logic;
	signal shift_reg_s : std_logic_vector(out_o'range);
begin
	process(rst_i,clk_i)
	begin
		if rst_i = '1' then
			shift_reg_s <= val_init;
		elsif rising_edge(clk_i) then
			shift_reg_s <= msb & shift_reg_s(shift_reg_s'high downto shift_reg_s'low+1);
		end if;
	end process;

	msb <= shift_reg_s(0) xor shift_reg_s(2) xor shift_reg_s(3) xor shift_reg_s(4);

	out_o <= shift_reg_s;

end architecture rtl;

-- File : fb_reg.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fb_reg_2 is
	--generic(M : integer := 2);
	port (
		signal clk_i : in std_logic;
		signal rst_i : in std_logic;
		signal out_o : out std_logic_vector(7 downto 0)
	);
end entity fb_reg_2;

architecture rtl of fb_reg_2 is
	constant val_init : std_logic_vector(out_o'range) := (out_o'high downto out_o'low+1 => '0') & '0';

	signal msb : std_logic;
	signal new_msb : std_logic;
	signal shift_reg_s : std_logic_vector(out_o'range);
	signal n_shift_reg_s : std_logic_vector(out_o'range);
begin
	process(rst_i,clk_i)
	begin
		if rst_i = '1' then
			shift_reg_s <= val_init;
		elsif rising_edge(clk_i) then
			shift_reg_s <= new_msb & shift_reg_s(shift_reg_s'high downto shift_reg_s'low+1);
		end if;
	end process;

	msb <= shift_reg_s(0) xor shift_reg_s(2) xor shift_reg_s(3) xor shift_reg_s(4);
	new_msb <= msb xor (n_shift_reg_s(0) and n_shift_reg_s(1) and n_shift_reg_s(2) and n_shift_reg_s(3) and n_shift_reg_s(4) and n_shift_reg_s(5) and n_shift_reg_s(6) and n_shift_reg_s(7));
	n_shift_reg_s <= not shift_reg_s;
	out_o <= shift_reg_s;

end architecture rtl;

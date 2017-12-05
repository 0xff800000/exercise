-- File : barrelshift8_tb_direct.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity barrelshift8_tb is end;

architecture bench_direct of barrelshift8_tb is
	constant WAIT_TIME : time := 10 ns;
	constant NBITS : natural := 8;
	type cmd_name_type is (LSR, ASR, RR);

	signal opa_tb,res_tb : std_logic_vector(NBITS-1 downto 0);
	signal res_exp : unsigned(NBITS-1 downto 0) := (others => '0');
	signal cmd_tb : std_logic_vector(1 downto 0);
	signal cmd_name : cmd_name_type;
	signal amt_tb : std_logic_vector(natural(ceil(log2(real(NBITS))))-1 downto 0);
begin
	DUV : entity work.barrelshift8_rtl2
		port map (
			in_i => opa_tb,
			cmd_i => cmd_tb,
			amt_i => amt_tb,
			out_o => res_tb
		);
	process
		procedure do_lsr (amt : natural) is
		begin
			cmd_tb <= "00"; cmd_name <= LSR;
			amt_tb <= std_logic_vector(to_unsigned(amt, amt_tb'length));
			res_exp <= unsigned(opa_tb) srl amt;
			wait for WAIT_TIME;
			report "LSR check";
			assert res_tb = std_logic_vector(res_exp)
				report "LSR failed";
			wait for WAIT_TIME/2;
		end procedure do_lsr;

		procedure do_asr (amt : natural) is
		begin
			cmd_tb <= "01"; cmd_name <= ASR;
			amt_tb <= std_logic_vector(to_unsigned(amt, amt_tb'length));
			res_exp <= unsigned(shift_right(signed(opa_tb), amt));
			wait for WAIT_TIME;
			report "ASR check";
			assert res_tb = std_logic_vector(res_exp)
				report "ASR failed";
			wait for WAIT_TIME/2;
		end procedure do_asr;

		procedure do_rr (amt : natural) is
		begin
			cmd_tb <= "10"; cmd_name <= RR;
			amt_tb <= std_logic_vector(to_unsigned(amt, amt_tb'length));
			res_exp <= unsigned(opa_tb) ror amt;
			wait for WAIT_TIME;
			report "RR check";
			assert res_tb = std_logic_vector(res_exp)
				report "RR failed";
			wait for WAIT_TIME/2;
		end procedure do_rr;

	begin
		opa_tb <= std_logic_vector(to_unsigned(206, opa_tb'length)); -- "11001110"
		wait for WAIT_TIME;
		for i in 0 to opa_tb'length-1 loop
			do_lsr(i);
			do_asr(i);
			do_rr(i);
		end loop;
		wait;
end process;
end architecture bench_direct;
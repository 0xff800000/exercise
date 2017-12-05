ghdl -i encoder8to3_combAlgo.vhd encoder8to3_combinational.vhd encoder8to3_comb_tb.vhd
ghdl -e encoder8to3_combAlgo
ghdl -e encoder8to3_comb
ghdl -e encoder8to3_comb_tb
ghdl -r encoder8to3_comb_tb --vcd=wave.vcd

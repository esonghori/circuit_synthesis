#!/bin/bash

rm -f o.txt
rm -rf work transcript vsim.wlf
vlib work

vlog ../../syn_lib/MUX.v
vlog ../*.v
vlog a23_barrel_shift_testbench.v

#w/o gui
vsim -c -do a23_test_barrel.do a23_barrel_shift_testbench 

#w/ gui
#vsim -do a23_test_barrel.do a23_barrel_shift_testbench 

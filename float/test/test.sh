#!/bin/bash

rm -f o.txt
rm -rf work transcript vsim.wlf
vlib work


vlog ../float_add.v ../float_mul.v
vlog float_test.v

#w/o gui
vsim -c -do float_test.do float_test

#w/ gui
#vsim -do float_test.do float_test

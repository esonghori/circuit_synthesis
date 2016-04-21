#!/bin/bash
mkdir -p syn
if [ ! -f syn/a23_core.v ]; then
  design_vision -no_gui -f a23_core.dcsh
fi
design_vision -no_gui -f a23_gc_main.dcsh
# tc


![text](https://github.com/aslozada/tc/blob/master/lqt.png)



Display the VMD "dynamic" Field (beta, charge, occupancy, ...)

Script tcl vmd


usage: vmd -xyz <file>.xyz -e tc_v1.3.0.tcl -args -f <field>.dat -r [0|1] :: Enable screen
usage: vmd -(xyz|gro) <file>.(xyz|gro) -e tc_v1.3.0.tcl -args -f <field>.dat -r [0|1] :: Enable screen
usage: vmd -dispdev none -xyz <file>.xyz -e tc_v1.3.0.tcl -args -f <field>.dat -r [0|1] :: Text mode

Example: vmd -xyz lqt.xyz -e tc_v1.3.0.tcl -args -f field.dat -r 1

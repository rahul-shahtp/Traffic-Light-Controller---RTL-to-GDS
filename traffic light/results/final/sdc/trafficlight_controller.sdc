###############################################################################
# Created by write_sdc
# Tue Apr 14 05:32:23 2026
###############################################################################
current_design trafficlight_controller
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 10.0000 
set_clock_uncertainty 0.2500 clk
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {clear}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {clock}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {x}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {hwy[0]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {hwy[1]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {road[0]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {road[1]}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0334 [get_ports {hwy[1]}]
set_load -pin_load 0.0334 [get_ports {hwy[0]}]
set_load -pin_load 0.0334 [get_ports {road[1]}]
set_load -pin_load 0.0334 [get_ports {road[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clear}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clock}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {x}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 0.7500 [current_design]
set_max_fanout 10.0000 [current_design]

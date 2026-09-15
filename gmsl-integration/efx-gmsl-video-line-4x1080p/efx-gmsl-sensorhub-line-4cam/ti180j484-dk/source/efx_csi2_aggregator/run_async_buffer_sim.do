# --- 1. Cleanup and Setup ---
quit -sim
vlib work

# --- 2. Compile Design Files ---
# We use the -sv flag for SystemVerilog support
vlog -sv pulse_sync.sv
vlog -sv async_multi_line_buffer.sv
vlog -sv tb_async_buffer.sv

# --- 3. Start Simulation ---
# -voptargs=+acc ensures internal signals are visible in the wave window
# We specify the timescale to match our clock generation
vsim -t 1ps -voptargs=+acc work.tb_async_buffer

# --- 4. Add Waves with Formatting ---

add wave -radix hex -position insertpoint sim:/tb_async_buffer/dut/*
# --- 5. Run simulation ---
# Set the wave display to show decimal for counts
#property wave -default_radix hex
#configure wave -namecolwidth 250
#configure wave -valuecolwidth 100

run -all

# Zoom to see the full transaction history
wave zoom full
# --- 1. Cleanup ---
quit -sim
if {[file exists work]} {
    vdel -all
}
vlib work

# --- 2. Single-Pass Compilation ---
# Note: We do NOT list the .svh file here. 
# The compiler finds it via the `include inside the .sv files.
vlog +define+SIM -sv \
    pulse_sync.sv \
    async_multi_line_buffer.sv \
    csi2_aggregator_top.sv \
	video_monitor.v \
    tb_csi2_aggregator.sv

# --- 3. Start Simulation ---
vsim -t 1ps -voptargs="+acc" work.tb_csi2_aggregator

# --- 4. Add Waves ---
add wave -divider "TX_OUT"
add wave -color "Cyan" -radix hex sim:/tb_csi2_aggregator/tx_vc_id
add wave -color "Green" sim:/tb_csi2_aggregator/tx_valid
add wave -radix hex sim:/tb_csi2_aggregator/tx_data

add wave -divider "ARBITER"
add wave -radix hex sim:/tb_csi2_aggregator/dut/state
add wave -radix hex sim:/tb_csi2_aggregator/dut/active_ch


add wave -divider "Input"
add wave -radix hex -position insertpoint  \
sim:/tb_csi2_aggregator/dut/rx_clks \
sim:/tb_csi2_aggregator/dut/rx_rst_n \
sim:/tb_csi2_aggregator/dut/rx_frame_count \
sim:/tb_csi2_aggregator/dut/rx_line_count \
sim:/tb_csi2_aggregator/dut/rx_vsync \
sim:/tb_csi2_aggregator/dut/rx_hsync \
sim:/tb_csi2_aggregator/dut/rx_data \
sim:/tb_csi2_aggregator/dut/rx_valid

add wave -divider "Output"
add wave -radix hex -position insertpoint  \
sim:/tb_csi2_aggregator/dut/rst_n \
sim:/tb_csi2_aggregator/dut/sys_clk \
sim:/tb_csi2_aggregator/dut/tx_enable \
sim:/tb_csi2_aggregator/dut/tx_data \
sim:/tb_csi2_aggregator/dut/tx_valid \
sim:/tb_csi2_aggregator/dut/tx_vsync \
sim:/tb_csi2_aggregator/dut/tx_hsync \
sim:/tb_csi2_aggregator/dut/tx_data_type \
sim:/tb_csi2_aggregator/dut/tx_vc_id \
sim:/tb_csi2_aggregator/dut/tx_frame_num \
sim:/tb_csi2_aggregator/dut/tx_line_num


add wave -position insertpoint  \
sim:/tb_csi2_aggregator/dut/frame_state \
sim:/tb_csi2_aggregator/dut/frame_state_update


add wave -position insertpoint  \
{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/rd_frame_state} \
{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/frame_state_update} \
{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[1]/u_line_buffer/rd_frame_state} \
{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[1]/u_line_buffer/frame_state_update} \
{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[2]/u_line_buffer/rd_frame_state} \
{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[2]/u_line_buffer/frame_state_update} \
{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[3]/u_line_buffer/rd_frame_state} \
{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[3]/u_line_buffer/frame_state_update}


add wave -position insertpoint  \
sim:/tb_csi2_aggregator/dut/tx_frame_num \
sim:/tb_csi2_aggregator/dut/tx_line_num

add wave -position insertpoint  \
{sim:/tb_csi2_aggregator/csi_rx_monitor[0]/inst_csi_rx_monitor/hsync_per_frame} \
{sim:/tb_csi2_aggregator/csi_rx_monitor[0]/inst_csi_rx_monitor/pixel_per_line} \
{sim:/tb_csi2_aggregator/csi_rx_monitor[1]/inst_csi_rx_monitor/hsync_per_frame} \
{sim:/tb_csi2_aggregator/csi_rx_monitor[1]/inst_csi_rx_monitor/pixel_per_line} \
{sim:/tb_csi2_aggregator/csi_rx_monitor[2]/inst_csi_rx_monitor/hsync_per_frame} \
{sim:/tb_csi2_aggregator/csi_rx_monitor[2]/inst_csi_rx_monitor/pixel_per_line} \
{sim:/tb_csi2_aggregator/csi_rx_monitor[3]/inst_csi_rx_monitor/hsync_per_frame} \
{sim:/tb_csi2_aggregator/csi_rx_monitor[3]/inst_csi_rx_monitor/pixel_per_line}

add wave -position insertpoint  \
{sim:/tb_csi2_aggregator/csi_tx_vc_monitor[0]/inst_csi_rx_monitor/hsync_per_frame} \
{sim:/tb_csi2_aggregator/csi_tx_vc_monitor[0]/inst_csi_rx_monitor/pixel_per_line} \
{sim:/tb_csi2_aggregator/csi_tx_vc_monitor[1]/inst_csi_rx_monitor/hsync_per_frame} \
{sim:/tb_csi2_aggregator/csi_tx_vc_monitor[1]/inst_csi_rx_monitor/pixel_per_line} \
{sim:/tb_csi2_aggregator/csi_tx_vc_monitor[2]/inst_csi_rx_monitor/hsync_per_frame} \
{sim:/tb_csi2_aggregator/csi_tx_vc_monitor[2]/inst_csi_rx_monitor/pixel_per_line} \
{sim:/tb_csi2_aggregator/csi_tx_vc_monitor[3]/inst_csi_rx_monitor/hsync_per_frame} \
{sim:/tb_csi2_aggregator/csi_tx_vc_monitor[3]/inst_csi_rx_monitor/pixel_per_line}




#add wave -position insertpoint  \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/rd_frame_state} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/frame_state_update}
#add wave -position insertpoint  \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[1]/u_line_buffer/rd_frame_state} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[1]/u_line_buffer/frame_state_update}
#add wave -position insertpoint  \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[2]/u_line_buffer/rd_frame_state} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[2]/u_line_buffer/frame_state_update}
#add wave -position insertpoint  \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[3]/u_line_buffer/rd_frame_state} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[3]/u_line_buffer/frame_state_update}
#
#
#add wave -position insertpoint  \
#sim:/tb_csi2_aggregator/dut/global_hsync \
#sim:/tb_csi2_aggregator/dut/global_hsync_start \
#sim:/tb_csi2_aggregator/dut/global_rd_start \
#sim:/tb_csi2_aggregator/dut/global_rd_end \
#sim:/tb_csi2_aggregator/dut/global_hsync_end \
#sim:/tb_csi2_aggregator/dut/global_hact \
#sim:/tb_csi2_aggregator/dut/global_state \
#sim:/tb_csi2_aggregator/dut/global_counter
#
#add wave -position insertpoint  \
#sim:/tb_csi2_aggregator/dut/active_ch \
#sim:/tb_csi2_aggregator/dut/buf_rd_en_count \
#sim:/tb_csi2_aggregator/dut/state
#add wave -position insertpoint  \
#sim:/tb_csi2_aggregator/dut/buf_lines_ready

#add wave -divider "Output"
#add wave -radix hex  -position insertpoint  \
#sim:/tb_csi2_aggregator/dut/tx_vsync \
#sim:/tb_csi2_aggregator/dut/tx_hsync \
#sim:/tb_csi2_aggregator/dut/tx_data \
#sim:/tb_csi2_aggregator/dut/tx_valid \
#sim:/tb_csi2_aggregator/dut/tx_data_type \
#sim:/tb_csi2_aggregator/dut/tx_vc_id \
#sim:/tb_csi2_aggregator/dut/tx_frame_num \
#sim:/tb_csi2_aggregator/dut/tx_line_num \
#sim:/tb_csi2_aggregator/dut/tx_line_count \
#sim:/tb_csi2_aggregator/dut/buf_rd_en \
#sim:/tb_csi2_aggregator/dut/buf_rd_en_count \
#sim:/tb_csi2_aggregator/dut/last_tx_count \
#sim:/tb_csi2_aggregator/dut/buf_line_consumed \
#sim:/tb_csi2_aggregator/dut/buf_rd_data
##sim:/tb_csi2_aggregator/dut/state \
##sim:/tb_csi2_aggregator/dut/active_ch


#sim:/tb_csi2_aggregator/dut/buf_lines_ready \
#sim:/tb_csi2_aggregator/dut/buf_line_empty \


#add wave -radix hex -position insertpoint  \
#sim:/tb_csi2_aggregator/tx_hsync_count \
#sim:/tb_csi2_aggregator/tx_valid_count
#
#add wave -position insertpoint  \
#sim:/tb_csi2_aggregator/dut/tx_data_type \
#sim:/tb_csi2_aggregator/dut/slot_counter \
#sim:/tb_csi2_aggregator/dut/rd_vsync_sigs \
#sim:/tb_csi2_aggregator/dut/active_slot



#add wave -divider "BUFFER 0"
#add wave -radix hex sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/*
#add wave -position insertpoint  \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/DATA_WIDTH} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/PIXEL_PER_CLK} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/LINE_WIDTH} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/NUM_LINES} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/WORDS_PER_LINE}
#add wave -divider "BUFFER 1"
#add wave -radix hex sim:/tb_csi2_aggregator/dut/RX_CHANNELS[1]/u_line_buffer/*
#add wave -divider "BUFFER 2"
#add wave -radix hex sim:/tb_csi2_aggregator/dut/RX_CHANNELS[2]/u_line_buffer/*
#add wave -divider "BUFFER 3"
#add wave -radix hex sim:/tb_csi2_aggregator/dut/RX_CHANNELS[3]/u_line_buffer/*

#add wave -position insertpoint  \
#sim:/tb_csi2_aggregator/dut/tx_enable \
#sim:/tb_csi2_aggregator/dut/tx_data \
#sim:/tb_csi2_aggregator/dut/tx_valid \
#sim:/tb_csi2_aggregator/dut/tx_vsync \
#sim:/tb_csi2_aggregator/dut/tx_hsync \
#sim:/tb_csi2_aggregator/dut/tx_data_type \
#sim:/tb_csi2_aggregator/dut/tx_vc_id \
#sim:/tb_csi2_aggregator/dut/tx_frame_num \
#sim:/tb_csi2_aggregator/dut/tx_line_num \
#sim:/tb_csi2_aggregator/dut/tx_line_count
#
#add wave -position insertpoint  \
#sim:/tb_csi2_aggregator/w_rx_frame_count \
#sim:/tb_csi2_aggregator/w_rx_hsync_per_frame \
#sim:/tb_csi2_aggregator/w_rx_pixel_per_line \
#sim:/tb_csi2_aggregator/w_rx_frame_rate \
#sim:/tb_csi2_aggregator/w_tx_frame_count \
#sim:/tb_csi2_aggregator/w_tx_hsync_per_frame \
#sim:/tb_csi2_aggregator/w_tx_pixel_per_line \
#sim:/tb_csi2_aggregator/w_tx_frame_rate
#
#add wave -position insertpoint  \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/frame_state}
#add wave -position insertpoint  \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[1]/u_line_buffer/frame_state}
#add wave -position insertpoint  \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[2]/u_line_buffer/frame_state}
#add wave -position insertpoint  \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[3]/u_line_buffer/frame_state}
#
#add wave -position insertpoint  \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/wr_vsync} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/wr_hsync} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/wr_data} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/wr_en} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/line_consumed} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/rd_frame_state} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/frame_state_update} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/rd_wr_line_num} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/rd_lines_available} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/rd_rd_line_num} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/rd_rd_frame_num} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/rd_line_empty} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/rd_buffer_empty} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/rd_sync_pulse} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/rd_line_ready_pulse} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/rd_ptr} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/rd_line_idx} \
#{sim:/tb_csi2_aggregator/dut/RX_CHANNELS[0]/u_line_buffer/frame_state}

run -all
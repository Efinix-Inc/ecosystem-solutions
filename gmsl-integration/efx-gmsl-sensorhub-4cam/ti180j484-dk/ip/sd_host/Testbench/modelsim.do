onerror {quit -f}
vlib work
vlog +define+EFX_SIM -sv ./tb_top.v
vlog +define+EFX_SIM -sv ./top.v
vlog +define+EFX_SIM -sv ./sdModel.v
vlog +define+EFX_SIM -sv ./axi_ram.v
vlog +define+EFX_SIM -sv ./axi_interconnect.v
vlog +define+EFX_SIM -sv ./apb3_2_axi4_lite.v
vlog +define+EFX_SIM+SIM_MODE -sv ./modelsim/sd_host.v
vsim -t ns work.tb_top
run -all

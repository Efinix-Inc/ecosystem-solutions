set TB_NAME tb_soc
set SWITCH  EFX_SIM

vlib work

set rtlfiles [glob -nocomplain ./aldec/\*.v]
if {[llength $rtlfiles]} {
    foreach rtl $rtlfiles {
        file copy -force $rtl ./
    }
}

vlog -dbg -sve -msg 5 +nospecify +define+$SWITCH ./\*.*v -sv2k12

asim -t 0 -dataset . -datasetname {sim} work.$TB_NAME
run -all


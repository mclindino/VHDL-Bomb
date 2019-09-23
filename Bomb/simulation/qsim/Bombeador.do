onerror {quit -f}
vlib work
vlog -work work Bombeador.vo
vlog -work work Bombeador.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.Bombeador_vlg_vec_tst
vcd file -direction Bombeador.msim.vcd
vcd add -internal Bombeador_vlg_vec_tst/*
vcd add -internal Bombeador_vlg_vec_tst/i1/*
add wave /*
run -all

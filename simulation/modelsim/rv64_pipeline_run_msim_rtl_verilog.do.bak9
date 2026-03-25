transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/Top_Module.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/Stalling_Unit.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/RiscV_CPU.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/Register_File.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/NonArch_Reg.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/Mux4.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/Mux3.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/Mux2.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/Main_Controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/Forwarding_Unit.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/Extend_Unit.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/Data_Path.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/Data_Mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/Control_Path.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/ALU_Controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/Adder.v}
vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/code/components {C:/Users/User/Desktop/RiscV_64b_pipeline/code/components/Instruction_Mem.v}

vlog -vlog01compat -work work +incdir+C:/Users/User/Desktop/RiscV_64b_pipeline/.test {C:/Users/User/Desktop/RiscV_64b_pipeline/.test/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run -all

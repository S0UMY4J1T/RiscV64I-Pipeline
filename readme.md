# RV64 Pipeline CPU

This repository contains a Verilog RISC-V CPU project built around a 64-bit datapath, a 32-bit instruction stream, and a simple five-stage pipeline. The workspace includes the HDL source, a Quartus project, a checked-in ModelSim script, and a small test program for simulation.

## Quick Links

- [Top-level wrapper](./code/components/Top_Module.v)
- [CPU core](./code/components/RiscV_CPU.v)
- [Datapath](./code/components/Data_Path.v)
- [Control path](./code/components/Control_Path.v)
- [Hazard detection](./code/components/Stalling_Unit.v)
- [Forwarding unit](./code/components/Forwarding_Unit.v)
- [Instruction memory](./code/components/Instruction_Mem.v)
- [Data memory](./code/components/Data_Mem.v)
- [Register file](./code/components/Register_File.v)
- [Sample assembly program](./code/rv32i_test.s)
- [Simulation testbench](./.test/tb.v)
- [ModelSim script](./simulation/modelsim/rv64_pipeline_run_msim_rtl_verilog.do)
- [Quartus project file](./rv64_pipeline.qpf)
- [Quartus settings](./rv64_pipeline.qsf)
- [License](./LICENSE)

## Overview

The design is organized around [`Top_Module`](./code/components/Top_Module.v), which connects:

- [`RiscV_CPU`](./code/components/RiscV_CPU.v) for the pipelined core
- [`Instruction_Mem`](./code/components/Instruction_Mem.v) for instruction fetch
- [`Data_Mem`](./code/components/Data_Mem.v) for byte-addressable data memory

Inside the core, the logic is split into:

- [`Control_Path`](./code/components/Control_Path.v) for decode, control signal generation, and pipeline control propagation
- [`Data_Path`](./code/components/Data_Path.v) for PC logic, register access, ALU execution, memory access, and write-back

Pipeline state is stored with [`NonArch_Reg`](./code/components/NonArch_Reg.v), forwarding is handled by [`Forwarding_Unit`](./code/components/Forwarding_Unit.v), and load-use / control hazards are handled by [`Stalling_Unit`](./code/components/Stalling_Unit.v).

## Architecture Notes

- Five pipeline stages: IF, ID, EX, MEM, WB
- 64-bit data path with 32-bit instructions
- Immediate extension support for I, S, B, J, and U formats through [`Extend_Unit`](./code/components/Extend_Unit.v)
- ALU and decode support for arithmetic, logical, branch, jump, load/store, `LUI`, and `AUIPC` style operations through [`ALU`](./code/components/ALU.v), [`ALU_Controller`](./code/components/ALU_Controller.v), and [`Main_Controller`](./code/components/Main_Controller.v)
- Byte, halfword, word, and doubleword memory handling in [`Data_Mem`](./code/components/Data_Mem.v)
- Debug visibility from [`Top_Module`](./code/components/Top_Module.v) and the simulation [`tb`](./.test/tb.v), including pipeline PCs, result bus, and memory writes

## Repository Layout

| Path | Purpose |
| --- | --- |
| [`code/components/`](./code/components/) | Main Verilog source files for the CPU, memories, muxes, and support blocks |
| [`code/rv32i_test.s`](./code/rv32i_test.s) | Human-readable sample assembly program used for bring-up and functional checks |
| [`code/components/rv32i_test.hex`](./code/components/rv32i_test.hex) | Hex program image used by the instruction memory source tree |
| [`./.test/`](./.test/) | Simulation testbench files |
| [`simulation/modelsim/`](./simulation/modelsim/) | ModelSim NativeLink script, transcript, and simulator-generated files |
| [`rv64_pipeline.qpf`](./rv64_pipeline.qpf) | Quartus project entry file |
| [`rv64_pipeline.qsf`](./rv64_pipeline.qsf) | Quartus project settings, source list, device target, and testbench registration |
| [`output_files/`](./output_files/) | Quartus compilation outputs |
| [`db/`](./db/) and [`incremental_db/`](./incremental_db/) | Quartus databases and incremental compilation artifacts |

## Main Source Map

- [`Top_Module.v`](./code/components/Top_Module.v): project top level and memory wrapper
- [`RiscV_CPU.v`](./code/components/RiscV_CPU.v): CPU integration point for control and datapath
- [`Data_Path.v`](./code/components/Data_Path.v): PC update, register file access, execute path, pipeline registers, forwarding, and write-back
- [`Control_Path.v`](./code/components/Control_Path.v): decode-side control generation and stage-to-stage control pipelining
- [`Main_Controller.v`](./code/components/Main_Controller.v): opcode decoder
- [`ALU_Controller.v`](./code/components/ALU_Controller.v): ALU operation decode
- [`ALU.v`](./code/components/ALU.v): arithmetic, logic, shift, compare, and branch condition logic
- [`Instruction_Mem.v`](./code/components/Instruction_Mem.v): instruction ROM preload via `rv32i_test.hex`
- [`Data_Mem.v`](./code/components/Data_Mem.v): byte-addressable load/store memory
- [`Register_File.v`](./code/components/Register_File.v): architectural register file
- [`Forwarding_Unit.v`](./code/components/Forwarding_Unit.v): execute-stage forwarding control
- [`Stalling_Unit.v`](./code/components/Stalling_Unit.v): load-use stall and control flush handling

## Simulation

The repository already includes a testbench at [`./.test/tb.v`](./.test/tb.v) and a generated ModelSim script at [`simulation/modelsim/rv64_pipeline_run_msim_rtl_verilog.do`](./simulation/modelsim/rv64_pipeline_run_msim_rtl_verilog.do).

Typical flow:

1. Open ModelSim / Questa or launch simulation through Quartus NativeLink.
2. Run the checked-in `.do` file from [`simulation/modelsim/`](./simulation/modelsim/).
3. Observe the console output from [`tb.v`](./.test/tb.v), which prints:
   - pipeline PC values (`PC`, `PCD`, `PCE`, `PCM`, `PCW`)
   - the write-back `Result`
   - memory write events when `WE` is asserted

The included testbench drives a free-running clock, releases reset after 20 ns, and finishes after 500 cycles.

## Quartus Project

From [`rv64_pipeline.qsf`](./rv64_pipeline.qsf):

- Toolchain: Quartus Prime Lite 20.1.1
- Device family: Cyclone IV E
- Device: `EP4CE22F17C6`
- Top-level entity: `Top_Module`
- Registered testbench: [`./.test/tb.v`](./.test/tb.v)

Open [`rv64_pipeline.qpf`](./rv64_pipeline.qpf) in Quartus to inspect or rebuild the project.

## Program Image

The sample program source is stored in [`code/rv32i_test.s`](./code/rv32i_test.s). It exercises arithmetic, logical, branch, jump, and memory instructions for simulation bring-up.

The instruction memory source at [`Instruction_Mem.v`](./code/components/Instruction_Mem.v) loads `rv32i_test.hex`. A copy of that hex file exists in both:

- [`code/components/rv32i_test.hex`](./code/components/rv32i_test.hex)
- [`simulation/modelsim/rv32i_test.hex`](./simulation/modelsim/rv32i_test.hex)

## Notes

- The checked-in ModelSim `.do` script uses absolute paths for this workspace. If the repository is moved, regenerate the script from Quartus NativeLink or update the paths manually in [`rv64_pipeline_run_msim_rtl_verilog.do`](./simulation/modelsim/rv64_pipeline_run_msim_rtl_verilog.do).
- Most files under [`db/`](./db/), [`incremental_db/`](./incremental_db/), [`output_files/`](./output_files/), and simulator work directories are generated artifacts rather than hand-maintained source files.

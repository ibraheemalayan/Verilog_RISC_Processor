                    ╔════════════════━━──── • ────━━━═══════════════╗

                                Simple RISC Verilog Processor

                    ╚═══════════════━━━──── • ────━━━═══════════════╝

---

# Simple RISC Verilog Processor 💻

Second project in the computer architicture course (ENCS4370) at [Birzeit University](https://www.birzeit.edu/)

A Simple multi-cycle RISC Verilog processor with architecture similar to MIPS

## Partners

```
👷 Ibraheem Alyan  1201180
👷 Mohammad Mualla 1180546
👷 Feras Sandouka  1200779
```

---

## [Project ( Requirements )](./Project_Paper.pdf)

---

## Data Path

![datapath block diagram](./assets/data_path.png)

## Naming Convention

- `{sig/flag}_{snack_case_name}` for signals/flags
- `{snack_case_name}` for internal components ( registers / wires )
- `{camel_case_name}` for modules
- `{pascal_case_name}` for input/output ports ( excluding signals )

## Modules

### Register file

- [register_file.v](./processor_modules/RiscProcessor/processor/src/register_file/register_file.v)
  a 32 bit register file with 32 registers
- [register_file_tb.v](./processor_modules/RiscProcessor/processor/src/register_file/register_file_testbench.v)
  test bench for the register file module
- waveform
  ![register file waveform](./assets/register_file_tb_waveform.png)

### Instruction memory

- [instruction_memory.v](./processor_modules/RiscProcessor/processor/src/instruction_fetch/InstructionMemory.v)
  a 32 bit instruction memory with 256 words
- [instruction_memory_tb.v](.processor_modules/RiscProcessor/processor/src/instruction_fetch/instruction_memory_testbench.v)
  test bench for the instruction memory module
- waveform
  ![instruction memory waveform](./assets/instruction_memory_waveform.png)

### Data memory

- [data_memory.v](./processor_modules/RiscProcessor/processor/src/data_memory/data_memory.v)
  a 32 bit data memory with 256 words

- [data_memory_tb.v](./processor_modules/RiscProcessor/processor/src/data_memory/data_memory_testbench.v)
  test bench for the data memory module

- waveform
  ![data memory waveform](./assets/data_memory_waveform.png)

### ALU

- [alu.v](./processor_modules/RiscProcessor/processor/src/alu/alu.v)
  a 32 bit ALU with 5 operations ( ADD, SUB, AND, SL, SR ) and 2 flags ( zero, negative )

- [alu_tb.v](./processor_modules/RiscProcessor/processor/src/alu/alu_testbench.v)
  a test bench for the ALU module that tests all operations and the flags

- waveform
  ![alu waveform](./assets/alu_tb_waveform.png)

### PC Module

- [pc_module.v](./processor_modules/RiscProcessor/processor/src/instruction_fetch/pc_module.v)
  a 32 bit program counter logic module that handles Jump/Conditional Branches/Increment/Return

- [pc_module_tb.v](./processor_modules/RiscProcessor/processor/src/instruction_fetch/pc_module_testbench.v)
  a test bench for the PC module that tests all operations

- waveform
  ![pc module waveform](./assets/pc_module_tb_waveform.png)

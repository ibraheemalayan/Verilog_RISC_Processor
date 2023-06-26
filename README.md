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

## [Project Paper ( Requirements )](./Project_Paper.pdf)

---

## Modules

- [REGISTER_FILE.v](./modules/REGISTER_FILE.v)
  a 32 bit register file with 32 registers

- [MEM.v](./modules/MEM.v)
  a XXX bit memory with XXX words # TODO

- [ALU.v](./modules/ALU.v)
  an Arithmetic Logic Unit that can execute 3 operations on 32 bit operands

- [CLK_GEN.v](./modules/CLK_GEN.v)
  a sample clock generator that inverts the clock signal each 5 ns (full cycle is 10 ns)

- [Test_Bench.v](./modules/Test_Bench.v)
  the test bench that connects the modules and is the top level file in the simulation

---

## Running The Simulation

install [Icarus Verilog](https://github.com/steveicarus/iverilog) and add its binaries to your shell path then run the following

```
git clone https://github.com/ibraheemalayan/Verilog_RISC_Processor.git
cd Verilog_RISC_Processor/modules
iverilog -o compiled_testbench.vvp Test_Bench.v
vvp compiled_testbench.vvp
```

Then you can read the output of the display statments  
**OR**  
open the [waves.vcd](./modules/waves.vcd) using a wave viewer (eg: GTKwave)

<!-- ------------------------------

## Simulations on GTKwave

>>> Visit the link of each simulation to view the **Discussion**, simulation text output, memory table view, memory loading code, and the high quality images links

------------------------------ -->
<!--
#### [Simulation 1](Simulation_1.md)
![waveform on GTKwave](./img/simulation_1_screenshot.png)

------------------------------

#### [Simulation 2](Simulation_2.md)
![waveform on GTKwave](./img/simulation_2_screenshot.png)

------------------------------

#### [Simulation 3](Simulation_3.md)
![waveform on GTKwave](./img/simulation_3_screenshot.png)

------------------------------

#### [Simulation 4](Simulation_4.md)
![waveform on GTKwave](./img/simulation_4_screenshot.png)
 -->

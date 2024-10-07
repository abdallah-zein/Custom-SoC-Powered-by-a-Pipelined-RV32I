# SoC Design with Pipelined RV32I Processor and APB Integration

Welcome to the repository for the **SoC Design Project** featuring a custom **RV32I Pipelined Processor** integrated with an **Advanced Peripheral Bus (APB)**, along with a **UART** module. This project showcases a modular and efficient System-on-Chip (SoC) design aimed at achieving both performance and scalability, ideal for embedded systems.

## Project Overview

This project centers around the integration of a custom-designed RV32I processor that supports **27 RISC-V instructions** and is connected to peripheral devices via the APB protocol. The system includes memory-mapped UART functionality and efficient hazard detection, ensuring smooth operation across the pipeline.

### Key Features:
- **Pipelined RV32I Processor**:
  - Supports **R-Type, I-Type, S-Type, B-Type, and J-Type** instruction formats.
  - **Hazard Unit** that detects and resolves data and control hazards, preventing pipeline stalls.
  - Delivers **higher throughput** and **lower latency** compared to single-cycle designs.
  
- **APB Integration**:
  - Processor communicates with peripherals via an **APB Master Wrapper**, address decoder, and multiple slaves.
  - Modular architecture allowing easy expansion with additional peripherals.

- **Memory-Mapped UART**:
  - Includes **control, status, TX data, and RX data registers**, allowing full configuration of UART modes (e.g., parity type, parity enable).
  

### Components:
- **Processor**: RV32I architecture with 5-stage pipeline (Fetch, Decode, Execute, Memory, Write Back).
- **APB Interface**: APB Master wrapper, address decoder, and multiple slave peripherals.
- **UART**: Configurable through memory-mapped registers for communication.

  ## Supported Instruction Set

My Design supports 27 different instructions which are classified according to these instruction formats

<div align="center">
  <img src="https://github.com/abdallah-zein/SoC-Design-with-Pipelined-RV32I-Processor-and-APB-Integration/blob/main/images/Instructions%20types.png" alt=" Instructions types">
</div>
<br>

The Supported R-Type instructions formats:
<div align="center">
  <img src="https://github.com/abdallah-zein/SoC-Design-with-Pipelined-RV32I-Processor-and-APB-Integration/blob/main/images/supported%20R-Type%20Instructions.png" alt=" Instructions types">
</div>
<br>

The Supported I-Type instructions formats:
<div align="center">
  <img src="https://github.com/abdallah-zein/SoC-Design-with-Pipelined-RV32I-Processor-and-APB-Integration/blob/main/images/supported%20I-Type%20Instructions.png" alt=" Instructions types">
</div>
<br>

The Supported S-Type instructions formats:
<div align="center">
  <img src="https://github.com/abdallah-zein/SoC-Design-with-Pipelined-RV32I-Processor-and-APB-Integration/blob/main/images/supported%20S-Type%20Instructions.png" alt=" Instructions types">
</div>
<br>

The Supported B-Type instruction format:
<div align="center">
  <img src="https://github.com/abdallah-zein/SoC-Design-with-Pipelined-RV32I-Processor-and-APB-Integration/blob/main/images/supported%20B-Type%20Instructions.png" alt=" Instructions types">
</div>
<br>

The Supported J-Type instruction format:

<div align="center">
  <img src="https://github.com/abdallah-zein/SoC-Design-with-Pipelined-RV32I-Processor-and-APB-Integration/blob/main/images/supported%20J-Type%20Instructions.png" alt=" Instructions types">
</div>
<br>

### Future Work:
- Conducted basic verification using SystemVerilog testbenches to ensure the correct operation of the SoC under various conditions and prescale settings
- Expanding with additional peripherals to demonstrate scalability.
- Optimizing power consumption and clock speed for embedded applications.

Feel free to explore the design, contribute, or use it as a reference for your own SoC projects!

# Computer Structure – MIPS Assembly

This repository contains my MIPS assembly codes (labs, exercises, and small projects) from the **Computer Structure** course. It’s intended as a learning resource and a reference for anyone exploring low-level programming and computer architecture concepts.

## What is MIPS?

**MIPS** (Microprocessor without Interlocked Pipeline Stages) is a classic **RISC** (Reduced Instruction Set Computer) architecture widely used in academia to teach computer organization and assembly programming. MIPS emphasizes a small, regular instruction set with consistent instruction formats, making it easier to reason about pipelines, hazards, and performance.

### RISC vs. CISC (Quick Overview)

- **RISC**
  - Small, uniform set of simple instructions
  - Fixed instruction length (e.g., 32-bit)
  - Load/store architecture (memory is accessed only by `lw`/`sw`; ALU ops are register-to-register)
  - Easier to pipeline and optimize in hardware
  - Examples: MIPS, ARM, RISC-V

- **CISC**
  - Large, feature-rich instruction set (some instructions are complex/do multiple things)
  - Variable instruction length
  - More addressing modes; some instructions access memory directly
  - Historically aimed to reduce code size at the expense of hardware complexity
  - Examples: x86/x86-64

Neither approach is universally “better”—modern CPUs often blend ideas. But MIPS is excellent for learning because the ISA is clean and predictable.

## What is “Computer Structure” (a.k.a. Computer Architecture)?

“Computer Structure” studies **how computers are built and how they execute programs**, spanning concepts from logic gates all the way to full processors:

- **Data representation:** binary, two’s complement, integers vs. floating point  
- **Instruction Set Architecture (ISA):** the contract between software and hardware (registers, instructions, calling conventions)  
- **Datapath & Control:** ALU, register file, control signals, multiplexers  
- **Pipelining:** instruction throughput, data/control hazards, forwarding, stalls, branch prediction basics  
- **Memory hierarchy:** registers, caches (L1/L2/L3), main memory, locality  
- **I/O & peripherals:** memory-mapped I/O, system calls  
- **Performance:** CPI, clock rate, Amdahl’s law, trade-offs in design

MIPS assembly ties these together: you see how high-level constructs (loops, functions, arrays) map to registers, instructions, and memory.

---

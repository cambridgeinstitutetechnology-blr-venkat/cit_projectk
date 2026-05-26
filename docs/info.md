# 8-Bit LFSR Pseudo-Random Circuit

Designed for digital VLSI training module parameters.

## Core Topology
This design generates pseudo-random sequences using an active feedback polynomial shift mechanism.

Feedback Polynomial:

x^8 + x^6 + x^5 + x^4 + 1

The feedback bit is generated using XOR operations from:
- Bit 7
- Bit 5
- Bit 4
- Bit 3

## Functional Description
An 8-bit shift register updates on every positive clock edge.

- When `rst_n` is LOW:
  - The register initializes with seed value `0x01`

- When `rst_n` is HIGH:
  - The register shifts left by one position
  - The feedback bit is inserted into the least significant bit

This creates a maximal-length pseudo-random sequence.

## Inputs
- `clk` : System clock
- `rst_n` : Active-low reset

## Outputs
- `uo_out[7:0]` : 8-bit pseudo-random sequence output

## Validation Guide
1. Hold `rst_n` LOW to inject the `0x01` seed.
2. Assert `rst_n` HIGH to begin pseudo-random cycling.
3. Observe the changing sequence across `uo_out[7:0]` on each clock cycle.

## Applications
- Pseudo-random number generation
- Digital security systems
- Data scrambling
- Side-channel protection concepts
- Hardware security research

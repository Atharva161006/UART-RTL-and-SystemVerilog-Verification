# UART-RTL-and-SystemVerilog-Verification
This project implements a parameterized UART (Universal Asynchronous Receiver Transmitter) in Verilog/SystemVerilog along with a complete SystemVerilog verification environment.

The UART supports serial transmission and reception using configurable baud rate generation. A self-checking verification environment is developed to verify the functionality of the design.

# Table of Contents

- [Overview](#overview)
- [UART Architecture](#uart-architecture)
- [Baud Rate Calculation](#baud-rate-calculation)
- [Verification Architecture](#verification-architecture)
- [Verification Components](#verification-components)
- [Simulation Flow](#simulation-flow)
- [Simulation Results](#simulation-results)
- [How to Run](#how-to-run)
- [Tools Used](#tools-used)
- [Skills Demonstrated](#skills-demonstrated)
- [Future Improvements](#future-improvements)

## Overview

This project implements a Universal Asynchronous Receiver Transmitter (UART) using Verilog/SystemVerilog along with a complete SystemVerilog verification environment. The design includes a UART Transmitter, UART Receiver, and Baud Rate Generator, enabling reliable serial communication between digital systems.

A self-checking verification environment has been developed using SystemVerilog object-oriented programming concepts. The verification environment consists of a Transaction class, Generator, Driver, Monitor, Scoreboard, Environment, Interface, and Mailbox-based communication to automatically verify the correctness of the UART design.

The project was simulated using Xilinx Vivado, and the verification environment automatically compares expected and actual data to validate the functionality of the UART.

## UART Architecture

The UART design is divided into three main RTL modules:

1. **Baud Rate Generator**
   - Generates baud tick signals from the system clock.
   - Provides timing for both the transmitter and receiver.

2. **UART Transmitter**
   - Converts parallel input data into a serial bit stream.
   - Transmits data in the following order:
     - Start Bit
     - Data Bits (LSB first)
     - Stop Bit
   - Controlled by a finite state machine (FSM).

3. **UART Receiver**
   - Samples the incoming serial data using the baud tick.
   - Detects the start bit, receives each data bit, and reconstructs the original parallel data.
   - Controlled by a finite state machine (FSM).

### Block Diagram

```text
                 +----------------------+
                 |  Baud Rate Generator |
                 +----------+-----------+
                            |
          +-----------------+-----------------+
          |                                   |
          v                                   v
+-------------------+               +-------------------+
|  UART Transmitter |-------------->|   UART Receiver   |
|                   |     TX Line   |                   |
+-------------------+               +-------------------+
        |                                   |
        |                                   |
   Parallel Data In                  Parallel Data Out
```

### Data Flow

1. Parallel data is provided to the UART Transmitter.
2. The Baud Rate Generator provides timing signals for transmission.
3. The transmitter serializes the data and sends it over the TX line.
4. The UART Receiver samples the serial data using the baud tick.
5. The receiver reconstructs the original parallel data and asserts the completion signal.

## Baud Rate Calculation

The UART baud rate generator divides the **50 MHz system clock** to generate timing pulses for both the transmitter and receiver.

### System Parameters

| Parameter | Value |
|-----------|-------|
| System Clock Frequency | 50 MHz |
| Baud Rate | 9600 bps |
| Oversampling | 16× (Receiver) |

---

### Transmitter Baud Tick

The transmitter requires one baud tick for each transmitted bit.

**Formula:**

\[
\text{Counter Value}=\frac{\text{Clock Frequency}}{\text{Baud Rate}}
\]

\[
=\frac{50,000,000}{9600}
=5208.33
\]

Since the counter starts from **0**, the terminal count is:

```
5208 - 1 = 5207
```

Therefore, the transmitter generates one baud tick every **5208 clock cycles**.

---

### Receiver Baud Tick (16× Oversampling)

The receiver samples each bit **16 times** for improved timing accuracy.

Receiver sampling frequency:

\[
9600 \times 16 = 153600 \text{ Hz}
\]

Counter value:

\[
\frac{50,000,000}{153600}
=325.52
\]

Using the nearest integer value:

```
326 - 1 = 325
```

Therefore, the receiver generates one sampling tick every **326 clock cycles**, providing approximately **16 samples per UART bit**.

---

### Why 16× Oversampling?

The UART receiver uses 16× oversampling because it:

- Detects the start bit more accurately.
- Samples each data bit near its center, where it is most stable.
- Improves immunity to noise and glitches.
- Compensates for small clock differences between the transmitter and receiver, resulting in more reliable data reception.

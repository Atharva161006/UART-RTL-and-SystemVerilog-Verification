# UART-RTL-and-SystemVerilog-Verification
This project implements a parameterized UART (Universal Asynchronous Receiver Transmitter) in Verilog/SystemVerilog along with a complete SystemVerilog verification environment.

The UART supports serial transmission and reception using configurable baud rate generation. A self-checking verification environment is developed to verify the functionality of the design.

# Table of Contents

- [Overview](#overview)
- [UART Architecture](#uart-architecture)
- [Baud Rate Calculation](#baud-rate-calculation)
- [Module Description](#module-description)
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

The baud rate generator divides the **50 MHz system clock** to generate the required timing pulses for UART transmission and reception.

### System Parameters

| Parameter | Value |
|-----------|-------|
| System Clock | 50 MHz |
| Baud Rate | 9600 bps |
| Receiver Oversampling | 16× |

---

### Transmitter Baud Tick

**Formula:**

```
Counter = Clock Frequency / Baud Rate
```

Substituting the values:

```
Counter = 50,000,000 / 9,600
        = 5208.33
```

Since the counter starts from **0**, the terminal count becomes:

```
5208 - 1 = 5207
```

Therefore, the transmitter generates one baud tick every **5208 clock cycles**.

---

### Receiver Baud Tick (16× Oversampling)

The receiver samples each bit **16 times**.

Receiver sampling frequency:

```
Sampling Frequency = Baud Rate × 16
                   = 9,600 × 16
                   = 153,600 Hz
```

Counter value:

```
Counter = 50,000,000 / 153,600
        = 325.52
```

Rounding to the nearest integer:

```
326 - 1 = 325
```

Therefore, the receiver generates one sampling tick every **326 clock cycles**, providing approximately **16 samples per UART bit**.

---

### Why 16× Oversampling?

- Detects the start bit accurately.
- Samples each data bit near its center.
- Improves noise immunity.
- Tolerates small clock mismatches between transmitter and receiver.
- Increases overall communication reliability.

## Module Description

### 1. Baud Rate Generator

**Purpose:**
Generates timing pulses for UART transmission and reception.

**Inputs**
| Signal | Width | Description |
|--------|-------|-------------|
| clk | 1 | 50 MHz system clock |


**Outputs**
| Signal | Width | Description |
|--------|-------|-------------|
| tx_enb | 1 | A one-clock-cycle pulse telling the transmitter, "Send the next UART bit now." |
| rx_enb | 1 | A one-clock-cycle pulse telling the receiver, "Take the next oversampling sample now. |

---

### 2. UART Transmitter

**Purpose:**
Converts 8-bit parallel data into serial UART data.

**Inputs**
| Signal | Width | Description |
|--------|-------|-------------|
| clk | 1 | System clock |
| rst | 1 | Active-high reset |
| tx_enb | 1 |Transmitter Baud tick |
| data_in | 8 | Parallel input data |
| tx_start | 1 | Starts transmission |

**Outputs**
| Signal | Width | Description |
|--------|-------|-------------|
| tx | 1 | Serial output |
| busy | 1 | Indicates transmission in progress |


---

### 3. UART Receiver

**Purpose:**
Receives serial UART data and converts it into 8-bit parallel data.

**Inputs**
| Signal | Width | Description |
|--------|-------|-------------|
| clk | 1 | System clock |
| rst | 1 | Active-high reset |
| rx | 1 | Serial input |
| rx_enb | 1 | Receiver oversampling tick |

**Outputs**
| Signal | Width | Description |
|--------|-------|-------------|
| data_out | 8 | Received parallel data |
| done | 1 | Reception complete |

---

### 4. Top Module

**Purpose:**
Integrates the baud rate generator, UART transmitter, and UART receiver into a complete UART communication system.

**Inputs**
- clk
- rst
- data_in
- tx_start


**Outputs**
- tx
- data_out
- busy
- done
## Verification Architecture

The UART design is verified using a modular **SystemVerilog testbench** based on object-oriented programming concepts. The verification environment separates stimulus generation, driving, monitoring, and result checking into independent components for improved scalability and maintainability.

### Verification Environment

```
                    +-------------------+
                    |    Generator      |
                    +---------+---------+
                              |
                              | Mailbox
                              v
                    +-------------------+
                    |      Driver       |
                    +---------+---------+
                              |
                        Virtual Interface
                              |
                              v
                    +-------------------+
                    |      UART DUT     |
                    +---------+---------+
                              |
                        Virtual Interface
                              |
                              v
                    +-------------------+
                    |      Monitor      |
                    +---------+---------+
                              |
                              | Mailbox
                              v
                    +-------------------+
                    |    Scoreboard     |
                    +-------------------+
```

### Verification Components

#### Transaction
- Defines UART transaction fields.
- Stores input stimulus and observed DUT outputs.

#### Generator
- Creates randomized UART transactions.
- Sends transactions to the driver through a mailbox.

#### Driver
- Receives transactions from the generator.
- Drives UART interface signals using the interface clocking block.

#### Monitor
- Samples DUT inputs and outputs through the interface.
- Packages observed values into transactions.
- Sends transactions to the scoreboard.

#### Scoreboard
- Compares expected results with DUT outputs.
- Reports **PASS** or **FAIL** for each transaction.

#### Environment
- Instantiates and connects all verification components.
- Starts all verification processes using parallel execution (`fork...join_none`).

#### Interface
- Groups all DUT signals.
- Uses clocking blocks to synchronize stimulus and sampling.
- Connects the verification environment with the DUT through a virtual interface.

  ## Simulation Flow

The UART design is verified through the following sequence:

1. **Clock Generation**
   - A 50 MHz system clock is generated throughout the simulation.

2. **Reset Initialization**
   - Active-low reset (`rst_n`) is asserted for the initial clock cycles.
   - All DUT registers and verification components are initialized.

3. **Environment Creation**
   - The testbench creates the Generator, Driver, Monitor, Scoreboard, and mailboxes.
   - The virtual interface is connected to all verification components.

4. **Transaction Generation**
   - The Generator creates randomized UART transactions.
   - Each transaction contains randomized input data and control signals.

5. **Stimulus Driving**
   - The Driver receives transactions from the mailbox.
   - It drives DUT input signals through the interface clocking block.

6. **UART Transmission**
   - The Baud Rate Generator produces `tx_enb` and `rx_enb` pulses.
   - The Transmitter serializes the input byte and sends it over the `tx` line.
   - - The transmitter output (`tx`) is connected directly to the receiver input (`rx`) in loopback mode, enabling end-to-end verification of the complete UART design.

7. **UART Reception**
   - The Receiver samples the serial data using the baud enable signal.
   - The received byte is reconstructed and made available at the output.

8. **Output Monitoring**
   - The Monitor samples DUT inputs and outputs using the interface clocking block.
   - Observed transactions are forwarded to the Scoreboard.

9. **Result Checking**
   - The Scoreboard compares the expected and actual received data.
   - Simulation reports **PASS** if they match, otherwise **FAIL**.

10. **Simulation Completion**
    - After all transactions are verified, the simulation ends and waveform analysis can be performed.

### UART Waveform

<img width="773" height="454" alt="uart_waveform" src="https://github.com/user-attachments/assets/a8abed8e-92ab-40d3-8f0c-000c4754a8a9" />


# 12/24-Hour BCD Digital Clock with Alarm

This repository contains a fully synthesizable Verilog implementation of a digital clock. It features Binary-Coded Decimal (BCD) logic, a multiplexed 12-hour and 24-hour display, an AM/PM indicator, and a programmable alarm.

## Features
* **BCD Architecture:** Counters are designed using BCD logic (0-9) to interface cleanly with 7-segment display drivers.
* **12/24-Hour Modes:** A hardware multiplexer allows seamless, real-time switching between 12-hour and 24-hour formats without losing the underlying time state.
* **Synchronous Design:** All modules are driven by a single system clock, utilizing a "cascade enable" architecture to prevent ripple-counter timing glitches.
* **Smart PM Toggle:** The AM/PM indicator evaluates the internal 12-hour state, ensuring it toggles correctly at noon and midnight regardless of which display mode the user is currently viewing.
* **Alarm System:** Compares current BCD time arrays with user-input alarm arrays.

## Module Hierarchy
* `top_module.v`: The top-level wrapper managing the enable chain and mode multiplexers.
  * `bcdcount.v`: Standard Modulo-10 counter for seconds and minutes.
  * `hour_counter1.v`: Custom wrap-around logic for the 12-hour display (`12 -> 01`).
  * `hour_counter2.v`: Custom wrap-around logic for the 24-hour display (`23 -> 00`).

## Simulation
A comprehensive testbench (`tb_digital_clock.v`) is provided to verify functionality. 

**Tested Scenarios:**
1. Standard counting and BCD carry logic.
2. Alarm triggering.
3. Live switching between 12hr and 24hr modes.
4. Pausing the clock (`ena` signal).
5. Midnight/Noon roll-over and AM/PM toggling.

*The testbench utilizes `$monitor` with hex formatting to print the BCD arrays as a readable digital clock format in the simulator console.*

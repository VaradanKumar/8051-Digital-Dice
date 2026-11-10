# Digital Dice using 8051 Assembly

A push-button-operated digital dice implemented in 8051 assembly language. Each valid button press generates a pseudo-random value from 1 to 6 and displays the digit on a seven-segment display.

## Features

- 8051 assembly-language implementation.
- Timer 0 in Mode 1 used as a changing timing source.
- P2.0 push-button input, active low.
- P3 output port drives the seven-segment display byte.
- Debounce routine for the push button.
- Lookup table for digit patterns 1–6.
- Keil µVision build workflow and HEX programming as documented in the project report.

## Hardware

- 8051 development board (report workflow names P89V51RD2).
- Common-cathode seven-segment display.
- Push button.
- 5 V board supply.
- Programmer/interface supported by the development board.

## Pin mapping used by the supplied assembly

| Signal | 8051 pin |
|---|---|
| Push button | P2.0 |
| Seven-segment display byte | P3.0–P3.7 |

**Port mapping note:** The report contains an inconsistency: its circuit-design paragraph mentions connecting the display to Port 1, but its supplied assembly writes display values to P3, and the programming/simulation instructions also specify P3.0–P3.7. This repository preserves the assembly program, so connect the display to Port 3 for this code, or update the program and wiring together.

## Build and program

1. Open Keil µVision and create an 8051 project for the exact device on your board.
2. Add `src/digital_dice.asm` to the source group.
3. Configure the target clock to 11.0592 MHz as specified in the report, if that matches your board.
4. Enable HEX file generation and build.
5. Program the generated HEX file using the interface supported by your board.

## How it works

Timer 0 runs while the button is idle. When the active-low push button is pressed, the code stops the timer, debounces the input, combines the low timer byte with a rolling register value, constrains the result to the dice range, and uses a lookup table to produce the seven-segment pattern. The code waits for button release before the next roll.

The timer-derived value is pseudo-random, not cryptographically random.

## How it works

The circuit reads an unsigned 8-bit value from `ui_in` on each rising clock edge
when `ena` is high. It compares the reading with the previous one and sets
`uo_out[0]` to 1 if the absolute difference is greater than 20. The first
reading after reset establishes the baseline and does not trigger an alarm.

## How to test

Hold `rst_n` low for one rising clock edge, then set it high. With `ena` high,
apply 50, 55, 75, and 96 on four successive rising clock edges. The expected
alarm outputs are 0, 0, 0, and 1. The change from 55 to 75 is exactly 20,
so it does not trigger the alarm.

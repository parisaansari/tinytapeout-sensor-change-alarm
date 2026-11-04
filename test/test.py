import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def test_sensor_change_alarm(dut):
    dut.clk.value = 0
    dut.ena.value = 1
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    async def sample(reading, expected_alarm):
        dut.clk.value = 0
        dut.ui_in.value = reading
        await Timer(5, "ns")
        dut.clk.value = 1
        await Timer(5, "ns")
        assert int(dut.uo_out.value) == expected_alarm, (
            f"Reading {reading}: expected alarm {expected_alarm}"
        )

    await sample(0, 0)    # Reset
    dut.rst_n.value = 1
    await sample(50, 0)   # First reading establishes the baseline
    await sample(55, 0)   # Change of 5: no alarm
    await sample(75, 0)   # Change of exactly 20: no alarm
    await sample(96, 1)   # Increase of 21: alarm
    await sample(60, 1)   # Decrease of 36: alarm
    await sample(61, 0)   # Small change: alarm clears

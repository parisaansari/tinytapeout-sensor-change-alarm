/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

     reg [7:0] previous_sample;
    reg       have_previous;
    reg       alarm;

    wire [7:0] difference = (ui_in >= previous_sample)
                          ? (ui_in - previous_sample)
                          : (previous_sample - ui_in);

    always @(posedge clk) begin
        if (!rst_n) begin
            previous_sample <= 8'd0;
            have_previous   <= 1'b0;
            alarm           <= 1'b0;
        end else if (ena) begin
            alarm           <= have_previous && (difference > 8'd20);
            previous_sample <= ui_in;
            have_previous   <= 1'b1;
        end
    end

    assign uo_out  = {7'b0, alarm};
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    wire _unused = &{uio_in, 1'b0};
endmodule

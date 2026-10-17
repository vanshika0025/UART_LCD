module Top_Module (
    input clk,        // 50 MHz FPGA Clock
    input rx,         // UART Receive Input
    output lcd_e,     // LCD Enable
    output lcd_rs,    // LCD Register Select
    output [7:0] data // LCD Data Bus
);

wire [7:0] RxData; // Data received from UART
wire valid_rx;     // Wire for valid_rx output (can be left floating if unused)

// Instantiate UART Receiver
uart_receiver uart_rx (
    .clk_fpga(clk),
    .rstn(1'b1),        // Tie reset high so it stays active
    .rxd(rx),           // Connect top-level input rx to rxd port
    .rxdata(RxData),    // Connect output data bus
    .valid_rx(valid_rx) // Connect valid output signal
);

// Instantiate LCD Display Module
LCD_DISPLAY lcd_disp (
    .clk(clk),
    .lcd_e(lcd_e),
    .lcd_rs(lcd_rs),
    .data(data),
    .RxData(RxData)     // Pass received UART data to LCD
);

endmodule
/*module LCD_DISPLAY (
    input clk,            // 50 MHz FPGA Clock
    input [7:0] RxData,   // Data received from UART
    output reg lcd_e,     // LCD Enable
    output reg lcd_rs,    // LCD Register Select (0 = Command, 1 = Data)
    output reg [7:0] data // LCD 8-bit Data Bus
);

integer i = 0;
integer j = 1;
reg [19:0] delay_counter;
reg [7:0] Datas [1:7]; // Limit depth to 7

// Data Initialization for only first 6 values
initial begin
    delay_counter <= 5000000; // Increase delay before sending first command
    Datas[1]  = 8'h38; // Function Set: 8-bit mode, 2 lines, 5x7 matrix
    Datas[2]  = 8'h38; // Repeat Function Set for stability
    Datas[3]  = 8'h0C; // Display ON, Cursor OFF
    Datas[4]  = 8'h06; // Entry Mode: Increment cursor
    Datas[5]  = 8'h01; // Clear Display
    Datas[6]  = 8'h80; // Set Cursor to 1st Line
end

always @(posedge clk) begin
    Datas[7] <= RxData; // Update dynamically with received UART data
    
    // Increase Initialization Delay Further
    if (delay_counter > 0) begin
        delay_counter <= delay_counter - 1;
    end
    else begin
        // Ensure Proper Enable (E) Pulsing
        if (i < 50000) begin
            lcd_e <= 1;
        end
        else if (i < 100000) begin
            lcd_e <= 0; // Latch Data into LCD
        end
        else begin
            j = j + 1;
            if (j > 7) j = 1; // Restart loop after depth 7
            i = 0;
        end
        i = i + 1;
    end
end

// Correct RS Assignment (Command Mode or Data Mode)
if (j <= 6)

endmodule
*/

module LCD_DISPLAY (
    input clk,            // 50 MHz FPGA Clock
    input [7:0] RxData,   // Data received from UART
    output reg lcd_e,     // LCD Enable
    output reg lcd_rs,    // LCD Register Select (0 = Command, 1 = Data)
    output reg [7:0] data // LCD 8-bit Data Bus
);

integer i = 0;
integer j = 1;
reg [19:0] delay_counter;
reg [7:0] Datas [1:7]; // Limit depth to 7

// Data Initialization for only first 6 values
initial begin
    delay_counter <= 5000000; // Increase delay before sending first command
    Datas[1]  = 8'h38; // Function Set: 8-bit mode, 2 lines, 5x7 matrix
    Datas[2]  = 8'h38; // Repeat Function Set for stability
    Datas[3]  = 8'h0C; // Display ON, Cursor OFF
    Datas[4]  = 8'h06; // Entry Mode: Increment cursor
    Datas[5]  = 8'h01; // Clear Display
    Datas[6]  = 8'h80; // Set Cursor to 1st Line
end

always @(posedge clk) begin
    Datas[7] <= RxData; // Update dynamically with received UART data
    
    // Increase Initialization Delay Further
    if (delay_counter > 0) begin
        delay_counter <= delay_counter - 1;
    end
    else begin
        // Ensure Proper Enable (E) Pulsing
        if (i < 50000) begin
            lcd_e <= 1;
        end
        else if (i < 100000) begin
            lcd_e <= 0; // Latch Data into LCD
        end
        else begin
            j = j + 1;
            if (j > 7) j = 1; // Restart loop after depth 7
            i = 0;
        end
        i = i + 1;
    end
end

// Correct RS Assignment (Command Mode or Data Mode) and Data Bus Assignment
always @(*) begin
    if (j <= 6) begin
        lcd_rs = 1'b0; // Command Mode
    end else begin
        lcd_rs = 1'b1; // Data Mode (prints RxData)
    end
    data = Datas[j];   // Drive the LCD data bus with the active step value
end

endmodule
`timescale 1ns/1ps

module uart_rxd_tb;
reg clk_fpga, rstn, rxd;
wire[7:0] rxdata;
wire valid_rx;
integer file;
reg[7:0] ch;

uart_receiver dut(
    .clk_fpga(clk_fpga), 
    .rstn(rstn),
    .rxd(rxd),
    .rxdata(rxdata),
    .valid_rx(valid_rx)
);

always #10 clk_fpga=~clk_fpga; // 50 MHz clock period is 20ns (10ns high, 10ns low)

task send_uart_byte(input[7:0]data);
    integer i;
    begin
        rxd=0;
        #104166;
        for(i=0;i<8;i=i+1)begin
            rxd=data[i];
            #104166;
        end
        rxd=1;
        #104166;
        #104166;
    end
endtask

initial begin   
    clk_fpga=0;
    rstn=0;
    rxd=1;
    #100 rstn=1;
    #50000;
    
    // Corrected path with forward slashes
    file= $fopen("C:/Users/Asus/Desktop/uart/vid_uart/string.txt","r");
    if(file==0) begin 
        $display("Error: file not found");
    end
    else begin
        $display("file opened successfully");
    end
    while (!$feof(file)) begin
        if($fscanf(file,"%c",ch)==1)begin
            $write("%c",ch);
            send_uart_byte(ch);
        end
    end
    $fclose(file);
    #500000;
    $finish;
end

endmodule




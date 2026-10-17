module uart_receiver(
input clk_fpga, rstn, rxd,
output [7:0] rxdata,
output reg valid_rx
);

reg shift;
reg state, nextstate;
reg[3:0] bit_counter;
reg [1:0] sample_counter;
reg [13:0] baudrate_counter;
reg [9:0] rxshift_reg;
reg clear_bitcounter, inc_bitcounter, inc_samplecounter, clear_samplecounter;

parameter clk_freq=50_000_000;
parameter baud_rate= 9_600;
parameter div_sample=4;
parameter div_counter= clk_freq/(baud_rate*div_sample);
parameter mid_sample=div_sample/2;
parameter div_bit=10;

assign rxdata= rxshift_reg[8:1];

always@(posedge clk_fpga) begin
    if(!rstn) begin
        state<=0;
        bit_counter<=0;
        baudrate_counter<=0;
        sample_counter<=0;
        rxshift_reg<=10'b0;
        valid_rx<=0;
    end
    else begin  
        baudrate_counter<=baudrate_counter+1;
        if(baudrate_counter==div_counter-1) begin
            baudrate_counter<=0;
            state<=nextstate;
            
            if (state == 1 && nextstate == 0) begin
                valid_rx<=1;
            end else begin
                valid_rx<=0;
            end
            
            if (shift) rxshift_reg<={rxd, rxshift_reg[9:1]};
            if (clear_samplecounter) sample_counter<=0;
            else if (inc_samplecounter) sample_counter<=sample_counter+1;
            if (clear_bitcounter) bit_counter<=0;
            else if (inc_bitcounter) bit_counter<=bit_counter+1;
        end
    end
end

//state machine

always @(*) begin
    shift = 0;
    clear_samplecounter = 0;
    inc_samplecounter = 0;
    clear_bitcounter = 0;
    inc_bitcounter = 0;
    nextstate = state;
    
    case(state)
        0: begin //idle state
            if(rxd)begin
                nextstate = 0;
            end else begin
                nextstate = 1;
                clear_bitcounter = 1;
                clear_samplecounter = 1;
            end
        end 
        
        1: begin //receiving state
            inc_samplecounter = 1;
            if(sample_counter==mid_sample) shift = 1;
            if(sample_counter==div_sample-1) begin
                clear_samplecounter = 1;
                inc_bitcounter = 1;
                if(bit_counter==div_bit-1) begin
                    nextstate = 0;
                end
            end
        end 
        default:nextstate = 0;
    endcase 
end
endmodule




//Dedicated Hour Counter (24Hr)
module hour_counter2(input clk, input enable, input reset, output reg [7:0] hh);
always@(posedge clk)begin
if (reset) begin
  hh<= 8'd0;   // Master reset to 00
  end
  else if(enable)begin
      if(hh == 8'h23)begin
      hh<=8'd0;  // Wrap around from 23 to 00
         end
      else if(hh[3:0] == 4'd9)begin
      hh[3:0]<= 4'd0;
      hh[7:4]<= hh[7:4] + 1; // BCD carry from 09 to 10
         end
      else begin
      hh[3:0]<=hh[3:0]+1;
         end 
    end
end
endmodule
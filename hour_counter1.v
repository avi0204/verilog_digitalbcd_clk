//Dedicated Hour Counter (12Hr)
module hour_counter1(input clk, input enable, input reset, output reg [7:0] hh);
    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'h12; // Master reset to 12
        end
        else if (enable) begin
            if (hh == 8'h12) begin
                hh <= 8'h01; // Wrap around from 12 to 01
            end
            else if (hh[3:0] == 4'h9) begin
                hh[3:0] <= 4'h0;
                hh[7:4] <= hh[7:4] + 1; // BCD carry from 09 to 10
            end
            else begin
                hh[3:0] <= hh[3:0] + 1;
            end
        end
    end
endmodule

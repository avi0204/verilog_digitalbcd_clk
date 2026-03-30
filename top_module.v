`timescale 1ns / 1ps
module top_module(
    input clk,
    input reset,
    input ena,
    input twelvehr,   //choose 12hr or 24hr digital output
    input [7:0]ha,    //alarm hour
    input [7:0]ma,    //alarm minutes
    input [7:0]sa,    //alarm seconds
    output reg pm,    //am pm switch
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss,
    output reg alarm
); 

    wire [3:0] w1, w2, w3, w4;
    wire en1, en2, en3, en4;
    wire rst1, rst2;
    wire [7:0] wh1, wh2;

    assign en1 = (w1 == 4'd9) && ena;
    assign rst1 = (w2 == 4'd5 && w1 == 4'd9) || reset;
    
    assign en2 = (w2 == 4'd5 && w1 == 4'd9) && ena;
    assign rst2 = (w4 == 4'd5 && w3 == 4'd9 && w2 == 4'd5 && w1 == 4'd9) || reset;
    
    assign en3 = (w3 == 4'd9) && en2; 
    assign en4 = (w4 == 4'd5 && w3 == 4'd9 && w2 == 4'd5 && w1 == 4'd9) && ena; // Hour enable

    // Seconds count
    bcdcount M1(clk, ena, rst1, w1);
    bcdcount M2(clk, en1, rst1, w2);
    
    // Minutes count  
    bcdcount M3(clk, en2, rst2, w3);
    bcdcount M4(clk, en3, rst2, w4);
    
    // Hours count (12hr and 24hr count simultaneously)

    hour_counter1 M_Hours1(clk, en4, reset, wh1);

    hour_counter2 M_Hours2(clk, en4, reset, wh2);
    
    assign hh = twelvehr? wh1:wh2;
    
    assign ss = {w2, w1};
    assign mm = {w4, w3};
   
    //PM Toggle
    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0; // Reset to AM
        end
        else if (wh1 == 8'h11 && w4 == 4'd5 && w3 == 4'd9 && w2 == 4'd5 && w1 == 4'd9 && ena) begin
            pm <= ~pm;
        end
    end
    //alarm toggle
    always@(posedge clk)begin
    if (hh == ha && mm == ma && ss == sa && ena)begin
    alarm <= 1'b1;
    end
    else begin
    alarm <= 1'b0;
    end
    
    end

endmodule
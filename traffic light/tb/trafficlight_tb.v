`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2025 11:19:17 AM
// Design Name: testbench
// Module Name: trafficlight_tb
// Project Name: traffic light controller
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module trafficlight_tb();
    reg CLOCK;    
    reg CLEAR;    
    reg X;        
    wire [1:0] HWY;   
    wire [1:0] ROAD;  

    reg [8*6:1] hwy_light, road_light;
    reg [8*11:1] state_name; 
    
    always @(*) begin
        case (uut.state)
            0: state_name = "HWY_GREEN";
            1: state_name = "HWY_YELLOW";
            2: state_name = "ALL_RED";
            3: state_name = "ROAD_GREEN";
            4: state_name = "ROAD_YELLOW";
            default: state_name = "UNKNOWN";
        endcase
        
        case (HWY)
            2'b00: hwy_light = "RED";
            2'b01: hwy_light = "GREEN";
            2'b10: hwy_light = "YELLOW";
            default: hwy_light = "ERROR";
        endcase
        
        case (ROAD)
            2'b00: road_light = "RED";
            2'b01: road_light = "GREEN";
            2'b10: road_light = "YELLOW";
            default: road_light = "ERROR";
        endcase
    end

    // Instantiate traffic controller
    trafficlight_controller uut (
        .clock(CLOCK),
        .clear(CLEAR),
          .x(X),
          .hwy(HWY),
        .road(ROAD)
    );

   initial CLOCK = 0;
   always #5 CLOCK = ~CLOCK;

    // Test stimulation
    initial begin

        $dumpfile("dump.vcd");
        $dumpvars(0, trafficlight_tb);

        // Test 1: Reset - Should go to HWY_GREEN
        $display("\nTest 1: Reset condition");
        CLEAR = 1;
        X = 0;
        #20;

        // Test 2: Normal operation - Highway Green
        $display("\nTest 2: Normal operation - Highway Green");
        CLEAR = 0;
        X = 0;
        #40;

        // Test 3: Car arrives - Transition through all states
        $display("\nTest 3: Car arrives - Full state transition");
        X = 1;  // Car arrives on road
        #150;  

        // Test 4: Car leaves - Transition back to Highway
        $display("\nTest 4: Car leaves - Return to Highway");
        X = 0;  // Car leaves
        #150;   

        // Test 5: Quick car detection
        $display("\nTest 5: Quick car detection");
        X= 1;  // Another car arrives
        #50;
        X= 0;  // Car leaves quickly
        #100;

        $finish;
    end

    always @(posedge CLOCK) begin
        $display("Time=%0t State=%s HWY=%s ROAD=%s CAR=%b", 
                 $time, state_name, hwy_light, road_light, X);
    end
endmodule
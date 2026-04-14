`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2025 11:18:46 AM
// Module Name: trafficlight_controller
// Project Name: traffic light controller
// Product family: Spartan-7
// Project part: xc7s50fgga484-1Q
// Target language: Verilog
// Simulator language: Mixed
// Target Simulator: Vivado Simulator
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module trafficlight_controller (
    input clock,
    input clear,
    input x,     // sensor 
    output reg [1:0] hwy,  
    output reg [1:0] road  
);

    localparam [1:0] RED = 2'b00,
                     GREEN = 2'b01,
                     YELLOW = 2'b10;
    
    localparam [2:0] S0 = 0,  // Highway green, Road red (default)
                     S1 = 1,  // Highway yellow, Road red
                     S2 = 2,  // Highway red, Road red (safety state)
                     S3 = 3,  // Highway red, Road green
                     S4 = 4;  // Highway red, Road yellow
    
    reg [2:0] state;
    reg [2:0] delay;

    always @(posedge clock) begin
        if (clear) begin
            state <= S0;  // Default state:Highway green
            delay <= 0;
        end
        else begin
            case (state)
                S0: begin  // Highway green
                    if (x)  // Car detected on road
                        state <= S1; // Start highway yellow
                end

                S1: begin  // Highway yellow
                    if (delay == 2) begin  // After 3 cycles
                        state <= S2;  // Go to red-red state
                        delay <= 0;   // Reset delay for next state
                    end
                    else
                        delay <= delay + 1;
                end

                S2: begin  // Red-red safety state
                    if (delay == 1) begin  // Wait 2 cycles
                        state <= S3;  // Switch to road green
                        delay <= 0;
                    end
                    else
                        delay <= delay + 1;
                end

                S3: begin  // Road green
                    if (!x)  // No car on road
                        state <= S4;  // Start road yellow
                end

                S4: begin  // Road yellow
                    if (delay == 2) begin  // After 3 cycles
                        state <= S0;  // Back to highway green
                        delay <= 0;
                    end
                    else
                        delay <= delay + 1;
                end

                default: state <= S0;  // Return to default state
            endcase
        end
    end

    always @(*) begin
        // Default state (Highway green, Road red)
        hwy = GREEN;
        road = RED;
        
        case (state)
            S0: begin  // Highway green
                hwy = GREEN;
                road = RED;
            end
            S1: begin  // Highway yellow
                hwy = YELLOW;
                road = RED;
            end
            S2: begin // All red (safety state)
                hwy = RED;
                road = RED;
            end
            S3: begin  // Road green
                hwy = RED;
                road = GREEN;
            end
            S4: begin  // Road yellow
                hwy = RED;
                road = YELLOW;
            end
        endcase
    end

endmodule


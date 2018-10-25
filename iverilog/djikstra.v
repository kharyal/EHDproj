/*
    module for Dijkstra:

    input n: number of nodes
    input e: number of edges
    input data: [0:3] contain parent node
                [4:7] contain child node
                [7:11] contain weight of edge from parent to child
    output sp: shortest path of each node from node 0
    other inputs and outputs are self explainatory
*/
module Djikstra
(
    input [3:0] n,
    input [7:0] e,
    input [11:0] data [0:255],
    input clk,
    reset,
    valid,
    ready,
    hold,

    output reg [255:0] sp [0:15],
    output reg valid_out
);
    reg [3:0] hp [0:15];
    reg [3:0] len;
    reg [31:0] state;
    reg [3:0] nn;
    reg [7:0] ee;
    reg [11:0] inp [0:255];
    always @(posedge clk or reset==1'b0)
    begin
        if (reset==1'b0) begin          //reset
            hp [0:15] <=0;
            valid_out<=1'b0;
            sp [0:15]<=0;
            len<=0;
            state<=0;
        end
        else begin
            if(state==0) begin
                nn<=n;
                ee<=e;
                inp<=data;
            end
        end 
    end    
endmodule
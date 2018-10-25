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

    output [255:0] sp [0:15],
    output valid_out
);

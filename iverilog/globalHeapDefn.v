module defnHeap();
    reg [3:0] hp [0:15];
endmodule

module swap(input [0:15] pos1, input [0:15] pos2);
    defnHeap.hp[pos1]<=defnHeap.hp[pos2];
    defnHeap.hp[pos2]<=defnHeap.hp[pos1];
endmodule
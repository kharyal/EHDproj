module tb_division;
    parameter WIDTH = 32;
    // Inputs
    reg [WIDTH-1:0] A;
    reg [WIDTH-1:0] B;
    // Outputs
    wire [WIDTH-1:0] Res;

    // Instantiate the division module (UUT)
    division #(WIDTH) uut (
        .A(A), 
        .B(B), 
        .Res(Res)
    );

    initial begin
        // Initialize Inputs and wait for 100 ns
        A = 100;  B = 100;  #100;  //Undefined inputs
        //Apply each set of inputs and wait for 100 ns.
        A = 1;    B = 2; #100;
        $display(Res);
        A = 200;    B = 40; #100;
        $display(Res);
        A = 90; B = 9;  #100;
        $display(Res);
        A = 70; B = 10; #100;
        $display(Res);
        A = 16; B = 3;  #100;
        $display(Res);
        A = 255;    B = 5;  #100;
        $display(Res);
    end
    endmodule
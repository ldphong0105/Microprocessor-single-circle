module add_sub_4bit_sign (
    input logic sub,
    input logic [3:0] x,
    input logic [3:0] y,
    output logic [3:0] result,
    output logic overflow
);  
    logic [3:0] a;
    logic [3:0] c;

    assign a = y ^ {4{sub}}; 

    fulladder f0 (.a(x[0]), .b(a[0]), .c_in(sub),   .x(result[0]), .c_out(c[0]));
    fulladder f1 (.a(x[1]), .b(a[1]), .c_in(c[0]),  .x(result[1]), .c_out(c[1]));
    fulladder f2 (.a(x[2]), .b(a[2]), .c_in(c[1]),  .x(result[2]), .c_out(c[2]));
    fulladder f3 (.a(x[3]), .b(a[3]), .c_in(c[2]),  .x(result[3]), .c_out(c[3]));

    assign overflow = c[2] ^ c[3];

endmodule
module multi_comb_4bit (
    input logic [3:0] sbn,
    input logic [3:0] sn,
    output logic [7:0] result
);
    logic [2:0][3:0] a;
    logic [2:0][3:0] b;
    logic  [2:0] c;

    assign result [0] = sbn[0] & sn[0];
    assign b[0][1:0] = sbn[2:1] & {2{sn[0]}};
    assign b[0][2] = ~(sbn[3] & sn[0]);
    assign b[0][3] = 1'b1;

    assign a[0][2:0] = sbn[2:0] & {3{sn[1]}};
    assign a[0][3] = ~(sbn[3] & sn [1]);
    add_sub_4bit fa0(.sub(1'b0), .x(a[0]), .y(b[0]),
                .result({b[1][2:0],result[1]}), .overflow(c[0]));
    assign b[1][3]=c[0];
    
    assign a[1][2:0] = sbn[2:0] & {3{sn[2]}};
    assign a[1][3] = ~(sbn[3] & sn[2]);
    add_sub_4bit fa1(.sub(1'b0), .x(a[1]), .y(b[1]),
                .result({b[2][2:0],result[2]}), .overflow(c[1]));
    assign b[2][3]=c[1];
    
    assign a[2][2:0] = ~(sbn[2:0] & {3{sn[3]}});
    assign a[2][3] = sbn[3] & sn[3];
    add_sub_4bit fa3(.sub(1'b0), .x(a[2]), .y(b[2]),
                .result(result[6:3]), .overflow(c[2]));
    assign result[7]= ~c[2];

endmodule
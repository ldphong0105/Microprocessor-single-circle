
module fulladder (
    input logic a,
    input logic b,
    input logic c_in, 
    output logic x,
    output logic c_out
);
    assign x= (a^b)^c_in;
    assign c_out = (c_in & (a ^ b)) | (a & b);

endmodule


module counter(
    input clk,
    input reset_n,

    output logic [3:0] count
);
    always_ff @(posedge clk, negedge reset_n) begin
        if(~reset_n) begin
            count <=0;
        end else begin
            count <= count +1;
        end
    end
endmodule
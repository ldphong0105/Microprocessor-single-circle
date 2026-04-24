module ALU_4bit (
    input logic [3:0] a,
    input logic [3:0] b,
    input logic [1:0] opcode,

    output logic [7:0] result,
    output logic zerosflag,
    output logic overflowflag,
    output logic signflag
);

    logic [3:0] addsub_result;
    logic [7:0] mul_result;
    logic overflow_addsub;
    logic sub;

  
    assign sub = |(opcode);

    add_sub_4bit_sign add_sub (.sub(sub), .x(a), .y(b)
                , .result(addsub_result), .overflow(overflow_addsub));
    multi_comb_4bit mul (.sbn(a), .sn(b), .result(mul_result));

    always_comb begin
        case (opcode)
            2'b00, 2'b01: begin 
                result[3:0] = addsub_result;
                if(a[3]^b[3]^sub) begin
                    result[7:4] = {4{addsub_result[3]}};
                end
                else begin 
                    result[7:4] = {4{a[3]}};
                end
                overflowflag = overflow_addsub;
                signflag = addsub_result[3];
                zerosflag = (result == 8'b0);
            end
            2'b10: begin 
                result = mul_result;
                overflowflag = 1'b0; 
                signflag = result[7];
                zerosflag = (result == 8'b0);
            end
            default: begin
                result = 8'h00;
                overflowflag = 1'b0;
                signflag = 1'b0;
                zerosflag = 1'b1;
            end
        endcase
    end
endmodule
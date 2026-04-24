module controller (
    input clk,
    input reset_n,
    input [7:0] data_in,
    input [7:0] result,
    input [2:0] flag,
    
    output logic [3:0] addr,
    output wenable,
    output select,
    output logic [3:0] a,
    output logic [3:0] b,
    // output logic [7:0] data_out,
    output logic [1:0] opcode
);
    logic zeros_flag;
    logic overflow_flag;
    logic sign_flag;

    memory mem ( 
        .clk(clk),
        .reset_n(reset_n),  
        //.data_in(data_out),
        .addr(addr),
        .select (select), 
        .wenable(wenable), 
        .data_out(data_in)
    );


    ALU_4bit alu (
        .a(a),
        .b(b), 
        .opcode(opcode), 
        .result(result), 
        .zerosflag(flag[0]),
        .overflowflag(flag[1]),
        .signflag (flag[2])
    );

    logic [3:0] R0_next, R1_next, R2_next, R3_next;
    logic [3:0] R0, R1, R2, R3;

    
    logic [3:0] R_addr_next;

    logic [7:0] R_data;
    logic [3:0] R_addr;

    assign wenable = 1'b0;
    assign select = 1'b1;
    


    always_comb begin
        addr = R_addr;
        opcode = 2'b11; 
        R_addr_next = R_addr + 1;
        R0_next = R0;
        R1_next = R1;
        R2_next = R2;
        R3_next = R3;
        a = 4'd0;
        b = 4'd0;
        case (R_data[7:4])
            4'b0000: begin      //ADD
                a = R1;
                b = R_data[3:0];
                R1_next = result;
                opcode = 2'b00;
            end
            4'b0001: begin      //SUB
                a = R1;
                b= R0;
                R1_next = result;
                opcode = 2'b01; 
            end
            4'b0010: begin
                opcode = 2'b10;    //MUL
                case (R_data[3:2])
                    2'b00 : begin 
                        a = R0;
                        R0_next = result;
                    end
                    2'b01 : begin 
                        a = R1;
                        R1_next= result;
                    end
                    2'b10 : begin 
                        a = R2;
                        R2_next= result;
                    end
                    2'b11 : begin 
                        a = R3;
                        R3_next= result;
                    end
                endcase
                case (R_data[1:0])
                    2'b00 : b = R0;
                    2'b01 : b = R1;
                    2'b10 : b = R2;
                    2'b11 : b = R3;
                endcase
            end

            4'b0100: begin      //SUB
                opcode = 2'b01;
                a = R0;
                b = R_data[3:0];
                R0_next = result;
            end

            4'b0101: begin       //CMP R0
                a = R0;
                b = R_data[3:0];
                opcode = 2'b01;
            end

            4'b0110: begin       //CMP R1
                opcode = 2'b01;
                a = R1;
                b = R_data[3:0];
            end

            4'b0111: begin // BNE addr
                // opcode = 2'b01;
                // a = R1;
                // b = R_data[3:0];
                if (!zeros_flag) R_addr_next = R_data[3:0];
            end

                

            4'b1100: begin     //MOV
                R0_next = R_data[3:0];
            end

            4'b1101: begin
                R1_next = R_data[3:0];
            end
            4'b1110: begin
                R2_next = R_data[3:0];
            end
            4'b1111: begin
                R3_next = R_data[3:0];
            end
            
            
        endcase 
    end

    always_ff @(posedge clk, negedge reset_n) begin
        if(~reset_n) begin
            R0 <= 4'b0000;
            R1 <= 4'b0000;
            R2 <= 4'b0000;
            R3 <= 4'b0000;
          //  R_data <=8'b00000000;
            R_addr <= 4'b0000;
            sign_flag <= 1'b0;
            overflow_flag <= 1'b0;
            zeros_flag <= 1'b0;

        end else begin
            R0 <= R0_next;
            R1 <= R1_next;
            R2 <= R2_next;
            R3 <= R3_next;
          //  R_data <= data_in;
            R_addr <= R_addr_next;
            zeros_flag <= flag [0];
            overflow_flag <= flag [1];
            sign_flag <= flag [2];
        end
    end
    assign R_data = data_in;

endmodule

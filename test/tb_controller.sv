`timescale 1ns / 1ps

module tb_controller;

    logic clk;
    logic reset_n;

    logic [7:0] data_in;
    logic [7:0] result;
    logic [2:0] flag;

    logic [3:0] addr;
    logic wenable;
    logic select;
    logic [3:0] a, b;
    //logic [7:0] data_out;
    logic [1:0] opcode;

    // Instantiate DUT
    controller dut (
        .clk(clk),
        .reset_n(reset_n),
        .data_in(data_in),
        .result(result),
        .flag(flag),
        .addr(addr),
        .wenable(wenable),
        .select(select),
        .a(a),
        .b(b),
        //.data_out(data_out),
        .opcode(opcode)
    );

    // Clock: 10ns period
    always #5 clk = ~clk;

    // ROM program (instruction memory)
    always_comb begin
        case (addr)
            
            
        endcase
    end

    // Mô phỏng ALU phản hồi theo opcode
    always_comb begin
        case (opcode)
            2'b00: result = a + b;
            2'b01: result = a - b;
            2'b10: result = a * b;
            default: result = 8'h00;
        endcase
        flag[0] = (result == 0);       // zero flag
        flag[1] = 0;                   // overflow flag (not used)
        flag[2] = result[7];           // sign flag
    end

    // Monitor để debug trạng thái hoạt động
    initial begin
        $display("=== BẮT ĐẦU MÔ PHỎNG ===");
        $monitor("T=%0t | addr=%0d | inst=%b | opcode=%b | a=%0d, b=%0d | result=%0d | zero=%b", 
                  $time, addr, data_in, opcode, a, b, result, flag[0]);
    end

    // Khởi tạo reset và clock
    initial begin
        clk = 0;
        reset_n = 0;
        #12;
        reset_n = 1;

        // Chạy trong 40 chu kỳ
        repeat (60) @(posedge clk);

        $display("=== KẾT THÚC MÔ PHỎNG ===");
        $finish;
    end

endmodule

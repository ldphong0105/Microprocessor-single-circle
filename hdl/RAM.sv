module RAM (
    input logic [3:0] addr,
    input logic select,
    input logic wenable,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);

    logic [7:0] mem [0:15];

    // Đọc từ RAM
    always_comb begin
        if (select && !wenable)
            data_out = mem[addr];
        else
            data_out = 8'hZZ;
    end

    // Ghi vào RAM
    always_ff @(posedge wenable) begin
        if (select && wenable)
            mem[addr] <= data_in;
    end

    // Khởi tạo chương trình
    initial begin
        mem[0] = 8'b1101_1111;  // MOV R1, #15
        mem[1] = 8'b1100_1010;  // MOV R0, #10
        mem[2] = 8'b0001_1010;  // SUB R1, R0
        mem[3] = 8'b0011_0001;  // SUB R0, #1
        mem[4] = 8'b0100_0000;  // CMP R0, #0
        mem[5] = 8'b0110_0100;  // BNE LOOP (0x04)
        mem[6] = 8'b0101_0000;  // CMP R1, #0
        mem[7] = 8'b0110_1001;  // BNE ELSE (0x09)
        mem[8] = 8'b1101_1111;  // MOV R1, #15
        mem[9] = 8'b0000_1010;  // ADD R1, #10
        // mem[10]...mem[15] có thể để trống hoặc 0
    end

endmodule

module memory(
    input clk,
    input reset_n,
    //input [7:0] data_in,
    input [3:0] addr,
    input select,
    input wenable,
    output logic [7:0] data_out
);

    logic [7:0] ram [15:0]; // 16 ô nhớ 8-bit

    // Gán lệnh mặc định khi reset
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            ram[0]  <= 8'b11011111; // MOV R1, #15
            ram[1]  <= 8'b11001010; // MOV R0, #10
            ram[2]  <= 8'b00011010; // SUB R1, R0
            ram[3]  <= 8'b01000001; // SUB R0, #1
            ram[4]  <= 8'b01010000; // CMP R0, #0
            ram[5]  <= 8'b01110010; // BNE LOOP
            ram[6]  <= 8'b01100000; // CMP R1, #0
            ram[7]  <= 8'b01111001; // BNE ELSE
            ram[8]  <= 8'b11011111; // MOV R1, #15
            ram[9]  <= 8'b00001010; // ADD R1, #10
            ram[10] <= 8'b00000000; // NOP
            ram[11] <= 8'b00000000;
            ram[12] <= 8'b00000000;
            ram[13] <= 8'b00000000;
            ram[14] <= 8'b00000000;
            ram[15] <= 8'b00000000;
        end 
        // else if (wenable && select) begin
        //     ram[addr] <= data_in; // ghi dữ liệu
        // end
    end

    // Đọc dữ liệu tổ hợp
    always_comb begin
        if (!wenable && select)
            data_out = ram[addr];
        else
            data_out = 8'hZZ;
    end

endmodule
`timescale 1ns / 1ps

module ALU_4bit_tb;

    logic [3:0] a, b;
    logic [1:0] opcode;
    logic [7:0] result;
    logic zerosflag, overflowflag, signflag;

    // Instantiate DUT
    ALU_4bit dut (
        .a(a), .b(b), .opcode(opcode),
        .result(result),
        .zerosflag(zerosflag),
        .overflowflag(overflowflag),
        .signflag(signflag)
    );

    initial begin
        // Header
        $display("Time\ta\tb\topcode\tresult\tzero\toverflow\tsign");

        // Test ADD: 3 + 5
        a = 4'd3; b = 4'd5; opcode = 2'b00;
        #10;
        $display("%0t\t%d\t%d\t%b\t%h\t%b\t%b\t%b", $time, a, b, opcode, result, zerosflag, overflowflag, signflag);

        // Test SUB: 7 - 2
        a = 4'd7; b = 4'd2; opcode = 2'b01;
        #10;
        $display("%0t\t%d\t%d\t%b\t%h\t%b\t%b\t%b", $time, a, b, opcode, result, zerosflag, overflowflag, signflag);

        // Test SUB: 2 - 7 (âm)
        a = 4'd2; b = 4'd7; opcode = 2'b01;
        #10;
        $display("%0t\t%d\t%d\t%b\t%h\t%b\t%b\t%b", $time, a, b, opcode, result, zerosflag, overflowflag, signflag);

        // Test MUL: 3 * 4
        a = 4'd3; b = 4'd4; opcode = 2'b10;
        #10;
        $display("%0t\t%d\t%d\t%b\t%h\t%b\t%b\t%b", $time, a, b, opcode, result, zerosflag, overflowflag, signflag);

        // Test default (invalid opcode)
        a = 4'd0; b = 4'd0; opcode = 2'b11;
        #10;
        $display("%0t\t%d\t%d\t%b\t%h\t%b\t%b\t%b", $time, a, b, opcode, result, zerosflag, overflowflag, signflag);

        $finish;
    end
endmodule

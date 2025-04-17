// file: alu_tb.v
`timescale 1ns/1ps

module alu_tb;
    reg [31:0] operand_a;
    reg [31:0] operand_b;
    reg [3:0] alu_control;
    wire [31:0] result;
    wire zero;
    
    // Instantiate the ALU
    alu dut (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );
    
    // Test sequence
    initial begin
        // Initialize waveform dump
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        // Test ADD operation (11 + 12)
        operand_a = 32'd11;
        operand_b = 32'd12;
        alu_control = 4'b0000; // ADD
        #10;
        $display("ADD: %d + %d = %d", operand_a, operand_b, result);
        
        // Test SUB operation
        operand_a = 32'd20;
        operand_b = 32'd15;
        alu_control = 4'b0001; // SUB
        #10;
        $display("SUB: %d - %d = %d", operand_a, operand_b, result);
        
        // Test AND operation
        operand_a = 32'h0F0F;
        operand_b = 32'hF0F0;
        alu_control = 4'b1001; // AND
        #10;
        $display("AND: 0x%h & 0x%h = 0x%h", operand_a, operand_b, result);
        
        // Test OR operation
        operand_a = 32'h0F0F;
        operand_b = 32'hF0F0;
        alu_control = 4'b1000; // OR
        #10;
        $display("OR: 0x%h | 0x%h = 0x%h", operand_a, operand_b, result);
        
        // End simulation
        #10;
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time = %0t, A = %d, B = %d, ALU_Control = %b, Result = %d, Zero = %b", 
                $time, operand_a, operand_b, alu_control, result, zero);
    end
endmodule
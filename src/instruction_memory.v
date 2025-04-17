module instruction_memory(
    input [31:0] pc,
    output [31:0] instruction
);

    reg [31:0] memory [255:0]; // 1KB instruction memory

    // Initialize with a sample program
    initial begin
        memory[0] = 32'h00B00513;  // addi x10, x0, 11
        memory[1] = 32'h00C00593;  // addi x11, x0, 12
        memory[2] = 32'h00B50533;  // add x10, x10, x11
        memory[3] = 32'h0000006F;  // jal x0, 0 -> jump về chính mình (giả lập halt)
    end

    // Instruction fetch - PC is word-aligned (PC's 2 LSBs are always 00)
    assign instruction = memory[pc[9:2]]; // PC/4 để có địa chỉ từ bộ nhớ

endmodule

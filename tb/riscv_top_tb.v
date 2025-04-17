`timescale 1ns/1ps

module riscv_top_tb;
    reg clk;
    reg reset;
    wire [31:0] result;
    wire [31:0] x10_out;  // Đọc giá trị x10_out từ DUT
    
    // Instantiate the RISC-V processor
    riscv_top dut (
        .clk(clk),
        .reset(reset),
        .result(result),
        .x10_out(x10_out)  // Kết nối x10_out
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock (10ns period)
    end
    
    // Test sequence
    initial begin
        $display("Starting simulation...");

        // Initial reset and clock
        reset = 1;
        #50;
        reset = 0;

        // Chờ 3 chu kỳ để hoàn thành lệnh add
        #30;

        // In kết quả ngay sau lệnh add
        $display("Time: %0t, Reset: %b, Result: %d", $time, reset, result);
        $display("x10_out: %d", x10_out);
        $display("Final result: %d", result);
        
        // Kết thúc mô phỏng
        $finish;
    end

    // Monitor changes tại cạnh xung clock
    always @(posedge clk) begin
        $strobe("Time = %0t, Reset = %b, Result = %d, x10_out = %d", $time, reset, result, x10_out);
    end
endmodule
// file: register_file_tb.v
`timescale 1ns/1ps

module register_file_tb;

    reg clk;
    reg reset;
    reg [4:0] read_reg1;
    reg [4:0] read_reg2;
    reg [4:0] write_reg;
    reg [31:0] write_data;
    reg reg_write;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Instantiate the register file
    register_file dut (
        .clk(clk),
        .reset(reset),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Test sequence
    initial begin
        // Reset
        reset = 1;
        #10;
        reset = 0;

        // Test write to register
        write_reg = 5'b00001;  // Writing to register 1
        write_data = 32'hA5A5A5A5;
        reg_write = 1;
        #10;
        reg_write = 0;

        // Test read from register
        read_reg1 = 5'b00001;  // Reading from register 1
        #10;
        $display("Register 1: %h", read_data1);

        // Test writing and reading from another register
        write_reg = 5'b00010;  // Writing to register 2
        write_data = 32'h12345678;
        reg_write = 1;
        #10;
        reg_write = 0;
        read_reg2 = 5'b00010;  // Reading from register 2
        #10;
        $display("Register 2: %h", read_data2);

        // End simulation
        $finish;
    end

endmodule

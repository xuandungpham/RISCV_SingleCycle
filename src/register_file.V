// file: register_file.v
module register_file(
    input clk,
    input reset,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [31:0] write_data,
    input reg_write,
    output [31:0] read_data1,
    output [31:0] read_data2,
    output [31:0] register_x10  // Xuất giá trị thanh ghi x10
);

    reg [31:0] registers [31:0];
    integer i;
    
    // Initialize registers
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end

    // Read operations (asynchronous)
    assign read_data1 = (read_reg1 == 5'b0) ? 32'b0 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 5'b0) ? 32'b0 : registers[read_reg2];

    // Write operation (synchronous)
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (reg_write && write_reg != 5'b0) begin
            // Register x0 is hardwired to 0
            registers[write_reg] <= write_data;
        end
    end

    // Output the value of register x10
    assign register_x10 = registers[10];  // x10 corresponds to register 10

endmodule

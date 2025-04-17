// file: data_memory.v
module data_memory(
    input clk,
    input [31:0] address,
    input [31:0] write_data,
    input mem_write,
    input mem_read,
    input [2:0] func3,  // For load/store type
    output reg [31:0] read_data
);

    reg [7:0] memory [1023:0]; // 1KB data memory
    
    // Initialize memory with zeros
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 8'b0;
        end
    end

    // Memory write operation (synchronous)
    always @(posedge clk) begin
        if (mem_write) begin
            case (func3)
                3'b000: memory[address] <= write_data[7:0];                           // SB
                3'b001: {memory[address+1], memory[address]} <= write_data[15:0];     // SH
                3'b010: {memory[address+3], memory[address+2], 
                         memory[address+1], memory[address]} <= write_data;          // SW
                default: ; // No operation
            endcase
        end
    end

    // Memory read operation (asynchronous)
    always @(*) begin
        if (mem_read) begin
            case (func3)
                3'b000: read_data = {{24{memory[address][7]}}, memory[address]};                                // LB
                3'b001: read_data = {{16{memory[address+1][7]}}, memory[address+1], memory[address]};         // LH
                3'b010: read_data = {memory[address+3], memory[address+2], memory[address+1], memory[address]}; // LW
                3'b100: read_data = {24'b0, memory[address]};                                                 // LBU
                3'b101: read_data = {16'b0, memory[address+1], memory[address]};                             // LHU
                default: read_data = 32'b0;
            endcase
        end else begin
            read_data = 32'b0;
        end
    end

endmodule
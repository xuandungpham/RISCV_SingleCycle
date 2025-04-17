// file: control_unit.v
module control_unit(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [1:0] alu_op,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write,
    output reg jump
);

    // RISC-V Opcodes
    parameter R_TYPE    = 7'b0110011;
    parameter I_TYPE    = 7'b0010011;
    parameter LOAD      = 7'b0000011;
    parameter STORE     = 7'b0100011;
    parameter BRANCH    = 7'b1100011;
    parameter JAL       = 7'b1101111;
    parameter JALR      = 7'b1100111;
    parameter LUI       = 7'b0110111;
    parameter AUIPC     = 7'b0010111;

    always @(*) begin
        // Default values
        alu_op = 2'b00;
        branch = 1'b0;
        mem_read = 1'b0;
        mem_to_reg = 1'b0;
        mem_write = 1'b0;
        alu_src = 1'b0;
        reg_write = 1'b0;
        jump = 1'b0;

        case (opcode)
            R_TYPE: begin
                alu_op = 2'b10;    // R-type ALU operation
                reg_write = 1'b1;  // Write to register file
            end
            
            I_TYPE: begin
                alu_op = 2'b10;    // I-type ALU operation
                alu_src = 1'b1;    // Use immediate as second operand
                reg_write = 1'b1;  // Write to register file
            end
            
            LOAD: begin
                alu_op = 2'b00;    // Add for address calculation
                alu_src = 1'b1;    // Use immediate as second operand
                mem_read = 1'b1;   // Read from memory
                mem_to_reg = 1'b1; // Load from memory to register
                reg_write = 1'b1;  // Write to register file
            end
            
            STORE: begin
                alu_op = 2'b00;    // Add for address calculation
                alu_src = 1'b1;    // Use immediate as second operand
                mem_write = 1'b1;  // Write to memory
            end
            
            BRANCH: begin
                alu_op = 2'b01;    // Subtraction for comparison
                branch = 1'b1;     // Branch instruction
            end
            
            JAL: begin
                alu_src = 1'b1;    // Use immediate for jump offset
                reg_write = 1'b1;  // Write return address to register
                jump = 1'b1;       // Jump instruction
            end
            
            JALR: begin
                alu_op = 2'b00;    // Add for address calculation
                alu_src = 1'b1;    // Use immediate as second operand
                reg_write = 1'b1;  // Write return address to register
                jump = 1'b1;       // Jump instruction
            end
            
            LUI: begin
                alu_src = 1'b1;    // Use immediate
                reg_write = 1'b1;  // Write to register file
                // Special handling in ALU control will bypass ALU for LUI
            end
            
            AUIPC: begin
                alu_src = 1'b1;    // Use immediate
                reg_write = 1'b1;  // Write to register file
                // PC + Immediate will be handled in the datapath
            end
            
            default: begin
                // Default values are already set
            end
        endcase
    end

endmodule
module alu_control(
    input [1:0] alu_op,
    input [2:0] funct3,
    input [6:0] funct7,
    input [6:0] opcode,
    output reg [3:0] alu_control_out
);

    // ALU Operation Codes
    parameter ALU_ADD = 4'b0000;
    parameter ALU_SUB = 4'b0001;
    parameter ALU_SLL = 4'b0010;
    parameter ALU_SLT = 4'b0011;
    parameter ALU_SLTU = 4'b0100;
    parameter ALU_XOR = 4'b0101;
    parameter ALU_SRL = 4'b0110;
    parameter ALU_SRA = 4'b0111;
    parameter ALU_OR = 4'b1000;
    parameter ALU_AND = 4'b1001;

    always @(*) begin
        // Đặt mặc định là phép cộng ADD
        alu_control_out = ALU_ADD;

        case (alu_op)
            2'b00: alu_control_out = ALU_ADD; // Load/Store - add for address calculation
            2'b01: alu_control_out = ALU_SUB; // Branch - subtract for comparison
            2'b10: begin // R-type or I-type
                case (funct3)
                    3'b000: begin
                        // ADD/SUB for R-type, ADD for I-type
                        if (opcode == 7'b0110011 && funct7 == 7'b0100000)
                            alu_control_out = ALU_SUB; // SUB
                        else
                            alu_control_out = ALU_ADD; // ADD or ADDI
                    end
                    3'b001: alu_control_out = ALU_SLL; // SLL or SLLI
                    3'b010: alu_control_out = ALU_SLT; // SLT or SLTI
                    3'b011: alu_control_out = ALU_SLTU; // SLTU or SLTIU
                    3'b100: alu_control_out = ALU_XOR; // XOR or XORI
                    3'b101: begin
                        // SRL/SRA for R-type, SRLI/SRAI for I-type
                        if (funct7 == 7'b0100000)
                            alu_control_out = ALU_SRA; // SRA or SRAI
                        else
                            alu_control_out = ALU_SRL; // SRL or SRLI
                    end
                    3'b110: alu_control_out = ALU_OR; // OR or ORI
                    3'b111: alu_control_out = ALU_AND; // AND or ANDI
                    default: alu_control_out = ALU_ADD;
                endcase
            end
            default: alu_control_out = ALU_ADD;
        endcase
    end

endmodule

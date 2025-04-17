// file: alu.v
module alu(
    input [31:0] operand_a,
    input [31:0] operand_b,
    input [3:0] alu_control,
    output reg [31:0] result,
    output zero
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

    // Generate Zero Flag
    assign zero = (result == 32'b0);

    always @(*) begin
        case (alu_control)
            ALU_ADD: result = operand_a + operand_b;
            ALU_SUB: result = operand_a - operand_b;
            ALU_SLL: result = operand_a << operand_b[4:0];
            ALU_SLT: result = ($signed(operand_a) < $signed(operand_b)) ? 32'b1 : 32'b0;
            ALU_SLTU: result = (operand_a < operand_b) ? 32'b1 : 32'b0;
            ALU_XOR: result = operand_a ^ operand_b;
            ALU_SRL: result = operand_a >> operand_b[4:0];
            ALU_SRA: result = $signed(operand_a) >>> operand_b[4:0];
            ALU_OR: result = operand_a | operand_b;
            ALU_AND: result = operand_a & operand_b;
            default: result = 32'b0;
        endcase
    end

endmodule
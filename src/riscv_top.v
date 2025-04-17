// file: riscv_top.v
module riscv_top(
    input clk,
    input reset,
    output [31:0] result,
    output [31:0] x10_out
);

    // === Internal wires & regs ===
    // Program Counter
    reg [31:0] pc;
    wire [31:0] pc_next;
    wire [31:0] pc_plus4;
    wire [31:0] branch_target;
    wire pc_src;

    // Instruction Memory
    wire [31:0] instruction;

    // Control Signals
    wire [1:0] alu_op;
    wire branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write, jump;

    // Instruction fields
    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];
    wire [4:0] rd = instruction[11:7];
    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];

    // Register File
    wire [31:0] reg_read_data1;
    wire [31:0] reg_read_data2;
    wire [31:0] write_back_data;
    wire [31:0] x10_val;

    // Immediate
    wire [31:0] immediate;

    // ALU
    wire [31:0] alu_operand2;
    wire [3:0] alu_control_out;
    wire [31:0] alu_result;
    wire zero;

    // Data Memory
    wire [31:0] read_data;

    // === PC Logic ===
    wire take_branch = branch & zero;
    assign pc_src = take_branch | jump;
    assign pc_plus4 = pc + 4;
    assign branch_target = pc + immediate;
    assign pc_next = pc_src ? branch_target : pc_plus4;

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'b0;
        else
            pc <= pc_next;
    end

    // === Instruction Memory ===
    instruction_memory instr_mem (
        .pc(pc),
        .instruction(instruction)
    );

    // === Control Unit ===
    control_unit control (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_op(alu_op),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .jump(jump)
    );

    // === Register File ===
    register_file reg_file (
        .clk(clk),
        .reset(reset),
        .read_reg1(rs1),
        .read_reg2(rs2),
        .write_reg(rd),
        .write_data(write_back_data),
        .reg_write(reg_write),
        .read_data1(reg_read_data1),
        .read_data2(reg_read_data2),
        .register_x10(x10_val)
    );

    // === Immediate Generator ===
    immediate_gen imm_gen (
        .instruction(instruction),
        .immediate(immediate)
    );

    // === ALU Operand Selection ===
    assign alu_operand2 = alu_src ? immediate : reg_read_data2;

    // === ALU Control ===
    alu_control alu_control (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .opcode(opcode),
        .alu_control_out(alu_control_out)
    );

    // === ALU ===
    alu alu_unit (
        .operand_a(reg_read_data1),
        .operand_b(alu_operand2),
        .alu_control(alu_control_out),
        .result(alu_result),
        .zero(zero)
    );

    // === Data Memory ===
    data_memory data_mem (
        .clk(clk),
        .address(alu_result),
        .write_data(reg_read_data2),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .func3(funct3),
        .read_data(read_data)
    );

    // === Write Back MUX ===
    assign write_back_data = mem_to_reg ? read_data : alu_result;

    // === Output result ===
    assign result = x10_val; // Sử dụng x10_val thay vì write_back_data
    assign x10_out = x10_val;

endmodule
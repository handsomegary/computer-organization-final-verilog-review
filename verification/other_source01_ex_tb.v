`timescale 1ns / 1ps
// Directed diagnostics against the unmodified source 01 EX module.
// Compile EX.v only; ALUcontrol.v is a separate empty, duplicate EX module.
module other_source01_ex_tb;
    reg clk = 0;
    reg rst = 1;
    reg [31:0] read1 = 0;
    reg [31:0] read2 = 0;
    reg [31:0] instruction = 0;
    reg [31:0] extension = 0;
    wire signed [31:0] result;
    wire [31:0] instruction_out;
    wire signed [31:0] write_data;
    wire branch;
    wire jump;
    integer checks = 0;
    integer failures = 0;

    EX dut(
        .Read_data1(read1), .Read_data2(read2),
        .instruction_Reg(instruction), .Alu_result(result),
        .instruction_Alu(instruction_out), .Write_data_mem(write_data),
        .clk(clk), .sign_extend(extension), .rst(rst),
        .newpc(32'd4), .branch(branch), .jump(jump)
    );
    always #5 clk = ~clk;

    task expect_result;
        input [255:0] name;
        input [31:0] expected;
        begin
            checks = checks + 1;
            if (result !== expected) begin
                failures = failures + 1;
                $display("FAIL %0s expected=%0d actual=%0d", name,
                         $signed(expected), $signed(result));
            end else $display("PASS %0s result=%0d", name, $signed(result));
        end
    endtask

    initial begin
        repeat (2) @(negedge clk);
        rst = 0;
        // Sanity check confirms that stimulus, clock and result wiring work.
        instruction = {6'd0,5'd1,5'd3,5'd4,5'd0,6'h20};
        read1 = 7; read2 = 5;
        @(posedge clk); #1;
        expect_result("baseline_add", 12);

        @(negedge clk);
        instruction = {6'd0,5'd1,5'd3,5'd4,5'd0,6'h2a};
        read1 = 1; read2 = 2;
        @(posedge clk); #1;
        expect_result("required_slt_true", 1);

        @(negedge clk);
        read1 = 3; read2 = 2;
        @(posedge clk); #1;
        expect_result("required_slt_false", 0);

        @(negedge clk);
        read1 = 32'hffffffff; read2 = 1;
        @(posedge clk); #1;
        expect_result("required_signed_slt", 1);

        // A jump control output must not remain set for a subsequent add.
        @(negedge clk);
        instruction = {6'd2,26'd25};
        @(posedge clk); #1;
        checks = checks + 1;
        if (jump !== 1'b1) begin
            failures = failures + 1;
            $display("FAIL jump_assert expected=1 actual=%b", jump);
        end else $display("PASS jump_assert");

        @(negedge clk);
        instruction = {6'd0,5'd1,5'd3,5'd4,5'd0,6'h20};
        read1 = 7; read2 = 5;
        @(posedge clk); #1;
        checks = checks + 1;
        if (jump !== 1'b0) begin
            failures = failures + 1;
            $display("FAIL jump_clear_after_add expected=0 actual=%b", jump);
        end else $display("PASS jump_clear_after_add");

        $display("SUMMARY source01_ex checks=%0d failures=%0d", checks, failures);
        if (failures) $fatal(1, "Source 01 EX fails required behavior");
        $finish;
    end
endmodule

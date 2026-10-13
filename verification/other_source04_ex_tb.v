`timescale 1ns / 1ps
// Isolated diagnostic of source 04 Execution.v, preserving all original RTL.
// This bypasses Main.v's named-port compilation errors only to test EX logic.
module other_source04_ex_tb;
    reg clk = 0;
    reg rst = 1;
    reg signed [31:0] read1 = 0;
    reg signed [31:0] read2 = 0;
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
        .ins_reg(instruction), .result(result),
        .ins_Alu(instruction_out), .Write_data_mem(write_data),
        .clk(clk), .sign_extend(extension), .rst(rst),
        .PC(32'd4), .branch(branch), .jump(jump)
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
        // Changing ins_reg to an instruction with rd=2 captures reset result 0
        // into the design's RESULT cache. The legitimate ADD produces 12.
        instruction = {6'd0,5'd1,5'd3,5'd2,5'd0,6'h20};
        read1 = 7; read2 = 5;
        @(posedge clk); #1;
        expect_result("baseline_add", 12);

        // rs=4 and rt=5 have no dependency on the previous destination r2.
        // Operand VALUE 2 is valid data and must remain 2, not cached RESULT.
        @(negedge clk);
        instruction = {6'd0,5'd4,5'd5,5'd3,5'd0,6'h20};
        read1 = 2; read2 = 5;
        @(posedge clk); #1;
        expect_result("add_value_two_no_dependency", 7);

        @(negedge clk);
        instruction = {6'd0,5'd6,5'd5,5'd4,5'd0,6'h22};
        read1 = 2; read2 = 5;
        @(posedge clk); #1;
        expect_result("sub_value_two_no_dependency", 32'hfffffffd);

        @(negedge clk);
        instruction = {6'd0,5'd6,5'd5,5'd7,5'd0,6'h25};
        read1 = 4; read2 = 2;
        @(posedge clk); #1;
        expect_result("or_value_two_no_dependency", 6);

        @(negedge clk);
        instruction = {6'd8,5'd6,5'd4,16'd7};
        read1 = 2; read2 = 0; extension = 7;
        @(posedge clk); #1;
        expect_result("addi_value_two_no_dependency", 9);

        // The signed SLT case is present and provides an independent baseline.
        @(negedge clk);
        instruction = {6'd0,5'd6,5'd5,5'd8,5'd0,6'h2a};
        read1 = -1; read2 = 1;
        @(posedge clk); #1;
        expect_result("baseline_signed_slt", 1);

        $display("SUMMARY source04_ex checks=%0d failures=%0d", checks, failures);
        if (failures) $fatal(1, "Source 04 EX corrupts legitimate data value 2");
        $finish;
    end
endmodule

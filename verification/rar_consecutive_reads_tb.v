`timescale 1ns/1ps
// Populate using separated stores, then load two addresses with MemRead high.
module rar_consecutive_reads_tb;
  reg clk=0,memwrite=0,memread=0;
  reg [31:0] addr=0,data=0;
  wire [31:0] read_data,addr_wb;
  wire pcsrc,regwrite_wb,memtoreg_wb;
  wire [4:0] reg_wb;
  Dmemory dut(.addr(addr),.write_data(data),.memwrite(memwrite),.memread(memread),
    .clk(clk),.write_back(1'b0),.mem_to_reg(1'b0),.write_reg(5'd0),
    .read_data1(read_data),.addr1(addr_wb),.m(1'b0),.zero(1'b0),.PCsrc(pcsrc),
    .write_reg1(reg_wb),.write_back1(regwrite_wb),.mem_to_reg1(memtoreg_wb));
  task tick;begin #1;clk=1;#1;clk=0;#1;end endtask
  initial begin
    #1;addr=32'd4;data=32'd11;memwrite=1;tick;
    memwrite=0;tick;
    addr=32'd8;data=32'd22;memwrite=1;tick;
    memwrite=0;tick;
    addr=32'd4;memread=1;tick;
    if(read_data!==32'd11)
      $fatal(1,"FAIL read setup: expected 11, got %0d",read_data);
    addr=32'd8;tick;
    if(read_data!==32'd22)
      $fatal(1,"FAIL consecutive loads: second address expected 22, got %0d",read_data);
    $display("PASS rar_consecutive_reads_tb");$finish;
  end
endmodule

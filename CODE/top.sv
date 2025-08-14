`include "uvm_macros.svh"
`include "interface.sv"
`include "alu.v"
//`include "alu_pkg.sv"

module top;

  import uvm_pkg::*;
  import alu_pkg::*;

  bit clk;
  bit RST;
  bit CE;
  always #5 clk = ~clk;
  alu_intf intrf(clk,RST,CE);

   ALU_DESIGN  DUT(  .CLK(clk),
                     .RST(RST),
                     .CE(CE),
                     .INP_VALID(intrf.inp_valid),
                     .MODE(intrf.mode),
                     .CMD(intrf.CMD),
                     .CIN(intrf.Cin),
                     .ERR(intrf.ERR),
                     .RES(intrf.RES),
                     .OPA(intrf.OPA),
                     .OPB(intrf.OPB),
                     .OFLOW(intrf.OFLOW),
                     .COUT(intrf.COUT),
                     .G(intrf.G),
                     .L(intrf.L),
                     .E(intrf.E));


  initial begin
    RST = 0;
    #5;
    CE = 0;
    RST = 1;
    #10;
    CE = 1;
    #20;
    RST = 0;
    //clk = 1;

  end

  initial begin
    uvm_config_db#(virtual alu_intf)::set(null,"*","alu_intf",intrf);
    run_test("regression_test");
  end
endmodule

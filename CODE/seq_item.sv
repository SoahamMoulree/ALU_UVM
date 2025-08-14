`include "defines.sv"
class seq_item extends uvm_sequence_item;
  rand logic [`W-1 : 0] OPA;
  rand logic [`W-1 :0] OPB;
  rand logic Cin;
  //logic CE;
  rand logic mode;
  rand logic [1:0] inp_valid;
  rand logic [`N-1 : 0] CMD;
  logic [`W:0] RES;
  logic OFLOW;
  logic COUT;
  logic G;
  logic L;
  logic E;
  logic ERR;
  //constraint c1 {mode == 1; CMD inside{9};OPA inside{[0:10]}; OPB inside{[0:10]};}
  //`uvm_object_utils(seq_item)
  `uvm_object_utils_begin(seq_item)
    `uvm_field_int(OPA,UVM_ALL_ON)
    `uvm_field_int(OPB,UVM_ALL_ON)
    `uvm_field_int(Cin,UVM_ALL_ON)
    `uvm_field_int(mode,UVM_ALL_ON)
    `uvm_field_int(inp_valid,UVM_ALL_ON)
    `uvm_field_int(CMD,UVM_ALL_ON)
    `uvm_field_int(RES,UVM_ALL_ON)
    `uvm_field_int(OFLOW,UVM_ALL_ON)
    `uvm_field_int(COUT,UVM_ALL_ON)
    `uvm_field_int(G,UVM_ALL_ON)
    `uvm_field_int(L,UVM_ALL_ON)
    `uvm_field_int(E,UVM_ALL_ON)
    `uvm_field_int(ERR,UVM_ALL_ON)
  `uvm_object_utils_end
  function new(string name = "seq_item");
    super.new(name);
  endfunction

endclass

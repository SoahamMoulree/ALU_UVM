class alu_test extends uvm_test;

  `uvm_component_utils(alu_test)
  alu_env env1;
  alu_sequence sq1;
  function new(string name = "alu_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env1 = alu_env::type_id::create("env1",this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    sq1 = alu_sequence::type_id::create("sq1",this);
    sq1.start(env1.agnt1.seqr1);
    phase.drop_objection(this);
  endtask

endclass

class arith_test_single_op extends alu_test;
  `uvm_component_utils(arith_test_single_op)

  function new(string name = "arith_test_single_op",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    arithmetic_seq_single_op seq1;
    phase.raise_objection(this);
    seq1 = arithmetic_seq_single_op::type_id::create("seq1");
    seq1.start(env1.agnt1.seqr1);
    phase.drop_objection(this);
  endtask

endclass

class logical_test_single_op extends alu_test;
  `uvm_component_utils(logical_test_single_op)

  function new(string name = "logical_test_single_op",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    logical_seq_single_op seq2;
    phase.raise_objection(this);
    seq2 = logical_seq_single_op::type_id::create("seq2");
    seq2.start(env1.agnt1.seqr1);
    phase.drop_objection(this);
  endtask

endclass


class arith_test_two_op extends alu_test;
  `uvm_component_utils(arith_test_two_op)

  function new(string name = "arith_test_two_op",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    arithmetic_seq_two_op seq3;
    phase.raise_objection(this);
    seq3 = arithmetic_seq_two_op::type_id::create("seq3");
    seq3.start(env1.agnt1.seqr1);
    phase.drop_objection(this);
  endtask

endclass

class logical_test_two_op extends alu_test;
  `uvm_component_utils(logical_test_two_op)

  function new(string name = "logical_test_two_op",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    logical_seq_two_op seq4;
    phase.raise_objection(this);
    seq4 = logical_seq_two_op::type_id::create("seq4");
    seq4.start(env1.agnt1.seqr1);
    phase.drop_objection(this);
  endtask

endclass

class regression_test extends alu_test;
  `uvm_component_utils(regression_test)
  function new(string name = "regression_test", uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual task run_phase(uvm_phase phase);

    regression_seq seq_reg;
    phase.raise_objection(this);
    seq_reg = regression_seq::type_id::create("seq_reg");
    seq_reg.start(env1.agnt1.seqr1);
       phase.drop_objection(this);
  endtask
endclass

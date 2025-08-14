`include "defines.sv"

class alu_sequence extends uvm_sequence#(seq_item);

  `uvm_object_utils(alu_sequence)

  int single_op_arithmetic[] = {4,5,6,7};
  int single_op_logical[] = {6,7,8,9,10,11};

  seq_item req;

  function new(string name = "alu_sequence");
    super.new(name);
  endfunction

    virtual task body();
    req = seq_item::type_id::create("req");
    repeat(`num_txns) begin
      start_item(req);
      assert(req.randomize());
      `uvm_info(get_type_name(),$sformatf("| SEQUENCE GENERATED | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",req.mode,req.inp_valid,req.CMD, req.OPA,req.OPB,req.Cin),UVM_MEDIUM);
      $display("");
      finish_item(req);
      //get_response(req);
    end

  endtask
endclass

class arithmetic_seq_single_op extends uvm_sequence#(seq_item);
  `uvm_object_utils(arithmetic_seq_single_op)

  function new(string name = " arithmetic_seq_single_op");
    super.new(name);
  endfunction

  task body();
    repeat(`num_txns) begin
    `uvm_do_with(req,{req.mode == 1; req.CMD inside{[4:7]};req.inp_valid == 2'b11;})
    //`uvm_info(get_type_name(),$sformatf("| SEQUENCE GENERATED | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",req.mode,req.inp_valid,req.CMD, req.OPA,req.OPB,req.Cin),UVM_MEDIUM);
     //$display("");
     // get_response(req);
    end
  endtask

endclass

class logical_seq_single_op extends uvm_sequence#(seq_item);
  `uvm_object_utils(logical_seq_single_op)

  function new(string name = "logical_seq_single_op");
    super.new(name);
  endfunction

  task body();
    repeat(`num_txns) begin
    `uvm_do_with(req,{req.mode == 0; req.CMD inside{[6:11]};req.inp_valid == 2'b11;})
    //`uvm_info(get_type_name(),$sformatf("| SEQUENCE GENERATED | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",req.mode,req.inp_valid,req.CMD, req.OPA,req.OPB,req.Cin),UVM_MEDIUM);
    //$display("");
      //get_response(req);
    end
  endtask
endclass

class arithmetic_seq_two_op extends uvm_sequence#(seq_item);
  `uvm_object_utils(arithmetic_seq_two_op)

  function new(string name = " arithmetic_seq_two_op");
    super.new(name);
  endfunction

  task body();
    repeat(`num_txns) begin
      `uvm_do_with(req,{req.mode == 1;req.CMD inside{[0:3],[8:10]}; req.inp_valid == 2'b11;OPA dist {0 := 2, 255 :=2};OPB dist {0:=2,255:=2};})
    //`uvm_info(get_type_name(),$sformatf("| SEQUENCE GENERATED | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",req.mode,req.inp_valid,req.CMD, req.OPA,req.OPB,req.Cin),UVM_MEDIUM);
    //$display("");
      //get_response(req);
    end
  endtask

endclass

class logical_seq_two_op extends uvm_sequence#(seq_item);
    `uvm_object_utils(logical_seq_two_op)

    function new(string name = " logical_seq_two_op");
      super.new(name);
    endfunction

    task body();
      repeat(`num_txns) begin
      `uvm_do_with(req,{req.mode == 0; req.CMD inside{[0:5],12,13};req.inp_valid == 2'b11;})
      //`uvm_info(get_type_name(),$sformatf("| SEQUENCE GENERATED | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",req.mode,req.inp_valid,req.CMD, req.OPA,req.OPB,req.Cin),UVM_MEDIUM);
      //$display("");
        //get_response(req);
      end
    endtask

endclass

class regression_seq extends uvm_sequence#(seq_item);
  `uvm_object_utils(regression_seq)
  alu_sequence seq;
  arithmetic_seq_single_op seq1;
  logical_seq_single_op seq2;
  arithmetic_seq_two_op seq3;
  logical_seq_two_op seq4;
  function new(string name = "regression_test");
    super.new(name);
    req = new();
  endfunction

  virtual task body();
    `uvm_do(seq)

    `uvm_do(seq1)

    `uvm_do(seq2)

    `uvm_do(seq3)

    `uvm_do(seq4)
  endtask

endclass

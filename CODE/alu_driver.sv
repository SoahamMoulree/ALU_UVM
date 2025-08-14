`include "defines.sv"

class alu_driver extends uvm_driver#(seq_item);

  `uvm_component_utils(alu_driver)
  virtual alu_intf drv_vif;
  uvm_analysis_port#(seq_item)drv_cov_port;
  function new(string name,uvm_component parent);
    super.new(name,parent);
    drv_cov_port = new("drv_cov_port",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_intf)::get(this,"","alu_intf",drv_vif))
      `uvm_error(get_type_name(),"Config_db not set at TOP!")
  endfunction

  task drive_inputs();
    drv_vif.drv_cb.OPA <= req.OPA;
    drv_vif.drv_cb.OPB <= req.OPB;
    drv_vif.drv_cb.Cin <= req.Cin;
    drv_vif.drv_cb.mode <= req.mode;
    drv_vif.drv_cb.inp_valid <=  req.inp_valid;
    drv_vif.drv_cb.CMD <= req.CMD;
  endtask

  task run_phase(uvm_phase phase);
    int count;
    int single_op_arithmetic[] = {4,5,6,7};
    int single_op_logical[] = {6,7,8,9,10,11};
    repeat(3)@(drv_vif.drv_cb);

    forever begin : repeatloop


      seq_item_port.get_next_item(req);

      if(req.inp_valid == 2'b11 || req.inp_valid == 2'b00)  begin : if1

        drive_inputs();
        drv_cov_port.write(req);
        `uvm_info(get_type_name(),$sformatf("|VALUES DRIVEN | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",req.mode,req.inp_valid,req.CMD, req.OPA,req.OPB,req.Cin),UVM_MEDIUM);
        $display("");
        if(req.mode == 1 && (req.CMD == 9 || req.CMD == 10))
          repeat(2)@(drv_vif.drv_cb);
        else
          repeat(1)@(drv_vif.drv_cb);
      end : if1

      else if(req.mode == 0 && req.CMD inside{single_op_logical}) begin : eif1;
        drive_inputs();
        drv_cov_port.write(req);
        `uvm_info(get_type_name(),$sformatf("|VALUES DRIVEN | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",req.mode,req.inp_valid,req.CMD, req.OPA,req.OPB,req.Cin),UVM_MEDIUM);
        $display("");
        repeat(1)@(drv_vif.drv_cb);
      end : eif1

      else if(req.mode == 1 && req.CMD inside {single_op_arithmetic}) begin : ef2
        drive_inputs();
        drv_cov_port.write(req);
        `uvm_info(get_type_name(),$sformatf("|VALUES DRIVEN | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",req.mode,req.inp_valid,req.CMD, req.OPA,req.OPB,req.Cin),UVM_MEDIUM);
        $display("");
        repeat(1)@(drv_vif.drv_cb);
      end : ef2

      else begin : e1
        drive_inputs();
        drv_cov_port.write(req);
        `uvm_info(get_type_name(),$sformatf("|VALUES DRIVEN | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",req.mode,req.inp_valid,req.CMD, req.OPA,req.OPB,req.Cin),UVM_MEDIUM);
        $display("");
        req.CMD.rand_mode(0);
        req.mode.rand_mode(0);

        for(int i = 0; i < 16; i++) begin : for1
          count++;
          repeat(1)@(drv_vif.drv_cb);
          req.randomize();
          drive_inputs();
          drv_cov_port.write(req);
          `uvm_info(get_type_name(),$sformatf(" [%0d] |VALUES DRIVEN | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",count,req.mode,req.inp_valid,req.CMD, req.OPA,req.OPB,req.Cin),UVM_MEDIUM);
          $display("");

          if(req.inp_valid == 2'b11) begin : nif1
             break;
          end : nif1

        end : for1

        if(count == 16) begin
          uvm_config_db#(int)::set(this,"*","ERR",1);
          repeat(1)@(drv_vif.drv_cb);
        end
        else begin
          uvm_config_db#(int)::set(this,"*","ERR",0);
        end

      end : e1
      req.CMD.rand_mode(1);
      req.mode.rand_mode(1);

      if(req.mode == 1 && (req.CMD == 9 || req.CMD == 10))
        repeat(2)@(drv_vif.drv_cb);
      else
        repeat(1)@(drv_vif.drv_cb);

      seq_item_port.item_done();
    end : repeatloop
  endtask

endclass

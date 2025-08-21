`include "defines.sv"

class alu_monitor extends uvm_monitor;

  `uvm_component_utils(alu_monitor)

  virtual alu_intf mon_vif;
  seq_item mon_item;
  uvm_analysis_port#(seq_item)analysis_port;
  uvm_analysis_port#(seq_item)mon_cov_port;
  uvm_analysis_port#(seq_item)drv_cov_port;
  function new(string name,uvm_component parent);
    super.new(name,parent);
    analysis_port = new("mon_ap",this);
    mon_cov_port = new("mon_cov_port",this);
    drv_cov_port = new("drv_cov_port",this);
    mon_item = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_intf)::get(this,"","alu_intf",mon_vif))
      `uvm_error(get_type_name,"Config db not set at TOP!")
  endfunction

  task monitor_op();
    mon_item.RES = mon_vif.mon_cb.RES;
    mon_item.COUT = mon_vif.mon_cb.COUT;
    mon_item.OFLOW = mon_vif.mon_cb.OFLOW;
    mon_item.G = mon_vif.mon_cb.G;
    mon_item.L = mon_vif.mon_cb.L;
    mon_item.E = mon_vif.mon_cb.E;
    mon_item.ERR = mon_vif.mon_cb.ERR;
    //inputs
    mon_item.OPA = mon_vif.mon_cb.OPA;
    mon_item.OPB = mon_vif.mon_cb.OPB;
    mon_item.Cin = mon_vif.mon_cb.Cin;
    mon_item.CMD = mon_vif.mon_cb.CMD;
    mon_item.mode = mon_vif.mon_cb.mode;
    mon_item.inp_valid = mon_vif.mon_cb.inp_valid;
    mon_cov_port.write(mon_item);
    drv_cov_port.write(mon_item);
  endtask


  task run_phase(uvm_phase phase);
    int single_op_arithmetic[] = {4,5,6,7};
    int single_op_logical[] = {6,7,8,9,10,11};

    int count;

    monitor_op();
    //mon_cov_port.write(mon_item);
    repeat(4)@(mon_vif.mon_cb);
    forever begin : mainloop
      monitor_op();
      //mon_cov_port.write(mon_item);
      if(mon_item.inp_valid == 2'b11 || mon_item.inp_valid == 2'b00) begin : if1
        if(mon_item.mode == 1 && (mon_item.CMD == 9 || mon_item.CMD == 10)) begin : nif1
          repeat(2)@(mon_vif.mon_cb);
          monitor_op();
          //mon_cov_port.write(mon_item);
          `uvm_info(get_type_name,$sformatf("| MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",mon_item.mode,mon_item.inp_valid,mon_item.CMD, mon_item.OPA,mon_item.OPB,mon_item.Cin),UVM_MEDIUM )
          `uvm_info(get_type_name(),$sformatf("| DUT OUTPUT | RES = %0d |",mon_item.RES),UVM_MEDIUM)
          $display("");
        end : nif1

        else begin : ne1
          repeat(1)@(mon_vif.mon_cb);
          $display("here");
          monitor_op();
          //mon_cov_port.write(mon_item);
          `uvm_info(get_type_name,$sformatf("| MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",mon_item.mode,mon_item.inp_valid,mon_item.CMD, mon_item.OPA,mon_item.OPB,mon_item.Cin),UVM_MEDIUM )
          `uvm_info(get_type_name(),$sformatf("| DUT OUTPUT | RES = %0d |",mon_item.RES),UVM_MEDIUM)
          $display("");
        end : ne1
      end : if1

      else if(mon_item.mode == 0 && mon_item.CMD inside {single_op_logical}) begin : eif1
        repeat(1)@(mon_vif.mon_cb);
        monitor_op();
        //mon_cov_port.write(mon_item);
        `uvm_info(get_type_name,$sformatf("| MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",mon_item.mode,mon_item.inp_valid,mon_item.CMD, mon_item.OPA,mon_item.OPB,mon_item.Cin),UVM_MEDIUM )
        `uvm_info(get_type_name(),$sformatf("| DUT OUTPUT | RES = %0d |",mon_item.RES),UVM_MEDIUM)
        $display("");
      end : eif1

      else if(mon_item.mode == 1 && mon_item.CMD inside {single_op_arithmetic}) begin : eif2
         repeat(1)@(mon_vif.mon_cb);
         monitor_op();
         //mon_cov_port.write(mon_item);
         `uvm_info(get_type_name,$sformatf("| MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",mon_item.mode,mon_item.inp_valid,mon_item.CMD, mon_item.OPA,mon_item.OPB,mon_item.Cin),UVM_MEDIUM )
        `uvm_info(get_type_name(),$sformatf("| DUT OUTPUT | RES = %0d |",mon_item.RES),UVM_MEDIUM)
        $display("");
      end : eif2

      else begin : e1
        for(int i = 0; i < 16; i++) begin
          count++;
          repeat(1)@(mon_vif.mon_cb);
          monitor_op();
          //mon_cov_port.write(mon_item);
          if(mon_item.inp_valid == 2'b11) begin : nif1
            monitor_op();
            //mon_cov_port.write(mon_item);
            `uvm_info(get_type_name,$sformatf("| MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",mon_item.mode,mon_item.inp_valid,mon_item.CMD, mon_item.OPA,mon_item.OPB,mon_item.Cin),UVM_MEDIUM )
            `uvm_info(get_type_name(),$sformatf("| DUT OUTPUT | RES = %0d |",mon_item.RES),UVM_MEDIUM)
            $display("");
            break;
          end : nif1
        end
        /*if(count == 16) begin
          `uvm_info(get_type_name,$sformatf("| MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",mon_item.mode,mon_item.inp_valid,mon_item.CMD, mon_item.OPA,mon_item.OPB,mon_item.Cin),UVM_MEDIUM )
          `uvm_info(get_type_name(),$sformatf("| DUT OUTPUT | RES = %0d | ERR = %0d |",mon_item.RES,mon_item.ERR),UVM_MEDIUM)
           $display("");
        end*/


      end : e1

      analysis_port.write(mon_item);

      if(mon_item.mode == 1 && (mon_item.CMD == 9 || mon_item.CMD == 10))
        repeat(2)@(mon_vif.mon_cb);
      else
        repeat(1)@(mon_vif.mon_cb);


    end : mainloop
    //mon_item.print();
  endtask

endclass

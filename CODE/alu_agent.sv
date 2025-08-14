class alu_agent extends uvm_agent;

  `uvm_component_utils(alu_agent)

  alu_driver drv1;
  alu_monitor mon1;
  alu_seqr seqr1;

  function new(string name = "alu_agent" , uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv1 = alu_driver::type_id::create("drv1",this);
    mon1 = alu_monitor::type_id::create("mon1",this);
    seqr1 = alu_seqr::type_id::create("seqr1",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv1.seq_item_port.connect(seqr1.seq_item_export);
  endfunction
endclass

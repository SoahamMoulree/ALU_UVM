class alu_env extends uvm_env;

  `uvm_component_utils(alu_env)

  alu_agent agnt1;
  alu_scoreboard scb1;
  alu_coverage cov1;

  function new(string name = "alu_env",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scb1 = alu_scoreboard::type_id::create("scb1",this);
    agnt1 = alu_agent::type_id::create("agnt1",this);
    cov1 = alu_coverage::type_id::create("cov1",this);
  endfunction

  function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);
    agnt1.mon1.analysis_port.connect(scb1.analysis_imp);
    agnt1.drv1.drv_cov_port.connect(cov1.drv_cov_imp);
    agnt1.mon1.mon_cov_port.connect(cov1.mon_cov_imp);

  endfunction

endclass

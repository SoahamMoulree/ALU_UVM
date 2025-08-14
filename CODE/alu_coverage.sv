`uvm_analysis_imp_decl(_mon_cg)
`uvm_analysis_imp_decl(_drv_cg)

class alu_coverage extends uvm_component;
  `uvm_component_utils(alu_coverage)
  uvm_analysis_imp_mon_cg#(seq_item,alu_coverage)mon_cov_imp;
  uvm_analysis_imp_drv_cg#(seq_item,alu_coverage)drv_cov_imp;

  seq_item drv_cov_seq;
  seq_item mon_cov_seq;

  covergroup drv_cgrp;
    mode_cp : coverpoint drv_cov_seq.mode;
    inp_valid_cp : coverpoint drv_cov_seq.inp_valid;
    opa_cp : coverpoint drv_cov_seq.OPA {
      bins all_zeros = {0};
      bins max_val = {255};
      bins opa = {[255:0]};
    }
    opb_cp : coverpoint drv_cov_seq.OPB {
      bins all_zeros = {0};
      bins max_val = {255};
      bins opb = {[255:0]};
    }
    cin_cp : coverpoint drv_cov_seq.Cin;
    cmd_cp : coverpoint drv_cov_seq.CMD;

    //cross coverage

    cmd_x_inp_v : cross cmd_cp,inp_valid_cp;
    mode_x_inp_v : cross mode_cp,inp_valid_cp;
    mode_x_cmd : cross mode_cp,cmd_cp;
    opa_x_opb : cross opa_cp,opb_cp;
  endgroup

  covergroup mon_cgrp;
      RES_CP : coverpoint mon_cov_seq.RES {
        bins b1 = {[0:9'b111111111]};
      }
      ERR_CP : coverpoint mon_cov_seq.ERR;
      E_CP : coverpoint mon_cov_seq.E { bins one_e = {1};
      }
      G_CP : coverpoint mon_cov_seq.G { bins one_g = {1};
      }
      L_CP : coverpoint mon_cov_seq.L { bins one_l = {1};
      }
      OV_CP: coverpoint mon_cov_seq.OFLOW;
      COUT_CP: coverpoint mon_cov_seq.COUT;
  endgroup

  function new(string name = "alu_coverage",uvm_component parent = null);
    super.new(name,parent);
    mon_cov_imp = new("mon_cov_imp",this);
    drv_cov_imp = new("drv_cov_imp",this);
    drv_cgrp = new();
    mon_cgrp = new();
  endfunction
  function write_drv_cg(seq_item req);
    drv_cov_seq = req;
    drv_cgrp.sample();
  endfunction
  function write_mon_cg(seq_item req);
    mon_cov_seq = req;
    mon_cgrp.sample();
  endfunction
endclass

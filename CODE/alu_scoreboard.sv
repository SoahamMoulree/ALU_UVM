`include "defines.sv"

class alu_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(alu_scoreboard)
  uvm_analysis_imp#(seq_item,alu_scoreboard)analysis_imp;
  int match;
  int mismatch;
  seq_item scb_queue[$];
  seq_item scb_item;
  seq_item ref_pkt;
  virtual alu_intf ref_vif;
  function new(string name = "scb",uvm_component parent = null);
    super.new(name,parent);
    analysis_imp = new("analysis_imp_scb",this);
    scb_item = new();
    ref_pkt = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_intf)::get(this,"","alu_intf",ref_vif))
      `uvm_error(get_type_name(),"Config Db not Set")
  endfunction

  task alu_operation(seq_item ref_pkt);
    if(ref_vif.ref_cb.RST) begin : reset
           ref_pkt.RES = {9{1'bz}};
           ref_pkt.OFLOW = 1'bz;
           ref_pkt.COUT = 1'bz;
           ref_pkt.G = 1'bz;
           ref_pkt.L = 1'bz;
           ref_pkt.E = 1'bz;
           ref_pkt.ERR = 1'bz;
   end : reset

   else if(ref_vif.ref_cb.CE) begin

          //assigning default values
          ref_pkt.RES = {9{1'bz}};
          ref_pkt.OFLOW = 1'bz;
          ref_pkt.COUT = 1'bz;
          ref_pkt.G = 1'bz;
          ref_pkt.L = 1'bz;
          ref_pkt.E = 1'bz;
          ref_pkt.ERR = 1'bz;

          if(ref_pkt.mode == 1) begin

            //if(ref_pkt.CMD inside {})
              case(ref_pkt.inp_valid)
                2'b00 : begin
                  ref_pkt.RES = 0;
                  ref_pkt.ERR = 1;
                end
                2'b01 : begin
                  case(ref_pkt.CMD)
                    4'b0100 : begin
                      ref_pkt.RES = ref_pkt.OPA + 1;
                      ref_pkt.COUT = ref_pkt.RES[`W];
                    end
                    4'b0101 : begin
                      ref_pkt.RES = ref_pkt.OPA - 1;
                      ref_pkt.OFLOW = ref_pkt.RES[`W];
                    end
                    default : begin
                      ref_pkt.RES = 0;
                      ref_pkt.ERR = 1;
                    end
                  endcase
                end
                2'b10 : begin
                  case(ref_pkt.CMD)
                    4'b0110 : begin
                      ref_pkt.RES = ref_pkt.OPB + 1;
                      ref_pkt.COUT = ref_pkt.RES[`W];
                    end
                    4'b0111 : begin
                      ref_pkt.RES = ref_pkt.OPB - 1;
                      ref_pkt.OFLOW = ref_pkt.RES[`W];
                    end
                    default : begin
                      ref_pkt.RES = 0;
                      ref_pkt.ERR = 1;
                    end
                  endcase
                end
                2'b11 : begin
                  case(ref_pkt.CMD)
                    4'b0000 : begin //ADD
                      ref_pkt.RES = ref_pkt.OPA + ref_pkt.OPB;
                      ref_pkt.COUT = ref_pkt.RES[`W];
                    end
                    4'b0001 : begin //SUB
                      ref_pkt.RES = ref_pkt.OPA - ref_pkt.OPB;
                      ref_pkt.OFLOW = ref_pkt.RES[`W];
                    end
                    4'b0010 : begin //ADD_CIN
                      ref_pkt.RES = ref_pkt.OPA + ref_pkt.OPB + ref_pkt.Cin;
                      ref_pkt.COUT = ref_pkt.RES[`W];
                    end
                    4'b0011 : begin //SUB_CIN
                      ref_pkt.RES = ref_pkt.OPA - ref_pkt.OPB - ref_pkt.Cin;
                      ref_pkt.OFLOW = ref_pkt.RES[`W];
                    end
                    4'b1000 : begin //CMP
                      if(ref_pkt.OPA > ref_pkt.OPB)
                        ref_pkt.G = 1;
                      else if(ref_pkt.OPA < ref_pkt.OPB)
                        ref_pkt.L = 1;
                      else
                        ref_pkt.E = 1;
                    end
                    4'b1001 : begin //MULT and INCR
                      ref_pkt.RES = (ref_pkt.OPA + 1) * (ref_pkt.OPB + 1);
                    end
                    4'b1010 : begin // OPA shift left by 1 and MULT with OPB
                      ref_pkt.RES = (ref_pkt.OPA << 1) * (ref_pkt.OPB);
                    end

                    4'b0100 : begin
                      ref_pkt.RES = ref_pkt.OPA + 1;
                      ref_pkt.COUT = ref_pkt.RES[`W];
                    end
                    4'b0101 : begin
                      ref_pkt.RES = ref_pkt.OPA - 1;
                      ref_pkt.OFLOW = ref_pkt.RES[`W];
                    end
                   4'b0110 : begin
                      ref_pkt.RES = ref_pkt.OPB + 1;
                      ref_pkt.COUT = ref_pkt.RES[`W];
                    end
                    4'b0111 : begin
                      ref_pkt.RES = ref_pkt.OPB - 1;
                      ref_pkt.OFLOW = ref_pkt.RES[`W];
                    end


                    default : begin
                      ref_pkt.RES = 0;
                      ref_pkt.ERR = 1;
                    end
                  endcase
                end
                default : begin
                  ref_pkt.RES = 0;
                  ref_pkt.ERR = 1;
                end
              endcase
          end

          else begin : mode0 // for mode = 0
            case(ref_pkt.inp_valid)
              2'b00 : begin : inv_op
                ref_pkt.RES = 0;
                ref_pkt.ERR = 1;
              end : inv_op
              2'b01 : begin : opa_valid
                case(ref_pkt.CMD)
                  4'b0110 : begin : not_a
                    ref_pkt.RES = ~(ref_pkt.OPA);
                    ref_pkt.RES[`W] = 0;
                  end : not_a
                  4'b1000 : begin : SHRA1
                    ref_pkt.RES = (ref_pkt.OPA >> 1);
                  end : SHRA1
                  4'b1001 : begin : SHLA1
                    ref_pkt.RES = (ref_pkt.OPA << 1);
                  end : SHLA1
                  default : begin : def_opa
                    ref_pkt.RES = 0;
                    ref_pkt.ERR = 1;
                  end : def_opa
                endcase
              end : opa_valid
              2'b10 : begin : opb_valid
                case(ref_pkt.CMD)
                  4'b0111 : begin : not_b
                    ref_pkt.RES = ~(ref_pkt.OPB);
                    ref_pkt.RES[`W] = 0;
                  end : not_b
                  4'b1010 : begin : SHRB1
                    ref_pkt.RES = (ref_pkt.OPB >> 1);
                  end : SHRB1
                  4'b1011 : begin : SHLB1
                    ref_pkt.RES = (ref_pkt.OPB << 1);
                  end : SHLB1
                  default : begin : def_opb
                    ref_pkt.RES = 0;
                    ref_pkt.ERR = 1;
                  end : def_opb
                endcase
              end : opb_valid
              2'b11 : begin : opa_opb_valid
                case(ref_pkt.CMD)
                  4'b0000 : begin : and_inp
                    ref_pkt.RES = ref_pkt.OPA & ref_pkt.OPB;
                    ref_pkt.RES[`W] = 0;
                  end : and_inp
                  4'b0001 : begin : nand_inp
                    ref_pkt.RES = ~(ref_pkt.OPA & ref_pkt.OPB);
                    ref_pkt.RES[`W] = 0;
                  end : nand_inp
                  4'b0010 : begin : or_inp
                    ref_pkt.RES = (ref_pkt.OPA | ref_pkt.OPB);
                    ref_pkt.RES[`W] = 0;
                  end : or_inp
                  4'b0011 : begin : nor_inp
                    ref_pkt.RES = ~(ref_pkt.OPA | ref_pkt.OPB);
                    ref_pkt.RES[`W] = 0;
                  end : nor_inp
                  4'b0100 : begin : xor_inp
                    ref_pkt.RES = (ref_pkt.OPA ^ ref_pkt.OPB);
                    ref_pkt.RES[`W] = 0;
                  end : xor_inp
                  4'b0101 : begin : xnor_inp
                    ref_pkt.RES = ~(ref_pkt.OPA ^ ref_pkt.OPB);
                    ref_pkt.RES[`W] = 0;
                  end : xnor_inp
                  4'b1100 : begin : rol_a_b
                    if(| (ref_pkt.OPB[`W-1 : `SHIFT_WIDTH + 1])) begin
                      ref_pkt.ERR = 1;
                      ref_pkt.RES = 0;
                    end
                    else
                      ref_pkt.RES = (ref_pkt.OPA << ref_pkt.OPB[`SHIFT_WIDTH - 1:0]) | (ref_pkt.OPA >> (`W - ref_pkt.OPB[`SHIFT_WIDTH - 1: 0]));
                      // later can make res msb as 0
                  end : rol_a_b
                  4'b1101 : begin : ror_a_b
                    if(| (ref_pkt.OPB[`W-1 : `SHIFT_WIDTH + 1])) begin
                      ref_pkt.ERR = 1;
                      ref_pkt.RES = 0;
                      end
                    else
                      ref_pkt.RES = (ref_pkt.OPA >> ref_pkt.OPB[`SHIFT_WIDTH - 1:0]) | (ref_pkt.OPA << (`W - ref_pkt.OPB[`SHIFT_WIDTH - 1: 0]));
                      //later make res msb to 0;

                  end : ror_a_b

                  4'b0111 : begin : not_b
                    ref_pkt.RES = ~(ref_pkt.OPB);
                    ref_pkt.RES[`W] = 0;
                  end : not_b
                  4'b1010 : begin : SHRB1
                    ref_pkt.RES = (ref_pkt.OPB >> 1);
                    ref_pkt.RES[`W] = 0;
                  end : SHRB1
                  4'b1011 : begin : SHLB1
                    ref_pkt.RES = (ref_pkt.OPB << 1);
                    ref_pkt.RES[`W] = 0;
                  end : SHLB1

                  4'b0110 : begin : not_a
                    ref_pkt.RES = ~(ref_pkt.OPA);
                    ref_pkt.RES[`W] = 0;
                  end : not_a
                  4'b1000 : begin : SHRA1
                    ref_pkt.RES = (ref_pkt.OPA >> 1);
                    ref_pkt.RES[`W] = 0;
                  end : SHRA1
                  4'b1001 : begin : SHLA1
                    ref_pkt.RES = (ref_pkt.OPA << 1);
                    ref_pkt.RES[`W] = 0;
                  end : SHLA1

                  default : begin : def_op
                    ref_pkt.RES = 0;
                    ref_pkt.ERR = 1;
                  end : def_op
                endcase
              end : opa_opb_valid
              default : begin   : inpval_def
                ref_pkt.RES = 0;
                ref_pkt.ERR = 1;
              end : inpval_def
            endcase
          end : mode0

        end


  endtask


  function void write(seq_item req);
    $display("pkt received in scoreboard");
    scb_queue.push_back(req);
  endfunction

  task run_phase(uvm_phase phase);
    int ERR;
    //repeat(1)@(ref_vif.ref_cb);
    forever begin
      wait(scb_queue.size > 0);
      scb_item = scb_queue.pop_front();

      void'(uvm_config_db#(int)::get(this,"","ERR",ERR));
      ref_pkt.ERR = ERR;

      ref_pkt.copy(scb_item);
      alu_operation(ref_pkt);
      `uvm_info(get_type_name(),$sformatf("| REF_MODEL | RES = %0d | ERR = %0d |",ref_pkt.RES,ref_pkt.ERR),UVM_MEDIUM)
      if(scb_item.compare(ref_pkt)) begin
        `uvm_info(get_type_name(),"!! PASS !! ",UVM_MEDIUM)
        $display("");
        match++;
      end
      else begin
        `uvm_info(get_type_name(),"!! FAIL !! ",UVM_MEDIUM)
        $display("");
        mismatch++;
      end
      $display("");
      `uvm_info(get_type_name(),$sformatf("TOTAL MATCH = %0d | TOTAL MISMATCH = %0d",match,mismatch),UVM_MEDIUM);
      $display("------------------------------------------------------------------------------- TESTBENCH -------------------------------------------------------------------------------");
      $display("");
    end
  endtask

endclass

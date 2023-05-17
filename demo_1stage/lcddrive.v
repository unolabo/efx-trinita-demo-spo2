module lcddrive
(
   input CLK,
   input XRST,
   input [11:0] VAL_SPO2,
   input [11:0] VAL_HEARTRATE,
   input [19:0] VAL_WATT,
   input        VAL_STB,
   output [3:0] STATE,
   output[10:0] CTRL
);

  /*
                         _______________
     RS, R/W, ADDR _____|___________|10n|___
                         40n  ______
     E            ___________| 460n |_______ ~~ Next 2ms ~~> __|
                                ________
     DATA         _____________|60ns|10n|___
  
     RS,R/W,ADDR and DATA are latched when E is falling.
     
     main state
    
        reset -> init_1 -> init_2 -> init_3 -> init_4 -> idle <-> update
        
     
     
     transmit counter 0 ~ 512 @ 100MHz
     
        case  2  : Set RS, R/W, ADDR
        case  7  : Rise E
        case  9  : Set DATA
        case 31  : Fall E
        case 35  : Clear RS, R/W, ADDR, DATA
        case 512 : done
     
  
  */
  
  
  reg [ 4:0] state_main;
  reg [17:0] c_transmit;
  wire       n_transmit_clear;
  wire       n_transmit_enable;
  wire       n_transmit_done;
  reg [ 9:0] r_transmit_request;
  reg [ 9:0] r_set_instruction;
  reg [ 5:0] c_set_position;
  wire       n_set_position_enable;
  reg        r_ctrl_regsel;
  reg        r_ctrl_xwrite;
  reg        r_ctrl_enble;
  reg [ 7:0] r_ctrl_data;
  reg [ 1:0] r_val_stb;
  reg [11:0] r_val_spo2;
  reg [11:0] r_val_heartrate;
  reg [19:0] r_val_watt;
  wire       n_stb_trigger;
  
  localparam CONST_MAIN_RESET  =  0;
  localparam CONST_MAIN_INIT1  =  1;
  localparam CONST_MAIN_INIT2  =  2;
  localparam CONST_MAIN_INIT3  =  3;
  localparam CONST_MAIN_INIT4  =  4;
  localparam CONST_MAIN_INIT5  =  5;
  localparam CONST_MAIN_IDLE   =  8;
  localparam CONST_MAIN_UPDATE =  9;
  localparam CONST_MAIN_DONE   = 10;
  localparam CONST_INSTRUCTION_CLEAR    = {1'b0, 1'b0, 8'b00000001};
  localparam CONST_INSTRUCTION_FUNCTION = {1'b0, 1'b0, 8'b00111100};
  localparam CONST_INSTRUCTION_DISPLAY  = {1'b0, 1'b0, 8'b00001100};
  localparam CONST_INSTRUCTION_ENTRY    = {1'b0, 1'b0, 8'b00000110};
  localparam CONST_TIMING_LCD_CTRL      =  2;
  localparam CONST_TIMING_LCD_RISE_E    =  7;
  localparam CONST_TIMING_LCD_DATA      =  9;
  localparam CONST_TIMING_LCD_FALL_E    = 57;
  localparam CONST_TIMING_LCD_CLEAR     = 62;  
  localparam CONST_TEMPLATE_SETPOS_U = {1'b0, 1'b0, 8'b10000000};
  localparam CONST_TEMPLATE_0_0      = {1'b1, 1'b0, 8'h42}; //B
  localparam CONST_TEMPLATE_0_1      = {1'b1, 1'b0, 8'h69}; //i
  localparam CONST_TEMPLATE_0_2      = {1'b1, 1'b0, 8'h6F}; //o
  localparam CONST_TEMPLATE_0_3      = {1'b1, 1'b0, 8'h3A}; //:
  localparam CONST_TEMPLATE_0_4      = {1'b1, 1'b0, 8'h31}; //1
  localparam CONST_TEMPLATE_0_5      = {1'b1, 1'b0, 8'h30}; //0
  localparam CONST_TEMPLATE_0_6      = {1'b1, 1'b0, 8'h30}; //0
  localparam CONST_TEMPLATE_0_7      = {1'b1, 1'b0, 8'h25}; //%
  localparam CONST_TEMPLATE_0_8      = {1'b1, 1'b0, 8'h20}; //_
  localparam CONST_TEMPLATE_0_9      = {1'b1, 1'b0, 8'h31}; //1
  localparam CONST_TEMPLATE_0_10     = {1'b1, 1'b0, 8'h32}; //2
  localparam CONST_TEMPLATE_0_11     = {1'b1, 1'b0, 8'h33}; //3
  localparam CONST_TEMPLATE_0_12     = {1'b1, 1'b0, 8'h42}; //B
  localparam CONST_TEMPLATE_0_13     = {1'b1, 1'b0, 8'h50}; //P
  localparam CONST_TEMPLATE_0_14     = {1'b1, 1'b0, 8'h4D}; //M
  localparam CONST_TEMPLATE_0_15     = {1'b1, 1'b0, 8'h20}; //_
  localparam CONST_TEMPLATE_SETPOS_L = {1'b0, 1'b0, 8'b11000000};
  localparam CONST_TEMPLATE_1_0      = {1'b1, 1'b0, 8'h50}; //P
  localparam CONST_TEMPLATE_1_1      = {1'b1, 1'b0, 8'h6F}; //o
  localparam CONST_TEMPLATE_1_2      = {1'b1, 1'b0, 8'h77}; //w
  localparam CONST_TEMPLATE_1_3      = {1'b1, 1'b0, 8'h3A}; //:
  localparam CONST_TEMPLATE_1_4      = {1'b1, 1'b0, 8'h31}; //1
  localparam CONST_TEMPLATE_1_5      = {1'b1, 1'b0, 8'h32}; //2
  localparam CONST_TEMPLATE_1_6      = {1'b1, 1'b0, 8'h33}; //3
  localparam CONST_TEMPLATE_1_7      = {1'b1, 1'b0, 8'h2E}; //.
  localparam CONST_TEMPLATE_1_8      = {1'b1, 1'b0, 8'h34}; //4
  localparam CONST_TEMPLATE_1_9      = {1'b1, 1'b0, 8'h35}; //5
  localparam CONST_TEMPLATE_1_10     = {1'b1, 1'b0, 8'h6D}; //m
  localparam CONST_TEMPLATE_1_11     = {1'b1, 1'b0, 8'h57}; //W
  localparam CONST_TEMPLATE_1_12     = {1'b1, 1'b0, 8'h20}; //
  localparam CONST_TEMPLATE_1_13     = {1'b1, 1'b0, 8'h20}; //
  localparam CONST_TEMPLATE_1_14     = {1'b1, 1'b0, 8'h20}; //
  localparam CONST_TEMPLATE_1_15     = {1'b1, 1'b0, 8'h20}; //
  localparam CONST_UPDATE_POS0_4     = {1'b0, 1'b0, 8'h84};
  localparam CONST_UPDATE_POS0_9     = {1'b0, 1'b0, 8'h89};
  localparam CONST_UPDATE_POS1_4     = {1'b0, 1'b0, 8'hC4};
  localparam CONST_UPDATE_DOT        = {1'b1, 1'b0, 8'h2E}; //.
  
  
  always@(posedge CLK)
  begin
    if (XRST==1'b0) r_val_stb <= 2'b00;
    else            r_val_stb <= {r_val_stb[0], VAL_STB};
  end
  
  assign n_stb_trigger = (state_main==CONST_MAIN_IDLE && r_val_stb==2'b01) ? 1'b1 : 1'b0;
  
  always@(posedge CLK)
  begin
    if (XRST==1'b0)
    begin
      r_val_spo2      <= 12'h0;
      r_val_heartrate <= 12'h0;
      r_val_watt      <= 20'h0;
    end
    else if (n_stb_trigger==1'b1)
    begin
      r_val_spo2      <= VAL_SPO2;
      r_val_heartrate <= VAL_HEARTRATE;
      r_val_watt      <= VAL_WATT;
    end
  end
  
  always@(posedge CLK)
  begin
    if (XRST==1'b0)
    begin
      state_main <= CONST_MAIN_RESET;    
    end
    else begin
      case (state_main)
        
        CONST_MAIN_RESET  : state_main <= CONST_MAIN_INIT1;
        
        CONST_MAIN_INIT1  :
          begin
            r_transmit_request <= 1'b1;
            r_set_instruction  <= CONST_INSTRUCTION_FUNCTION;
            if (n_transmit_done==1'b1) state_main <= CONST_MAIN_INIT2;
          end

        CONST_MAIN_INIT2  :
          begin
            r_transmit_request <= 1'b1;
            r_set_instruction  <= CONST_INSTRUCTION_FUNCTION;
            if (n_transmit_done==1'b1) state_main <= CONST_MAIN_INIT3;
          end
          
        CONST_MAIN_INIT3  :
          begin
            r_transmit_request <= 1'b1;
            r_set_instruction  <= CONST_INSTRUCTION_DISPLAY;
            if (n_transmit_done==1'b1) state_main <= CONST_MAIN_INIT4;
          end
          
        CONST_MAIN_INIT4  :
          begin
            r_transmit_request <= 1'b1;
            r_set_instruction  <= CONST_INSTRUCTION_CLEAR;
            if (n_transmit_done==1'b1) state_main <= CONST_MAIN_INIT5;
          end
        
        CONST_MAIN_INIT5  :
          begin
            r_transmit_request <= 1'b1;
            r_set_instruction  <= GetTemplate(c_set_position);
            if (c_set_position==34 && n_transmit_done==1'b1) state_main <= CONST_MAIN_IDLE;
          end
        
        CONST_MAIN_IDLE   : 
          begin
            r_transmit_request <= 1'b0;
            if (n_stb_trigger==1'b1) state_main <= CONST_MAIN_UPDATE;
          end
          
        CONST_MAIN_UPDATE :
          begin
            r_transmit_request <= 1'b1;
            r_set_instruction  <= GetUpdatePattern(c_set_position);
            if (c_set_position==14 && n_transmit_done==1'b1) state_main <= CONST_MAIN_DONE;
          end 
        CONST_MAIN_DONE   : state_main <= CONST_MAIN_IDLE;
        default           : state_main <= CONST_MAIN_RESET;
      endcase
    end
  end
  
  //
  assign n_set_position_clear  = (state_main!=CONST_MAIN_INIT5 && state_main!=CONST_MAIN_UPDATE) ? 1'b1 : 1'b0;
  assign n_set_position_enable = (
           (state_main==CONST_MAIN_INIT5 || state_main==CONST_MAIN_UPDATE) &&
            n_transmit_done==1'b1
         ) ? 1'b1 : 1'b0;
  
  always@(posedge CLK)
  begin
    if (XRST==1'b0) c_set_position <= 5'h0;
    else begin
      if (n_set_position_clear==1'b1)       c_set_position <= 5'h0;
      else if (n_set_position_enable==1'b1) c_set_position <= c_set_position + 1'b1;
        
    end
  end
  
  
  function [9:0] GetTemplate(input [5:0] pattern);
  begin
    case(pattern)
      0 : GetTemplate = CONST_INSTRUCTION_ENTRY;
      1 : GetTemplate = CONST_TEMPLATE_SETPOS_U;
      2 : GetTemplate = CONST_TEMPLATE_0_0;
      3 : GetTemplate = CONST_TEMPLATE_0_1;
      4 : GetTemplate = CONST_TEMPLATE_0_2;
      5 : GetTemplate = CONST_TEMPLATE_0_3;
      6 : GetTemplate = CONST_TEMPLATE_0_4;
      7 : GetTemplate = CONST_TEMPLATE_0_5;
      8 : GetTemplate = CONST_TEMPLATE_0_6;
      9 : GetTemplate = CONST_TEMPLATE_0_7;
      10: GetTemplate = CONST_TEMPLATE_0_8;
      11: GetTemplate = CONST_TEMPLATE_0_9;
      12: GetTemplate = CONST_TEMPLATE_0_10;
      13: GetTemplate = CONST_TEMPLATE_0_11;
      14: GetTemplate = CONST_TEMPLATE_0_12;
      15: GetTemplate = CONST_TEMPLATE_0_13;
      16: GetTemplate = CONST_TEMPLATE_0_14;
      17: GetTemplate = CONST_TEMPLATE_0_15;
      18: GetTemplate = CONST_TEMPLATE_SETPOS_L;
      19: GetTemplate = CONST_TEMPLATE_1_0;
      20: GetTemplate = CONST_TEMPLATE_1_1;
      21: GetTemplate = CONST_TEMPLATE_1_2;
      22: GetTemplate = CONST_TEMPLATE_1_3;
      23: GetTemplate = CONST_TEMPLATE_1_4;
      24: GetTemplate = CONST_TEMPLATE_1_5;
      25: GetTemplate = CONST_TEMPLATE_1_6;
      26: GetTemplate = CONST_TEMPLATE_1_7;
      27: GetTemplate = CONST_TEMPLATE_1_8;
      28: GetTemplate = CONST_TEMPLATE_1_9;
      29: GetTemplate = CONST_TEMPLATE_1_10;
      30: GetTemplate = CONST_TEMPLATE_1_11;
      31: GetTemplate = CONST_TEMPLATE_1_12;
      32: GetTemplate = CONST_TEMPLATE_1_13;
      33: GetTemplate = CONST_TEMPLATE_1_14;
      34: GetTemplate = CONST_TEMPLATE_1_15;
      default: GetTemplate = CONST_TEMPLATE_SETPOS_U;
    endcase
  end
  endfunction
  
  function [9:0] GetUpdatePattern(input [5:0] pattern);
  begin
    case(pattern)
      0  : GetUpdatePattern = CONST_UPDATE_POS0_4;
      1  : GetUpdatePattern = {1'b1, 1'b0, 8'h30 + r_val_spo2[11:8]};
      2  : GetUpdatePattern = {1'b1, 1'b0, 8'h30 + r_val_spo2[ 7:4]};
      3  : GetUpdatePattern = {1'b1, 1'b0, 8'h30 + r_val_spo2[ 3:0]};
      4  : GetUpdatePattern = CONST_UPDATE_POS0_9;
      5  : GetUpdatePattern = {1'b1, 1'b0, 8'h30 + r_val_heartrate[11:8]};
      6  : GetUpdatePattern = {1'b1, 1'b0, 8'h30 + r_val_heartrate[ 7:4]};
      7  : GetUpdatePattern = {1'b1, 1'b0, 8'h30 + r_val_heartrate[ 3:0]};
      8  : GetUpdatePattern = CONST_UPDATE_POS1_4;
      9  : GetUpdatePattern = {1'b1, 1'b0, 8'h30 + r_val_watt[19:16]};
      10 : GetUpdatePattern = {1'b1, 1'b0, 8'h30 + r_val_watt[15:12]};
      11 : GetUpdatePattern = {1'b1, 1'b0, 8'h30 + r_val_watt[11: 8]};
      12 : GetUpdatePattern = CONST_UPDATE_DOT;
      13 : GetUpdatePattern = {1'b1, 1'b0, 8'h30 + r_val_watt[ 7: 4]};
      14 : GetUpdatePattern = {1'b1, 1'b0, 8'h30 + r_val_watt[ 3: 0]};
      default: GetUpdatePattern = CONST_UPDATE_POS0_4;
    endcase
  end
  endfunction
  
  //
  
  assign n_transmit_clear  = (r_transmit_request==1'b0 || n_transmit_done==1'b1) ? 1'b1 : 1'b0;
  assign n_transmit_enable = (r_transmit_request==1'b1 && n_transmit_done==1'b0) ? 1'b1 : 1'b0;
  assign n_transmit_done   = (c_transmit[17:16] == 2'b11) ? 1'b1 : 1'b0;
  
  always@(posedge CLK)
  begin
    if (XRST==1'b0)
    begin
      c_transmit <= 10'h0;
    end
    else begin
      if      (n_transmit_clear ==1'b1) c_transmit <= 10'h0;
      else if (n_transmit_enable==1'b1) c_transmit <= c_transmit + 1'b1;
    end
  end
  
  always@(posedge CLK)
  begin
    if (XRST==1'b0)
    begin
      r_ctrl_regsel <= 1'b0;
      r_ctrl_xwrite <= 1'b0;
      r_ctrl_enble  <= 1'b0;
      r_ctrl_data   <= 8'h0;
    end
    else begin
      if (c_transmit==CONST_TIMING_LCD_CTRL)
      begin
        r_ctrl_regsel <= r_set_instruction[9];
        r_ctrl_xwrite <= r_set_instruction[8];
      end
      
      if (c_transmit==CONST_TIMING_LCD_RISE_E)
      begin
        r_ctrl_enble <= 1'b1;
      end
      else if (c_transmit==CONST_TIMING_LCD_FALL_E)
      begin
        r_ctrl_enble <= 1'b0;
      end
      
      if (c_transmit==CONST_TIMING_LCD_DATA)
      begin
        r_ctrl_data <= r_set_instruction[7:0];
      end
    
    end
  end
  
  assign STATE = state_main;
  assign CTRL  = {r_ctrl_data, r_ctrl_enble, r_ctrl_xwrite, r_ctrl_regsel};
  
  //


endmodule

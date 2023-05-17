`timescale 1 ns / 100 ps
module tb_lcddrive;

    reg CLK;
    reg XRST;
    reg [11:0]  VAL_SPO2;
    reg [11:0]  VAL_HEARTRATE;
    reg [19:0]  VAL_WATT;
    reg         VAL_STB;
    wire [ 3:0] STATE;
    wire [10:0] CTRL;
    
    localparam CONST_MAIN_IDLE   =  8;
    
    initial begin
      XRST = 1'b0;
      CLK  = 1'b0;
      #100;
      XRST = 1'b1;
    end
    
    always #5
      CLK <= ~CLK;
    
    initial begin
      VAL_STB       = 1'b0;
      VAL_SPO2      = 12'h0;
      VAL_HEARTRATE = 12'h0;
      VAL_WATT      = 20'h0;
      wait (STATE==CONST_MAIN_IDLE);
      $display("STATE is idle");
      #100
      VAL_STB       = 1'b0;
      VAL_SPO2      = 12'h097;
      VAL_HEARTRATE = 12'h055;
      VAL_WATT      = 20'h54321;
      #20
      VAL_STB       = 1'b1;
      #20
      VAL_STB       = 1'b0;
      
    end
    
    lcddrive lcddrive (
       .CLK(CLK),
       .XRST(XRST),
       .STATE(STATE),
       .CTRL(CTRL),
       .VAL_SPO2(VAL_SPO2),
       .VAL_HEARTRATE(VAL_HEARTRATE),
       .VAL_WATT(VAL_WATT),
       .VAL_STB(VAL_STB)
    );



endmodule
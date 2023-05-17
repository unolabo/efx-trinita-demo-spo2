module spo2_top
(
    input  io_systemClk,
    input  io_systemClk2,
    input  io_systemClk3,
    input  io_pushAsyncReset,
    input  io_pllLocked,
    output io_pllReset,
    input  jtagCtrl_enable,
    input  jtagCtrl_tdi,
    input  jtagCtrl_capture,
    input  jtagCtrl_shift,
    input  jtagCtrl_update,
    input  jtagCtrl_reset,
    output jtagCtrl_tdo,   
    input  jtagCtrl_tck,
    input  system_spi_0_io_data_0_read,
    output system_spi_0_io_data_0_write,
    output system_spi_0_io_data_0_writeEnable,
    input  system_spi_0_io_data_1_read,
    output system_spi_0_io_data_1_write,
    output system_spi_0_io_data_1_writeEnable,
    //input  system_spi_0_io_data_2_read,
    //output system_spi_0_io_data_2_write,
    //output system_spi_0_io_data_2_writeEnable,
    //input  system_spi_0_io_data_3_read,
    //output system_spi_0_io_data_3_write,
    //output system_spi_0_io_data_3_writeEnable,
    output system_spi_0_io_sclk_write,
    output system_spi_0_io_ss,
    
    input  io_asyncReset,
    output system_uart_0_io_txd,
    input  system_uart_0_io_rxd,
    input  system_i2c_1_io_scl_read,
    output system_i2c_1_io_scl_write,
    output system_i2c_1_io_scl_writeEnable,
    input  system_i2c_1_io_sda_read,
    output system_i2c_1_io_sda_write,
    output system_i2c_1_io_sda_writeEnable,
    input  system_i2c_0_io_scl_read,
    output system_i2c_0_io_scl_write,
    output system_i2c_0_io_scl_writeEnable,
    input  system_i2c_0_io_sda_read,
    output system_i2c_0_io_sda_write,
    output system_i2c_0_io_sda_writeEnable,
    output spo2_reset,
    output [3:0]  system_gpio_0_io_writeEnable,
    output [3:0]  system_gpio_0_io_write,
    input  [3:0]  system_gpio_0_io_read,    
    output [3:0]  oled,
    output [10:0] lcd_control
);
`include "trinita_define.vh"

  wire userInterruptA;
  wire systemReset;
  wire system_i2c_0_io_scl_write_net;
  wire system_i2c_0_io_sda_write_net;
  wire system_i2c_1_io_scl_write_net;
  wire system_i2c_1_io_sda_write_net;
  reg[25:0]   test_cnt;
  reg[29:0]   test_cycle;
  reg[ 3:0]   oled;
  wire [15:0] io_apbSlave_0_PADDR;
  wire        io_apbSlave_0_PENABLE;
  wire [31:0] io_apbSlave_0_PRDATA;
  wire        io_apbSlave_0_PREADY;
  wire        io_apbSlave_0_PSEL;
  wire        io_apbSlave_0_PSLVERROR;
  wire [31:0] io_apbSlave_0_PWDATA;
  wire        io_apbSlave_0_PWRITE;
  wire [11:0] VAL_SPO2;
  wire [11:0] VAL_HEARTRATE;
  wire [19:0] VAL_WATT;
  wire        VAL_STB;

  assign userInterruptA = 1'b0;
  assign io_pllReset    = io_asyncReset;
  //assign systemReset    = ~io_pllLocked;
  assign spo2_reset     = io_pllLocked;

sap sap(
    .io_systemClk ( io_systemClk ),
    .io_systemClk2 ( io_systemClk2 ),
    .jtagCtrl_enable  ( jtagCtrl_enable ),
    .jtagCtrl_tdi     ( jtagCtrl_tdi ),
    .jtagCtrl_capture ( jtagCtrl_capture ),
    .jtagCtrl_shift   ( jtagCtrl_shift ),
    .jtagCtrl_update  ( jtagCtrl_update ),
    .jtagCtrl_reset   ( jtagCtrl_reset ),
    .jtagCtrl_tdo     ( jtagCtrl_tdo ),
    .jtagCtrl_tck     ( jtagCtrl_tck ),
    .system_spi_0_io_data_0_read        ( system_spi_0_io_data_0_read ),
    .system_spi_0_io_data_0_write       ( system_spi_0_io_data_0_write ),
    .system_spi_0_io_data_0_writeEnable ( system_spi_0_io_data_0_writeEnable ),
    .system_spi_0_io_data_1_read        ( system_spi_0_io_data_1_read ),
    .system_spi_0_io_data_1_write       ( system_spi_0_io_data_1_write ),
    .system_spi_0_io_data_1_writeEnable ( system_spi_0_io_data_1_writeEnable ),
    .system_spi_0_io_data_2_read        ( system_spi_0_io_data_2_read ),
    .system_spi_0_io_data_2_write       ( system_spi_0_io_data_2_write ),
    .system_spi_0_io_data_2_writeEnable ( system_spi_0_io_data_2_writeEnable ),
    .system_spi_0_io_data_3_read        ( system_spi_0_io_data_3_read ),
    .system_spi_0_io_data_3_write       ( system_spi_0_io_data_3_write ),
    .system_spi_0_io_data_3_writeEnable ( system_spi_0_io_data_3_writeEnable ),
    .system_spi_0_io_sclk_write         ( system_spi_0_io_sclk_write ),
    .system_spi_0_io_ss                 ( system_spi_0_io_ss ),
    .userInterruptA       ( userInterruptA ),
    .io_apbSlave_0_PADDR     (io_apbSlave_0_PADDR     ),
    .io_apbSlave_0_PENABLE   (io_apbSlave_0_PENABLE   ),
    .io_apbSlave_0_PRDATA    (io_apbSlave_0_PRDATA    ),
    .io_apbSlave_0_PREADY    (io_apbSlave_0_PREADY    ),
    .io_apbSlave_0_PSEL      (io_apbSlave_0_PSEL      ),
    .io_apbSlave_0_PSLVERROR (io_apbSlave_0_PSLVERROR ),
    .io_apbSlave_0_PWDATA    (io_apbSlave_0_PWDATA    ),
    .io_apbSlave_0_PWRITE    (io_apbSlave_0_PWRITE    ),
    .io_asyncReset        ( systemReset ),
    .io_systemReset       ( io_systemReset ),
    .system_uart_0_io_txd ( system_uart_0_io_txd ),
    .system_uart_0_io_rxd ( system_uart_0_io_rxd ),
    .system_i2c_1_io_sda_read ( system_i2c_1_io_sda_read ),
    .system_i2c_1_io_scl_write ( system_i2c_1_io_scl_write_net ),
    .system_i2c_1_io_scl_read ( system_i2c_1_io_scl_read ),
    .system_i2c_1_io_sda_write ( system_i2c_1_io_sda_write_net ),
    .system_i2c_0_io_scl_read ( system_i2c_0_io_scl_read ),
    .system_i2c_0_io_scl_write ( system_i2c_0_io_scl_write_net ),
    .system_i2c_0_io_sda_read ( system_i2c_0_io_sda_read ),
    .system_i2c_0_io_sda_write ( system_i2c_0_io_sda_write_net ),
    .system_gpio_0_io_writeEnable ( system_gpio_0_io_writeEnable ),
    .system_gpio_0_io_write ( system_gpio_0_io_write ),
    .system_gpio_0_io_read ( system_gpio_0_io_read )
);

  apb3_to_lcddata apb3_to_lcddata
  (
	// user logic starts here
	/*input				        */ .clk(io_systemClk),
	/*input				        */ .resetn(io_pllLocked),
	/*input	[ADDR_WIDTH-1:0]    */ .PADDR(io_apbSlave_0_PADDR),
	/*input				        */ .PSEL(io_apbSlave_0_PSEL),
	/*input				        */ .PENABLE(io_apbSlave_0_PENABLE),
	/*output				    */ .PREADY(io_apbSlave_0_PREADY),
	/*input				        */ .PWRITE(io_apbSlave_0_PWRITE),
	/*input 	[DATA_WIDTH-1:0]*/ .PWDATA(io_apbSlave_0_PWDATA),
	/*output	[DATA_WIDTH-1:0]*/ .PRDATA(io_apbSlave_0_PRDATA),
	/*output				    */ .PSLVERROR(io_apbSlave_0_PSLVERROR),
    /*output  [11:0]            */ .LCD_SPO2 (VAL_SPO2),
    /*output  [11:0]            */ .LCD_HEART(VAL_HEARTRATE),
    /*output  [19:0]            */ .LCD_WATT (VAL_WATT),
    /*output                    */ .LCD_STB  (VAL_STB)
  );

  lcddrive lcddrive
  (
    .CLK(io_systemClk3),
    .XRST(~systemReset),
    .STATE(_),
    .CTRL(lcd_control),
    .VAL_SPO2     (VAL_SPO2),      //({test_cycle[29:26],test_cycle[29:26],test_cycle[29:26]}),
    .VAL_HEARTRATE(VAL_HEARTRATE), //({test_cycle[29:26],test_cycle[29:26],test_cycle[29:26]}),
    .VAL_WATT     (VAL_WATT),      //({test_cycle[29:26],test_cycle[29:26],test_cycle[29:26],test_cycle[29:26],test_cycle[29:26]}),
    .VAL_STB      (VAL_STB)        //(test_cycle[26])
  );

  assign system_i2c_0_io_scl_write       = 1'b0;
  assign system_i2c_0_io_scl_writeEnable = ~system_i2c_0_io_scl_write_net;
  assign system_i2c_0_io_sda_write       = 1'b0;
  assign system_i2c_0_io_sda_writeEnable = ~system_i2c_0_io_sda_write_net;
  
  assign system_i2c_1_io_scl_write       = 1'b0;
  assign system_i2c_1_io_scl_writeEnable = ~system_i2c_1_io_scl_write_net;
  assign system_i2c_1_io_sda_write       = 1'b0;
  assign system_i2c_1_io_sda_writeEnable = ~system_i2c_1_io_sda_write_net;

  always@(posedge io_systemClk3 or negedge io_pllLocked)
  begin
      if (io_pllLocked==1'b0)
          test_cnt <= 0;
      else if (test_cnt[18]==1'b0)
          test_cnt <= test_cnt + 1'b1;
  end

  assign systemReset = ~test_cnt[18];
  
  //assign oled[3:1] = test_cnt[25:21];
  //assign oled[0]   = io_asyncReset;
  /*
  always@(posedge CLK25M)
  begin
      oled[0] <= ~oled[0];
  end

  always@(posedge CLK25M_180DEG)
  begin
      oled[1] <= ~oled[1];
  end
  */

  always@(posedge io_systemClk)
  begin
    test_cycle <= test_cycle + 1'b1;
  end

endmodule

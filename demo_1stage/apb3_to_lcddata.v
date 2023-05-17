
module apb3_to_lcddata #(
	// user parameter starts here
	//
	parameter	ADDR_WIDTH	= 16,
	parameter	DATA_WIDTH	= 32,
	parameter	NUM_REG		= 4
) (
	// user logic starts here
	input				     clk,
	input				     resetn,
	input	[ADDR_WIDTH-1:0] PADDR,
	input				     PSEL,
	input				     PENABLE,
	output				     PREADY,
	input				     PWRITE,
	input 	[DATA_WIDTH-1:0] PWDATA,
	output	[DATA_WIDTH-1:0] PRDATA,
	output				     PSLVERROR,
    output  [11:0]           LCD_SPO2,
    output  [11:0]           LCD_HEART,
    output  [19:0]           LCD_WATT,
    output                   LCD_STB

);


///////////////////////////////////////////////////////////////////////////////

localparam [1:0]	IDLE   = 2'b00,
			        SETUP  = 2'b01,
			        ACCESS = 2'b10;

integer			     byteIndex;
reg [DATA_WIDTH-1:0] slaveReg [0:NUM_REG-1];
reg [DATA_WIDTH-1:0] slaveRegOut;
reg [1:0] 		     busState, 
			         busNext;
reg			         slaveReady;
wire	 		     actWrite,
			         actRead;
reg [31:0]           lfsr;
wire                 lfsr_stop;


///////////////////////////////////////////////////////////////////////////////

	always@(posedge clk or negedge resetn)
	begin
		if(!resetn) 
			busState <= IDLE; 
		else
			busState <= busNext; 
	end

	always@(*)
	begin
		busNext = busState;

		case(busState)
			IDLE:
			begin
				if(PSEL && !PENABLE)
					busNext = SETUP;
				else
					busNext = IDLE;
			end
			SETUP:
			begin
				if(PSEL && PENABLE)
					busNext = ACCESS;
				else
					busNext = IDLE;
			end
			ACCESS:
			begin
				if(PREADY)
					busNext = IDLE;
				else
					busNext = ACCESS;
			end
			default:
			begin
				busNext = IDLE;
			end
		endcase
	end


	assign actWrite = PWRITE  & (busState == ACCESS);
	assign actRead  = !PWRITE & (busState == ACCESS);
	assign PSLVERROR = 1'b0; 
	assign PRDATA = slaveRegOut;
	assign PREADY = slaveReady & & (busState !== IDLE);

	always@ (posedge clk)
	begin
		slaveReady <= actWrite | actRead;
	end

	always@ (posedge clk or negedge resetn)
	begin
		if(!resetn)
			for(byteIndex = 0; byteIndex < NUM_REG; byteIndex = byteIndex + 1)
			slaveReg[byteIndex] <= {DATA_WIDTH{1'b0}};
		else 
        begin
			if(actWrite) 
            begin
			    for(byteIndex = 0; byteIndex < NUM_REG; byteIndex = byteIndex + 1)
                if (PADDR[3:0] == (byteIndex*4))
				    slaveReg[byteIndex] <= PWDATA;
            end
			else
            begin
                for(byteIndex = 1; byteIndex < NUM_REG; byteIndex = byteIndex + 1)
                slaveReg[byteIndex] <= slaveReg[byteIndex];
            end
		end
	end

	always@ (posedge clk or negedge resetn)
	begin
		if(!resetn)
			slaveRegOut <= {DATA_WIDTH{1'b0}};
		else begin
			if(actRead)
				slaveRegOut <= slaveReg[PADDR[7:2]];
			else
				slaveRegOut <= slaveRegOut;
				
		end

	end
    
    assign LCD_SPO2  = slaveReg[0][11:0];
    assign LCD_HEART = slaveReg[1][11:0];
    assign LCD_WATT  = slaveReg[2][19:0];
    assign LCD_STB   = slaveReg[3][0];

endmodule
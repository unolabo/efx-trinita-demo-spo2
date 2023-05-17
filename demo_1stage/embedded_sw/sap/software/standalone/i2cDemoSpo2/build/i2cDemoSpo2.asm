
build/i2cDemoSpo2.elf:     file format elf32-littleriscv


Disassembly of section .text:

f9000040 <uart_writeAvailability>:
#include "type.h"
#include "soc.h"


    static inline u32 read_u32(u32 address){
        return *((volatile u32*) address);
f9000040:	00452503          	lw	a0,4(a0)
        enum UartStop stop;
        u32 clockDivider;
    } Uart_Config;
    
    static u32 uart_writeAvailability(u32 reg){
        return (read_u32(reg + UART_STATUS) >> 16) & 0xFF;
f9000044:	01055513          	srli	a0,a0,0x10
    }
f9000048:	0ff57513          	andi	a0,a0,255
f900004c:	00008067          	ret

f9000050 <uart_write>:
    static u32 uart_readOccupancy(u32 reg){
        return read_u32(reg + UART_STATUS) >> 24;
    }
    
    static void uart_write(u32 reg, char data){
f9000050:	ff010113          	addi	sp,sp,-16
f9000054:	00112623          	sw	ra,12(sp)
f9000058:	00812423          	sw	s0,8(sp)
f900005c:	00912223          	sw	s1,4(sp)
f9000060:	00050413          	mv	s0,a0
f9000064:	00058493          	mv	s1,a1
        while(uart_writeAvailability(reg) == 0);
f9000068:	00040513          	mv	a0,s0
f900006c:	fd5ff0ef          	jal	ra,f9000040 <uart_writeAvailability>
f9000070:	fe050ce3          	beqz	a0,f9000068 <uart_write+0x18>
    }
    
    static inline void write_u32(u32 data, u32 address){
        *((volatile u32*) address) = data;
f9000074:	00942023          	sw	s1,0(s0)
        write_u32(data, reg + UART_DATA);
    }
f9000078:	00c12083          	lw	ra,12(sp)
f900007c:	00812403          	lw	s0,8(sp)
f9000080:	00412483          	lw	s1,4(sp)
f9000084:	01010113          	addi	sp,sp,16
f9000088:	00008067          	ret

f900008c <uart_writeStr>:
    
    static void uart_writeStr(u32 reg, const char* str){
f900008c:	ff010113          	addi	sp,sp,-16
f9000090:	00112623          	sw	ra,12(sp)
f9000094:	00812423          	sw	s0,8(sp)
f9000098:	00912223          	sw	s1,4(sp)
f900009c:	00050493          	mv	s1,a0
f90000a0:	00058413          	mv	s0,a1
        while(*str) uart_write(reg, *str++);
f90000a4:	00044583          	lbu	a1,0(s0)
f90000a8:	00058a63          	beqz	a1,f90000bc <uart_writeStr+0x30>
f90000ac:	00140413          	addi	s0,s0,1
f90000b0:	00048513          	mv	a0,s1
f90000b4:	f9dff0ef          	jal	ra,f9000050 <uart_write>
f90000b8:	fedff06f          	j	f90000a4 <uart_writeStr+0x18>
    }
f90000bc:	00c12083          	lw	ra,12(sp)
f90000c0:	00812403          	lw	s0,8(sp)
f90000c4:	00412483          	lw	s1,4(sp)
f90000c8:	01010113          	addi	sp,sp,16
f90000cc:	00008067          	ret

f90000d0 <uart_writeHex>:
    static void uart_applyConfig(u32 reg, Uart_Config *config){
        write_u32(config->clockDivider, reg + UART_CLOCK_DIVIDER);
        write_u32(((config->dataLength-1) << 0) | (config->parity << 8) | (config->stop << 16), reg + UART_FRAME_CONFIG);
    }

    static void uart_writeHex(u32 reg, int value){
f90000d0:	ff010113          	addi	sp,sp,-16
f90000d4:	00112623          	sw	ra,12(sp)
f90000d8:	00812423          	sw	s0,8(sp)
f90000dc:	00912223          	sw	s1,4(sp)
f90000e0:	01212023          	sw	s2,0(sp)
f90000e4:	00050913          	mv	s2,a0
f90000e8:	00058493          	mv	s1,a1
        for(int i = 7; i >= 0; i--){
f90000ec:	00700413          	li	s0,7
f90000f0:	0140006f          	j	f9000104 <uart_writeHex+0x34>
            int hex = (value >> i*4) & 0xF;
            uart_write(reg, hex > 9 ? 'A' + hex - 10 : '0' + hex);
f90000f4:	03058593          	addi	a1,a1,48
f90000f8:	00090513          	mv	a0,s2
f90000fc:	f55ff0ef          	jal	ra,f9000050 <uart_write>
        for(int i = 7; i >= 0; i--){
f9000100:	fff40413          	addi	s0,s0,-1
f9000104:	02044063          	bltz	s0,f9000124 <uart_writeHex+0x54>
            int hex = (value >> i*4) & 0xF;
f9000108:	00241593          	slli	a1,s0,0x2
f900010c:	40b4d5b3          	sra	a1,s1,a1
f9000110:	00f5f593          	andi	a1,a1,15
            uart_write(reg, hex > 9 ? 'A' + hex - 10 : '0' + hex);
f9000114:	00900793          	li	a5,9
f9000118:	fcb7dee3          	bge	a5,a1,f90000f4 <uart_writeHex+0x24>
f900011c:	03758593          	addi	a1,a1,55
f9000120:	fd9ff06f          	j	f90000f8 <uart_writeHex+0x28>
        }
    }
f9000124:	00c12083          	lw	ra,12(sp)
f9000128:	00812403          	lw	s0,8(sp)
f900012c:	00412483          	lw	s1,4(sp)
f9000130:	00012903          	lw	s2,0(sp)
f9000134:	01010113          	addi	sp,sp,16
f9000138:	00008067          	ret

f900013c <clint_uDelay>:
    
        return (((u64)hi) << 32) | lo;
    }
    
    static void clint_uDelay(u32 usec, u32 hz, u32 reg){
        u32 mTimePerUsec = hz/1000000;
f900013c:	000f47b7          	lui	a5,0xf4
f9000140:	24078793          	addi	a5,a5,576 # f4240 <CUSTOM1+0xf4215>
f9000144:	02f5d5b3          	divu	a1,a1,a5
    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
f9000148:	0000c7b7          	lui	a5,0xc
f900014c:	ff878793          	addi	a5,a5,-8 # bff8 <CUSTOM1+0xbfcd>
f9000150:	00f60633          	add	a2,a2,a5
        return *((volatile u32*) address);
f9000154:	00062783          	lw	a5,0(a2)
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
f9000158:	02a58533          	mul	a0,a1,a0
f900015c:	00f50533          	add	a0,a0,a5
f9000160:	00062783          	lw	a5,0(a2)
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
f9000164:	40f507b3          	sub	a5,a0,a5
f9000168:	fe07dce3          	bgez	a5,f9000160 <clint_uDelay+0x24>
    }
f900016c:	00008067          	ret

f9000170 <bsp_print>:
            }
        }


#if (ENABLE_BSP_PRINT)
    static void bsp_print(uint8_t * data) {
f9000170:	ff010113          	addi	sp,sp,-16
f9000174:	00112623          	sw	ra,12(sp)
        uart_writeStr(BSP_UART_TERMINAL, (const char*)data);
f9000178:	00050593          	mv	a1,a0
f900017c:	f8001537          	lui	a0,0xf8001
f9000180:	f0dff0ef          	jal	ra,f900008c <uart_writeStr>
        uart_write(BSP_UART_TERMINAL, '\n');
f9000184:	00a00593          	li	a1,10
f9000188:	f8001537          	lui	a0,0xf8001
f900018c:	ec5ff0ef          	jal	ra,f9000050 <uart_write>
        uart_write(BSP_UART_TERMINAL, '\r');
f9000190:	00d00593          	li	a1,13
f9000194:	f8001537          	lui	a0,0xf8001
f9000198:	eb9ff0ef          	jal	ra,f9000050 <uart_write>
    }
f900019c:	00c12083          	lw	ra,12(sp)
f90001a0:	01010113          	addi	sp,sp,16
f90001a4:	00008067          	ret

f90001a8 <bsp_printHexDigit>:

    static void bsp_printHexDigit(uint8_t digit){
f90001a8:	ff010113          	addi	sp,sp,-16
f90001ac:	00112623          	sw	ra,12(sp)
        uart_write(BSP_UART_TERMINAL, digit < 10 ? '0' + digit : 'A' + digit - 10);
f90001b0:	00900793          	li	a5,9
f90001b4:	02a7e063          	bltu	a5,a0,f90001d4 <bsp_printHexDigit+0x2c>
f90001b8:	03050513          	addi	a0,a0,48 # f8001030 <phase+0xfef80ee8>
f90001bc:	0ff57593          	andi	a1,a0,255
f90001c0:	f8001537          	lui	a0,0xf8001
f90001c4:	e8dff0ef          	jal	ra,f9000050 <uart_write>
    }
f90001c8:	00c12083          	lw	ra,12(sp)
f90001cc:	01010113          	addi	sp,sp,16
f90001d0:	00008067          	ret
        uart_write(BSP_UART_TERMINAL, digit < 10 ? '0' + digit : 'A' + digit - 10);
f90001d4:	03750513          	addi	a0,a0,55 # f8001037 <phase+0xfef80eef>
f90001d8:	0ff57593          	andi	a1,a0,255
f90001dc:	fe5ff06f          	j	f90001c0 <bsp_printHexDigit+0x18>

f90001e0 <i2c_applyConfig>:
        //Minimum time between the Stop/Drop -> Start transition
        u32 tBuf;  
    } I2c_Config;
    
    static void i2c_applyConfig(u32 reg, I2c_Config *config){
        write_u32(config->samplingClockDivider, reg + I2C_SAMPLING_CLOCK_DIVIDER);
f90001e0:	0005a783          	lw	a5,0(a1)
        *((volatile u32*) address) = data;
f90001e4:	02f52423          	sw	a5,40(a0)
        write_u32(config->timeout, reg + I2C_TIMEOUT);
f90001e8:	0045a783          	lw	a5,4(a1)
f90001ec:	02f52623          	sw	a5,44(a0)
        write_u32(config->tsuDat, reg + I2C_TSUDAT);
f90001f0:	0085a783          	lw	a5,8(a1)
f90001f4:	02f52823          	sw	a5,48(a0)
    
        write_u32(config->tLow, reg + I2C_TLOW);
f90001f8:	00c5a783          	lw	a5,12(a1)
f90001fc:	04f52823          	sw	a5,80(a0)
        write_u32(config->tHigh, reg + I2C_THIGH);
f9000200:	0105a783          	lw	a5,16(a1)
f9000204:	04f52a23          	sw	a5,84(a0)
        write_u32(config->tBuf, reg + I2C_TBUF);
f9000208:	0145a783          	lw	a5,20(a1)
f900020c:	04f52c23          	sw	a5,88(a0)
    }
f9000210:	00008067          	ret

f9000214 <i2c_masterBusy>:
        return *((volatile u32*) address);
f9000214:	04052503          	lw	a0,64(a0)
        i2c_masterStart(reg);
    }
    
    static int i2c_masterBusy(u32 reg){
        return (read_u32(reg + I2C_MASTER_STATUS) & I2C_MASTER_BUSY) != 0;
    }
f9000218:	00157513          	andi	a0,a0,1
f900021c:	00008067          	ret

f9000220 <i2c_masterStartBlocking>:
        write_u32(I2C_MASTER_START, reg + I2C_MASTER_STATUS);
f9000220:	04050713          	addi	a4,a0,64
        *((volatile u32*) address) = data;
f9000224:	01000793          	li	a5,16
f9000228:	04f52023          	sw	a5,64(a0)
        return *((volatile u32*) address);
f900022c:	00072783          	lw	a5,0(a4)
        return (read_u32(reg + I2C_MASTER_STATUS));
    }
    
    static void i2c_masterStartBlocking(u32 reg){
        i2c_masterStart(reg);
        while(i2c_getMasterStatus(reg) & I2C_MASTER_START);
f9000230:	0107f793          	andi	a5,a5,16
f9000234:	fe079ce3          	bnez	a5,f900022c <i2c_masterStartBlocking+0xc>
    }
f9000238:	00008067          	ret

f900023c <i2c_masterStopWait>:

    static inline void i2c_masterStop(u32 reg){
        write_u32(I2C_MASTER_STOP, reg + I2C_MASTER_STATUS);
    }
    
    static void i2c_masterStopWait(u32 reg){
f900023c:	ff010113          	addi	sp,sp,-16
f9000240:	00112623          	sw	ra,12(sp)
f9000244:	00812423          	sw	s0,8(sp)
f9000248:	00050413          	mv	s0,a0
        while(i2c_masterBusy(reg));
f900024c:	00040513          	mv	a0,s0
f9000250:	fc5ff0ef          	jal	ra,f9000214 <i2c_masterBusy>
f9000254:	fe051ce3          	bnez	a0,f900024c <i2c_masterStopWait+0x10>
    }
f9000258:	00c12083          	lw	ra,12(sp)
f900025c:	00812403          	lw	s0,8(sp)
f9000260:	01010113          	addi	sp,sp,16
f9000264:	00008067          	ret

f9000268 <i2c_masterStopBlocking>:
    
    static inline void i2c_masterDrop(u32 reg){
        write_u32(I2C_MASTER_DROP, reg + I2C_MASTER_STATUS);
    }
    
    static void i2c_masterStopBlocking(u32 reg){
f9000268:	ff010113          	addi	sp,sp,-16
f900026c:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
f9000270:	02000713          	li	a4,32
f9000274:	04e52023          	sw	a4,64(a0)
        i2c_masterStop(reg);
        i2c_masterStopWait(reg);
f9000278:	fc5ff0ef          	jal	ra,f900023c <i2c_masterStopWait>
    }
f900027c:	00c12083          	lw	ra,12(sp)
f9000280:	01010113          	addi	sp,sp,16
f9000284:	00008067          	ret

f9000288 <i2c_txAckWait>:
        return *((volatile u32*) address);
f9000288:	00452783          	lw	a5,4(a0)
    static inline void i2c_txNack(u32 reg){
        write_u32(1 | I2C_TX_VALID | I2C_TX_ENABLE, reg + I2C_TX_ACK);
    }
    
    static void i2c_txAckWait(u32 reg){
        while(read_u32(reg + I2C_TX_ACK) & I2C_TX_VALID);
f900028c:	1007f793          	andi	a5,a5,256
f9000290:	fe079ce3          	bnez	a5,f9000288 <i2c_txAckWait>
    }
f9000294:	00008067          	ret

f9000298 <i2c_txAckBlocking>:
    
    static void i2c_txAckBlocking(u32 reg){
f9000298:	ff010113          	addi	sp,sp,-16
f900029c:	00112623          	sw	ra,12(sp)
        *((volatile u32*) address) = data;
f90002a0:	30000713          	li	a4,768
f90002a4:	00e52223          	sw	a4,4(a0)
        i2c_txAck(reg);
        i2c_txAckWait(reg);
f90002a8:	fe1ff0ef          	jal	ra,f9000288 <i2c_txAckWait>
    }
f90002ac:	00c12083          	lw	ra,12(sp)
f90002b0:	01010113          	addi	sp,sp,16
f90002b4:	00008067          	ret

f90002b8 <i2c_txNackBlocking>:

    static void i2c_txNackBlocking(u32 reg){
f90002b8:	ff010113          	addi	sp,sp,-16
f90002bc:	00112623          	sw	ra,12(sp)
f90002c0:	30100713          	li	a4,769
f90002c4:	00e52223          	sw	a4,4(a0)
        i2c_txNack(reg);
        i2c_txAckWait(reg);
f90002c8:	fc1ff0ef          	jal	ra,f9000288 <i2c_txAckWait>
    }
f90002cc:	00c12083          	lw	ra,12(sp)
f90002d0:	01010113          	addi	sp,sp,16
f90002d4:	00008067          	ret

f90002d8 <i2c_rxData>:
        return *((volatile u32*) address);
f90002d8:	00852503          	lw	a0,8(a0)
    
    static u32 i2c_rxData(u32 reg){
        return read_u32(reg + I2C_RX_DATA) & I2C_RX_VALUE;
    }
f90002dc:	0ff57513          	andi	a0,a0,255
f90002e0:	00008067          	ret

f90002e4 <apb3_read>:
f90002e4:	00052503          	lw	a0,0(a0)
    
    u32 apb3_read(u32 slave)
    {
    	return read_u32(slave+EXAMPLE_APB3_SLV_REG0_OFFSET);
    	
    }
f90002e8:	00008067          	ret

f90002ec <apb3_ctrl_write>:
    
    void apb3_ctrl_write(u32 slave, struct ctrl_reg *cfg)
    {
        write_u32(*(int *)cfg, slave+EXAMPLE_APB3_SLV_REG1_OFFSET);
f90002ec:	0005a783          	lw	a5,0(a1)
        *((volatile u32*) address) = data;
f90002f0:	00f52223          	sw	a5,4(a0)
    }
f90002f4:	00008067          	ret

f90002f8 <init>:

uint32_t phase = 0;

#ifdef SYSTEM_I2C_0_IO_CTRL

void init(){
f90002f8:	fd010113          	addi	sp,sp,-48
f90002fc:	02112623          	sw	ra,44(sp)
    //I2C init
    I2c_Config i2c;
    i2c.samplingClockDivider = 3;
f9000300:	00300793          	li	a5,3
f9000304:	00f12423          	sw	a5,8(sp)
    i2c.timeout = I2C_CTRL_HZ/1000;     //1 ms;
f9000308:	000067b7          	lui	a5,0x6
f900030c:	1a878793          	addi	a5,a5,424 # 61a8 <CUSTOM1+0x617d>
f9000310:	00f12623          	sw	a5,12(sp)
    i2c.tsuDat  = I2C_CTRL_HZ/2000000;  //500 ns
f9000314:	00c00793          	li	a5,12
f9000318:	00f12823          	sw	a5,16(sp)
    i2c.tLow  = I2C_CTRL_HZ/800000;     //1.25 us
f900031c:	01f00793          	li	a5,31
f9000320:	00f12a23          	sw	a5,20(sp)
    i2c.tHigh = I2C_CTRL_HZ/800000;     //1.25 us
f9000324:	00f12c23          	sw	a5,24(sp)
    i2c.tBuf  = I2C_CTRL_HZ/400000;     //2.5 us
f9000328:	03e00793          	li	a5,62
f900032c:	00f12e23          	sw	a5,28(sp)
    i2c_applyConfig(SYSTEM_I2C_0_IO_CTRL, &i2c);
f9000330:	00810593          	addi	a1,sp,8
f9000334:	f800a537          	lui	a0,0xf800a
f9000338:	ea9ff0ef          	jal	ra,f90001e0 <i2c_applyConfig>
    i2c_applyConfig(SYSTEM_I2C_1_IO_CTRL, &i2c);
f900033c:	00810593          	addi	a1,sp,8
f9000340:	f800b537          	lui	a0,0xf800b
f9000344:	e9dff0ef          	jal	ra,f90001e0 <i2c_applyConfig>
}
f9000348:	02c12083          	lw	ra,44(sp)
f900034c:	03010113          	addi	sp,sp,48
f9000350:	00008067          	ret

f9000354 <trap>:

void trap(){
}
f9000354:	00008067          	ret

f9000358 <ReadInaRegister>:

uint16_t ReadInaRegister(uint16_t address)
{
f9000358:	ff010113          	addi	sp,sp,-16
f900035c:	00112623          	sw	ra,12(sp)
f9000360:	00812423          	sw	s0,8(sp)
f9000364:	00912223          	sw	s1,4(sp)
f9000368:	01212023          	sw	s2,0(sp)
f900036c:	00050493          	mv	s1,a0
	uint16_t retval;
	uint32_t rd;

	// Pointer set
	i2c_masterStartBlocking(SYSTEM_I2C_1_IO_CTRL);
f9000370:	f800b537          	lui	a0,0xf800b
f9000374:	eadff0ef          	jal	ra,f9000220 <i2c_masterStartBlocking>
f9000378:	f800b937          	lui	s2,0xf800b
f900037c:	00001437          	lui	s0,0x1
f9000380:	b8040793          	addi	a5,s0,-1152 # b80 <CUSTOM1+0xb55>
f9000384:	00f92023          	sw	a5,0(s2) # f800b000 <phase+0xfef8aeb8>
	i2c_txByte(SYSTEM_I2C_1_IO_CTRL, 0x80); i2c_txNackBlocking(SYSTEM_I2C_1_IO_CTRL);
f9000388:	f800b537          	lui	a0,0xf800b
f900038c:	f2dff0ef          	jal	ra,f90002b8 <i2c_txNackBlocking>
	i2c_txByte(SYSTEM_I2C_1_IO_CTRL, address); i2c_txNackBlocking(SYSTEM_I2C_1_IO_CTRL);
f9000390:	0ff4f493          	andi	s1,s1,255
        write_u32(byte | I2C_TX_VALID | I2C_TX_ENABLE | I2C_TX_DISABLE_ON_DATA_CONFLICT, reg + I2C_TX_DATA);
f9000394:	b0040793          	addi	a5,s0,-1280
f9000398:	00f4e4b3          	or	s1,s1,a5
f900039c:	00992023          	sw	s1,0(s2)
f90003a0:	f800b537          	lui	a0,0xf800b
f90003a4:	f15ff0ef          	jal	ra,f90002b8 <i2c_txNackBlocking>
	i2c_masterStopBlocking(SYSTEM_I2C_1_IO_CTRL);
f90003a8:	f800b537          	lui	a0,0xf800b
f90003ac:	ebdff0ef          	jal	ra,f9000268 <i2c_masterStopBlocking>


    // Read Register
    i2c_masterStartBlocking(SYSTEM_I2C_1_IO_CTRL);
f90003b0:	f800b537          	lui	a0,0xf800b
f90003b4:	e6dff0ef          	jal	ra,f9000220 <i2c_masterStartBlocking>
f90003b8:	b8140793          	addi	a5,s0,-1151
f90003bc:	00f92023          	sw	a5,0(s2)
    i2c_txByte(SYSTEM_I2C_1_IO_CTRL, 0x81); i2c_txNackBlocking(SYSTEM_I2C_1_IO_CTRL);
f90003c0:	f800b537          	lui	a0,0xf800b
f90003c4:	ef5ff0ef          	jal	ra,f90002b8 <i2c_txNackBlocking>
    rd = i2c_rxData(SYSTEM_I2C_1_IO_CTRL);
f90003c8:	f800b537          	lui	a0,0xf800b
f90003cc:	f0dff0ef          	jal	ra,f90002d8 <i2c_rxData>
f90003d0:	bff40413          	addi	s0,s0,-1025
f90003d4:	00892023          	sw	s0,0(s2)
    i2c_txByte(SYSTEM_I2C_1_IO_CTRL, 0xFF); i2c_txAckBlocking(SYSTEM_I2C_1_IO_CTRL);
f90003d8:	f800b537          	lui	a0,0xf800b
f90003dc:	ebdff0ef          	jal	ra,f9000298 <i2c_txAckBlocking>
    retval = i2c_rxData(SYSTEM_I2C_1_IO_CTRL) << 8;
f90003e0:	f800b537          	lui	a0,0xf800b
f90003e4:	ef5ff0ef          	jal	ra,f90002d8 <i2c_rxData>
f90003e8:	01051493          	slli	s1,a0,0x10
f90003ec:	0104d493          	srli	s1,s1,0x10
f90003f0:	00849493          	slli	s1,s1,0x8
f90003f4:	01049493          	slli	s1,s1,0x10
f90003f8:	0104d493          	srli	s1,s1,0x10
f90003fc:	00892023          	sw	s0,0(s2)
    i2c_txByte(SYSTEM_I2C_1_IO_CTRL, 0xFF); i2c_txNackBlocking(SYSTEM_I2C_1_IO_CTRL);
f9000400:	f800b537          	lui	a0,0xf800b
f9000404:	eb5ff0ef          	jal	ra,f90002b8 <i2c_txNackBlocking>
    retval = retval + i2c_rxData(SYSTEM_I2C_1_IO_CTRL);
f9000408:	f800b537          	lui	a0,0xf800b
f900040c:	ecdff0ef          	jal	ra,f90002d8 <i2c_rxData>
f9000410:	01051413          	slli	s0,a0,0x10
f9000414:	01045413          	srli	s0,s0,0x10
f9000418:	00940433          	add	s0,s0,s1
f900041c:	01041413          	slli	s0,s0,0x10
f9000420:	01045413          	srli	s0,s0,0x10
    i2c_masterStopBlocking(SYSTEM_I2C_1_IO_CTRL);
f9000424:	f800b537          	lui	a0,0xf800b
f9000428:	e41ff0ef          	jal	ra,f9000268 <i2c_masterStopBlocking>

	return retval;
}
f900042c:	00040513          	mv	a0,s0
f9000430:	00c12083          	lw	ra,12(sp)
f9000434:	00812403          	lw	s0,8(sp)
f9000438:	00412483          	lw	s1,4(sp)
f900043c:	00012903          	lw	s2,0(sp)
f9000440:	01010113          	addi	sp,sp,16
f9000444:	00008067          	ret

f9000448 <WriteInaRegister>:

void WriteInaRegister(uint16_t address, uint16_t data)
{
f9000448:	fe010113          	addi	sp,sp,-32
f900044c:	00112e23          	sw	ra,28(sp)
f9000450:	00812c23          	sw	s0,24(sp)
f9000454:	00912a23          	sw	s1,20(sp)
f9000458:	01212823          	sw	s2,16(sp)
f900045c:	01312623          	sw	s3,12(sp)
f9000460:	00050913          	mv	s2,a0
f9000464:	00058413          	mv	s0,a1
	uint32_t rd;

	i2c_masterStartBlocking(SYSTEM_I2C_1_IO_CTRL);
f9000468:	f800b537          	lui	a0,0xf800b
f900046c:	db5ff0ef          	jal	ra,f9000220 <i2c_masterStartBlocking>
f9000470:	f800b9b7          	lui	s3,0xf800b
f9000474:	000014b7          	lui	s1,0x1
f9000478:	b8048793          	addi	a5,s1,-1152 # b80 <CUSTOM1+0xb55>
f900047c:	00f9a023          	sw	a5,0(s3) # f800b000 <phase+0xfef8aeb8>
	i2c_txByte(SYSTEM_I2C_1_IO_CTRL, 0x80); i2c_txNackBlocking(SYSTEM_I2C_1_IO_CTRL);
f9000480:	f800b537          	lui	a0,0xf800b
f9000484:	e35ff0ef          	jal	ra,f90002b8 <i2c_txNackBlocking>
	rd = i2c_rxData(SYSTEM_I2C_1_IO_CTRL);
f9000488:	f800b537          	lui	a0,0xf800b
f900048c:	e4dff0ef          	jal	ra,f90002d8 <i2c_rxData>

	i2c_txByte(SYSTEM_I2C_1_IO_CTRL, address); i2c_txNackBlocking(SYSTEM_I2C_1_IO_CTRL);
f9000490:	0ff97913          	andi	s2,s2,255
f9000494:	b0048493          	addi	s1,s1,-1280
f9000498:	00996933          	or	s2,s2,s1
f900049c:	0129a023          	sw	s2,0(s3)
f90004a0:	f800b537          	lui	a0,0xf800b
f90004a4:	e15ff0ef          	jal	ra,f90002b8 <i2c_txNackBlocking>
	rd = i2c_rxData(SYSTEM_I2C_1_IO_CTRL);
f90004a8:	f800b537          	lui	a0,0xf800b
f90004ac:	e2dff0ef          	jal	ra,f90002d8 <i2c_rxData>

	i2c_txByte(SYSTEM_I2C_1_IO_CTRL, (data>>8) ); i2c_txNackBlocking(SYSTEM_I2C_1_IO_CTRL);
f90004b0:	00845793          	srli	a5,s0,0x8
f90004b4:	0097e7b3          	or	a5,a5,s1
f90004b8:	00f9a023          	sw	a5,0(s3)
f90004bc:	f800b537          	lui	a0,0xf800b
f90004c0:	df9ff0ef          	jal	ra,f90002b8 <i2c_txNackBlocking>
	rd = i2c_rxData(SYSTEM_I2C_1_IO_CTRL);
f90004c4:	f800b537          	lui	a0,0xf800b
f90004c8:	e11ff0ef          	jal	ra,f90002d8 <i2c_rxData>

	i2c_txByte(SYSTEM_I2C_1_IO_CTRL, (data & 0xFF)); i2c_txNackBlocking(SYSTEM_I2C_1_IO_CTRL);
f90004cc:	0ff47413          	andi	s0,s0,255
f90004d0:	00946433          	or	s0,s0,s1
f90004d4:	0089a023          	sw	s0,0(s3)
f90004d8:	f800b537          	lui	a0,0xf800b
f90004dc:	dddff0ef          	jal	ra,f90002b8 <i2c_txNackBlocking>
	rd = i2c_rxData(SYSTEM_I2C_1_IO_CTRL);
f90004e0:	f800b537          	lui	a0,0xf800b
f90004e4:	df5ff0ef          	jal	ra,f90002d8 <i2c_rxData>

	i2c_masterStopBlocking(SYSTEM_I2C_1_IO_CTRL);
f90004e8:	f800b537          	lui	a0,0xf800b
f90004ec:	d7dff0ef          	jal	ra,f9000268 <i2c_masterStopBlocking>

}
f90004f0:	01c12083          	lw	ra,28(sp)
f90004f4:	01812403          	lw	s0,24(sp)
f90004f8:	01412483          	lw	s1,20(sp)
f90004fc:	01012903          	lw	s2,16(sp)
f9000500:	00c12983          	lw	s3,12(sp)
f9000504:	02010113          	addi	sp,sp,32
f9000508:	00008067          	ret

f900050c <Max32664Write>:


void Max32664Write(const uint8_t numOfWrites, uint8_t userArray[])
{
f900050c:	ff010113          	addi	sp,sp,-16
f9000510:	00112623          	sw	ra,12(sp)
f9000514:	00812423          	sw	s0,8(sp)
f9000518:	00912223          	sw	s1,4(sp)
f900051c:	01212023          	sw	s2,0(sp)
f9000520:	00050493          	mv	s1,a0
f9000524:	00058913          	mv	s2,a1
    i2c_masterStartBlocking(I2C_CTRL);
f9000528:	f800a537          	lui	a0,0xf800a
f900052c:	cf5ff0ef          	jal	ra,f9000220 <i2c_masterStartBlocking>
f9000530:	f800a737          	lui	a4,0xf800a
f9000534:	000017b7          	lui	a5,0x1
f9000538:	baa78793          	addi	a5,a5,-1110 # baa <CUSTOM1+0xb7f>
f900053c:	00f72023          	sw	a5,0(a4) # f800a000 <phase+0xfef89eb8>
    i2c_txByte(I2C_CTRL, 0xAA); i2c_txNackBlocking(I2C_CTRL);
f9000540:	f800a537          	lui	a0,0xf800a
f9000544:	d75ff0ef          	jal	ra,f90002b8 <i2c_txNackBlocking>

    for (int i=0; i<numOfWrites; i++)
f9000548:	00000413          	li	s0,0
f900054c:	02945863          	bge	s0,s1,f900057c <Max32664Write+0x70>
    {
        i2c_txByte(I2C_CTRL, userArray[i]);
f9000550:	008907b3          	add	a5,s2,s0
f9000554:	0007c783          	lbu	a5,0(a5)
f9000558:	00001737          	lui	a4,0x1
f900055c:	b0070713          	addi	a4,a4,-1280 # b00 <CUSTOM1+0xad5>
f9000560:	00e7e7b3          	or	a5,a5,a4
f9000564:	f800a737          	lui	a4,0xf800a
f9000568:	00f72023          	sw	a5,0(a4) # f800a000 <phase+0xfef89eb8>
    	i2c_txNackBlocking(I2C_CTRL);
f900056c:	f800a537          	lui	a0,0xf800a
f9000570:	d49ff0ef          	jal	ra,f90002b8 <i2c_txNackBlocking>
    for (int i=0; i<numOfWrites; i++)
f9000574:	00140413          	addi	s0,s0,1
f9000578:	fd5ff06f          	j	f900054c <Max32664Write+0x40>
    }
    i2c_masterStopBlocking(I2C_CTRL);
f900057c:	f800a537          	lui	a0,0xf800a
f9000580:	ce9ff0ef          	jal	ra,f9000268 <i2c_masterStopBlocking>

	return;
}
f9000584:	00c12083          	lw	ra,12(sp)
f9000588:	00812403          	lw	s0,8(sp)
f900058c:	00412483          	lw	s1,4(sp)
f9000590:	00012903          	lw	s2,0(sp)
f9000594:	01010113          	addi	sp,sp,16
f9000598:	00008067          	ret

f900059c <Max32664Read>:


uint8_t Max32664Read(const uint8_t numOfReads, uint8_t userArray[])
{
f900059c:	fe010113          	addi	sp,sp,-32
f90005a0:	00112e23          	sw	ra,28(sp)
f90005a4:	00812c23          	sw	s0,24(sp)
f90005a8:	00912a23          	sw	s1,20(sp)
f90005ac:	01212823          	sw	s2,16(sp)
f90005b0:	01312623          	sw	s3,12(sp)
f90005b4:	00050493          	mv	s1,a0
f90005b8:	00058913          	mv	s2,a1
f90005bc:	00000993          	li	s3,0
	uint8_t rd;
	uint8_t statusByte;

    i2c_masterStartBlocking(I2C_CTRL);
f90005c0:	f800a537          	lui	a0,0xf800a
f90005c4:	c5dff0ef          	jal	ra,f9000220 <i2c_masterStartBlocking>
f90005c8:	f800a737          	lui	a4,0xf800a
f90005cc:	000017b7          	lui	a5,0x1
f90005d0:	bab78793          	addi	a5,a5,-1109 # bab <CUSTOM1+0xb80>
f90005d4:	00f72023          	sw	a5,0(a4) # f800a000 <phase+0xfef89eb8>
    i2c_txByte(I2C_CTRL, 0xAB); i2c_txNackBlocking(I2C_CTRL);
f90005d8:	f800a537          	lui	a0,0xf800a
f90005dc:	cddff0ef          	jal	ra,f90002b8 <i2c_txNackBlocking>

    for (int i=0; i<numOfReads; i++)
f90005e0:	00000413          	li	s0,0
f90005e4:	01c0006f          	j	f9000600 <Max32664Read+0x64>
    {
        i2c_txByte(I2C_CTRL, 0xFF);

        if (i == numOfReads-1)
        {
        	i2c_txNackBlocking(I2C_CTRL);
f90005e8:	f800a537          	lui	a0,0xf800a
f90005ec:	ccdff0ef          	jal	ra,f90002b8 <i2c_txNackBlocking>
f90005f0:	0340006f          	j	f9000624 <Max32664Read+0x88>
        if (i==0)
        {
        	statusByte = rd;
        }

        userArray[i] = rd;
f90005f4:	008907b3          	add	a5,s2,s0
f90005f8:	00a78023          	sb	a0,0(a5)
    for (int i=0; i<numOfReads; i++)
f90005fc:	00140413          	addi	s0,s0,1
f9000600:	02945e63          	bge	s0,s1,f900063c <Max32664Read+0xa0>
f9000604:	f800a737          	lui	a4,0xf800a
f9000608:	000017b7          	lui	a5,0x1
f900060c:	bff78793          	addi	a5,a5,-1025 # bff <CUSTOM1+0xbd4>
f9000610:	00f72023          	sw	a5,0(a4) # f800a000 <phase+0xfef89eb8>
        if (i == numOfReads-1)
f9000614:	fff48793          	addi	a5,s1,-1
f9000618:	fc8788e3          	beq	a5,s0,f90005e8 <Max32664Read+0x4c>
        	i2c_txAckBlocking(I2C_CTRL);
f900061c:	f800a537          	lui	a0,0xf800a
f9000620:	c79ff0ef          	jal	ra,f9000298 <i2c_txAckBlocking>
        rd = i2c_rxData(I2C_CTRL);
f9000624:	f800a537          	lui	a0,0xf800a
f9000628:	cb1ff0ef          	jal	ra,f90002d8 <i2c_rxData>
f900062c:	0ff57513          	andi	a0,a0,255
        if (i==0)
f9000630:	fc0412e3          	bnez	s0,f90005f4 <Max32664Read+0x58>
        	statusByte = rd;
f9000634:	00050993          	mv	s3,a0
f9000638:	fbdff06f          	j	f90005f4 <Max32664Read+0x58>
    }
    i2c_masterStopBlocking(I2C_CTRL);
f900063c:	f800a537          	lui	a0,0xf800a
f9000640:	c29ff0ef          	jal	ra,f9000268 <i2c_masterStopBlocking>

	return statusByte;
}
f9000644:	00098513          	mv	a0,s3
f9000648:	01c12083          	lw	ra,28(sp)
f900064c:	01812403          	lw	s0,24(sp)
f9000650:	01412483          	lw	s1,20(sp)
f9000654:	01012903          	lw	s2,16(sp)
f9000658:	00c12983          	lw	s3,12(sp)
f900065c:	02010113          	addi	sp,sp,32
f9000660:	00008067          	ret

f9000664 <Max32664setRegister>:


uint32_t Max32664setRegister(uint32_t w1, uint32_t w2, uint32_t w3)
{
f9000664:	fd010113          	addi	sp,sp,-48
f9000668:	02112623          	sw	ra,44(sp)
f900066c:	02812423          	sw	s0,40(sp)
f9000670:	02912223          	sw	s1,36(sp)
f9000674:	03212023          	sw	s2,32(sp)
f9000678:	01312e23          	sw	s3,28(sp)
f900067c:	00050993          	mv	s3,a0
f9000680:	00058913          	mv	s2,a1
f9000684:	00060493          	mv	s1,a2
	uint32_t rd1;
	uint32_t rd2;
	uint8_t wds[3];
	uint8_t rds[1];

    bsp_putString("Max32664 WRITE : ");
f9000688:	f90805b7          	lui	a1,0xf9080
f900068c:	00058593          	mv	a1,a1
f9000690:	f8001537          	lui	a0,0xf8001
f9000694:	9f9ff0ef          	jal	ra,f900008c <uart_writeStr>
    uart_writeHex(BSP_UART_TERMINAL, 0xAA); bsp_putString(" ");
f9000698:	0aa00593          	li	a1,170
f900069c:	f8001537          	lui	a0,0xf8001
f90006a0:	a31ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f90006a4:	f9080437          	lui	s0,0xf9080
f90006a8:	01040593          	addi	a1,s0,16 # f9080010 <phase+0xfffffec8>
f90006ac:	f8001537          	lui	a0,0xf8001
f90006b0:	9ddff0ef          	jal	ra,f900008c <uart_writeStr>
    uart_writeHex(BSP_UART_TERMINAL, w1);   bsp_putString(" ");
f90006b4:	00098593          	mv	a1,s3
f90006b8:	f8001537          	lui	a0,0xf8001
f90006bc:	a15ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f90006c0:	01040593          	addi	a1,s0,16
f90006c4:	f8001537          	lui	a0,0xf8001
f90006c8:	9c5ff0ef          	jal	ra,f900008c <uart_writeStr>
    uart_writeHex(BSP_UART_TERMINAL, w2);   bsp_putString(" ");
f90006cc:	00090593          	mv	a1,s2
f90006d0:	f8001537          	lui	a0,0xf8001
f90006d4:	9fdff0ef          	jal	ra,f90000d0 <uart_writeHex>
f90006d8:	01040593          	addi	a1,s0,16
f90006dc:	f8001537          	lui	a0,0xf8001
f90006e0:	9adff0ef          	jal	ra,f900008c <uart_writeStr>
    uart_writeHex(BSP_UART_TERMINAL, w3);   bsp_putString(" ");
f90006e4:	00048593          	mv	a1,s1
f90006e8:	f8001537          	lui	a0,0xf8001
f90006ec:	9e5ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f90006f0:	01040593          	addi	a1,s0,16
f90006f4:	f8001537          	lui	a0,0xf8001
f90006f8:	995ff0ef          	jal	ra,f900008c <uart_writeStr>

    wds[0] = w1;
f90006fc:	01310623          	sb	s3,12(sp)
    wds[1] = w2;
f9000700:	012106a3          	sb	s2,13(sp)
    wds[2] = w3;
f9000704:	00910723          	sb	s1,14(sp)
    //Max32664Write(w1,w2,w3);
    Max32664Write(sizeof(wds), wds);
f9000708:	00c10593          	addi	a1,sp,12
f900070c:	00300513          	li	a0,3
f9000710:	dfdff0ef          	jal	ra,f900050c <Max32664Write>
    bsp_uDelay(CMD_DELAY);
f9000714:	f8b00637          	lui	a2,0xf8b00
f9000718:	017d84b7          	lui	s1,0x17d8
f900071c:	84048593          	addi	a1,s1,-1984 # 17d7840 <CUSTOM1+0x17d7815>
f9000720:	0000a537          	lui	a0,0xa
f9000724:	c4050513          	addi	a0,a0,-960 # 9c40 <CUSTOM1+0x9c15>
f9000728:	a15ff0ef          	jal	ra,f900013c <clint_uDelay>
    Max32664Read(sizeof(rds), rds);
f900072c:	00810593          	addi	a1,sp,8
f9000730:	00100513          	li	a0,1
f9000734:	e69ff0ef          	jal	ra,f900059c <Max32664Read>

    rd2 = rds[0];
f9000738:	00814403          	lbu	s0,8(sp)
    bsp_putString(" -> RES : ");
f900073c:	f90805b7          	lui	a1,0xf9080
f9000740:	01458593          	addi	a1,a1,20 # f9080014 <phase+0xfffffecc>
f9000744:	f8001537          	lui	a0,0xf8001
f9000748:	945ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rd2 & 0xFF); bsp_putString("\r\n")
f900074c:	00040593          	mv	a1,s0
f9000750:	f8001537          	lui	a0,0xf8001
f9000754:	97dff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000758:	f90805b7          	lui	a1,0xf9080
f900075c:	03c58593          	addi	a1,a1,60 # f908003c <phase+0xfffffef4>
f9000760:	f8001537          	lui	a0,0xf8001
f9000764:	929ff0ef          	jal	ra,f900008c <uart_writeStr>

    bsp_uDelay(100);
f9000768:	f8b00637          	lui	a2,0xf8b00
f900076c:	84048593          	addi	a1,s1,-1984
f9000770:	06400513          	li	a0,100
f9000774:	9c9ff0ef          	jal	ra,f900013c <clint_uDelay>

	return rd2;

}
f9000778:	00040513          	mv	a0,s0
f900077c:	02c12083          	lw	ra,44(sp)
f9000780:	02812403          	lw	s0,40(sp)
f9000784:	02412483          	lw	s1,36(sp)
f9000788:	02012903          	lw	s2,32(sp)
f900078c:	01c12983          	lw	s3,28(sp)
f9000790:	03010113          	addi	sp,sp,48
f9000794:	00008067          	ret

f9000798 <Max32664getRegister>:

uint32_t Max32664getRegister(uint32_t w1, uint32_t w2)
{
f9000798:	fe010113          	addi	sp,sp,-32
f900079c:	00112e23          	sw	ra,28(sp)
f90007a0:	00812c23          	sw	s0,24(sp)
	uint8_t wds[2];
	uint8_t rds[2];

    wds[0] = w1;
f90007a4:	00a10623          	sb	a0,12(sp)
    wds[1] = w2;
f90007a8:	00b106a3          	sb	a1,13(sp)
    Max32664Write(sizeof(wds), wds);
f90007ac:	00c10593          	addi	a1,sp,12
f90007b0:	00200513          	li	a0,2
f90007b4:	d59ff0ef          	jal	ra,f900050c <Max32664Write>

    bsp_uDelay(2000);
f90007b8:	f8b00637          	lui	a2,0xf8b00
f90007bc:	017d8437          	lui	s0,0x17d8
f90007c0:	84040593          	addi	a1,s0,-1984 # 17d7840 <CUSTOM1+0x17d7815>
f90007c4:	7d000513          	li	a0,2000
f90007c8:	975ff0ef          	jal	ra,f900013c <clint_uDelay>

    Max32664Read(sizeof(rds), rds);
f90007cc:	00810593          	addi	a1,sp,8
f90007d0:	00200513          	li	a0,2
f90007d4:	dc9ff0ef          	jal	ra,f900059c <Max32664Read>

	uart_writeHex(BSP_UART_TERMINAL, rds[0] & 0xFF); bsp_putString(" ");
f90007d8:	00814583          	lbu	a1,8(sp)
f90007dc:	f8001537          	lui	a0,0xf8001
f90007e0:	8f1ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f90007e4:	f90805b7          	lui	a1,0xf9080
f90007e8:	01058593          	addi	a1,a1,16 # f9080010 <phase+0xfffffec8>
f90007ec:	f8001537          	lui	a0,0xf8001
f90007f0:	89dff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[1] & 0xFF); bsp_putString("\r\n")
f90007f4:	00914583          	lbu	a1,9(sp)
f90007f8:	f8001537          	lui	a0,0xf8001
f90007fc:	8d5ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000800:	f90805b7          	lui	a1,0xf9080
f9000804:	03c58593          	addi	a1,a1,60 # f908003c <phase+0xfffffef4>
f9000808:	f8001537          	lui	a0,0xf8001
f900080c:	881ff0ef          	jal	ra,f900008c <uart_writeStr>

    bsp_uDelay(100);
f9000810:	f8b00637          	lui	a2,0xf8b00
f9000814:	84040593          	addi	a1,s0,-1984
f9000818:	06400513          	li	a0,100
f900081c:	921ff0ef          	jal	ra,f900013c <clint_uDelay>

	return rds[1];

}
f9000820:	00914503          	lbu	a0,9(sp)
f9000824:	01c12083          	lw	ra,28(sp)
f9000828:	01812403          	lw	s0,24(sp)
f900082c:	02010113          	addi	sp,sp,32
f9000830:	00008067          	ret

f9000834 <Max32664reset>:
        return *((volatile u32*) address);
f9000834:	f800d737          	lui	a4,0xf800d
f9000838:	00472783          	lw	a5,4(a4) # f800d004 <phase+0xfef8cebc>


void Max32664reset(uint16_t val)
{
	uint16_t set_val;
	set_val = (gpio_getOutput(GPIO0) & 0xE) | (val & 0x1);
f900083c:	00e7f793          	andi	a5,a5,14
f9000840:	00157513          	andi	a0,a0,1
f9000844:	00a7e7b3          	or	a5,a5,a0
        *((volatile u32*) address) = data;
f9000848:	00f72223          	sw	a5,4(a4)
    gpio_setOutput(GPIO0, set_val);
    return;
}
f900084c:	00008067          	ret

f9000850 <Max32664mfio>:
        return *((volatile u32*) address);
f9000850:	f800d737          	lui	a4,0xf800d
f9000854:	00472783          	lw	a5,4(a4) # f800d004 <phase+0xfef8cebc>

void Max32664mfio(uint16_t val)
{
	uint16_t set_val;
	set_val = (gpio_getOutput(GPIO0) & 0xD) |  ((val & 0x1) << 1);
f9000858:	00d7f793          	andi	a5,a5,13
f900085c:	00151513          	slli	a0,a0,0x1
f9000860:	00257513          	andi	a0,a0,2
f9000864:	00a7e7b3          	or	a5,a5,a0
        *((volatile u32*) address) = data;
f9000868:	00f72223          	sw	a5,4(a4)

    gpio_setOutput(GPIO0, set_val);
    return;
}
f900086c:	00008067          	ret

f9000870 <Max32664StatusCheck>:

void Max32664StatusCheck(uint32_t status, char *str)
{
	if (status != SUCCESS)
f9000870:	00051463          	bnez	a0,f9000878 <Max32664StatusCheck+0x8>
f9000874:	00008067          	ret
{
f9000878:	ff010113          	addi	sp,sp,-16
f900087c:	00112623          	sw	ra,12(sp)
f9000880:	00812423          	sw	s0,8(sp)
f9000884:	00050413          	mv	s0,a0
	{

		bsp_putString(str);
f9000888:	f8001537          	lui	a0,0xf8001
f900088c:	801ff0ef          	jal	ra,f900008c <uart_writeStr>
		bsp_putString(" Failed : ");
f9000890:	f90805b7          	lui	a1,0xf9080
f9000894:	02058593          	addi	a1,a1,32 # f9080020 <phase+0xfffffed8>
f9000898:	f8001537          	lui	a0,0xf8001
f900089c:	ff0ff0ef          	jal	ra,f900008c <uart_writeStr>
		uart_writeHex(BSP_UART_TERMINAL, status);
f90008a0:	00040593          	mv	a1,s0
f90008a4:	f8001537          	lui	a0,0xf8001
f90008a8:	829ff0ef          	jal	ra,f90000d0 <uart_writeHex>
		bsp_putString("\r\n");
f90008ac:	f90805b7          	lui	a1,0xf9080
f90008b0:	03c58593          	addi	a1,a1,60 # f908003c <phase+0xfffffef4>
f90008b4:	f8001537          	lui	a0,0xf8001
f90008b8:	fd4ff0ef          	jal	ra,f900008c <uart_writeStr>
	}
}
f90008bc:	00c12083          	lw	ra,12(sp)
f90008c0:	00812403          	lw	s0,8(sp)
f90008c4:	01010113          	addi	sp,sp,16
f90008c8:	00008067          	ret

f90008cc <Max32664GetHubStatus>:

uint8_t Max32664GetHubStatus()
{
f90008cc:	fe010113          	addi	sp,sp,-32
f90008d0:	00112e23          	sw	ra,28(sp)
	uint8_t wds[2];
	uint8_t rds[2];

	wds[0] = 0x00;
f90008d4:	00010623          	sb	zero,12(sp)
	wds[1] = 0x00;
f90008d8:	000106a3          	sb	zero,13(sp)
	Max32664Write(sizeof(wds), wds);
f90008dc:	00c10593          	addi	a1,sp,12
f90008e0:	00200513          	li	a0,2
f90008e4:	c29ff0ef          	jal	ra,f900050c <Max32664Write>

	bsp_uDelay(CMD_DELAY);
f90008e8:	f8b00637          	lui	a2,0xf8b00
f90008ec:	017d85b7          	lui	a1,0x17d8
f90008f0:	84058593          	addi	a1,a1,-1984 # 17d7840 <CUSTOM1+0x17d7815>
f90008f4:	0000a537          	lui	a0,0xa
f90008f8:	c4050513          	addi	a0,a0,-960 # 9c40 <CUSTOM1+0x9c15>
f90008fc:	841ff0ef          	jal	ra,f900013c <clint_uDelay>

	Max32664Read(sizeof(rds), rds);
f9000900:	00810593          	addi	a1,sp,8
f9000904:	00200513          	li	a0,2
f9000908:	c95ff0ef          	jal	ra,f900059c <Max32664Read>

	return rds[1];
}
f900090c:	00914503          	lbu	a0,9(sp)
f9000910:	01c12083          	lw	ra,28(sp)
f9000914:	02010113          	addi	sp,sp,32
f9000918:	00008067          	ret

f900091c <Max32664GetNumberOfSamples>:

uint8_t Max32664GetNumberOfSamples()
{
f900091c:	fe010113          	addi	sp,sp,-32
f9000920:	00112e23          	sw	ra,28(sp)
	uint8_t wds[2];
	uint8_t rds[2];

	wds[0] = 0x12;
f9000924:	01200793          	li	a5,18
f9000928:	00f10623          	sb	a5,12(sp)
	wds[1] = 0x00;
f900092c:	000106a3          	sb	zero,13(sp)
	Max32664Write(sizeof(wds), wds);
f9000930:	00c10593          	addi	a1,sp,12
f9000934:	00200513          	li	a0,2
f9000938:	bd5ff0ef          	jal	ra,f900050c <Max32664Write>

	bsp_uDelay(CMD_DELAY);
f900093c:	f8b00637          	lui	a2,0xf8b00
f9000940:	017d85b7          	lui	a1,0x17d8
f9000944:	84058593          	addi	a1,a1,-1984 # 17d7840 <CUSTOM1+0x17d7815>
f9000948:	0000a537          	lui	a0,0xa
f900094c:	c4050513          	addi	a0,a0,-960 # 9c40 <CUSTOM1+0x9c15>
f9000950:	fecff0ef          	jal	ra,f900013c <clint_uDelay>

	Max32664Read(sizeof(rds), rds);
f9000954:	00810593          	addi	a1,sp,8
f9000958:	00200513          	li	a0,2
f900095c:	c41ff0ef          	jal	ra,f900059c <Max32664Read>
	//bsp_putString("Number of Samples : ");
	//uart_writeHex(BSP_UART_TERMINAL, rds[1]);
	//bsp_putString("\r\n");

	return rds[1];
}
f9000960:	00914503          	lbu	a0,9(sp)
f9000964:	01c12083          	lw	ra,28(sp)
f9000968:	02010113          	addi	sp,sp,32
f900096c:	00008067          	ret

f9000970 <Max32664GetSampleSize>:


uint8_t Max32664GetSampleSize()
{
f9000970:	fe010113          	addi	sp,sp,-32
f9000974:	00112e23          	sw	ra,28(sp)
	uint8_t wds[3];
	uint8_t rds[2];

	wds[0] = 0x13;
f9000978:	01300793          	li	a5,19
f900097c:	00f10623          	sb	a5,12(sp)
	wds[1] = 0x00;
f9000980:	000106a3          	sb	zero,13(sp)
	wds[2] = 0x04;
f9000984:	00400793          	li	a5,4
f9000988:	00f10723          	sb	a5,14(sp)
	Max32664Write(sizeof(wds), wds);
f900098c:	00c10593          	addi	a1,sp,12
f9000990:	00300513          	li	a0,3
f9000994:	b79ff0ef          	jal	ra,f900050c <Max32664Write>

	bsp_uDelay(CMD_DELAY);
f9000998:	f8b00637          	lui	a2,0xf8b00
f900099c:	017d85b7          	lui	a1,0x17d8
f90009a0:	84058593          	addi	a1,a1,-1984 # 17d7840 <CUSTOM1+0x17d7815>
f90009a4:	0000a537          	lui	a0,0xa
f90009a8:	c4050513          	addi	a0,a0,-960 # 9c40 <CUSTOM1+0x9c15>
f90009ac:	f90ff0ef          	jal	ra,f900013c <clint_uDelay>

	Max32664Read(sizeof(rds), rds);
f90009b0:	00810593          	addi	a1,sp,8
f90009b4:	00200513          	li	a0,2
f90009b8:	be5ff0ef          	jal	ra,f900059c <Max32664Read>
	//bsp_putString("Number of Samples : ");
	//uart_writeHex(BSP_UART_TERMINAL, rds[1]);
	//bsp_putString("\r\n");

	return rds[1];
}
f90009bc:	00914503          	lbu	a0,9(sp)
f90009c0:	01c12083          	lw	ra,28(sp)
f90009c4:	02010113          	addi	sp,sp,32
f90009c8:	00008067          	ret

f90009cc <Max32664SetSpo2Coeff>:


uint8_t Max32664SetSpo2Coeff()
{
f90009cc:	fe010113          	addi	sp,sp,-32
f90009d0:	00112e23          	sw	ra,28(sp)
	uint8_t wds[7];
	uint8_t rds[2];

	wds[0] = 0x50;
f90009d4:	05000793          	li	a5,80
f90009d8:	00f10423          	sb	a5,8(sp)
	wds[1] = 0x02;
f90009dc:	00200793          	li	a5,2
f90009e0:	00f104a3          	sb	a5,9(sp)
	wds[2] = 0x0B;
f90009e4:	00b00713          	li	a4,11
f90009e8:	00e10523          	sb	a4,10(sp)
	wds[3] = 0x00;
f90009ec:	000105a3          	sb	zero,11(sp)
	wds[4] = 0x02;
f90009f0:	00f10623          	sb	a5,12(sp)
	wds[5] = 0x6F;
f90009f4:	06f00793          	li	a5,111
f90009f8:	00f106a3          	sb	a5,13(sp)
	wds[6] = 0x60;
f90009fc:	06000793          	li	a5,96
f9000a00:	00f10723          	sb	a5,14(sp)
	Max32664Write(sizeof(wds), wds);
f9000a04:	00810593          	addi	a1,sp,8
f9000a08:	00700513          	li	a0,7
f9000a0c:	b01ff0ef          	jal	ra,f900050c <Max32664Write>

	bsp_uDelay(CMD_DELAY);
f9000a10:	f8b00637          	lui	a2,0xf8b00
f9000a14:	017d85b7          	lui	a1,0x17d8
f9000a18:	84058593          	addi	a1,a1,-1984 # 17d7840 <CUSTOM1+0x17d7815>
f9000a1c:	0000a537          	lui	a0,0xa
f9000a20:	c4050513          	addi	a0,a0,-960 # 9c40 <CUSTOM1+0x9c15>
f9000a24:	f18ff0ef          	jal	ra,f900013c <clint_uDelay>

	Max32664Read(sizeof(rds), rds);
f9000a28:	00410593          	addi	a1,sp,4
f9000a2c:	00200513          	li	a0,2
f9000a30:	b6dff0ef          	jal	ra,f900059c <Max32664Read>

	return rds[0];
}
f9000a34:	00414503          	lbu	a0,4(sp)
f9000a38:	01c12083          	lw	ra,28(sp)
f9000a3c:	02010113          	addi	sp,sp,32
f9000a40:	00008067          	ret

f9000a44 <Max32664GetFifoData>:

uint8_t Max32664GetFifoData()
{
f9000a44:	fc010113          	addi	sp,sp,-64
f9000a48:	02112e23          	sw	ra,60(sp)
f9000a4c:	02812c23          	sw	s0,56(sp)
f9000a50:	02912a23          	sw	s1,52(sp)
f9000a54:	03212823          	sw	s2,48(sp)
f9000a58:	03312623          	sw	s3,44(sp)
f9000a5c:	03412423          	sw	s4,40(sp)
	uint8_t bpm;
	uint8_t wds[2];
	uint8_t rds[28];
	//uint8_t rds[10];

	wds[0] = 0x12;
f9000a60:	01200793          	li	a5,18
f9000a64:	00f10e23          	sb	a5,28(sp)
	wds[1] = 0x01;
f9000a68:	00100793          	li	a5,1
f9000a6c:	00f10ea3          	sb	a5,29(sp)
	Max32664Write(sizeof(wds), wds);
f9000a70:	01c10593          	addi	a1,sp,28
f9000a74:	00200513          	li	a0,2
f9000a78:	a95ff0ef          	jal	ra,f900050c <Max32664Write>

	bsp_uDelay(CMD_DELAY);
f9000a7c:	f8b00637          	lui	a2,0xf8b00
f9000a80:	017d85b7          	lui	a1,0x17d8
f9000a84:	84058593          	addi	a1,a1,-1984 # 17d7840 <CUSTOM1+0x17d7815>
f9000a88:	0000a537          	lui	a0,0xa
f9000a8c:	c4050513          	addi	a0,a0,-960 # 9c40 <CUSTOM1+0x9c15>
f9000a90:	eacff0ef          	jal	ra,f900013c <clint_uDelay>

	Max32664Read(sizeof(rds), rds);
f9000a94:	00010593          	mv	a1,sp
f9000a98:	01c00513          	li	a0,28
f9000a9c:	b01ff0ef          	jal	ra,f900059c <Max32664Read>

	bsp_putString("--- MAX30101 ---\r\n");
f9000aa0:	f90805b7          	lui	a1,0xf9080
f9000aa4:	02c58593          	addi	a1,a1,44 # f908002c <phase+0xfffffee4>
f9000aa8:	f8001537          	lui	a0,0xf8001
f9000aac:	de0ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[1]); bsp_putString(" ");
f9000ab0:	00114583          	lbu	a1,1(sp)
f9000ab4:	f8001537          	lui	a0,0xf8001
f9000ab8:	e18ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000abc:	f9080437          	lui	s0,0xf9080
f9000ac0:	01040593          	addi	a1,s0,16 # f9080010 <phase+0xfffffec8>
f9000ac4:	f8001537          	lui	a0,0xf8001
f9000ac8:	dc4ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[2]); bsp_putString(" ");
f9000acc:	00214583          	lbu	a1,2(sp)
f9000ad0:	f8001537          	lui	a0,0xf8001
f9000ad4:	dfcff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000ad8:	01040593          	addi	a1,s0,16
f9000adc:	f8001537          	lui	a0,0xf8001
f9000ae0:	dacff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[3]); bsp_putString(" ");
f9000ae4:	00314583          	lbu	a1,3(sp)
f9000ae8:	f8001537          	lui	a0,0xf8001
f9000aec:	de4ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000af0:	01040593          	addi	a1,s0,16
f9000af4:	f8001537          	lui	a0,0xf8001
f9000af8:	d94ff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000afc:	f90804b7          	lui	s1,0xf9080
f9000b00:	03c48593          	addi	a1,s1,60 # f908003c <phase+0xfffffef4>
f9000b04:	f8001537          	lui	a0,0xf8001
f9000b08:	d84ff0ef          	jal	ra,f900008c <uart_writeStr>

	uart_writeHex(BSP_UART_TERMINAL, rds[4]); bsp_putString(" ");
f9000b0c:	00414583          	lbu	a1,4(sp)
f9000b10:	f8001537          	lui	a0,0xf8001
f9000b14:	dbcff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000b18:	01040593          	addi	a1,s0,16
f9000b1c:	f8001537          	lui	a0,0xf8001
f9000b20:	d6cff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[5]); bsp_putString(" ");
f9000b24:	00514583          	lbu	a1,5(sp)
f9000b28:	f8001537          	lui	a0,0xf8001
f9000b2c:	da4ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000b30:	01040593          	addi	a1,s0,16
f9000b34:	f8001537          	lui	a0,0xf8001
f9000b38:	d54ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[6]); bsp_putString(" ");
f9000b3c:	00614583          	lbu	a1,6(sp)
f9000b40:	f8001537          	lui	a0,0xf8001
f9000b44:	d8cff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000b48:	01040593          	addi	a1,s0,16
f9000b4c:	f8001537          	lui	a0,0xf8001
f9000b50:	d3cff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000b54:	03c48593          	addi	a1,s1,60
f9000b58:	f8001537          	lui	a0,0xf8001
f9000b5c:	d30ff0ef          	jal	ra,f900008c <uart_writeStr>

	uart_writeHex(BSP_UART_TERMINAL, rds[7]); bsp_putString(" ");
f9000b60:	00714583          	lbu	a1,7(sp)
f9000b64:	f8001537          	lui	a0,0xf8001
f9000b68:	d68ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000b6c:	01040593          	addi	a1,s0,16
f9000b70:	f8001537          	lui	a0,0xf8001
f9000b74:	d18ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[8]); bsp_putString(" ");
f9000b78:	00814583          	lbu	a1,8(sp)
f9000b7c:	f8001537          	lui	a0,0xf8001
f9000b80:	d50ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000b84:	01040593          	addi	a1,s0,16
f9000b88:	f8001537          	lui	a0,0xf8001
f9000b8c:	d00ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[9]); bsp_putString(" ");
f9000b90:	00914583          	lbu	a1,9(sp)
f9000b94:	f8001537          	lui	a0,0xf8001
f9000b98:	d38ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000b9c:	01040593          	addi	a1,s0,16
f9000ba0:	f8001537          	lui	a0,0xf8001
f9000ba4:	ce8ff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000ba8:	03c48593          	addi	a1,s1,60
f9000bac:	f8001537          	lui	a0,0xf8001
f9000bb0:	cdcff0ef          	jal	ra,f900008c <uart_writeStr>

	uart_writeHex(BSP_UART_TERMINAL, rds[10]); bsp_putString(" ");
f9000bb4:	00a14583          	lbu	a1,10(sp)
f9000bb8:	f8001537          	lui	a0,0xf8001
f9000bbc:	d14ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000bc0:	01040593          	addi	a1,s0,16
f9000bc4:	f8001537          	lui	a0,0xf8001
f9000bc8:	cc4ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[11]); bsp_putString(" ");
f9000bcc:	00b14583          	lbu	a1,11(sp)
f9000bd0:	f8001537          	lui	a0,0xf8001
f9000bd4:	cfcff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000bd8:	01040593          	addi	a1,s0,16
f9000bdc:	f8001537          	lui	a0,0xf8001
f9000be0:	cacff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[12]); bsp_putString(" ");
f9000be4:	00c14583          	lbu	a1,12(sp)
f9000be8:	f8001537          	lui	a0,0xf8001
f9000bec:	ce4ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000bf0:	01040593          	addi	a1,s0,16
f9000bf4:	f8001537          	lui	a0,0xf8001
f9000bf8:	c94ff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000bfc:	03c48593          	addi	a1,s1,60
f9000c00:	f8001537          	lui	a0,0xf8001
f9000c04:	c88ff0ef          	jal	ra,f900008c <uart_writeStr>

	bsp_putString("---HR/SpO2 ---\r\n");
f9000c08:	f90805b7          	lui	a1,0xf9080
f9000c0c:	04058593          	addi	a1,a1,64 # f9080040 <phase+0xfffffef8>
f9000c10:	f8001537          	lui	a0,0xf8001
f9000c14:	c78ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[13]); bsp_putString(" ");
f9000c18:	00d14583          	lbu	a1,13(sp)
f9000c1c:	f8001537          	lui	a0,0xf8001
f9000c20:	cb0ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000c24:	01040593          	addi	a1,s0,16
f9000c28:	f8001537          	lui	a0,0xf8001
f9000c2c:	c60ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[14]); bsp_putString(" ");
f9000c30:	00e14583          	lbu	a1,14(sp)
f9000c34:	f8001537          	lui	a0,0xf8001
f9000c38:	c98ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000c3c:	01040593          	addi	a1,s0,16
f9000c40:	f8001537          	lui	a0,0xf8001
f9000c44:	c48ff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000c48:	03c48593          	addi	a1,s1,60
f9000c4c:	f8001537          	lui	a0,0xf8001
f9000c50:	c3cff0ef          	jal	ra,f900008c <uart_writeStr>

	uart_writeHex(BSP_UART_TERMINAL, rds[15]); bsp_putString(" ");
f9000c54:	00f14583          	lbu	a1,15(sp)
f9000c58:	f8001537          	lui	a0,0xf8001
f9000c5c:	c74ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000c60:	01040593          	addi	a1,s0,16
f9000c64:	f8001537          	lui	a0,0xf8001
f9000c68:	c24ff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000c6c:	03c48593          	addi	a1,s1,60
f9000c70:	f8001537          	lui	a0,0xf8001
f9000c74:	c18ff0ef          	jal	ra,f900008c <uart_writeStr>

	uart_writeHex(BSP_UART_TERMINAL, rds[16]); bsp_putString(" ");
f9000c78:	01014583          	lbu	a1,16(sp)
f9000c7c:	f8001537          	lui	a0,0xf8001
f9000c80:	c50ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000c84:	01040593          	addi	a1,s0,16
f9000c88:	f8001537          	lui	a0,0xf8001
f9000c8c:	c00ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[17]); bsp_putString(" ");
f9000c90:	01114583          	lbu	a1,17(sp)
f9000c94:	f8001537          	lui	a0,0xf8001
f9000c98:	c38ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000c9c:	01040593          	addi	a1,s0,16
f9000ca0:	f8001537          	lui	a0,0xf8001
f9000ca4:	be8ff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000ca8:	03c48593          	addi	a1,s1,60
f9000cac:	f8001537          	lui	a0,0xf8001
f9000cb0:	bdcff0ef          	jal	ra,f900008c <uart_writeStr>

	uart_writeHex(BSP_UART_TERMINAL, rds[18]); bsp_putString(" ");
f9000cb4:	01214583          	lbu	a1,18(sp)
f9000cb8:	f8001537          	lui	a0,0xf8001
f9000cbc:	c14ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000cc0:	01040593          	addi	a1,s0,16
f9000cc4:	f8001537          	lui	a0,0xf8001
f9000cc8:	bc4ff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000ccc:	03c48593          	addi	a1,s1,60
f9000cd0:	f8001537          	lui	a0,0xf8001
f9000cd4:	bb8ff0ef          	jal	ra,f900008c <uart_writeStr>

	uart_writeHex(BSP_UART_TERMINAL, rds[19]); bsp_putString(" ");
f9000cd8:	01314583          	lbu	a1,19(sp)
f9000cdc:	f8001537          	lui	a0,0xf8001
f9000ce0:	bf0ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000ce4:	01040593          	addi	a1,s0,16
f9000ce8:	f8001537          	lui	a0,0xf8001
f9000cec:	ba0ff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000cf0:	03c48593          	addi	a1,s1,60
f9000cf4:	f8001537          	lui	a0,0xf8001
f9000cf8:	b94ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[20]); bsp_putString(" ");
f9000cfc:	01414583          	lbu	a1,20(sp)
f9000d00:	f8001537          	lui	a0,0xf8001
f9000d04:	bccff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000d08:	01040593          	addi	a1,s0,16
f9000d0c:	f8001537          	lui	a0,0xf8001
f9000d10:	b7cff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000d14:	03c48593          	addi	a1,s1,60
f9000d18:	f8001537          	lui	a0,0xf8001
f9000d1c:	b70ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[21]); bsp_putString(" ");
f9000d20:	01514583          	lbu	a1,21(sp)
f9000d24:	f8001537          	lui	a0,0xf8001
f9000d28:	ba8ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000d2c:	01040593          	addi	a1,s0,16
f9000d30:	f8001537          	lui	a0,0xf8001
f9000d34:	b58ff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000d38:	03c48593          	addi	a1,s1,60
f9000d3c:	f8001537          	lui	a0,0xf8001
f9000d40:	b4cff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[22]); bsp_putString(" ");
f9000d44:	01614583          	lbu	a1,22(sp)
f9000d48:	f8001537          	lui	a0,0xf8001
f9000d4c:	b84ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000d50:	01040593          	addi	a1,s0,16
f9000d54:	f8001537          	lui	a0,0xf8001
f9000d58:	b34ff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000d5c:	03c48593          	addi	a1,s1,60
f9000d60:	f8001537          	lui	a0,0xf8001
f9000d64:	b28ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[23]); bsp_putString(" ");
f9000d68:	01714583          	lbu	a1,23(sp)
f9000d6c:	f8001537          	lui	a0,0xf8001
f9000d70:	b60ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000d74:	01040593          	addi	a1,s0,16
f9000d78:	f8001537          	lui	a0,0xf8001
f9000d7c:	b10ff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000d80:	03c48593          	addi	a1,s1,60
f9000d84:	f8001537          	lui	a0,0xf8001
f9000d88:	b04ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[24]); bsp_putString(" ");
f9000d8c:	01814583          	lbu	a1,24(sp)
f9000d90:	f8001537          	lui	a0,0xf8001
f9000d94:	b3cff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000d98:	01040593          	addi	a1,s0,16
f9000d9c:	f8001537          	lui	a0,0xf8001
f9000da0:	aecff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000da4:	03c48593          	addi	a1,s1,60
f9000da8:	f8001537          	lui	a0,0xf8001
f9000dac:	ae0ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[25]); bsp_putString(" ");
f9000db0:	01914583          	lbu	a1,25(sp)
f9000db4:	f8001537          	lui	a0,0xf8001
f9000db8:	b18ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000dbc:	01040593          	addi	a1,s0,16
f9000dc0:	f8001537          	lui	a0,0xf8001
f9000dc4:	ac8ff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000dc8:	03c48593          	addi	a1,s1,60
f9000dcc:	f8001537          	lui	a0,0xf8001
f9000dd0:	abcff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[26]); bsp_putString(" ");
f9000dd4:	01a14583          	lbu	a1,26(sp)
f9000dd8:	f8001537          	lui	a0,0xf8001
f9000ddc:	af4ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000de0:	01040593          	addi	a1,s0,16
f9000de4:	f8001537          	lui	a0,0xf8001
f9000de8:	aa4ff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000dec:	03c48593          	addi	a1,s1,60
f9000df0:	f8001537          	lui	a0,0xf8001
f9000df4:	a98ff0ef          	jal	ra,f900008c <uart_writeStr>
	uart_writeHex(BSP_UART_TERMINAL, rds[27]); bsp_putString(" ");
f9000df8:	01b14583          	lbu	a1,27(sp)
f9000dfc:	f8001537          	lui	a0,0xf8001
f9000e00:	ad0ff0ef          	jal	ra,f90000d0 <uart_writeHex>
f9000e04:	01040593          	addi	a1,s0,16
f9000e08:	f8001537          	lui	a0,0xf8001
f9000e0c:	a80ff0ef          	jal	ra,f900008c <uart_writeStr>
	bsp_putString("\r\n");
f9000e10:	03c48593          	addi	a1,s1,60
f9000e14:	f8001537          	lui	a0,0xf8001
f9000e18:	a74ff0ef          	jal	ra,f900008c <uart_writeStr>



	uint16_t heart = (rds[13]<<8) + rds[14];
f9000e1c:	00d14403          	lbu	s0,13(sp)
f9000e20:	00841413          	slli	s0,s0,0x8
f9000e24:	00e14783          	lbu	a5,14(sp)
f9000e28:	00f40433          	add	s0,s0,a5
f9000e2c:	01041413          	slli	s0,s0,0x10
f9000e30:	01045413          	srli	s0,s0,0x10
	uint16_t spo2  = (rds[16]<<8) + rds[17];
f9000e34:	01014783          	lbu	a5,16(sp)
f9000e38:	00879793          	slli	a5,a5,0x8
f9000e3c:	01114703          	lbu	a4,17(sp)
f9000e40:	00e787b3          	add	a5,a5,a4
f9000e44:	01079793          	slli	a5,a5,0x10
f9000e48:	0107d793          	srli	a5,a5,0x10

	uint32_t heart_reg = (((heart/1000)%10) << 8) + ( ((heart/100) %10) << 4) + ( (heart/10) %10 );
f9000e4c:	3e800713          	li	a4,1000
f9000e50:	02e45a33          	divu	s4,s0,a4
f9000e54:	00a00693          	li	a3,10
f9000e58:	02da7a33          	remu	s4,s4,a3
f9000e5c:	008a1913          	slli	s2,s4,0x8
f9000e60:	06400613          	li	a2,100
f9000e64:	02c459b3          	divu	s3,s0,a2
f9000e68:	02d9f9b3          	remu	s3,s3,a3
f9000e6c:	00499593          	slli	a1,s3,0x4
f9000e70:	00b90933          	add	s2,s2,a1
f9000e74:	02d45433          	divu	s0,s0,a3
f9000e78:	02d47433          	remu	s0,s0,a3
f9000e7c:	00890933          	add	s2,s2,s0
	uint32_t spo2_reg  = (((spo2/1000)%10)  << 8) + ( ((spo2/100) %10)  << 4) + ( (spo2/10)  %10 );
f9000e80:	02e7d4b3          	divu	s1,a5,a4
f9000e84:	02d4f4b3          	remu	s1,s1,a3
f9000e88:	00849493          	slli	s1,s1,0x8
f9000e8c:	02c7d633          	divu	a2,a5,a2
f9000e90:	02d67633          	remu	a2,a2,a3
f9000e94:	00461613          	slli	a2,a2,0x4
f9000e98:	00c484b3          	add	s1,s1,a2
f9000e9c:	02d7d7b3          	divu	a5,a5,a3
f9000ea0:	02d7f7b3          	remu	a5,a5,a3
f9000ea4:	00f484b3          	add	s1,s1,a5

	bsp_putString("Heart Rate: ");
f9000ea8:	f90805b7          	lui	a1,0xf9080
f9000eac:	05458593          	addi	a1,a1,84 # f9080054 <phase+0xffffff0c>
f9000eb0:	f8001537          	lui	a0,0xf8001
f9000eb4:	9d8ff0ef          	jal	ra,f900008c <uart_writeStr>

	bsp_printHexDigit( (heart/1000)%10 );
f9000eb8:	000a0513          	mv	a0,s4
f9000ebc:	aecff0ef          	jal	ra,f90001a8 <bsp_printHexDigit>
	bsp_printHexDigit( (heart/100) %10 );
f9000ec0:	00098513          	mv	a0,s3
f9000ec4:	ae4ff0ef          	jal	ra,f90001a8 <bsp_printHexDigit>
	bsp_printHexDigit( (heart/10)  %10 );
f9000ec8:	00040513          	mv	a0,s0
f9000ecc:	adcff0ef          	jal	ra,f90001a8 <bsp_printHexDigit>
	bsp_putString(" [bpm]\r\n");
f9000ed0:	f90805b7          	lui	a1,0xf9080
f9000ed4:	06458593          	addi	a1,a1,100 # f9080064 <phase+0xffffff1c>
f9000ed8:	f8001537          	lui	a0,0xf8001
f9000edc:	9b0ff0ef          	jal	ra,f900008c <uart_writeStr>
f9000ee0:	f81007b7          	lui	a5,0xf8100
f9000ee4:	0097a023          	sw	s1,0(a5) # f8100000 <phase+0xff07feb8>
f9000ee8:	0127a223          	sw	s2,4(a5)
	write_u32(spo2_reg,   IO_APB_SLAVE_0_INPUT);
	write_u32(heart_reg , IO_APB_SLAVE_0_INPUT + 4);


	return 0;
}
f9000eec:	00000513          	li	a0,0
f9000ef0:	03c12083          	lw	ra,60(sp)
f9000ef4:	03812403          	lw	s0,56(sp)
f9000ef8:	03412483          	lw	s1,52(sp)
f9000efc:	03012903          	lw	s2,48(sp)
f9000f00:	02c12983          	lw	s3,44(sp)
f9000f04:	02812a03          	lw	s4,40(sp)
f9000f08:	04010113          	addi	sp,sp,64
f9000f0c:	00008067          	ret

f9000f10 <Max32664Init>:



void Max32664Init()
{
f9000f10:	ff010113          	addi	sp,sp,-16
f9000f14:	00112623          	sw	ra,12(sp)
f9000f18:	00812423          	sw	s0,8(sp)
f9000f1c:	00912223          	sw	s1,4(sp)
f9000f20:	01212023          	sw	s2,0(sp)
f9000f24:	f800d937          	lui	s2,0xf800d
f9000f28:	00300793          	li	a5,3
f9000f2c:	00f92423          	sw	a5,8(s2) # f800d008 <phase+0xfef8cec0>
	uint8_t wds[4];
	uint8_t rds[1];

    gpio_setOutputEnable(GPIO0, 0x3);
    Max32664mfio(1);
f9000f30:	00100513          	li	a0,1
f9000f34:	91dff0ef          	jal	ra,f9000850 <Max32664mfio>
    Max32664reset(0);
f9000f38:	00000513          	li	a0,0
f9000f3c:	8f9ff0ef          	jal	ra,f9000834 <Max32664reset>
    bsp_uDelay(10 * 1000);
f9000f40:	f8b00637          	lui	a2,0xf8b00
f9000f44:	017d8437          	lui	s0,0x17d8
f9000f48:	84040593          	addi	a1,s0,-1984 # 17d7840 <CUSTOM1+0x17d7815>
f9000f4c:	00002537          	lui	a0,0x2
f9000f50:	71050513          	addi	a0,a0,1808 # 2710 <CUSTOM1+0x26e5>
f9000f54:	9e8ff0ef          	jal	ra,f900013c <clint_uDelay>
    Max32664reset(1);
f9000f58:	00100513          	li	a0,1
f9000f5c:	8d9ff0ef          	jal	ra,f9000834 <Max32664reset>
    bsp_uDelay(1500 * 1000);
f9000f60:	f8b00637          	lui	a2,0xf8b00
f9000f64:	84040593          	addi	a1,s0,-1984
f9000f68:	0016e4b7          	lui	s1,0x16e
f9000f6c:	36048513          	addi	a0,s1,864 # 16e360 <CUSTOM1+0x16e335>
f9000f70:	9ccff0ef          	jal	ra,f900013c <clint_uDelay>
f9000f74:	00100793          	li	a5,1
f9000f78:	00f92423          	sw	a5,8(s2)
    gpio_setOutputEnable(GPIO0, 0x1);

    uint32_t mode = Max32664getRegister(0x02, 0x00);
f9000f7c:	00000593          	li	a1,0
f9000f80:	00200513          	li	a0,2
f9000f84:	815ff0ef          	jal	ra,f9000798 <Max32664getRegister>
f9000f88:	00050913          	mv	s2,a0

    bsp_putString("Device Mode = ");
f9000f8c:	f90805b7          	lui	a1,0xf9080
f9000f90:	07058593          	addi	a1,a1,112 # f9080070 <phase+0xffffff28>
f9000f94:	f8001537          	lui	a0,0xf8001
f9000f98:	8f4ff0ef          	jal	ra,f900008c <uart_writeStr>
    uart_writeHex(BSP_UART_TERMINAL, mode);
f9000f9c:	00090593          	mv	a1,s2
f9000fa0:	f8001537          	lui	a0,0xf8001
f9000fa4:	92cff0ef          	jal	ra,f90000d0 <uart_writeHex>
    bsp_putString("\r\n");
f9000fa8:	f90805b7          	lui	a1,0xf9080
f9000fac:	03c58593          	addi	a1,a1,60 # f908003c <phase+0xfffffef4>
f9000fb0:	f8001537          	lui	a0,0xf8001
f9000fb4:	8d8ff0ef          	jal	ra,f900008c <uart_writeStr>

    bsp_putString("Deasserted Reset\r\n");
f9000fb8:	f90805b7          	lui	a1,0xf9080
f9000fbc:	08058593          	addi	a1,a1,128 # f9080080 <phase+0xffffff38>
f9000fc0:	f8001537          	lui	a0,0xf8001
f9000fc4:	8c8ff0ef          	jal	ra,f900008c <uart_writeStr>
	uint32_t status;

	//status = Max32664SetSpo2Coeff();
	//Max32664StatusCheck(status, "Set SpO2 Coeff.");

	status = Max32664setRegister(0x10, 0x00, 0x03);
f9000fc8:	00300613          	li	a2,3
f9000fcc:	00000593          	li	a1,0
f9000fd0:	01000513          	li	a0,16
f9000fd4:	e90ff0ef          	jal	ra,f9000664 <Max32664setRegister>
	Max32664StatusCheck(status, "SetOutputMode");
f9000fd8:	f90805b7          	lui	a1,0xf9080
f9000fdc:	09458593          	addi	a1,a1,148 # f9080094 <phase+0xffffff4c>
f9000fe0:	891ff0ef          	jal	ra,f9000870 <Max32664StatusCheck>
	bsp_uDelay(CMD_DELAY);
f9000fe4:	f8b00637          	lui	a2,0xf8b00
f9000fe8:	84040593          	addi	a1,s0,-1984
f9000fec:	0000a937          	lui	s2,0xa
f9000ff0:	c4090513          	addi	a0,s2,-960 # 9c40 <CUSTOM1+0x9c15>
f9000ff4:	948ff0ef          	jal	ra,f900013c <clint_uDelay>

	//status = Max32664setRegister(0x10, 0x01, 0xF);
	status = Max32664setRegister(0x10, 0x01, 0xF);
f9000ff8:	00f00613          	li	a2,15
f9000ffc:	00100593          	li	a1,1
f9001000:	01000513          	li	a0,16
f9001004:	e60ff0ef          	jal	ra,f9000664 <Max32664setRegister>
	Max32664StatusCheck(status, "Interrupt Threshold");
f9001008:	f90805b7          	lui	a1,0xf9080
f900100c:	0a458593          	addi	a1,a1,164 # f90800a4 <phase+0xffffff5c>
f9001010:	861ff0ef          	jal	ra,f9000870 <Max32664StatusCheck>
	bsp_uDelay(CMD_DELAY);
f9001014:	f8b00637          	lui	a2,0xf8b00
f9001018:	84040593          	addi	a1,s0,-1984
f900101c:	c4090513          	addi	a0,s2,-960
f9001020:	91cff0ef          	jal	ra,f900013c <clint_uDelay>

	status = Max32664setRegister(0x52, 0x00, 0x01);
f9001024:	00100613          	li	a2,1
f9001028:	00000593          	li	a1,0
f900102c:	05200513          	li	a0,82
f9001030:	e34ff0ef          	jal	ra,f9000664 <Max32664setRegister>
	Max32664StatusCheck(status, "Enable AGC");
f9001034:	f90805b7          	lui	a1,0xf9080
f9001038:	0b858593          	addi	a1,a1,184 # f90800b8 <phase+0xffffff70>
f900103c:	835ff0ef          	jal	ra,f9000870 <Max32664StatusCheck>
	bsp_uDelay(CMD_DELAY);
f9001040:	f8b00637          	lui	a2,0xf8b00
f9001044:	84040593          	addi	a1,s0,-1984
f9001048:	c4090513          	addi	a0,s2,-960
f900104c:	8f0ff0ef          	jal	ra,f900013c <clint_uDelay>
	Max32664Read(sizeof(rds), rds);
	Max32664StatusCheck(rds[0], "Enable the accelerometer");
	*/


	status = Max32664setRegister(0x44, 0x03, 0x01);
f9001050:	00100613          	li	a2,1
f9001054:	00300593          	li	a1,3
f9001058:	04400513          	li	a0,68
f900105c:	e08ff0ef          	jal	ra,f9000664 <Max32664setRegister>
	Max32664StatusCheck(status, "Enable the AFE");
f9001060:	f90805b7          	lui	a1,0xf9080
f9001064:	0c458593          	addi	a1,a1,196 # f90800c4 <phase+0xffffff7c>
f9001068:	809ff0ef          	jal	ra,f9000870 <Max32664StatusCheck>

	bsp_uDelay(1500 * 1000);
f900106c:	f8b00637          	lui	a2,0xf8b00
f9001070:	84040593          	addi	a1,s0,-1984
f9001074:	36048513          	addi	a0,s1,864
f9001078:	8c4ff0ef          	jal	ra,f900013c <clint_uDelay>

	status = Max32664setRegister(0x52, 0x02, 0x01);
f900107c:	00100613          	li	a2,1
f9001080:	00200593          	li	a1,2
f9001084:	05200513          	li	a0,82
f9001088:	ddcff0ef          	jal	ra,f9000664 <Max32664setRegister>
	Max32664StatusCheck(status, "Enable the HR/SpO2");
f900108c:	f90805b7          	lui	a1,0xf9080
f9001090:	0d458593          	addi	a1,a1,212 # f90800d4 <phase+0xffffff8c>
f9001094:	fdcff0ef          	jal	ra,f9000870 <Max32664StatusCheck>

	bsp_uDelay(1500 * 1000);
f9001098:	f8b00637          	lui	a2,0xf8b00
f900109c:	84040593          	addi	a1,s0,-1984
f90010a0:	36048513          	addi	a0,s1,864
f90010a4:	898ff0ef          	jal	ra,f900013c <clint_uDelay>

	return;
}
f90010a8:	00c12083          	lw	ra,12(sp)
f90010ac:	00812403          	lw	s0,8(sp)
f90010b0:	00412483          	lw	s1,4(sp)
f90010b4:	00012903          	lw	s2,0(sp)
f90010b8:	01010113          	addi	sp,sp,16
f90010bc:	00008067          	ret

f90010c0 <main>:



void main() {
f90010c0:	fe010113          	addi	sp,sp,-32
f90010c4:	00112e23          	sw	ra,28(sp)
f90010c8:	00812c23          	sw	s0,24(sp)
f90010cc:	00912a23          	sw	s1,20(sp)
f90010d0:	01212823          	sw	s2,16(sp)
f90010d4:	01312623          	sw	s3,12(sp)
f90010d8:	01412423          	sw	s4,8(sp)
    unsigned int loop_wait_us   = 512;
    unsigned int current_time   = 0;


    bsp_init();
    init();
f90010dc:	a1cff0ef          	jal	ra,f90002f8 <init>
    bsp_print("i2c 0 demo !");
f90010e0:	f9080537          	lui	a0,0xf9080
f90010e4:	0e850513          	addi	a0,a0,232 # f90800e8 <phase+0xffffffa0>
f90010e8:	888ff0ef          	jal	ra,f9000170 <bsp_print>
    Max32664Init();
f90010ec:	e25ff0ef          	jal	ra,f9000f10 <Max32664Init>
    bsp_putString("MAX32664 Initialized\r\n");
f90010f0:	f90805b7          	lui	a1,0xf9080
f90010f4:	0f858593          	addi	a1,a1,248 # f90800f8 <phase+0xffffffb0>
f90010f8:	f8001537          	lui	a0,0xf8001
f90010fc:	f91fe0ef          	jal	ra,f900008c <uart_writeStr>


    WriteInaRegister(0x00, 0x19F);
f9001100:	19f00593          	li	a1,415
f9001104:	00000513          	li	a0,0
f9001108:	b40ff0ef          	jal	ra,f9000448 <WriteInaRegister>
    WriteInaRegister(0x05, 26843);
f900110c:	000075b7          	lui	a1,0x7
f9001110:	8db58593          	addi	a1,a1,-1829 # 68db <CUSTOM1+0x68b0>
f9001114:	00500513          	li	a0,5
f9001118:	b30ff0ef          	jal	ra,f9000448 <WriteInaRegister>
    bsp_putString("INA219 Initialized\r\n");
f900111c:	f90805b7          	lui	a1,0xf9080
f9001120:	11058593          	addi	a1,a1,272 # f9080110 <phase+0xffffffc8>
f9001124:	f8001537          	lui	a0,0xf8001
f9001128:	f65fe0ef          	jal	ra,f900008c <uart_writeStr>
    unsigned int current_time   = 0;
f900112c:	00000493          	li	s1,0
f9001130:	0440006f          	j	f9001174 <main+0xb4>
    	uart_writeHex(BSP_UART_TERMINAL, samples); bsp_putString(" ");
    	bsp_putString("\r\n");

    	if ( (status & 0x08) == 0x8)
    	{
    	    Max32664GetFifoData();
f9001134:	911ff0ef          	jal	ra,f9000a44 <Max32664GetFifoData>
f9001138:	0b40006f          	j	f90011ec <main+0x12c>
            write_u32(1,          IO_APB_SLAVE_0_INPUT + 12);
            write_u32(0,          IO_APB_SLAVE_0_INPUT + 12);
            current_time -= update_time_us;
        }

        bsp_putString(" \r\n");
f900113c:	f90805b7          	lui	a1,0xf9080
f9001140:	13858593          	addi	a1,a1,312 # f9080138 <phase+0xfffffff0>
f9001144:	f8001537          	lui	a0,0xf8001
f9001148:	f45fe0ef          	jal	ra,f900008c <uart_writeStr>

    	bsp_uDelay(loop_wait_us);
f900114c:	f8b00637          	lui	a2,0xf8b00
f9001150:	017d85b7          	lui	a1,0x17d8
f9001154:	84058593          	addi	a1,a1,-1984 # 17d7840 <CUSTOM1+0x17d7815>
f9001158:	20000513          	li	a0,512
f900115c:	fe1fe0ef          	jal	ra,f900013c <clint_uDelay>
        current_time += loop_wait_us;
f9001160:	20048493          	addi	s1,s1,512
        //uart_writeHex(BSP_UART_TERMINAL, current_time);  bsp_putString(" ");
        bsp_putString("\r\n");
f9001164:	f90805b7          	lui	a1,0xf9080
f9001168:	03c58593          	addi	a1,a1,60 # f908003c <phase+0xfffffef4>
f900116c:	f8001537          	lui	a0,0xf8001
f9001170:	f1dfe0ef          	jal	ra,f900008c <uart_writeStr>
    	status  = Max32664GetHubStatus();
f9001174:	f58ff0ef          	jal	ra,f90008cc <Max32664GetHubStatus>
f9001178:	f9080437          	lui	s0,0xf9080
f900117c:	14a402a3          	sb	a0,325(s0) # f9080145 <phase+0xfffffffd>
    	samples = Max32664GetNumberOfSamples();
f9001180:	f9cff0ef          	jal	ra,f900091c <Max32664GetNumberOfSamples>
f9001184:	f90809b7          	lui	s3,0xf9080
f9001188:	14a98223          	sb	a0,324(s3) # f9080144 <phase+0xfffffffc>
    	bsp_putString("---Status ---\r\n");
f900118c:	f90805b7          	lui	a1,0xf9080
f9001190:	12858593          	addi	a1,a1,296 # f9080128 <phase+0xffffffe0>
f9001194:	f8001537          	lui	a0,0xf8001
f9001198:	ef5fe0ef          	jal	ra,f900008c <uart_writeStr>
    	uart_writeHex(BSP_UART_TERMINAL, status);  bsp_putString(" ");
f900119c:	14544583          	lbu	a1,325(s0)
f90011a0:	f8001537          	lui	a0,0xf8001
f90011a4:	f2dfe0ef          	jal	ra,f90000d0 <uart_writeHex>
f90011a8:	f9080937          	lui	s2,0xf9080
f90011ac:	01090593          	addi	a1,s2,16 # f9080010 <phase+0xfffffec8>
f90011b0:	f8001537          	lui	a0,0xf8001
f90011b4:	ed9fe0ef          	jal	ra,f900008c <uart_writeStr>
    	uart_writeHex(BSP_UART_TERMINAL, samples); bsp_putString(" ");
f90011b8:	1449c583          	lbu	a1,324(s3)
f90011bc:	f8001537          	lui	a0,0xf8001
f90011c0:	f11fe0ef          	jal	ra,f90000d0 <uart_writeHex>
f90011c4:	01090593          	addi	a1,s2,16
f90011c8:	f8001537          	lui	a0,0xf8001
f90011cc:	ec1fe0ef          	jal	ra,f900008c <uart_writeStr>
    	bsp_putString("\r\n");
f90011d0:	f90805b7          	lui	a1,0xf9080
f90011d4:	03c58593          	addi	a1,a1,60 # f908003c <phase+0xfffffef4>
f90011d8:	f8001537          	lui	a0,0xf8001
f90011dc:	eb1fe0ef          	jal	ra,f900008c <uart_writeStr>
    	if ( (status & 0x08) == 0x8)
f90011e0:	14544783          	lbu	a5,325(s0)
f90011e4:	0087f793          	andi	a5,a5,8
f90011e8:	f40796e3          	bnez	a5,f9001134 <main+0x74>
        rd0 = ReadInaRegister(0x00);
f90011ec:	00000513          	li	a0,0
f90011f0:	968ff0ef          	jal	ra,f9000358 <ReadInaRegister>
        rd1 = ReadInaRegister(0x01);
f90011f4:	00100513          	li	a0,1
f90011f8:	960ff0ef          	jal	ra,f9000358 <ReadInaRegister>
        rd2 = ReadInaRegister(0x02);
f90011fc:	00200513          	li	a0,2
f9001200:	958ff0ef          	jal	ra,f9000358 <ReadInaRegister>
f9001204:	00050913          	mv	s2,a0
        rd3 = ReadInaRegister(0x03);
f9001208:	00300513          	li	a0,3
f900120c:	94cff0ef          	jal	ra,f9000358 <ReadInaRegister>
f9001210:	00050a13          	mv	s4,a0
        rd4 = ReadInaRegister(0x04);
f9001214:	00400513          	li	a0,4
f9001218:	940ff0ef          	jal	ra,f9000358 <ReadInaRegister>
f900121c:	00050413          	mv	s0,a0
        rd5 = ReadInaRegister(0x05);
f9001220:	00500513          	li	a0,5
f9001224:	934ff0ef          	jal	ra,f9000358 <ReadInaRegister>
f9001228:	00050993          	mv	s3,a0
        uart_writeHex(BSP_UART_TERMINAL, rd2);  bsp_putString(" ");
f900122c:	00090593          	mv	a1,s2
f9001230:	f8001537          	lui	a0,0xf8001
f9001234:	e9dfe0ef          	jal	ra,f90000d0 <uart_writeHex>
f9001238:	f9080937          	lui	s2,0xf9080
f900123c:	01090593          	addi	a1,s2,16 # f9080010 <phase+0xfffffec8>
f9001240:	f8001537          	lui	a0,0xf8001
f9001244:	e49fe0ef          	jal	ra,f900008c <uart_writeStr>
        uart_writeHex(BSP_UART_TERMINAL, rd3);  bsp_putString(" ");
f9001248:	000a0593          	mv	a1,s4
f900124c:	f8001537          	lui	a0,0xf8001
f9001250:	e81fe0ef          	jal	ra,f90000d0 <uart_writeHex>
f9001254:	01090593          	addi	a1,s2,16
f9001258:	f8001537          	lui	a0,0xf8001
f900125c:	e31fe0ef          	jal	ra,f900008c <uart_writeStr>
        uart_writeHex(BSP_UART_TERMINAL, rd4);  bsp_putString(" ");
f9001260:	00040593          	mv	a1,s0
f9001264:	f8001537          	lui	a0,0xf8001
f9001268:	e69fe0ef          	jal	ra,f90000d0 <uart_writeHex>
f900126c:	01090593          	addi	a1,s2,16
f9001270:	f8001537          	lui	a0,0xf8001
f9001274:	e19fe0ef          	jal	ra,f900008c <uart_writeStr>
        uart_writeHex(BSP_UART_TERMINAL, rd5);  bsp_putString(" ");
f9001278:	00098593          	mv	a1,s3
f900127c:	f8001537          	lui	a0,0xf8001
f9001280:	e51fe0ef          	jal	ra,f90000d0 <uart_writeHex>
f9001284:	01090593          	addi	a1,s2,16
f9001288:	f8001537          	lui	a0,0xf8001
f900128c:	e01fe0ef          	jal	ra,f900008c <uart_writeStr>
        uint32_t watt = rd4 * 152 * 12;
f9001290:	72000513          	li	a0,1824
f9001294:	02a40533          	mul	a0,s0,a0
        uint32_t watt_reg = (((watt/10000000)%10)  << 16) + ( ((watt/1000000) %10)  << 12)
f9001298:	00989437          	lui	s0,0x989
f900129c:	68040413          	addi	s0,s0,1664 # 989680 <CUSTOM1+0x989655>
f90012a0:	02855433          	divu	s0,a0,s0
f90012a4:	00a00713          	li	a4,10
f90012a8:	02e47433          	remu	s0,s0,a4
f90012ac:	01041413          	slli	s0,s0,0x10
f90012b0:	000f47b7          	lui	a5,0xf4
f90012b4:	24078793          	addi	a5,a5,576 # f4240 <CUSTOM1+0xf4215>
f90012b8:	02f557b3          	divu	a5,a0,a5
f90012bc:	02e7f7b3          	remu	a5,a5,a4
f90012c0:	00c79793          	slli	a5,a5,0xc
f90012c4:	00f40433          	add	s0,s0,a5
            		+ ( ((watt/100000) %10)  << 8) + ( ((watt/10000) %10)  << 4) + ( ((watt %1000)%10)  << 0);
f90012c8:	000187b7          	lui	a5,0x18
f90012cc:	6a078793          	addi	a5,a5,1696 # 186a0 <CUSTOM1+0x18675>
f90012d0:	02f557b3          	divu	a5,a0,a5
f90012d4:	02e7f7b3          	remu	a5,a5,a4
f90012d8:	00879793          	slli	a5,a5,0x8
f90012dc:	00f40433          	add	s0,s0,a5
f90012e0:	000027b7          	lui	a5,0x2
f90012e4:	71078793          	addi	a5,a5,1808 # 2710 <CUSTOM1+0x26e5>
f90012e8:	02f557b3          	divu	a5,a0,a5
f90012ec:	02e7f7b3          	remu	a5,a5,a4
f90012f0:	00479793          	slli	a5,a5,0x4
f90012f4:	00f40433          	add	s0,s0,a5
f90012f8:	3e800793          	li	a5,1000
f90012fc:	02f57533          	remu	a0,a0,a5
f9001300:	02e57533          	remu	a0,a0,a4
        uint32_t watt_reg = (((watt/10000000)%10)  << 16) + ( ((watt/1000000) %10)  << 12)
f9001304:	00a40433          	add	s0,s0,a0
        if (current_time >= update_time_us )
f9001308:	000017b7          	lui	a5,0x1
f900130c:	e2f4e8e3          	bltu	s1,a5,f900113c <main+0x7c>
            uart_writeHex(BSP_UART_TERMINAL, watt_reg);  bsp_putString(" ");
f9001310:	00040593          	mv	a1,s0
f9001314:	f8001537          	lui	a0,0xf8001
f9001318:	db9fe0ef          	jal	ra,f90000d0 <uart_writeHex>
f900131c:	01090593          	addi	a1,s2,16
f9001320:	f8001537          	lui	a0,0xf8001
f9001324:	d69fe0ef          	jal	ra,f900008c <uart_writeStr>
            bsp_putString("\r\n");
f9001328:	f9080937          	lui	s2,0xf9080
f900132c:	03c90593          	addi	a1,s2,60 # f908003c <phase+0xfffffef4>
f9001330:	f8001537          	lui	a0,0xf8001
f9001334:	d59fe0ef          	jal	ra,f900008c <uart_writeStr>
            bsp_putString("\r\n");
f9001338:	03c90593          	addi	a1,s2,60
f900133c:	f8001537          	lui	a0,0xf8001
f9001340:	d4dfe0ef          	jal	ra,f900008c <uart_writeStr>
f9001344:	f81007b7          	lui	a5,0xf8100
f9001348:	0087a423          	sw	s0,8(a5) # f8100008 <phase+0xff07fec0>
f900134c:	0007a623          	sw	zero,12(a5)
f9001350:	00100713          	li	a4,1
f9001354:	00e7a623          	sw	a4,12(a5)
f9001358:	0007a623          	sw	zero,12(a5)
            current_time -= update_time_us;
f900135c:	fffff7b7          	lui	a5,0xfffff
f9001360:	00f484b3          	add	s1,s1,a5
f9001364:	dd9ff06f          	j	f900113c <main+0x7c>

f9001368 <trap_entry>:
.global  trap_entry
.align(2) //mtvec require 32 bits allignement
trap_entry:
  addi sp,sp, -16*4
f9001368:	fc010113          	addi	sp,sp,-64
  sw x1,   0*4(sp)
f900136c:	00112023          	sw	ra,0(sp)
  sw x5,   1*4(sp)
f9001370:	00512223          	sw	t0,4(sp)
  sw x6,   2*4(sp)
f9001374:	00612423          	sw	t1,8(sp)
  sw x7,   3*4(sp)
f9001378:	00712623          	sw	t2,12(sp)
  sw x10,  4*4(sp)
f900137c:	00a12823          	sw	a0,16(sp)
  sw x11,  5*4(sp)
f9001380:	00b12a23          	sw	a1,20(sp)
  sw x12,  6*4(sp)
f9001384:	00c12c23          	sw	a2,24(sp)
  sw x13,  7*4(sp)
f9001388:	00d12e23          	sw	a3,28(sp)
  sw x14,  8*4(sp)
f900138c:	02e12023          	sw	a4,32(sp)
  sw x15,  9*4(sp)
f9001390:	02f12223          	sw	a5,36(sp)
  sw x16, 10*4(sp)
f9001394:	03012423          	sw	a6,40(sp)
  sw x17, 11*4(sp)
f9001398:	03112623          	sw	a7,44(sp)
  sw x28, 12*4(sp)
f900139c:	03c12823          	sw	t3,48(sp)
  sw x29, 13*4(sp)
f90013a0:	03d12a23          	sw	t4,52(sp)
  sw x30, 14*4(sp)
f90013a4:	03e12c23          	sw	t5,56(sp)
  sw x31, 15*4(sp)
f90013a8:	03f12e23          	sw	t6,60(sp)
  call trap
f90013ac:	fa9fe0ef          	jal	ra,f9000354 <trap>
  lw x1 ,  0*4(sp)
f90013b0:	00012083          	lw	ra,0(sp)
  lw x5,   1*4(sp)
f90013b4:	00412283          	lw	t0,4(sp)
  lw x6,   2*4(sp)
f90013b8:	00812303          	lw	t1,8(sp)
  lw x7,   3*4(sp)
f90013bc:	00c12383          	lw	t2,12(sp)
  lw x10,  4*4(sp)
f90013c0:	01012503          	lw	a0,16(sp)
  lw x11,  5*4(sp)
f90013c4:	01412583          	lw	a1,20(sp)
  lw x12,  6*4(sp)
f90013c8:	01812603          	lw	a2,24(sp)
  lw x13,  7*4(sp)
f90013cc:	01c12683          	lw	a3,28(sp)
  lw x14,  8*4(sp)
f90013d0:	02012703          	lw	a4,32(sp)
  lw x15,  9*4(sp)
f90013d4:	02412783          	lw	a5,36(sp)
  lw x16, 10*4(sp)
f90013d8:	02812803          	lw	a6,40(sp)
  lw x17, 11*4(sp)
f90013dc:	02c12883          	lw	a7,44(sp)
  lw x28, 12*4(sp)
f90013e0:	03012e03          	lw	t3,48(sp)
  lw x29, 13*4(sp)
f90013e4:	03412e83          	lw	t4,52(sp)
  lw x30, 14*4(sp)
f90013e8:	03812f03          	lw	t5,56(sp)
  lw x31, 15*4(sp)
f90013ec:	03c12f83          	lw	t6,60(sp)
  addi sp,sp, 16*4
f90013f0:	04010113          	addi	sp,sp,64
  mret
f90013f4:	30200073          	mret

Disassembly of section .text.init:

f9000000 <_start>:
    .section .text.init
    .align 6
    .globl _start
    .globl _bss_end
_start:
    j reset_vector
f9000000:	0040006f          	j	f9000004 <other_exception>

f9000004 <other_exception>:
other_exception:
#    <<<他のハンドラの内容>>>
reset_vector:
#    <<<初期化内容>>>
#    li sp, 4096     # スタックポインタのアドレス
    la sp, STACK_TOP # スタックポインタのアドレス
f9000004:	00080117          	auipc	sp,0x80
f9000008:	54010113          	addi	sp,sp,1344 # f9080544 <phase+0x3fc>

    auipc t0,0x0    # PCをレジスタに退避
f900000c:	00000297          	auipc	t0,0x0
    addi  t0,t0,16  # mretのアドレス
f9000010:	01028293          	addi	t0,t0,16 # f900001c <other_exception+0x18>
    csrw  mepc,t0   # MEPCにアドレスをセット
f9000014:	34129073          	csrw	mepc,t0

    li    t0,0x4    # 0x4をセット
f9000018:	00400293          	li	t0,4
    csrw  mtvec,t0  # MTVECにアドレスをセット
f900001c:	30529073          	csrw	mtvec,t0

    li    t0,0x800  # 割り込みセット
f9000020:	000012b7          	lui	t0,0x1
f9000024:	80028293          	addi	t0,t0,-2048 # 800 <CUSTOM1+0x7d5>
    csrw  mie,t0    # mieに割り込みイネーブルをセット
f9000028:	30429073          	csrw	mie,t0

    li    t0,0x8    # 割り込みセット
f900002c:	00800293          	li	t0,8
    csrw  mstatus,t0 # mieに割り込みイネーブルをセット
f9000030:	30029073          	csrw	mstatus,t0

    call  main      # mainへジャンプ
f9000034:	08c010ef          	jal	ra,f90010c0 <main>

    mret            # MEPCへ飛んでいく
f9000038:	30200073          	mret
f900003c:	0000                	unimp
	...

/*
NISHIHARU
    RiscV_AE350_SOC customized 
    DDR3 Memory Interface IP customized and configured
*/
module ae350_customized_demo
(
    input           CLK,
    input           RSTN,
    // GPIO
    output [7:0]    LED,     // 2:0
    // UART2
    output          UART2_TXD,
    input           UART2_RXD,
    // SPI Flash Memory
    inout           FLASH_SPI_CSN,
    inout           FLASH_SPI_MISO,
    inout           FLASH_SPI_MOSI,
    inout           FLASH_SPI_CLK,
    inout           FLASH_SPI_HOLDN,
    inout           FLASH_SPI_WPN,
    // DDR3 Memory
    output          DDR3_INIT,
    output [2:0]    DDR3_BANK,
    output          DDR3_CS_N,
    output          DDR3_RAS_N,
    output          DDR3_CAS_N,
    output          DDR3_WE_N,
    output          DDR3_CK,
    output          DDR3_CK_N,
    output          DDR3_CKE,
    output          DDR3_RESET_N,
    output          DDR3_ODT,
    output [13:0]   DDR3_ADDR,
    output [3:0]    DDR3_DM,
    inout [31:0]    DDR3_DQ,
    inout [3:0]     DDR3_DQS,
    inout [3:0]     DDR3_DQS_N,
    // JTAG
    input           TCK_IN,
    input           TMS_IN,
    input           TRST_IN,
    input           TDI_IN,
    output          TDO_OUT
);

assign LED[7:0] = 8'b0000_0000;

wire CORE_CLK;
wire DDR3_CLK;
wire AHB_CLK;
wire APB_CLK;
wire RTC_CLK;

wire DDR3_MEMORY_CLK;
wire DDR_CLK_IN;
wire DDR3_RSTN;
wire DDR3_LOCK;
wire DDR3_STOP;

assign  DDR3_RSTN = RSTN;


// Gowin_PLL_AE350 instantiation
Gowin_PLL_AE350 u_Gowin_PLL_AE350
(
    .lock           (),
    .clkout0        (DDR_CLK),          // 50MHz
    .clkout1        (CORE_CLK),         // 800MHz
    .clkout2        (AHB_CLK),          // 100MHz
    .clkout3        (APB_CLK),          // 100MHz
    .clkout4        (RTC_CLK),          // 10MHz
    .clkin          (CLK),
    .enclk0         (1'b1),
    .enclk1         (1'b1),
    .enclk2         (1'b1),
    .enclk3         (1'b1),
    .enclk4         (1'b1)
);


// Gowin_PLL_DDR3 instantiation
Gowin_PLL_DDR3 u_Gowin_PLL_DDR3
(
    .lock       (DDR3_LOCK),
    .clkout0    (DDR3_CLK_IN),          // 50MHz
    .clkout2    (DDR3_MEMORY_CLK),      // 200MHz
    .clkin      (CLK),
    .reset      (1'b0),                   // Enforce
    .enclk0     (1'b1),
    .enclk2     (DDR3_STOP)
);

wire ae350_rstn;                    // AE350 power on and hardware reset in
wire ddr3_init_completed;           // DDR3 memory initialized completed

// key_debounce instantiation
// AE350 power on and hardware reset in key debounce
key_debounce u_key_debounce_ae350
(
    .out        (ae350_rstn),
    .in         (ddr3_init_completed),
    .clk        (CLK),              // 50MHz
    .rstn       (1'b1)
);

// AE350
RiscV_AE350_SOC_Top AE350m(
    // FLASH
    .FLASH_SPI_CSN              (FLASH_SPI_CSN),        //inout FLASH_SPI_CSN
    .FLASH_SPI_MISO             (FLASH_SPI_MISO),       //inout FLASH_SPI_MISO
    .FLASH_SPI_MOSI             (FLASH_SPI_MOSI),       //inout FLASH_SPI_MOSI
    .FLASH_SPI_CLK              (FLASH_SPI_CLK),        //inout FLASH_SPI_CLK
    .FLASH_SPI_HOLDN            (FLASH_SPI_HOLDN),      //inout FLASH_SPI_HOLDN
    .FLASH_SPI_WPN              (FLASH_SPI_WPN),        //inout FLASH_SPI_WPN
    // DDR
    .DDR3_MEMORY_CLK            (DDR3_MEMORY_CLK),      //input DDR3_MEMORY_CLK
    .DDR3_CLK_IN                (DDR3_CLK_IN),          //input DDR3_CLK_IN
    .DDR3_RSTN                  (DDR3_RSTN),            //input DDR3_RSTN
    .DDR3_LOCK                  (DDR3_LOCK),            //input DDR3_LOCK
    .DDR3_STOP                  (DDR3_STOP),            //output DDR3_STOP
    .DDR3_INIT                  (ddr3_init_completed),  //output DDR3_INIT
    .DDR3_BANK                  (DDR3_BANK),            //output [2:0] DDR3_BANK
    .DDR3_CS_N                  (DDR3_CS_N),            //output DDR3_CS_N
    .DDR3_RAS_N                 (DDR3_RAS_N),           //output DDR3_RAS_N
    .DDR3_CAS_N                 (DDR3_CAS_N),           //output DDR3_CAS_N
    .DDR3_WE_N                  (DDR3_WE_N),            //output DDR3_WE_N
    .DDR3_CK                    (DDR3_CK),              //output DDR3_CK
    .DDR3_CK_N                  (DDR3_CK_N),            //output DDR3_CK_N
    .DDR3_CKE                   (DDR3_CKE),             //output DDR3_CKE
    .DDR3_RESET_N               (DDR3_RESET_N),         //output DDR3_RESET_N
    .DDR3_ODT                   (DDR3_ODT),             //output DDR3_ODT
    .DDR3_ADDR                  (DDR3_ADDR),            //output [13:0] DDR3_ADDR
    .DDR3_DM                    (DDR3_DM[1:0]),         //output [1:0] DDR3_DM
    .DDR3_DQ                    (DDR3_DQ[15:0]),        //inout [15:0] DDR3_DQ
    .DDR3_DQS                   (DDR3_DQS[1:0]),        //inout [1:0] DDR3_DQS
    .DDR3_DQS_N                 (DDR3_DQS_N[1:0]),      //inout [1:0] DDR3_DQS_N
    // TCK
    .TCK_IN                     (TCK_IN),               //input TCK_IN
    .TMS_IN                     (TMS_IN),               //input TMS_IN
    .TRST_IN                    (TRST_IN),              //input TRST_IN
    .TDI_IN                     (TDI_IN),               //input TDI_IN
    .TDO_OUT                    (TDO_OUT),              //output TDO_OUT
    .TDO_OE                     (),                     //output TDO_OE
    // UART
    .UART2_TXD                  (UART2_TXD),            //output UART2_TXD
    .UART2_RTSN                 (),                     //output UART2_RTSN
    .UART2_RXD                  (UART2_RXD),            //input UART2_RXD
    .UART2_CTSN                 (),                     //input UART2_CTSN
    .UART2_DCDN                 (),                     //input UART2_DCDN
    .UART2_DSRN                 (),                     //input UART2_DSRN
    .UART2_RIN                  (),                     //input UART2_RIN
    .UART2_DTRN                 (),                     //output UART2_DTRN
    .UART2_OUT1N                (),                     //output UART2_OUT1N
    .UART2_OUT2N                (),                     //output UART2_OUT2N
    // CLK
    .CORE_CLK                   (CORE_CLK),             //input CORE_CLK
    .DDR_CLK                    (DDR_CLK),              //input DDR_CLK
    .AHB_CLK                    (AHB_CLK),              //input AHB_CLK
    .APB_CLK                    (APB_CLK),              //input APB_CLK
    .RTC_CLK                    (RTC_CLK),              //input RTC_CLK
    .POR_RSTN                   (ae350_rstn),                 //input POR_RSTN
    .HW_RSTN                    (ae350_rstn)                  //input HW_RSTN
);

endmodule

// RiscV_AE350_SOC customized demo
// DDR3 Memory Interface IP customized and configured
module ae350_customized_demo
(
    input CLK,
    input RSTN,
    // GPIO
    output [7:0] LED,     // 2:0
    inout [2:0] KEY,     // 5:3
    // UART2
    output UART2_TXD,
    input  UART2_RXD,
    // SPI Flash Memory
    inout FLASH_SPI_CSN,
    inout FLASH_SPI_MISO,
    inout FLASH_SPI_MOSI,
    inout FLASH_SPI_CLK,
    inout FLASH_SPI_HOLDN,
    inout FLASH_SPI_WPN,
    // DDR3 Memory
    output DDR3_INIT,
    output [2:0] DDR3_BANK,
    output DDR3_CS_N,
    output DDR3_RAS_N,
    output DDR3_CAS_N,
    output DDR3_WE_N,
    output DDR3_CK,
    output DDR3_CK_N,
    output DDR3_CKE,
    output DDR3_RESET_N,
    output DDR3_ODT,
    output [15:0] DDR3_ADDR,
    output [3:0] DDR3_DM,
    inout [31:0] DDR3_DQ,
    inout [3:0] DDR3_DQS,
    inout [3:0] DDR3_DQS_N,
    // JTAG
    input TCK_IN,
    input TMS_IN,
    input TRST_IN,
    input TDI_IN,
    output TDO_OUT
);


wire CORE_CLK;
wire DDR_CLK;
wire AHB_CLK;
wire APB_CLK;
wire RTC_CLK;

wire DDR3_MEMORY_CLK;
wire DDR3_CLK_IN;
wire DDR3_LOCK;
wire DDR3_STOP;


// Gowin_PLL_AE350 instantiation
Gowin_PLL_AE350 u_Gowin_PLL_AE350
(
    .clkout0(DDR_CLK),          // 50MHz
    .clkout1(CORE_CLK),         // 800MHz
    .clkout2(AHB_CLK),          // 100MHz
    .clkout3(APB_CLK),          // 100MHz
    .clkout4(RTC_CLK),          // 10MHz
    .clkin(CLK),
    .enclk0(1'b1),
    .enclk1(1'b1),
    .enclk2(1'b1),
    .enclk3(1'b1),
    .enclk4(1'b1)
);


// AE350
RiscV_AE350_SOC_Top AE350m(
    // FLASH
    .FLASH_SPI_CSN              (FLASH_SPI_CSN_io), //inout FLASH_SPI_CSN
    .FLASH_SPI_MISO             (FLASH_SPI_MISO_io), //inout FLASH_SPI_MISO
    .FLASH_SPI_MOSI             (FLASH_SPI_MOSI_io), //inout FLASH_SPI_MOSI
    .FLASH_SPI_CLK              (FLASH_SPI_CLK_io), //inout FLASH_SPI_CLK
    .FLASH_SPI_HOLDN            (FLASH_SPI_HOLDN_io), //inout FLASH_SPI_HOLDN
    .FLASH_SPI_WPN              (FLASH_SPI_WPN_io), //inout FLASH_SPI_WPN
    // DDR
    .DDR3_MEMORY_CLK            (DDR3_MEMORY_CLK_i), //input DDR3_MEMORY_CLK
    .DDR3_CLK_IN                (DDR3_CLK_IN_i), //input DDR3_CLK_IN
    .DDR3_RSTN                  (DDR3_RSTN_i), //input DDR3_RSTN
    .DDR3_LOCK                  (DDR3_LOCK_i), //input DDR3_LOCK
    .DDR3_STOP                  (DDR3_STOP_o), //output DDR3_STOP
    .DDR3_INIT                  (DDR3_INIT_o), //output DDR3_INIT
    .DDR3_BANK                  (DDR3_BANK_o), //output [2:0] DDR3_BANK
    .DDR3_CS_N                  (DDR3_CS_N_o), //output DDR3_CS_N
    .DDR3_RAS_N                 (DDR3_RAS_N_o), //output DDR3_RAS_N
    .DDR3_CAS_N                 (DDR3_CAS_N_o), //output DDR3_CAS_N
    .DDR3_WE_N                  (DDR3_WE_N_o), //output DDR3_WE_N
    .DDR3_CK                    (DDR3_CK_o), //output DDR3_CK
    .DDR3_CK_N                  (DDR3_CK_N_o), //output DDR3_CK_N
    .DDR3_CKE                   (DDR3_CKE_o), //output DDR3_CKE
    .DDR3_RESET_N               (DDR3_RESET_N_o), //output DDR3_RESET_N
    .DDR3_ODT                   (DDR3_ODT_o), //output DDR3_ODT
    .DDR3_ADDR                  (DDR3_ADDR_o), //output [13:0] DDR3_ADDR
    .DDR3_DM                    (DDR3_DM_o), //output [1:0] DDR3_DM
    .DDR3_DQ                    (DDR3_DQ_io), //inout [15:0] DDR3_DQ
    .DDR3_DQS                   (DDR3_DQS_io), //inout [1:0] DDR3_DQS
    .DDR3_DQS_N                 (DDR3_DQS_N_io), //inout [1:0] DDR3_DQS_N
    // TCK
    .TCK_IN                     (TCK_IN_i), //input TCK_IN
    .TMS_IN                     (TMS_IN_i), //input TMS_IN
    .TRST_IN                    (TRST_IN_i), //input TRST_IN
    .TDI_IN                     (TDI_IN_i), //input TDI_IN
    .TDO_OUT                    (TDO_OUT_o), //output TDO_OUT
    .TDO_OE                     (TDO_OE_o), //output TDO_OE
    // CLK
    .CORE_CLK                   (CORE_CLK_i), //input CORE_CLK
    .DDR_CLK                    (DDR_CLK_i), //input DDR_CLK
    .AHB_CLK                    (AHB_CLK_i), //input AHB_CLK
    .APB_CLK                    (APB_CLK_i), //input APB_CLK
    .RTC_CLK                    (RTC_CLK_i), //input RTC_CLK
    .POR_RSTN                   (POR_RSTN_i), //input POR_RSTN
    .HW_RSTN                    (HW_RSTN_i) //input HW_RSTN
);

endmodule
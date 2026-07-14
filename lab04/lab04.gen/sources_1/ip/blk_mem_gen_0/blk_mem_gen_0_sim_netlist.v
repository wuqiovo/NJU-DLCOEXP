// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Tue Jul  7 20:06:24 2026
// Host        : laptop_070628 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               d:/DLCOEXP/lab04/lab04.gen/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k70tfbv676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [3:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [7:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [7:0]douta;

  wire [3:0]addra;
  wire clka;
  wire [7:0]dina;
  wire [7:0]douta;
  wire ena;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [7:0]NLW_U0_doutb_UNCONNECTED;
  wire [3:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "4" *) 
  (* C_ADDRB_WIDTH = "4" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.54005 mW" *) 
  (* C_FAMILY = "kintex7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_gen_0.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "16" *) 
  (* C_READ_DEPTH_B = "16" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "8" *) 
  (* C_READ_WIDTH_B = "8" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "1" *) 
  (* C_USE_BYTE_WEB = "1" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "16" *) 
  (* C_WRITE_DEPTH_B = "16" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_0_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[7:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[3:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[3:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[7:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2022.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
RgPKnWr9n0dGgttm3akiFhAlfB96usOQYxnEmPhGyTGg1AbizYAjGPWLXBWl50n/d0IA71ci4aJB
wt6mtfyNADm3ZReK7D3mKu037BOgxryoEwwf1kiC6q/PllxsdAgEMfQrfHJ3E2AzSpdYjoxVYito
y0JW6CUDcWvWa4WV0EA=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
M0l6KpOGH3jL8eRt3NCD7e2USYnkg5H9GAnE1PKmnjiouFN3Y8kjWA2PZDAQLm9UW+TsC1HeVlzO
WjNCHkjR/6ubCsIcWfpPZWdIuAenlsyq8Y9l6b8vMj8JSbDEOiFF/GHSbKsn22MJdDJKEhHFK6GV
s8gR2vywRFwG69gIRE4qGhVB+WIg8GJrDpDMYH6lCjMkTrjXuKDUcNlJN3NPLuhJ7tsditwf1pr5
moJRmGpJnip/rGm0g4o4A6ev4CtePjoao8C1wFtzHkERX9oenhh7cGjDMejU5IrLv8NxFnLj1FpB
9MuF1beTU20NI5oAn6zLiLiOtXjf0ghU3AN4DA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
hAsrUfp6Qgjm8yBjNYTEtQmVQmMxzL8TE/3oiQSxSI3+yEkXAbQCXkT9mo+LCdv+fGECOB0istHd
eLtbsiYbxjxNxYkXiUrRE5O+aSxynIray+uF9DJigTEUZu8JJXUbzxK4DDUu1Lm9tpGps4+Prz1m
0gkj13RT/Y/418s2VTw=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BP/54Wm/GJmb1jy0bxWJJX4aiKyiWPVh4X3VL30BQrmX4PlEsNKzBJH3Qu8IIYERfnFP0ifAgboa
vypMQ5Ed0BrMePGkWIgT6I8hxJCMFpHdkSK7m1giSKyZzFfTOrVqoNFXE+qdzLfY1J5hBWCvouYo
jllavK4N3gF9FLScH2AUWYVMcVth2QPaTAU2NLnAUNH8kgtBjBfc8/KbPPTznD1QNVqvFstzcbTA
hGQ1ETVPvINQ0KqxxAG5PRhtQD4+pC+hr/Tvk+RSvGyBOfy9zE86OXkJiYs9dSFhNiMFmCPL9DBO
se4OxNNC0/7aBtb1mkSEA9YFDYEb9jS7Jasy2A==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
SnzT9DVH3xlEN8nrr2YrlvTO5qj7L22d7WaBcuKyTaiHoIwwFHrC4HQbfs0TAwkdWcOgmJoATPSF
F6qm0KiddbrlERF3MfKUldeGBJtqLdX+zGw7+3JD7S+HB9dIMOFOHy+IiCZp1/Pz8epKpi238cel
rcVoJQKz406wmXDvOo8KsT+XhRLs9BVCrBErPGGXKYDk6NXAp0duOgQE9DbslzMU83M/kUC7uERV
tQW02240peKQFp2elEZC7Tetvgp0TaFTtJiKN45REi8GQUCKGa85JjNIk1qb/+k95TIIP1xrHirc
6iX7qbwnPetv8TVu2NjkZ0WDEK5RXdOXcxBwHA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_07", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
erkR82V0jX8ytva+9MzEs0c75Z7j7TsgxWRLNAUfbbU28i+U9YzuZlSfYU75M0f9jx1gvxtBrfKv
cNHVdkR+i5zfHDZsDwfMEEBhs8wzDCKqe+eex6BBEvlIOesCPXrr2RozQgaQ1PBh/os2Arfu+873
BjsVxFJkbhpzIqlddOo/XZV9Yi+eih7A7pXXEBR6IL7Poo4Ka49MiVQU0xJrDTm+ddOuMPDRRD7g
dsxS/uzdcBcO2myV6g/7YH/C2Ce9s6+UywJN/0JeXSqwA7bsBqqnfFicVAT0lckLopMLiuzK7dsN
EwhFeqoetciFrDIj9+o0xDMWBZhgNP1u68vURA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
R+BI65BKLT0I9hEtsxGnDyM5XY9gzULeTPOSDXvd3KWOzZJAx6C0xlbyZcFZhAEG/QIK2yd0wAi6
IUWxyF/sx3HsqKjhVi5KxnpuXDBOZVoj811O7JukedFVmDW7OHGtBkuiJ5X5irw7mfsEKRQmF/1i
V6lj9HYHZEjxtDeZjACsLY4y1QxWalSKT4HIMOHznBLL8dLbGMlS+ZmFuFn0gcwZavVl7gTkTtkf
W0gn01A9ru7NKsf+iLX0kj4dgItPu9N2g02M1vWQ9UUQEVvfV7lUc7GY1suibrD8aEkhH9S7lZ7n
bFsT4qxyvzg8ML6v4g4v7N6VuyhEtgFgNd725Q==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
jNUVKiwH68vHsU54idgvKwaVJcoxTUuxfgrQpbpmM/IpesWA3wHsGzYClwAxkKzw3KRnFyQqTWcZ
yj1EQ2CMBxlJ0kyNbZW8OK8pXzeigToZ0U6Aq3Gy+j7wBbhe83wE1Ygn82sK8dHTEulvaRLn/c5r
ispy1s7jMKIvYNzoUuZrgyBQyfaYmdqUia8XlQjFd+VwzhTXKwzvmaqHWyaHjfBKeCooO7+oUxMG
OJg83W54EVe9ronFQ8Wr9EOL8ia7qelCAgyQe/bC0HHCoMAm8apI7sX23iMR/wMiPP5V2bQzycy+
rBX/+SWkqSeIE1FLm+muFPvrE7iLwJaW8d1fzdFFjAZ5aIXArbWNfwbK8S0TczXc9lEzmpb69rwA
UJIrs4alo81qGQ32UFhjuMQjX75O9Od1HWHDj5PFaT/Ja5Ly+bK8Cc3gfO6dCE81m7d+B2JBZ/Hl
tBA19QuOAYwT2EIPOdpaVtCULb33cWODWu3qQFhZMmDzKTb3kwpcr0LL

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
MnzcA2swaxH1LRacKDou0ZmiiMRETbWIdHgeBgyQz7ILronsXLoB/C20WuFNGEVSiL2/51EZ6MXZ
vMHI8fFcMQCJcuTBDBibUMKv6bXI9s8fTbtrBZppbF/R1icG5JYhqmX4aRnv4W/dxJRjI2L35nLN
Y48E9OfgfkD1sr+IRwx8WEKFmUhuk8dLe0VOK7ywe3XEcneYvrz+HhPj16bGmNfMwNnDgZ3gKKZD
hRnys+jzvAX3HyISrErWXhMKrhWMxXeTNFJCqNQ0LWAVHQYwyKnF5xVpyXSuGNSIrva+QXqOrZBG
3VNLirNVtMRiKLfwZeMaqvswkqBDAa53utlAAA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
d0xXkKtsKM8GvXhDZr16p1+oE3uBtD04BJ76eGGIEj/CFECfHVy9qsJ43oSKjas0+AJr4GFFnVb6
X7gJV6MmX/OboC9ier5joUCGz0mxVzkRZK9a+LPEDcg0K6+cLE36kr+FfxW9Uk2816EHBCMCf5mK
A4eAhSmAb5Nq74F/q0quiG416npbny7faiQ+xmPDfYYiM3UuMKaD4iE8ODlz1w5xThPllWESf3LZ
NTkw6fozyTqZ47vvE21O3dgIGAY1v+C6BwlCK24VwPJa1xs9csY+qTk31j5jjAc1ExlB6QF7t9UH
lk70qdNPWxT87OH7kFT8UvPO1D6BTC3/WkDZfA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LYhdzKTvo93uJrAaiP5OfCDuOnu2BSvPnxlv6I7h2n1+xHtj34LNNKzWEgOg9dUV9cYDaHYUjjEt
DKdWcz6mZ61d5qyxAhpv67fc90v7JVgtOAcT94/Yb+AuLxXFcGA6Gic7uoJtUgz6JmTnb22Dxdjc
KuIewDj4IOTfP8XGXKTaF+cNp0CFrQgTAcVSQFyLFxr0I/9h3S+GZLecA7ntEeHEOfCJzPvy0ddi
7MCdQWECLb+fXC0IAn8V95TumcpINiRAX1BHi9IGJ4QoMrb3jOCrPkFhDMTJj2aiImUWdi/l/0QE
d7wcXlgIEYVeoKYUOJ4mqy+zZPUbLNeOPADUDQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20528)
`pragma protect data_block
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
qFhhrWDv+qA=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif

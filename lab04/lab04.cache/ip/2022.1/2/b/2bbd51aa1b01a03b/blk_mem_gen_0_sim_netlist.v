// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Tue Jul  7 19:49:40 2026
// Host        : laptop_070628 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k70tfbv676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_5 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20544)
`pragma protect data_block
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
lroYrIO4GY/GKAKq+ZmdqUZsD8m9ejti
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

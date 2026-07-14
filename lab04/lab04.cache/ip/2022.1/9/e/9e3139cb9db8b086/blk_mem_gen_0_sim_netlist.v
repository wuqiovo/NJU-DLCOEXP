// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Tue Jul  7 20:06:24 2026
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
rcLafcwbTVIKgsawJ3hCJ/jyrZEqfFhP
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

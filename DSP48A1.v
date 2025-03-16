module DSP48A1(
    input [17:0] A,B,D,BCIN,
    input [47:0] C,PCIN,
    input CLK,CARRYIN,
    input RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
    input CEA,CEB,CEC,CEM,CEP,CED,CECARRYIN,CEOPMODE,
    input [7:0] OPMODE,
    output [17:0] BCOUT,
    output [47:0] PCOUT,
    output [47:0] P,
    output [35:0] M,
    output CARRYOUT,CARRYOUTF
);
parameter A0REG = 0;
parameter A1REG = 1;
parameter B0REG = 0;
parameter B1REG = 1;
parameter CREG = 1;
parameter DREG = 1;
parameter MREG = 1;
parameter PREG = 1;
parameter CARRYINREG = 1;
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;
parameter CARRYINSEL = "OPMODE5";
parameter B_INPUT = "DIRECT";
parameter RSTTYPE = "SYNC";

// Internal signals
wire [17:0] outA0_reg,outB0_reg,outA1_reg,outB1_reg,outD_reg;
wire [47:0] outC_reg;
wire [7:0] outOPMODE_reg;
wire [17:0] B_selected;
reg [17:0] Pre_addSub_out;
wire [17:0] inB1_reg;
wire [35:0] inM_reg,outM_reg;
reg inCYI_reg;
wire CIN_reg;
reg [47:0] outX_mux,outZ_mux;
reg [48:0] Post_addSub_out;

// OPMODE Register Pipeline
DSP_pipeline #(.RSTTYPE(RSTTYPE),.DATAIN_SIZE(8)) OPMODE_REG(CLK,RSTOPMODE,CEOPMODE,OPMODE,OPMODEREG,outOPMODE_reg);

// D Register Pipeline
DSP_pipeline #(.RSTTYPE(RSTTYPE),.DATAIN_SIZE(18)) D_REG(CLK,RSTD,CED,D,DREG,outD_reg);

// B Input Selection based on B_INPUT parameter
assign B_selected = (B_INPUT == "DIRECT")  ? B : (B_INPUT == "CASCADE") ? BCIN : 18'b0;

// B0 and A0 Registers Pipeline
DSP_pipeline #(.RSTTYPE(RSTTYPE),.DATAIN_SIZE(18)) B0_REG(CLK,RSTB,CEB,B_selected,B0REG,outB0_reg);
DSP_pipeline #(.RSTTYPE(RSTTYPE),.DATAIN_SIZE(18)) A0_REG(CLK,RSTA,CEA,A,A0REG,outA0_reg);
// C Register Pipeline
DSP_pipeline #(.RSTTYPE(RSTTYPE),.DATAIN_SIZE(48)) C_REG(CLK,RSTC,CEC,C,CREG,outC_reg);

// Pre-Adder/Subtracter logic
always @(*) begin
    case (outOPMODE_reg[6])
        1'b0: Pre_addSub_out = outD_reg + outB0_reg;
        1'b1: Pre_addSub_out = outD_reg - outB0_reg;
    endcase
end
assign inB1_reg = (outOPMODE_reg[4])? Pre_addSub_out : outB0_reg;

// B1 and A1 Registers Pipeline
DSP_pipeline #(.RSTTYPE(RSTTYPE),.DATAIN_SIZE(18)) B1_REG(CLK,RSTB,CEB,inB1_reg,B1REG,outB1_reg);
DSP_pipeline #(.RSTTYPE(RSTTYPE),.DATAIN_SIZE(18)) A1_REG(CLK,RSTA,CEA,outA0_reg,A1REG,outA1_reg);
assign BCOUT = outB1_reg;

// Multiplication logic
assign inM_reg = outB1_reg * outA1_reg;

// M Register Pipeline
DSP_pipeline #(.RSTTYPE(RSTTYPE),.DATAIN_SIZE(36)) M_REG(CLK,RSTM,CEM,inM_reg,MREG,outM_reg);
// Buffer M output
assign M = ~(~outM_reg);

// Carry Cascade Input Selection based on CARRYINSEL parameter
always @(*) begin
    case (CARRYINSEL)
        "CARRYIN": inCYI_reg = CARRYIN;
        "OPMODE5": inCYI_reg = outOPMODE_reg[5];
        default: inCYI_reg = 0;
    endcase
end
// CYI Register Pipeline
DSP_pipeline #(.RSTTYPE(RSTTYPE),.DATAIN_SIZE(1)) CYI(CLK,RSTCARRYIN,CECARRYIN,inCYI_reg,CARRYINREG,CIN_reg);

// X MUX logic
always @(*) begin
    case (outOPMODE_reg[1:0])
        2'b00: outX_mux = 48'b0;
        2'b01: outX_mux = {12'b0,outM_reg};
        2'b10: outX_mux = PCOUT;
        2'b11: outX_mux = {outD_reg[11:0],outA1_reg,outB1_reg};
    endcase
end

// Z MUX logic
always @(*) begin
    case (outOPMODE_reg[3:2])
        2'b00: outZ_mux = 48'b0;
        2'b01: outZ_mux = PCIN;
        2'b10: outZ_mux = PCOUT;
        2'b11: outZ_mux = outC_reg;
    endcase
end

// Post-Adder/Subtracter logic
always @(*) begin
    case (outOPMODE_reg[7])
        1'b0: Post_addSub_out = outZ_mux + outX_mux + CIN_reg;
        1'b1: Post_addSub_out = outZ_mux - (outX_mux + CIN_reg);
    endcase
end

// P Register Pipeline
DSP_pipeline #(.RSTTYPE(RSTTYPE),.DATAIN_SIZE(48)) P_REG(CLK,RSTP,CEP,Post_addSub_out,PREG,P);
assign PCOUT = P;

// CYO Register Pipeline
DSP_pipeline #(.RSTTYPE(RSTTYPE),.DATAIN_SIZE(1)) CYO(CLK,RSTCARRYIN,CECARRYIN,Post_addSub_out[48],CARRYOUTREG,CARRYOUT);
assign CARRYOUTF = CARRYOUT;

endmodule
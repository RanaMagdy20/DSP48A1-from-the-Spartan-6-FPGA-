module PROJECT1(A,B,C,D,clk,carryIN,opmode,M,P,carryOUT,carryOUTF,ceA,ceB,ceC,ceD,ceM,ceCIN,ceOPMODE,ceP,
	              rstA,rstB,rstC,rstD,rstM,rstP,rstCIN,rstOPMODE,BCIN,BCOUT,PCIN,PCOUT);

parameter A0REG=0;
parameter A1REG=1;
parameter B0REG=0;
parameter B1REG=1;
parameter CREG=1;
parameter DREG=1;
parameter MREG=1;
parameter PREG=1;
parameter CARRYINREG=1;
parameter CARRYOUTREG=1;
parameter OPMODEREG=1;
parameter CARRYINSEL="OPMODE5";
parameter B_INPUT="DIRECT";
parameter RSTTYPE="SYNC";
input carryIN,clk,ceA,ceB,ceC,ceD,ceM,ceCIN,ceOPMODE,ceP,rstA,rstB,rstC,rstD,rstM,rstP,rstCIN,rstOPMODE;
input [17:0]A,B,D,BCIN;
input [47:0]C,PCIN;
input [7:0]opmode;
output carryOUT,carryOUTF;
output reg [17:0]BCOUT;
output reg [47:0]PCOUT;   
output[47:0]P;
output reg [35:0]M;
reg [17:0]ADDER_1,B1_regIN;
wire [17:0]D_regOUT,A0_regOUT,B0_regOUT,A1_regOUT,B1_regOUT;

wire [17:0]B_MUX;
reg [47:0]conc,X_MUX,Z_MUX,ADDER_2;
wire [47:0]C_regOUT;
wire cout,cin_mux;
wire cin;         //reg 
reg [35:0]multiply_OUT;
wire [35:0]M_regOUT;
wire [7:0]opmode_reg;
wire [47:0]P_regOUT;

REG_MUX_S #(.select(DREG),.WIDTH(18),.RSTTYPE(RSTTYPE)) m1(D,clk,ceD,rstD,D_regOUT);                         //D 
REG_MUX_S #(.select(A0REG),.WIDTH(18),.RSTTYPE(RSTTYPE)) m2(A,clk,ceA,rstA,A0_regOUT);                      //A0
REG_MUX_S #(.select(A1REG),.WIDTH(18),.RSTTYPE(RSTTYPE)) m3(A0_regOUT,clk,ceA,rstA,A1_regOUT);              //A1
REG_MUX_S #(.select(B0REG),.WIDTH(18),.RSTTYPE(RSTTYPE)) m4(B_MUX,clk,ceB,rstB,B0_regOUT);                  //B0
REG_MUX_S #(.select(B1REG),.WIDTH(18),.RSTTYPE(RSTTYPE)) m5(B1_regIN,clk,ceB,rstB,B1_regOUT);              //B1
REG_MUX_S #(.select(CREG),.WIDTH(48),.RSTTYPE(RSTTYPE)) m6(C,clk,ceC,rstC,C_regOUT);                        //C
REG_MUX_S #(.select(MREG),.WIDTH(36),.RSTTYPE(RSTTYPE)) m7(multiply_OUT,clk,ceM,rstM,M_regOUT);             //multiply
REG_MUX_S #(.select(PREG),.WIDTH(48),.RSTTYPE(RSTTYPE)) m8(ADDER_2,clk,ceP,rstP,P_regOUT);                         //p
REG_MUX_S #(.select(CARRYOUTREG),.WIDTH(1),.RSTTYPE(RSTTYPE)) m9(cout,clk,ceCIN,rstCIN,carryOUT);    
REG_MUX_S #(.select(CARRYINREG),.WIDTH(1),.RSTTYPE(RSTTYPE))  m10(cin,clk,ceCIN,rstCIN,cin_mux); 
REG_MUX_S #(.select( OPMODEREG),.WIDTH(8),.RSTTYPE(RSTTYPE))  m11(opmode,clk,ceOPMODE,rstOPMODE,opmode_reg); 

 assign opmode_reg[5]=1;
 assign B_MUX=(B_INPUT=="DIRECT")? B:BCIN;  
 assign cin=(CARRYINSEL=="OPMODE5")? opmode_reg[5]:carryIN;
 assign P=P_regOUT;
 assign cout=ADDER_2[47];
 assign carryOUTF=carryOUT;
 assign M_regOUT=multiply_OUT;

 //opmode block
always @(posedge clk)begin

 conc={D[11:0],A[17:0],B[17:0]};

  case(opmode_reg[6])
   0:ADDER_1=D_regOUT+B0_regOUT;
   1:ADDER_1=D_regOUT-B0_regOUT;
  endcase

case(opmode_reg[4])
   0:B1_regIN=B0_regOUT;
   1:B1_regIN=ADDER_1;
  endcase

  case(opmode_reg[1:0])
   00:X_MUX=0;
   01:X_MUX={{12{M_regOUT[35]}},M_regOUT};
   10:X_MUX=PCOUT;
   11:X_MUX=conc; 
  endcase

   case(opmode_reg[3:2])
   00:Z_MUX=0;
   01:Z_MUX=PCIN;
   10:Z_MUX=PCOUT;
   11:Z_MUX=C_regOUT; 
  endcase

  case(opmode_reg[7])
   0:ADDER_2=Z_MUX+X_MUX+cin_mux;
   1:ADDER_2=Z_MUX-(X_MUX+cin_mux);
  endcase
 
 multiply_OUT<=B1_regOUT*A1_regOUT;
 M<=M_regOUT;

end

endmodule
































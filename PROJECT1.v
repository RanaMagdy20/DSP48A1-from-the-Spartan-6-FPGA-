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
input [17:0]A,B,D,BCIN,B_MUX;
input [47:0]C,PCIN;
input [7:0]opmode;
output carryOUT,carryOUTF;
output reg [17:0]BCOUT;
output reg [47:0]P,PCOUT;
output reg [35:0]M;
reg [17:0]D_regOUT,A0_regOUT,B0_regOUT,A1_regOUT,B1_regOUT,ADDER_1,B1_regIN;
reg [47:0]C_regOUT,conc,X_MUX,Z_MUX,ADDER_2;
reg cin,cout,cin_mux;
reg [35:0]M_regOUT,multiply_OUT;

REG_MUX_S m1(D,clk,ceD,rstD,D_regOUT);       //D 
REG_MUX_S m2(A,clk,ceA,rstA,A0_regOUT);         //A0
REG_MUX_S m3(A0_regOUT,clk,ceA,rstA,A1_regOUT); //A1
REG_MUX_S m4(B_MUX,clk,ceB,rstB,B0_regOUT);     //B0
REG_MUX_S m5(B0_regOUT,clk,ceB,rstB,B1_regOUT); //B1
REG_MUX_S m6(C,clk,ceC,rstC,C_regOUT);          //C
REG_MUX_S m7(multiply_OUT,clk,ceM,rstM,M_regOUT); //multiply
REG_MUX_S m8(ADDER_2,clk,ceP,rstP,P);             //p
REG_MUX_S m9(cout,clk,ceCIN,rstCIN,carryOUT);    
REG_MUX_S m10(cin,clk,ceCIN,rstCIN,cin_mux); 



module REG_MUX_S(D,clk,E,rst,Q); 
 parameter select=1;
  input [47:0]D;
  input clk,rst,E;
  output [47:0]Q;  //---->MUX
   reg [47:0]result_SYNC,result_ASYNC;

   always @(posedge clk)begin
   if(E)begin
   	if(rst)
   	 result_SYNC<=0;
   else 
    result_SYNC<=D;
   end
  end
  
   always @(posedge clk or posedge rst)begin
   if(E)begin
   	if(rst)
   	 result_ASYNC<=0;
   else 
   result_ASYNC<=D;
   end
  end

  assign Q=(select==1)? result_SYNC:result_ASYNC;

  endmodule
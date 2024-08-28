module ram_tb();
parameter MEM_WIDTH=16;
parameter MEM_DEPTH=1024;
parameter ADDR_SIZE=10;
reg clk,rst,wr_en,rd_en,blk_select,addr_en,dout_en;
reg[ADDR_SIZE-1:0]addr; 
reg [MEM_WIDTH-1:0]din;
wire parity_out;
wire [MEM_WIDTH-1:0]dout;
ram dut(dout,parity_out,din,addr,wr_en,rd_en,blk_select,addr_en,dout_en,clk,rst);
integer i=0;
initial begin 
	$readmemb("mem.dat",dut.mem);
end
initial begin
clk=0;
forever
#2 clk=~clk;
end
initial begin
	rst=1;
	wr_en=1;
	rd_en=0;
	blk_select=0;
	addr_en=1;
	dout_en=1;
	din=0;
	addr=0;
	#50;
	blk_select=1;
	rst=0;
	#50;
	for(i=0;i<100;i=i+1)begin
		@(negedge clk)
		din=$random;
		wr_en=$random;
		rd_en=~wr_en;
		addr=addr+1;
		if(addr==10)
		addr=0;
	end
	$stop;
end
endmodule

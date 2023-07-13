module top_tb();
reg Hclk;
reg Hresetn;

wire [31:0] Hrdata,Haddr,Hwdata,Prdata,Paddr,Pwdata,Paddrout,Pwdataout;
wire Hwrite,Hreadyin;
wire[1:0] Htrans;
wire [1:0] Hresp=0;
wire Penable,Pwrite,Hreadyout,Pwriteout,Penableout;
wire [2:0] Pselx,Pselxout;

AHB_Master AHB(Hclk,Hresetn,Hresp,Hrdata,Hwrite,Hreadyin,Hreadyout,Htrans,Hwdata,Haddr);

Bridge_Top BRIDGE (Hclk,Hresetn,Hwrite,Hreadyin,Hreadyout,Hwdata,Haddr,Htrans,Prdata,Penable,Pwrite,Pselx,Paddr,Pwdata,Hreadyout,Hresp,Hrdata);

APB_Interface APB (Pwrite,Pselx,Penable,Paddr,Pwdata,Pwriteout,Pselxout,Penableout,Paddrout,Pwdataout,Prdata);

initial 
begin
Hclk =  1'b0;
forever  #10 Hclk =~ Hclk;
end

task reset;
begin
@(negedge Hclk);
Hresetn = 1'b0;
@(negedge Hclk);
Hresetn = 1'b1;
end 
endtask


initial
begin
reset;
AHB.burst_4_incr_write();

end
endmodule

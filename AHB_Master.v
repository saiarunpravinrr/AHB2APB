module AHB_Master(
input Hclk,Hresetn,Hreadyout,
input [1:0]Hresp,
input [31:0] Hrdata,
output reg Hwrite,Hreadyin,
output reg [1:0] Htrans,
output reg [31:0] Hwdata,Haddr);

reg [2:0] Hburst;
reg [2:0] Hsize;
integer i;


//single write
task single_write();
 begin
  @(posedge Hclk)
  #1;
   begin
    Hwrite=1;
    Htrans=2'd2;
    Hsize=0;
    Hburst=0;
    Hreadyin=1;
    Haddr=32'h8000_0000;
   end
  
  @(posedge Hclk)
  #2;
   begin
    Htrans=2'd0;
    Hwdata=32'h24;
   end 
 end
endtask


//single read
task single_read();
 begin
  @(posedge Hclk)
  #1;
   begin
    Hwrite=0;
    Htrans=2'd2;
    Hsize=0;
    Hburst=30;
    Hreadyin=1;
    Haddr=32'h8000_0000;
   end
  
  @(posedge Hclk)
  #1;
   begin
    Htrans=2'b00;
   end 
 end
endtask

//Burst_4_incr_write
task burst_4_incr_write();
begin
@(posedge Hclk)
#1;
begin
Hwrite=1;
Htrans=2'd2;
Hsize=0;
Hburst=0;
Hreadyin=1;
Haddr=32'h8000_0000;
end

@(posedge Hclk)
#1;
begin
Haddr = Haddr+1;
Hwdata={$random}%256;  // generate value between 0 to 255
Htrans=2'd3;
end

for(i=0;i<2;i=i+1)
begin
@(posedge Hclk)
@(posedge Hclk)
#1;
begin
   Haddr = Haddr+1;
   Hwdata={$random}%256;  // generate value between 0 to 255
   Htrans=2'd3;
end
end

/*@(posedge Hclk)
 #1;
begin
  Hwdata={$random}%256;
  Htrans=2'd0;
end*/
end
endtask


/*task burst_4_incr_write();
begin
  @(posedge Hclk) #1;
  begin
    Hwrite = 1;
    Htrans = 2'd2;
    Hsize = 0;
    Hburst = 0;
    Hreadyin = 1;
    Haddr = 32'h8000_0000;
  end

  @(posedge Hclk) #1;
  begin
    Haddr = Haddr + 1;
    Hwdata = $random % 256; // generate value between 0 to 255
    Htrans = 2'd3;
  end

  @(posedge Hclk) #1;
  begin
    Haddr = Haddr + 1;
    Hwdata = $random % 256; // generate value between 0 to 255
    Htrans = 2'd3;
  end

  repeat (2) begin
    @(posedge Hclk) #1;
    begin
      Haddr = Haddr + 1;
      Hwdata = $random % 256; // generate value between 0 to 255
      Htrans = 2'd3;
    end
  end

  @(posedge Hclk) #1;
  begin
    Haddr = Haddr + 1;
    Hwdata = $random % 256; // generate value between 0 to 255
    Htrans = 2'd0;
  end
end
endtask*/



endmodule

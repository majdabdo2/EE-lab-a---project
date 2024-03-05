
module swap (

					input	logic	clk, 
					input	logic	resetN, 
					input logic	DRredghost, 
					input logic	DRgreenghost,
					input logic [7:0] RGBoutredghost,
					input logic [7:0] RGBoutgreenghost ,
					input logic fivesec,
					input logic reset,
					
					
					
					output logic	DRred,
					output logic	DRgreen,
					output logic [7:0] RGBoutred,
					output logic [7:0] RGBoutgreen
					

 ) ;

logic [7:0] tempredP;
logic tempred1P;
logic [7:0] tempredN;
logic tempred1N;
logic [7:0] tempgreenP;
logic tempgreen1P;
logic [7:0] tempgreenN;
logic tempgreen1N;
enum logic [1:0] {one,second} ps,ns;



always_ff@(posedge clk or negedge resetN)
begin
 if(!resetN)
	begin 
		ps<=one;
		tempredP<=RGBoutredghost;
		tempred1P<=DRredghost;
		tempgreenP<=RGBoutgreenghost;
		tempgreen1P<=DRgreenghost;
	end 
	else if(reset)
	begin 
		tempredP<=RGBoutredghost;
		tempred1P<=DRredghost;
		tempgreenP<=RGBoutgreenghost;
		tempgreen1P<=DRgreenghost;
	end 
	else begin
	ps<=ns;
	tempredP<=tempredN;
	tempred1P<=tempred1N;
	tempgreenP<=tempgreenN;
	tempgreen1P<=tempgreen1N;
	end

end



always_comb 
begin
	ns=ps;
	tempredN=tempredP;
	tempred1N=tempred1P;
	tempgreenN=tempgreenP;
	tempgreen1N=tempgreen1P;
	case(ps)
	
	one:begin
		tempredN=RGBoutredghost;
		tempred1N=DRredghost;
		tempgreenN=RGBoutgreenghost;
		tempgreen1N=DRgreenghost;
		if(fivesec)
		begin
			ns=second;
		end
		
	end
	second:begin
		tempredN=RGBoutgreenghost;
		tempred1N=DRgreenghost;
		tempgreenN=RGBoutredghost;
		tempgreen1N=DRredghost;
		if(fivesec)
		begin
			ns=one;
		end
		
	end
	
	endcase
		
	end



assign	DRred=tempred1P;
assign	DRgreen=tempgreen1P;
assign  RGBoutred=tempredP;
assign  RGBoutgreen=tempgreenP;



endmodule

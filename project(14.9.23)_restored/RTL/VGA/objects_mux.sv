
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021
module	objects_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // smiley 
					input		logic	smileyDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] smileyRGB, 
					     
					input		logic	boxDrawingRequest, 
					input		logic	[7:0] boxRGB, 			
			  
		  ////////////////////////
		  // background 
					input    logic HartDrawingRequest, // box of numbers
					input		logic	[7:0] hartRGB,
					input		logic	WallawingRequest,
					input    logic [7:0]WallRGB,
					input		logic	ghostRequest,
					input    logic [7:0]ghostGB,
					input		logic	green_ghostRequest,
					input    logic [7:0]green_ghostGB,
					input		logic	[7:0] backGroundRGB,
					input		logic	BGDrawingRequest, 
					input		logic	[7:0] RGB_MIF,
					input		logic	numberDrawingRequest_hund, 
					input		logic	[7:0] RGBNum_hund,
					input		logic	numberDrawingRequest_ten, 
					input		logic	[7:0] RGBNum_ten,
					input		logic	numberDrawingRequest_one, 
					input		logic	[7:0] RGBNum_one,
					input		logic	LifeDrawingRequest, 
					input		logic	[7:0] LifeRGB,
					input		logic	WoodenWallDrawingRequest,
					input    logic [7:0]WoodenWallRGB,
					input		logic	AxeDrawingRequest,
					input    logic [7:0]AxeRGB,
					input		logic start,
					input    logic win,
					input    logic lose,
					input 	logic	drawingRequest_win, 
					input 	logic	[7:0] RGBout_win,
					input 	logic	drawingRequest_lose, 
					input 	logic	[7:0] RGBout_lose,
					input 	logic	drawingRequest_start, 
					input 	logic	[7:0] RGBout_start,
					input		logic	StoneWallDrawingRequest,
					input    logic [7:0]StoneWallRGB,



				
			  
				   output	logic	[7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
	
	
	
		if(start && drawingRequest_start)begin
		
			RGBOut <= RGBout_start;

		end
		else if(lose && drawingRequest_lose) begin
		
					RGBOut <= RGBout_lose;
		
		end
		else if(win && drawingRequest_win)begin
					RGBOut <= RGBout_win;
		
		end
		else if (smileyDrawingRequest == 1'b1 )   
			RGBOut <= smileyRGB;  //first priority 
		else if (numberDrawingRequest_hund == 1'b1)
				RGBOut <= RGBNum_hund;
				
	   else if (numberDrawingRequest_ten == 1'b1)
				RGBOut <= RGBNum_ten;
				
		else if (numberDrawingRequest_one == 1'b1)
				RGBOut <= RGBNum_one;
				
		else if (LifeDrawingRequest == 1'b1)
				RGBOut <= LifeRGB;
				
		else if (AxeDrawingRequest == 1'b1)
				RGBOut <= AxeRGB;

 		else if (boxDrawingRequest == 1'b1)
				RGBOut <= boxRGB;

 		else if (HartDrawingRequest == 1'b1)
				RGBOut <= hartRGB;
						
		else if(WallawingRequest==1'b1)
				RGBOut <= WallRGB;
				
		else if(WoodenWallDrawingRequest==1'b1)
				RGBOut <= WoodenWallRGB;
				
		else if(StoneWallDrawingRequest==1'b1)
				RGBOut <= StoneWallRGB;
				
		else if(ghostRequest==1'b1)
				RGBOut <= ghostGB;
				
		else if(green_ghostRequest==1'b1)
				RGBOut <= green_ghostGB;
				
		else if (BGDrawingRequest == 1'b1)
				RGBOut <= backGroundRGB ;
		else RGBOut <= RGB_MIF ;// last priority 
		end ; 
	end

endmodule



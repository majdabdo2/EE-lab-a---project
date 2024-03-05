// (c) Technion IIT, Department of Electrical Engineering 2020 

// Implements a slow clock as an one-second counter
// Turbo input sets output 10 times faster

 
 module   counter_for_audio  	(
   // Input, Output Ports
	input  logic clk, 
	input  logic resetN, 
	input  logic collosion,
	input	 logic win,
	input	 logic lose,

	
	output logic enable
   );
	
	int oneSecCount ;
	int sec ;		 // gets either one seccond or Turbo top value

// counter limit setting 
	
//       ----------------------------------------------	
	localparam oneSecVal = 26'd15_000_000; // for DE10 board un-comment this line 
	//localparam oneSecVal = 26'd20; // for quartus simulation un-comment this line 
//       ----------------------------------------------	
	
	assign  sec =  oneSecVal;  // it is legal to devide by 10, as it is done by the complier not by logic (actual transistors) 


	
   always_ff @( posedge clk or negedge resetN )
   begin
	
		// asynchronous reset
		if ( !resetN ) begin
			enable <= 1'b0;
			oneSecCount <= 26'd0;
		end // if reset
		
		
		// executed once every clock 	
		else begin
		if(collosion || win || lose) begin 
			enable <= 1'b1;
			oneSecCount <= 0;
			end
			if (oneSecCount >= sec) begin
				enable <= 1'b0;
				oneSecCount <= 0 ; 
				
			end
			else begin
				oneSecCount <= oneSecCount + 1;
			end
		end // else clk
		
	end // always
endmodule

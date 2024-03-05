
module	reset_game(	input	logic	clk,
			input	logic	resetN,
			input logic reset,
			
			
			output logic reset1
		
			);





always_ff@(posedge clk or negedge resetN)
begin

if(!resetN)
begin 
	reset1=0;	
end
else if(reset==1)
begin 
	reset1=0;	
end
else
begin
	reset1=1;	
end 

end
endmodule

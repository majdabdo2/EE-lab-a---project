
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_Ball,
			input	logic	drawing_request_1,
			input	logic	drawing_request_2,
			input	logic	drawing_request_coin,
		   input	logic	drawing_request_wall,
			input	logic [7:0] WallRGB,
			input	logic	drawing_request_redghost,
			input	logic	drawing_request_greenghost,


			



			
			output logic collision, // active in case of collision between two objects
			output logic coin_collision,
			output logic SingleHitPulse, // critical code, generating A single pulse in a frame 
			output logic collision_redghost,
			output logic collision_greenghost,
		   output logic [3:0]score

);

// drawing_request_Ball   -->  smiley
// drawing_request_1      -->  brackets
// drawing_request_2      -->  number/box 


assign collision1 = ( drawing_request_Ball &&  drawing_request_1 );// any collision 
						 						
						
// add colision between number and Smiley
//_______________________________________________________


assign collision_smiley_number  = ( drawing_request_Ball &&  drawing_request_2 );

assign collision_red_block  = ( drawing_request_Ball && drawing_request_wall && WallRGB==8'he0 );

assign coin_collision = ( drawing_request_Ball &&  drawing_request_coin );

assign collision_redghost = ( drawing_request_wall &&  drawing_request_redghost );

assign collision_greenghost = ( drawing_request_wall &&  drawing_request_greenghost );






assign collision =  collision1 || collision_smiley_number || collision_red_block ;



logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ;
		score=4'h0;
	end 
	else begin 

			SingleHitPulse <= 1'b0 ; // default 
			score<=score;
			if(startOfFrame) 
				flag <= 1'b0 ; // reset for next time 
				
//		change the section below  to collision between number and smile
 if(coin_collision)begin
	score<=score+1'h1;
 end
 

if(collision_red_block  && (flag == 1'b0))
		begin
				
    			flag	<= 1'b1; // to enter only once 
				SingleHitPulse <= 1'b1; 
		end 
 else if ( collision1  && (flag == 1'b0)) begin 
			
			
			flag	<= 1'b1; // to enter only once 
			SingleHitPulse <= 1'b0 ; 
		end 
	else if(collision_smiley_number  && (flag == 1'b0))
		begin
				
    			flag	<= 1'b1; // to enter only once 
				SingleHitPulse <= 1'b1 ; 
		end
			
	
	
	end 
end

endmodule

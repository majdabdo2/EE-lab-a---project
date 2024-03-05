
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
		   input	logic	drawing_request_Woodenwall,
			input	logic	drawing_request_Axe,
			input logic enter,
			input logic die,
			input logic win,
			input logic [1:0]random,
			input	logic	drawing_request_Stonewall,






			
			output logic collision, // active in case of collision between two objects
			output logic coin_collision,
			output logic SingleHitPulse, // critical code, generating A single pulse in a frame 
			output logic collision_redghost,
			output logic collision_greenghost,
		   output logic [7:0]score,
			//output logic [3:0]life_counter,
			output logic collision_pac_greenghost,
			output logic collision_pac_redghost,
			output logic [3:0]life_counter,
			output logic [3:0]Axe_counter,
			output logic collision_pac_axe,
			output logic Woodenwall_collision,
			output logic startDR,
			output logic winDR,
			output logic loseDR,
			output logic [1:0]Rand,
			output logic reset,
			output logic stop,
			output logic Stonewall_collision,
			output logic [3:0] sound





);

// drawing_request_Ball   -->  smiley
// drawing_request_1      -->  brackets
// drawing_request_2      -->  number/box 


logic [1:0]  RandN,  RandP  ; 

logic enter_tempN;
logic enter_tempP;


enum logic [2:0] {idle_state,start_state,lose_state,win_state,end_state} ps,ns;


assign collision1 = ( drawing_request_Ball &&  drawing_request_1 );// any collision 
						 						
						
// add colision between number and Smiley
//_______________________________________________________


assign collision_smiley_number  = ( drawing_request_Ball &&  drawing_request_2 );

assign collision_red_block  = ( drawing_request_Ball && (drawing_request_wall || drawing_request_Woodenwall || drawing_request_Stonewall ));

assign coin_collision = ( drawing_request_Ball &&  drawing_request_coin );

assign collision_redghost = ( (drawing_request_wall || drawing_request_Woodenwall || drawing_request_Stonewall) &&  drawing_request_redghost );

assign collision_greenghost = ( (drawing_request_wall || drawing_request_Woodenwall || drawing_request_Stonewall) &&  drawing_request_greenghost );

assign collision_pac_redghost = (drawing_request_Ball &&  drawing_request_redghost);

assign collision_pac_greenghost = (drawing_request_Ball &&  drawing_request_greenghost);

assign collision_pac_axe = (drawing_request_Ball &&  drawing_request_Axe);


assign Woodenwall_collision = ( drawing_request_Ball && drawing_request_Woodenwall);

assign Stonewall_collision = ( drawing_request_Ball && drawing_request_Stonewall);




assign collision =  collision1 || collision_smiley_number || collision_red_block ;


assign sound = (coin_collision) ? 30 : (ps == win_state ) ? 1 : (ps == lose_state) ? 2 : 0;


logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ;
		score<=4'h0;
		life_counter<=4'b0000;
		Axe_counter<=4'b0000;
		ps<=idle_state;
		RandP<=0;
		enter_tempP<=0;
		
	end 
	else if(reset)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ;
		score<=4'h0;
		life_counter<=4'b0000;
		Axe_counter<=4'b0000;
		ps<=idle_state;
		RandP<=0;
		enter_tempP<=0;
		
	end 
	else begin 

			SingleHitPulse <= 1'b0 ; // default 
			score<=score;
			life_counter<=life_counter;
			Axe_counter<=Axe_counter;
			ps<=ns;
			RandP<=RandN;
			enter_tempP<=enter_tempN;

			
			if(startOfFrame) 
				flag <= 1'b0 ; // reset for next time 
				
//		change the section below  to collision between number and smile
 if(coin_collision)begin
	score<=(score+1'h1);
 end
 
 
 
 
 
 if(collision_red_block  && (flag == 1'b0))
		begin
				
    			flag	<= 1'b1; // to enter only once 
				SingleHitPulse <= 1'b1; 
		end 
		
	 if(collision_pac_redghost)
		begin
    			flag	<= 1'b1; // to enter only once 
				if(life_counter<4'b0011)
				life_counter<=life_counter+4'b0001;
				
		end
		
		 if(collision_pac_greenghost)
		begin
    			flag	<= 1'b1; // to enter only once
				if(life_counter>4'b0000)
				life_counter<=life_counter-4'b0001;
				
		end
		
		if(collision_pac_axe)
		begin
				Axe_counter<=Axe_counter+4'h01;	
		end
		if(Woodenwall_collision && enter && Axe_counter>0)
		begin
				Axe_counter<=Axe_counter-4'h01;	
		end
		
		if(Stonewall_collision && enter && Axe_counter>1)
		begin
				Axe_counter<=Axe_counter-4'h02;	
		end
		
	
	end 
	
end


always_comb
begin

		ns = ps;
		RandN=RandP;
		enter_tempN=enter_tempP;
		startDR = 0;
	   loseDR = 0;
		winDR = 0;
		reset=0;
		stop=1;


case(ps)
			

		idle_state: begin
		
		startDR = 1;
		winDR=0;
		loseDR=0;
		reset=0;
		enter_tempN=0;
		stop=1;

		if (enter == 1'b1)
		ns = start_state;
		end

		start_state: begin
				startDR = 0;
				winDR=0;
				loseDR=0;
				reset=0;
				
				if(enter_tempP)
				begin 
					stop=0;
				end
				
				if (enter == 1'b1 && !enter_tempP) begin
					enter_tempN<=1;
					startDR = 0;
					RandN=random;
					if(random!=2'b00 && random!=2'b01 && random!=2'b10)
					begin	
					RandN=2'b00;
					end
				end

		
				if(die) begin
				
				loseDR=1;
				ns = lose_state ;
				end
		
		
				if(win) begin
			
				winDR=1;
				ns= win_state;
				end
				
		
			end
			
			
		lose_state:begin
			startDR = 0;
			winDR=0;
			loseDR=1;
	 		stop=1;

		  if(enter == 1)	begin
				ns = end_state;
				loseDR=0;
			end
		end
		
		win_state:begin
			startDR = 0;
			winDR=1;
			loseDR=0;
			stop=1;
		  if(enter == 1)	begin
				ns = end_state;
		  		winDR=0;
				
			end
		end
			
		
		end_state: begin
				startDR = 1;
				reset=1;
				stop=1;
				ns = idle_state;
			end	
	endcase
		
end
		
assign Rand=RandP;


endmodule

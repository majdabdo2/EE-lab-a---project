// A two level bitmap. dosplaying harts on the screen Apr  2023  
// (c) Technion IIT, Department of Electrical Engineering 2023 



module	WallMatrixBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic wall_collision,
					input logic [1:0] random,

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;
 

// Size represented as Number of X and Y bits 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'h00 ;// RGB value in the bitmap representing a transparent pixel 
 /*  end generated by the tool */


// the screen is 640*480  or  20 * 15 squares of 32*32  bits ,  we wiil round up to 16*16 and use only the top left 16*15 squares 
// this is the bitmap  of the maze , if there is a specific value  the  whole 32*32 rectange will be drawn on the screen
// there are  16 options of differents kinds of 32*32 squares 
// all numbers here are hard coded to simplify the  understanding 



logic[0:2][0:14][0:19][3:0]  MazeBiMapMask= 
{{{4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00},
{4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h01, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h01, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h01, 4'h00, 4'h01, 4'h01, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h01, 4'h01, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h01, 4'h01, 4'h00, 4'h01, 4'h01, 4'h00, 4'h00, 4'h01, 4'h01, 4'h00, 4'h00, 4'h01, 4'h00, 4'h01, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h01, 4'h00, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h00, 4'h00, 4'h01, 4'h01, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01},
{4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00}
}, 
{{4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00},
{4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h01, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h01, 4'h01, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h01, 4'h00, 4'h01, 4'h01, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h01, 4'h01, 4'h00, 4'h01, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h01, 4'h00, 4'h01, 4'h01, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h01, 4'h01, 4'h00, 4'h00, 4'h01, 4'h01, 4'h00, 4'h00, 4'h00, 4'h01, 4'h01, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h01, 4'h01, 4'h01, 4'h01, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h01, 4'h01, 4'h01, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01},
{4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00}
},
{{4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00},
{4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h01, 4'h01, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h01, 4'h01, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h01, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h01, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h01, 4'h00, 4'h00, 4'h01, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h00, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h01, 4'h01, 4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01, 4'h01, 4'h01, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h01},
{4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01, 4'h01},
{4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00, 4'h00}
}};



logic[0:31][0:31][7:0] object_colors = {
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'h00,8'h00},
	{8'h00,8'h00,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'h00,8'h00},
	{8'h00,8'h00,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'hf6,8'hc4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'hf6,8'hc4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'h00,8'h00},
	{8'h00,8'h00,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'h00,8'h00},
	{8'h00,8'h00,8'hed,8'hed,8'hc4,8'hf6,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hc4,8'hf6,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hc4,8'hf6,8'h00,8'h00},
	{8'h00,8'h00,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'h00,8'h00},
	{8'h00,8'h00,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'h00,8'h00},
	{8'h00,8'h00,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'h00,8'h00},
	{8'h00,8'h00,8'ha4,8'ha4,8'ha4,8'hf6,8'hc4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'hf6,8'hc4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'hf6,8'h00,8'h00},
	{8'h00,8'h00,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'h00,8'h00},
	{8'h00,8'h00,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hc4,8'hf6,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hc4,8'hf6,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'h00,8'h00},
	{8'h00,8'h00,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'h00,8'h00},
	{8'h00,8'h00,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'h00,8'h00},
	{8'h00,8'h00,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'h00,8'h00},
	{8'h00,8'h00,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'hf6,8'hc4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'hf6,8'hc4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'h00,8'h00},
	{8'h00,8'h00,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'h00,8'h00},
	{8'h00,8'h00,8'hed,8'hed,8'hc4,8'hf6,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hc4,8'hf6,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hc4,8'hf6,8'h00,8'h00},
	{8'h00,8'h00,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'h00,8'h00},
	{8'h00,8'h00,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'h00,8'h00},
	{8'h00,8'h00,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'h00,8'h00},
	{8'h00,8'h00,8'ha4,8'ha4,8'ha4,8'hf6,8'hc4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'hf6,8'hc4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'hf6,8'h00,8'h00},
	{8'h00,8'h00,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'h00,8'h00},
	{8'h00,8'h00,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hc4,8'hf6,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'hc4,8'hf6,8'hed,8'hed,8'hed,8'hed,8'hed,8'hed,8'h00,8'h00},
	{8'h00,8'h00,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'h00,8'h00},
	{8'h00,8'h00,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'h00,8'h00},
	{8'h00,8'h00,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'ha4,8'hfa,8'hed,8'hc4,8'hc4,8'hc4,8'hc4,8'hc4,8'h00,8'h00},
	{8'h00,8'h00,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'hf6,8'hc4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'hf6,8'hc4,8'ha4,8'ha4,8'ha4,8'ha4,8'ha4,8'h00,8'h00},
	{8'h00,8'h00,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'hf6,8'hfa,8'hfa,8'hfa,8'hf6,8'hf6,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},};

 

// pipeline (ff) to get the pixel color from the array 	 

//==----------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		RGBout <= TRANSPARENT_ENCODING ; // default 

		if ((InsideRectangle == 1'b1 ) 		& 	// only if inside the external bracket 
		   (MazeBiMapMask[random][offsetY[8:5]][offsetX[9:5]] == 4'h01 )) begin // take bits 5,6,7,8,9,10 from address to select  position in the maze 
//					if(wall_collision) begin
//					 MazeBiMapMask[offsetY[8:5]][offsetX[8:5]]<=4'h00;
//					end
					RGBout <= object_colors[offsetY[4:0]][offsetX[4:0]] ; 
				end
		end 
end

//==----------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   
endmodule


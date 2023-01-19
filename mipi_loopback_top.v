module mipi_loopback_top (
/* Signals of the video pattern generator */

	input         tx_vga_clk,
	input         sw4,  // change video pattern
	input         sw5,  // bypass MIPI channels

/* Flashing LEDs to indicate successful comparison of MIPI data */

        output        led5,
        output        led6,
	
/* Clocks of MIPI TX and RX parallel interfaces */
	    
	input         tx_pixel_clk,

/* Signals used by the MIPI TX Interface Designer instance */
	    
	output        my_mipi_tx_DPHY_RSTN,
	output        my_mipi_tx_RSTN,
	output        my_mipi_tx_VALID,
	output        my_mipi_tx_HSYNC,
	output        my_mipi_tx_VSYNC,
	output [63:0] my_mipi_tx_DATA,
	output [5:0]  my_mipi_tx_TYPE,
	output [1:0]  my_mipi_tx_LANES,
	output        my_mipi_tx_FRAME_MODE,
	output [15:0] my_mipi_tx_HRES,
	output [1:0]  my_mipi_tx_VC,
	output [3:0]  my_mipi_tx_ULPS_ENTER,
	output [3:0]  my_mipi_tx_ULPS_EXIT,
	output        my_mipi_tx_ULPS_CLK_ENTER,
	output        my_mipi_tx_ULPS_CLK_EXIT
    );

  wire rst_n = 1'b1;
//-----------------------------------------------------------//
// 800*600 VGA
//-----------------------------------------------------------//
parameter syncPulse_h= 80;            
parameter backPorch_h= 50;             
parameter activeVideo_h= 640;            
parameter frontPorch_h= 50; 
           
parameter syncPulse_v= 80;              
parameter backPorch_v = 5;             
parameter activeVideo_v = 480;            
parameter frontPorch_v = 5;

parameter FIFO_ADDR_WIDTH = 12;
parameter FIFO_DEPTH = (1 << FIFO_ADDR_WIDTH);

localparam HALF_FIFO_DEPTH = FIFO_DEPTH >> 1;
localparam total_pixel = activeVideo_h * activeVideo_v;
   
 

//**************************
// Pattern generation module
//**************************
   
wire[3:0] video_pattern;
wire[4:0]  vga_r_patgen;
wire[5:0]  vga_g_patgen;
wire[4:0]  vga_b_patgen; 

wire hsync_patgen;
wire vsync_patgen; 
wire valid_h_patgen;
wire valid_v_patgen;

wire [9:0] x,y;
video_gen #(.syncPulse_h (syncPulse_h),
            .backPorch_h (backPorch_h),
            .activeVideo_h (activeVideo_h),
            .frontPorch_h (frontPorch_h),
            .syncPulse_v (syncPulse_v),
            .backPorch_v (backPorch_v),
            .activeVideo_v (activeVideo_v),
            .frontPorch_v (frontPorch_v)
            ) patgen (
                    .rst (~rst_n),
                    .clk (tx_vga_clk),
                    .video_pattern (video_pattern),
                    .video_valid_h_o (valid_h_patgen),
                    .video_valid_h_o_2 (),
                    .video_hsync_o (hsync_patgen),
                    .video_hsync_o_2 (),
                    .video_vsync_o (vsync_patgen),
                    .video_valid_v_o (valid_v_patgen),
                    .red_o (vga_r_patgen),
                    .green_o (vga_g_patgen),
                    .blue_o (vga_b_patgen),
                    .x(x),
                    .y(y)
                    );


//***************
// MIPI TX HOOKUP
//***************

wire valid_data ;
wire [64:0]pixel_data;
reg [25:0]i;
reg char;
wire [23:0] pixel_0, pixel_1;
always @(posedge tx_vga_clk)begin
    if(valid_h_patgen)i <= i + 1;
end



assign pixel_data = ( y > 100 && y < (480-100) && x > 100  && x < (640-100))?64'h204f4c4c4548: 64'h00FFFF00FFFF;
                    //(i[25:24]==2'b10)?64'h00ff0000ff00:
                    //(i[25:24]==2'b11)?64'h0000ff0000ff:
                                          //  64'hFFFFFFFFFFFF;                                         
assign my_mipi_tx_DPHY_RSTN = 1'b1;
assign my_mipi_tx_RSTN = 1'b1;
assign my_mipi_tx_VALID = valid_h_patgen;
assign my_mipi_tx_HSYNC = hsync_patgen;//hsync_patgen_PC;
assign my_mipi_tx_VSYNC = vsync_patgen;//vsync_patgen_PC;
assign my_mipi_tx_DATA =  pixel_data;//64'h204f4c4c4548;// tx_pixel_data_PC;//pixel_data; 64'hff0000ff0000; //: 64'd0;//tx_pixel_data_PC;//64'hFF111111000000;
assign my_mipi_tx_TYPE = 6'h24;			// RGB565
assign my_mipi_tx_LANES = 2'b01;                // 2 lanes
assign my_mipi_tx_FRAME_MODE = 1'b0;            // Generic Frame Mode
assign my_mipi_tx_HRES = activeVideo_h;         // Number of pixels per line
assign my_mipi_tx_VC = 2'b00;                   // Virtual Channel select
assign my_mipi_tx_ULPS_ENTER = 4'b0000;
assign my_mipi_tx_ULPS_EXIT = 4'b0000;
assign my_mipi_tx_ULPS_CLK_ENTER = 1'b0;
assign my_mipi_tx_ULPS_CLK_EXIT = 1'b0;

   assign led5 = hsync_patgen;//(flash_cnt==25'b0) ? 1 : flash_cnt[24];
   assign led6 = valid_data;//vsync_patgen_PC;//(flash_cnt==25'b0) ? 1 : ~flash_cnt[24];



endmodule

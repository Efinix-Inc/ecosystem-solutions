// sensor_params.svh
`ifndef CSI2_AGGREGATOR_PARAMS_SVH
`define CSI2_AGGREGATOR_PARAMS_SVH

package csi2_rx_cfg_pkg;
    // Define the structure
    typedef struct {
        int LINE_WIDTH;
		int FRAME_HEIGHT;

		int PIXEL_PER_CLK;
        int DATA_WIDTH;
		int NUM_LINES;
        bit [5:0] DEFAULT_DT;
		
    } csi2_cfg_t;

	localparam int NUM_CHANNEL  = 4;
	localparam int MAX_DATA_WIDTH = 64;
	localparam int TX_HSP  = 120; //200 ;// H-Sync Pulse
	localparam int TX_HBP  =  22;  // H-Back Porch
	localparam int TX_HACT = (1920/4);// H-Active Area (The Max. Pixel Clock of All channel)
	localparam int TX_HFP  = 122; //122; // H-Front Porch
	
	localparam int TX_SLOT_COUNT = 200 ;// Updagte Gap between V-Sync of Channel 
	
    // Define a constant array of parameters
    // This makes it easy to change your whole project in one place
    localparam csi2_cfg_t SENSOR_ARRAY [NUM_CHANNEL] = '{
        '{LINE_WIDTH: 1920, FRAME_HEIGHT: 1080, PIXEL_PER_CLK: 4, DATA_WIDTH: 64, NUM_LINES: 8, DEFAULT_DT: 6'h2B}, // CH0
        '{LINE_WIDTH: 1920, FRAME_HEIGHT: 1080, PIXEL_PER_CLK: 4, DATA_WIDTH: 64, NUM_LINES: 8, DEFAULT_DT: 6'h2B}, // CH0
		'{LINE_WIDTH: 1920, FRAME_HEIGHT: 1080, PIXEL_PER_CLK: 4, DATA_WIDTH: 64, NUM_LINES: 8, DEFAULT_DT: 6'h2B}, // CH0
		'{LINE_WIDTH: 1920, FRAME_HEIGHT: 1080, PIXEL_PER_CLK: 4, DATA_WIDTH: 64, NUM_LINES: 8, DEFAULT_DT: 6'h2B} // CH0
		
        //'{LINE_WIDTH: 640 , PIXEL_PER_CLK: 4, DATA_WIDTH: 64, NUM_LINES: 4, DEFAULT_DT: 6'h2B}, // CH0
		//'{LINE_WIDTH: 1280, PIXEL_PER_CLK: 4, DATA_WIDTH: 64, NUM_LINES: 4, DEFAULT_DT: 6'h2B}, // CH1
		//'{LINE_WIDTH: 1920, PIXEL_PER_CLK: 4, DATA_WIDTH: 64, NUM_LINES: 4, DEFAULT_DT: 6'h2B}, // CH2
		//'{LINE_WIDTH: 3840, PIXEL_PER_CLK: 4, DATA_WIDTH: 64, NUM_LINES: 4, DEFAULT_DT: 6'h2B}  // CH3
		
			
       //'{LINE_WIDTH: 1920, PIXEL_PER_CLK: 4, DATA_WIDTH: 64, NUM_LINES: 4, DEFAULT_DT: 6'h2B}, // CH0
	   // '{LINE_WIDTH: 640, PIXEL_PER_CLK: 4, DATA_WIDTH: 64, NUM_LINES: 4, DEFAULT_DT: 6'h2B}, // CH1
       // '{LINE_WIDTH: 1280, PIXEL_PER_CLK: 4, DATA_WIDTH: 64, NUM_LINES: 4, DEFAULT_DT: 6'h2B}, // CH2
       // '{LINE_WIDTH: 3840, PIXEL_PER_CLK: 4, DATA_WIDTH: 64, NUM_LINES: 4, DEFAULT_DT: 6'h2B}  // CH3
	   
	   
    };
endpackage

package csi2_rx_sim_pkg;
    // Define the structure
    typedef struct {
		int H_RES ;
		int V_RES ;
		int HSP   ;// H-Sync Pulse
		int HBP   ;// H-Back Porch
		int HFP   ;// H-Front Porch
		int VSP   ;// V-Sync Pulse
		int VBP   ;// V-Back Porch
		int VFP   ;// V-Front Porch
		int INIT_DLY ;
		int CLK   ;
		int NUM_FRAME;

    } csi2_sim_t;

	localparam int NUM_SIM  = 4;
    localparam csi2_sim_t SIM_SENSOR_ARRAY [NUM_SIM] = '{
       '{H_RES :1920, V_RES :1080, HSP   :44, HBP   :148, HFP   :88, VSP   :1, VBP   :36, VFP   :1, INIT_DLY : 1000, CLK:20, NUM_FRAME:4}, // CH0
       '{H_RES :1920, V_RES :1080, HSP   :44, HBP   :148, HFP   :88, VSP   :1, VBP   :36, VFP   :1, INIT_DLY : 1000, CLK:20, NUM_FRAME:4}, // CH0
       '{H_RES :1920, V_RES :1080, HSP   :44, HBP   :148, HFP   :88, VSP   :1, VBP   :36, VFP   :1, INIT_DLY : 1000, CLK:20, NUM_FRAME:4}, // CH0
       '{H_RES :1920, V_RES :1080, HSP   :44, HBP   :148, HFP   :88, VSP   :1, VBP   :36, VFP   :1, INIT_DLY : 1000, CLK:20, NUM_FRAME:4} // CH0
	  //  '{H_RES :640,  V_RES :20,  HSP   :44, HBP   :148, HFP   :88, VSP   :5, VBP   :36, VFP   :4, INIT_DLY : 2000, CLK:60, NUM_FRAME:3}, // CH0
      //  '{H_RES :1280, V_RES :40,  HSP   :44, HBP   :148, HFP   :88, VSP   :5, VBP   :36, VFP   :4, INIT_DLY : 3000, CLK:30, NUM_FRAME:3}, // CH1
      //  '{H_RES :1920, V_RES :60,  HSP   :44, HBP   :148, HFP   :88, VSP   :5, VBP   :36, VFP   :4, INIT_DLY : 1000, CLK:20, NUM_FRAME:3}, // CH2
      //  '{H_RES :3840, V_RES :120, HSP   :44, HBP   :148, HFP   :88, VSP   :5, VBP   :36, VFP   :4, INIT_DLY : 4000, CLK:5,  NUM_FRAME:3}  // CH3
    };
endpackage


`endif
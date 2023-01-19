### FPGA Side : 
    VGA Timings :
        Horizontal parameters:
            -Sync Pulse   : 80
            -Backporch    : 50
            -active video : 640
            -front Porch  : 50

        Vertical parameters:
            -Sync Pulse   : 80
            -Backporch    : 5
            -active video : 480
            -front Porch  : 5

    System Clocks : 
        -VGA Clock     : 12.80 MHz
        -MIPI TX Clock : 6.40  MHz

### RK3399 Driver Configuration :
    -Media bus format : MEDIA_BUS_FMT_RGB888_1X24
    -Width   : 640 
	-Height  : 480
	-Max_fps : {
			.numerator = 10000,
			.denominator = 300000,
		    }
	-hts_def = 640+100,
	-vts_def = 480+100,


     ------------------------------------------------------------
    |<-          Start of frame    |         Frame ID          ->|
    |<-Payload id 0   | payload type(N-1) | payload length(N-1)->|
    |<--------------------Payload 0----------------------------> |
    |                 ..........                               ->|
    |<-Payload id(N-1)| payload type(N-1) | payload length(N-1)->|
    |<--------------------Payload (N-1)------------------------> |
    |<-               End Of frame                             ->|
     ------------------------------------------------------------
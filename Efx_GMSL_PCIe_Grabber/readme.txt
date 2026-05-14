
# Efx_GMSL_PCIe_Grabber ( GMSL PCIe Grabber) 

This project implements a complete video acquisition pipeline using an FPGA‑based PCIe grabber card and GMSL serializer/deserializer technology.

System Overview
1) Camera Input: Four cameras, each streaming at 1920×1080 resolution.

2) Serializer Side: The four video channels are multiplexed into a single GMSL link which is implemented by the sensors hub (Please reference to EFx_GMSL_SensorHub).   

3) PCIe Grabber Card (Efinix Ti375n1156 Dev board and and ADI GMSL Deserializer Dev Board MAX96792A-BCK-EVK) : FPGA logic receives the GMSL stream, deserializes it, and extracts the four independent video feeds.

4) Host Software (host_sw): PC‑side application that captures the video streams from the PCIe card and displays them in real time.


project_root/
├── Ti375_PCIe_Grabber.xml# FGPA Deisgn Project. 
├── quick_start/          # Quick Start Bitstream of the FGPA Deisgn
├── embedded_sw/     	  # Workspace of Embedded SOC
│   └── embedded_sw/      # Firmware running inside FPGA
└── host_sw/              # PC-side applications
    ├── apps/VideoGrabber # GUI for viewing streams
    ├── driver/   		  # The PCIe Driver for the demo 
    ├── source/   		  # Source code of the GUI
	├── run_app.sh		  # Script for running the application
	

## Features
- PCEe Gen4 x4

 NOR Flash Space Mapping 
   | --------------------------------- |
   | RISC-V app                        |
   | --------------------------------- | 0x0060_0000  6 MiB
   | FPGA Gateware                     |
   | --------------------------------- | 0x0000_0000


## Installation
Please see the slide of the Demo user guide. 

## Usage
Examples of how to use the project.

## How to run design

### To run PCIe - AI Accelerator Demo
``` 
    chmod 777 run_webcam_app.sh
    ./run_webcam_app.sh
```

## Revision History
| Version | Date      | Changes                                  |
|---------|-----------|------------------------------------------|
| 1.0.0   | 2026-05-14| Initial release                          |
|----------------------------------------------------------------|


### Additional packages required for app building
- Run install_make.sh to install the following package for app building 
	- qt6-multimedia-dev
	- libboost-dev
	- libavformat-dev
	- libavdevice-dev



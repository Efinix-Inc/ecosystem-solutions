# GMSL Integration
This project highlights the integration of four cameras, streaming through a GMSL link, with output displayed on HDMI ports.


## Table of Contents
* [Overview](#overview)
* [Hardware Requirement](#hardware-requirement)
  * [GMSL Sensor Hub (4 Cameras)](#gmsl-sensor-hub-4-cameras)
  * [GMSL Video Grabber (HDMI)](#gmsl-video-grabber-hdmi)
* [Software Requirement](#software-requirement)
  * [Efinity Software](#efinity-software)
  * [Eifnity RISC-V Embedded Software IDE](#efinity-risc-v-embedded-software-ide)
  * [GMSL SerDes Public GUI Software](#gmsl-serdes-public-gui-software)
* [Getting Start](#getting-start)
  * [Configurating GMSL Sensor Hub](#configurating-gmsl-sensor-hub)
  * [Configurating GMSL Video Grabber (HDMI)](#configurating-gmsl-video-grabber-hdmi)
* [Video Display Output](#video-display-output)
* [Resource Utilization](#resource-utilization)
* [Performance](#performance)
* [Project Directory Description](#project-directory-description)
* [Useful Links](#useful-links)


## Overview
The demonstration is divided into two parts: **Sensor Hub** and **Video Grabber**.

- **Sensor Hub**  
  Aggregates video frames from four-camera inputs and packs them into a single MIPI CSI‑2 TX channel using virtual channels (VC).  
  The pixel data is then passed to the Analog Devices Inc. MAX96793 for GMSL serialization and transmission.

- **Video Grabber**  
  Deserializes the data from GMSL link with the Analog Device Inc. MAX96792A and convert to MIPI CSI‑2 packeted data to the Titanium&#8482; Ti180 FPGA.  
  The FPGA extracts the video frames from the virtual channels and output to HDMI display monitor.

<img src="docs/images/gmsl_4cam-aggregation_block-diagram.png" alt="GMSL 4-cam Aggregation Block Diagram">


## Hardware Requirement
### GMSL Sensor Hub (4 Cameras)

- [Titanium&#8482; Ti180J484-DK](https://www.efinixinc.com/products-devkits-titaniumti180j484.html)
  - Titanium&#8482; Ti180J484 Development Board
  - 2 x [Dual Raspberry Pi Camera Connector Daughter Card](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=DUAL-RPICAM-DC-UG)
  - 4 x [Raspberry Pi Camera Module 2](https://www.raspberrypi.com/products/camera-module-v2/)   *(each development kit contain 2 cameras)*
  - IMX477 Camera Connector Daughter Card
- [ADI MAX96793 DPHY Evaluation Kit (GMSL2/3 Serializer, CSI-2, P/N: MAX96793-ACK-EVK#)](https://www.analog.com/en/resources/evaluation-hardware-and-software/evaluation-boards-kits/max96717f-aak-evk.html)
- [ADI GMSL Evaluation Kit Adapter Board](https://www.analog.com/en/resources/evaluation-hardware-and-software/evaluation-boards-kits/ad-gmslcamrpi-adp.html)
- 22-pin FFC Cable (Type A)


### GMSL Video Grabber (HDMI)
- [Titanium&#8482; Ti180J484-DK](https://www.efinixinc.com/products-devkits-titaniumti180j484.html)
  - Titanium&#8482; Ti180J484 Development Board
  - IMX477 Camera Connector Daughter Card
  - [FMC-to_QSE Adapter Card (Rev. C)](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=FMC-QSE-DC-UG)
  - [HDMI Connector Daughter Card](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=HDMI-DC-UG)
- [ADI MAX96792A DPHY Evaluation Kit (GMSL2/3 De-serializer, CSI-2, P/N: MAX96792A-BCK-EVK#)](https://www.analog.com/en/resources/evaluation-hardware-and-software/evaluation-boards-kits/max96716evkit.html)
- IMX477 Camera Connector Daughter Card
- 22-pin FFC Cable (Type A)

## Software Requirement
### Efinity Software
- [v2025.2.288](https://www.efinixinc.com/support/efinity.php) 
- Follow the official [documentation](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=UG-EFN-SOFTWARE) on installation process.
### Efinity RISC-V Embedded Software IDE
- [v2025.2](https://www.efinixinc.com/support/efinity.php)
- Follow the official [documentation](https://www.efinixinc.com/support/docsdl.php?s=ef&pn=SAPPHIREUG) on installation process 
- Learn more at the [official website](https://www.efinixinc.com/products-efinity-riscv-ide.html)
### GMSL SerDes Public GUI Software
- [Version 1.6.1](https://www.analog.com/en/resources/evaluation-hardware-and-software/software/software-download?swpart=SFW0019760J) or above


## Getting Start
### Configurating GMSL Sensor Hub 
* [Setup Ti180J484-DK (Board #1)](#efx-gmsl-sensorhub-4cam/ti180j484-dk/docs/setup_sensor-hub-4cam_ti180j484-dk)
* [Setup ADI GMSL Serializer (MAX96793-ACK-EVK)](#efx-gmsl-sensorhub-4cam/ti180j484-dk/docs/setup_gmsl-serializer_max96793-ack-evk)
### Configurating GMSL Video Grabber (HDMI)
* [Setup Ti180J484-DK (Board #2)](#efx-gmsl-video-grabber-hdmi/ti180j484-dk/docs/setup_video-grabber-hdmi_ti180j484-dk)
* [Setup ADI GMSL Deserializer (MAX96792A-BCK-EVK)](#efx-gmsl-sensorhub-4cam/ti180j484-dk/docs/setup_gmsl-deserializer_max96792a)


## Video Display Output


## Resource Utilization
| Project               | Device     | XLR             | Memory Block  | DSP Block  |
|-----------------------|------------|-----------------|---------------|------------|
| Sensor Hub (4-cam)    | Ti180J484  | 81662 / 172800  | 599 / 1280    | 4 / 640    |
| Video Grabber (HDMI)  | Ti180J484  | 81299 / 172800  | 599 / 1280    | 4 / 640    |

## Performance
| Device             | Mipi Pixel Clk RX (MHz)  |  (MHz)                   | Memory Clk SOC (MHz) | Memory Clk DMA (MHz) | HDMI Clk (MHz) | SOC Clk (MHz) |
|--------------------|--------------------------|--------------------------|----------------------|----------------------|----------------|---------------|
| sensor hub         | 250                      | 215                      | 141                  | 193                  | 211            | 158           |
| Video Grabber HDMI | 232                      | 202                      | 140                  | 193                  | 194            | 160           |


## Project Directory Description
```
.
└── gmsl_integration/
    ├── docs/
    │   ├── images
    │   └── .md
    ├── efx-gmsl-sensorhub-4cam/                                 # GMSL Sensor Hub (4-cam) project folder
    │   └── ti180j484-dk/                                        # Efinity project
    │       └── docs/ 
    │       └── embeddeded_sw/                                   # RISC-V embedded software project directory
    │       └── ...
    ├── efx-gmsl-video-grabber-hdmi/                             # GMSL Video Grabber (HDMI) project folder
    │   └── ... 
    ├── prebuild/
    │   ├── bootloader/                                          # Bootloader for both firmware images
    │   │   ├── bootloader.hex 
    │   ├── fpga/                                                # Bitstream for Efinity project
    │   │   ├── efx-gmsl-sensorhub-4cam.bit
    │   │   ├── efx-gmsl-sensorhub-4cam.hex
    │   │   ├── efx-gmsl-video-grabber-hdmi.bit
    │   │   └── efx-gmsl-video-grabber-hdmi.hex
    │   ├── fw/                                                  # Compiled firmware image
    │   │   ├── efx-gmsl-sensorhub-4cam.bin
    │   │   ├── efx-gmsl-sensorhub-4cam.elf
    │   │   ├── efx-gmsl-video-grabber-hdmi.bin
    │   │   └── efx-gmsl-video-grabber-hdmi.elf
    │   └── quick_start/                                         # Combined bitstream (fpga+fw) for quick demo deployment
    │       ├── efx-gmsl-sensorhub-4cam_combined.hex
    │       ├── efx-gmsl-sensorhub-4cam_combined.rpt             # Report from combining bitstream 
    │       ├── efx-gmsl-video-grabber-hdmi_combined.hex
    │       └── efx-gmsl-video-grabber-hdmi_combined.rpt
    ├── LICENSE
    └── README.md
```

## Useful Links

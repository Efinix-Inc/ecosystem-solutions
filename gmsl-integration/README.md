# GMSL Integration




## Table of Contents

* [Overview](#overview)
* [Hardware Requirement](#hardware-requirement)
  * [efx-gmsl-sensorhub-4cam](#efx-gmsl-sensorhub-4cam)
  * [efx-gmsl-hdmi-display](#efx-gmsl-hdmi-display)
* [Software Requirement](#software-requirement)
  * [Efinity Software](#efinity-software)
  * [Eifnity RISC-V Embedded Software IDE](#efinity-risc-v-embedded-software-ide)
  * [GMSL SerDes Public GUI Software](#gmsl-serdes-public-gui-software)
* [Getting Start](#getting-start)
  * [Setup GMSL Sensor Hub](#setup-gmsl-sensor-hub)
  * [Setup GMSL Video Grabber (HDMI)](#setup-gmsl-video-grabber-hdmi)
* [Video Display Output](#video-display-output)
* [Resource Utilization](#resource-utilization)
* [Performance](#performance)
* [Project Directory Description](#project-directory-description)
* [Useful Links](#useful-links)


## Overview
This project demonstrates cameras aggregation and with GMSL links.    

## Software Requirements

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
### Setup GMSL Sensor Hub 
* [Setup Ti180J484-DK (Board #1)](#efx-gmsl-sensorhub-4cam/ti180j484-dk/docs/setup_sensor-hub-4cam_ti180j484-dk)
* [Setup ADI GMSL Serializer (MAX96793-ACK-EVK)](#efx-gmsl-sensorhub-4cam/ti180j484-dk/docs/setup_gmsl-serializer_max96793-ack-evk)
### Setup GMSL Video Grabber (HDMI)
* [Setup Ti180J484-DK (Board #2)](#efx-gmsl-video-grabber-hdmi/ti180j484-dk/docs/setup_video-grabber-hdmi_ti180j484-dk)
* [Setup ADI GMSL Deserializer (MAX96792A-BCK-EVK)](#efx-gmsl-sensorhub-4cam/ti180j484-dk/docs/setup_gmsl-deserializer_max96792)
## 
## Video Display Output
## Resource Utilization

| Project               | Device     | XLR             | Memory Block  | DSP Block  |
|-----------------------|------------|-----------------|---------------|------------|
| Sensor Hub (4-cam)    | Ti180J484  | 81662 / 172800  | 599 / 1280    | 4 / 640    |
| Video Grabber (HDMI)  | Ti180J484  | 81299 / 172800  | 599 / 1280    | 4 / 640    |


| Device             | Mipi Pixel Clk RX (MHz) | Mipi Pixel Clk TX (MHz) | Memory Clk SOC (MHz) | Memory Clk DMA (MHz) | HDMI Clk (MHz) | SOC Clk (MHz) |
|--------------------|--------------------------|--------------------------|----------------------|----------------------|----------------|---------------|
| sensor hub         | 250                      | 215                      | 141                  | 193                  | 211            | 158           |
| Video Grabber HDMI | 232                      | 202                      | 140                  | 193                  | 194            | 160           |

## Performance

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

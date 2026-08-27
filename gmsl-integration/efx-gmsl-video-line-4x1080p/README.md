# GMSL Integration : Per-Line Mode 4x1080P

# Table of Contents
* [Overview](#overview)
* [Getting Start](#getting-start)
  * [Configurating GMSL Sensor Hub](#configurating-gmsl-sensor-hub)
  * [Configurating GMSL Video Grabber (HDMI)](#configurating-gmsl-video-grabber-hdmi)
  * [Running Video Streaming Demo](#running-video-streaming-demo)
* [Result](#result)
  * [Sensor Hub User IO Behavior (Board #1)](#sensor-hub-user-io-behavior-board-1)
  * [Video Grabber User IO Behavior (Board #2)](#video-grabber-user-io-behavior-board-2)
  * [Video Display Output](#video-display-output)


# Overview
<img src="docs/images/GMSL_Block-Diagram_linemode.png" alt="GMSL 4-cam Aggregation Block Diagram" width=1000>

# Getting Start
### Configurating GMSL Sensor Hub 
* [Setup Guide: GMSL Sensor Hub - Ti180J484-DK (Board #1)](efx-gmsl-sensorhub-line-4cam/ti180j484-dk/docs/setup_sensor-hub-4cam_ti180j484-dk.md)
* [Setup Guide: GMSL Sensor Hub - ADI GMSL Serializer (MAX96793-ACK-EVK#)](efx-gmsl-sensorhub-line-4cam/ti180j484-dk/docs/setup_gmsl-serializer_max96793-ack-evk.md)
### Configurating GMSL Video Grabber (HDMI)
* [Setup Guide: Video Grabber (HDMI) - Ti180J484-DK (Board #2)](efx-gmsl-video-grabber-line-hdmi/ti180j484-dk/docs/setup_video-grabber-hdmi_ti180j484-dk.md)
* [Setup Guide: Video Grabber (HDMI) - ADI GMSL Deserializer (MAX96792A-BCK-EVK#)](efx-gmsl-video-grabber-line-hdmi/ti180j484-dk/docs/setup_gmsl-deserializer_max96792a-bck-evk.md)
### Running Video Streaming Demo
Once all the kits are configurated properly, follow the steps below to start the video streaming demonstration:
1. Connecting the Sensor Hub Deserializer and Video Grabber Serializer using GMSL cable, and connect a monitor with HDMI cable.  
<img src="docs/images/gmsl_4cam-aggregation_hw-setup.png" alt="GMSL 4-cam Aggregation Hardware Setup" width=1000>

2. Turn on the power in this sequence: 
    - ADI Serializer EVK
    - ADI Deserializer EVK
    - Titanium&#8482; Ti180J180-DK (Sensor Hub, Board #2)
    - Once color bar is shown on monitor, turn on Titanium&#8482; Ti180J480-DK (Video Grabber, Board #1)  
      <img src="docs/images/gmsl_4cam-aggregation_colorbar.png" alt="GMSL 4-cam Aggregation Colorbar" width=400>

# Result

### Sensor Hub User IO Behavior (Board #1)
* SW4: System reset
* LED7: Initialization done
* LED3-6: Camera 0-3 streaming video

### Video Grabber User IO Behavior (Board #2)
* SW4: Video mode switching: CAM0 -> CAM1 -> CAM2 -> CAM3 -> Split-screen (4 CAM multi-view ) -> Split-screen ( multi-view CAM0 and CAM1 ) -> Split-screen ( multi-view CAM2 and CAM3 ) -> CAM0 -> ...
* LED7: Initialization done
* LED3: Receiving data from GMSL link

### Video Display Output
<img src="docs/images/gmsl_4cam-aggregation_video-display.png" alt="GMSL 4-cam Aggregation Video Display Output" width=400>



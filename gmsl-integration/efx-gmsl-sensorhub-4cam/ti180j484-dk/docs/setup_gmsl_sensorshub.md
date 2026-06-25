# Setup GMSL Sensors Hub



This guide show on how to setup the development boards and sensor. This setup only applicable for Titanium Ti180J484 development board. 

<img src="images/pic_efx_gmsl_sensors_hub.png" alt="Setup TI180" width="800">


## Overall hardware required: 

4 Camera sensor inputs sensors hub related hardware are needed in the following:
- USB type-C cable 
- Universal AC to DC power adapter
- [Titanium Ti180J484 Development Kit](https://www.efinixinc.com/docs/ti180j484-devkit-ug-v1.7.pdf) 
- [Raspberry Pi Camera MOdule V2 x4 ](https://www.raspberrypi.com/products/camera-module-v2/)
- [Dual Raspberry Pi Camera Connector Daughter Card x2](https://www.efinixinc.com/docs/rpi-dual-camera-daughter-card-ug-v1.2.pdf)

## Steps for connecting the hardware to Ti180J484 Development Board and ADI GMSL Serilaizer EVK 

<img src="images/blocks_efx_gmsl_sensors_hub.png" alt="Setup TI180" width="800">

1. Prepare two Groups The Camera Configuration.  
    - In the Camea Group ,connecting two Pi Cam V2 modules to a EFX Daul Pi Cam Daughter Cards through 15 Pins FFC cable Type B( opposite side)
3. Connecting the two Camera Groups to QSE connector P2 and P1 of EFX Ti180J484 Dev board. 
4. Attach the chain of the ADI GMSL Serializer to QSE Connector P3. [Go to Setup Guide of GMSL Serializer to Efinix Dev Board](setup_gmsl_serializer.md)

5. Ensure all boards have the followings jumper settings:

| **Board**                            | **Header**                  | **Pins to Connect**                               |
|--------------------------------------|-----------------------------|---------------------------------------------------|
| Titanium Ti180J484 Development Board | J9                                                                               | N.C.                                               |
|                                      | J10, J11, J12, J13, PT1, PT17                                                    | 1 - 2 and 3 - 4                                    |
|                                      | PT2, PT3, PT4, PT5, PT6, PT7, PT8, PT9, PT10, PT11, PT12, PT13, PT14, PT15, PT16 | 1 - 2                                              |
| FMC-to-QSE Adapter Card              | J5                                                                               | 5 - 6 and 7 - 8                                    |
| Dual Raspberry PiCam Daughter Card   | J1                                                                               | 1 - 2, 3 - 4, 5 - 6, 7 - 8, 9 - 10, and 11 - 12    |

## Configuration of the Efinix Dev Boards 

<img src="images/pic_efx_programmer.png" alt="Setup TI180" width="600">

1. Download the latest Efinity Software  and install to PC. 
2. Open Efinity and click start the programmer. 
3. Choose the USB Target (i.e., Titanium Ti180 J484 Development Board). 
4. Choose the SPI Active using JTAG Bridge (New) programming mode.
5. In the Image box, click the Select Image File button and find the precomplied bitstream Combine_Efx_GMSL_SensorsHub.hex in [quick start folder](../quick_start/Combine_Efx_GMSL_SensorsHub.hex).
6. Turn on the Auto configure JTAG Bridge Image option. 
7. Ensure that the Starting Flash Address is set to 0x000000. Click Start Program button. The Programmer will configure the FPGA to JTAG Bridge mode and then program the flash device



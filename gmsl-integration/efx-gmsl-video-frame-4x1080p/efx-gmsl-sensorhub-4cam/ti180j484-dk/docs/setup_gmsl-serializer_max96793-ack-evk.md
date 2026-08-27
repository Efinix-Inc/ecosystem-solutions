# Setup Guide: GMSL Sensor Hub - ADI GMSL Serializer (MAX96793-ACK-EVK#)

## CFG PIN Settings
1. Connect the serializer board to PC through USB and power up with 12V DC Supply.
2. Open ADI GMSL SerDes GUI on PC. In the main GUI, select **Tools** > **Other Config** > **SET CFG Pin Levels**.
3. set CFG0 = 0 and CFG1 = 4, and click **Program Serializer**  
   (I2C Mode, Address 0x80, RoR; STP, 6Gbps, NRZ, Tunnel Mode)  
   <img src="images/gmsl_4cam_sh_SerDesGUI_CFG-settings.png" alt="" width="200">  
   For more details of CFG Pin Settings, refer to:
   - [MAX96793: CSI-2 to GMSL3/2 Serializer Data Sheet](https://www.analog.com/media/en/technical-documentation/data-sheets/max96793.pdf), and 
   - [MAX96793 Device Specific User Guide](https://www.analog.com/media/en/technical-documentation/user-guides/max96793-device-specific-user-guide.pdf)  
4. On the ADI Serializer CSI-2 to GMSL Adapter, select S2 to 3V3 -> CAM 1. For detail, refer to [AD-GMSLCAMRPI-ADP# Schematics](https://wiki.analog.com/_media/resources/eval/user-guides/02_075922a_top.pdf)
5. Attach the ADI Serializer CSI-2 to GMSL Adapter for interfacing with Ti180J484-DK
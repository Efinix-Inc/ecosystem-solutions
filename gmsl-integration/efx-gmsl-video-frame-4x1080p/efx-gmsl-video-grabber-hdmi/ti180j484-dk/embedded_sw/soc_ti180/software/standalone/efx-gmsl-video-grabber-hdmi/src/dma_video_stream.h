////////////////////////////////////////////////////////////////////////////
//           _____
//          / _______    Copyright (C) 2013-2022 Efinix Inc. All rights reserved.
//         / /       \
//        / /  ..    /
//       / / .'     /
//    __/ /.'      /     Description:
//   __   \       /       DMA Controller Configuration for TI180M484 dev kit OOB design
//  /_/ /\ \_____/ /
// ____/  \_______/
//
// ***********************************************************************

void mipi_i2c_init();
void hdmi_i2c_init();

void framebuffer_pattern(u32 *framebuffer, int index, int orientation);
void framebuffer_overlayMask(u32 *framebuffer, int index);

void dma_video_in_channel_execution(u32 *framebuffer, u32 channel);
void dma_video_in_channel_SG(u32 * framebuffer, struct dmasg_descriptor* input_descriptor ,u32 channel);

void dma_video_out_channel_stop(u32 channel);
void dma_video_out_channel_execution(u32 *framebuffer, u32 channel);
void dma_video_out_channel_SG(u32 * framebuffer, struct dmasg_descriptor* output_descriptor ,u32 channel );

void dma_video_out_execution(u32 *framebuffer, u32 *framebuffer2);
void dma_video_out_split_frame(u32 * framebuffer1,  u32 * framebuffer2, u32 * framebuffer3, struct dmasg_descriptor* out_descriptor);
void dma_video_out_split4_frame(u32 * framebuffer1, u32 *framebuffer2, u32 *framebuffer3, u32 *framebuffer4, struct dmasg_descriptor* out_descriptor );
void dma_video_out_frame_loop(struct dmasg_descriptor* out_descriptor);

void dma_video_in_stop();
void dma_video_in_channel_stop( u32 channel);
void dma_video_out_stop();

void framebuffer_overlayFrame(u32 *framebuffer, u32 start_x, u32 end_x, u32 start_y, u32 end_y, u32 thickness, u32 colourType);
void framebuffer_loadTable(u32 *framebuffer, u32 start_x, u32 end_x, u32 start_y, u32 end_y, u32 TableIndex);
// Should be aligned to 64 bytes !
   struct frame_descriptor {
      u32 *From_Start_X;
      u32 *From_End_Y;
      u32 *To_Start_X;
      u32 *To_Start_Y;
   };

//Custom Defined Registers that Store the Descriptor in RTL ,it will be provide the Memory allocation information when DMA controller request.
//By default the RTL provides 4 descriptors per channels, It will shift to next descriptor after DMA controller request a descriptor.
   struct cs_sg_descriptor {
      u32 ctrl_word;
      u32 src_addr;
      u32 dst_addr;
      u32 nBytes;
   };
   //ctrl_word[0] Reset the descriptor pointer
   //ctrl_word[1] Increase Descriptor Pointer
   //ctrl_word[2] sg_rsp_last
   //ctrl_word[3] sg_rsp_stallout


void dma_video_out_channel_cs_sg_execution(struct cs_sg_descriptor* cs_descriptor, u32 nCSDescriptor, u32 channel);
void dma_video_in_channel_cs_sg_execution(struct cs_sg_descriptor* cs_descriptor, u32 nCSDescriptor, u32 channel);

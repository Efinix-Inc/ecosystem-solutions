#ifndef __DMA_REGS_H__
#define __DMA_REGS_H__

/* Target internal components on EDMA control BAR */
#define EDMA_OFFSET_INT_CTRL (0x2000UL)
#define EDMA_OFFSET_CONFIG (0x0000UL)
#define EDMA_OFFSET_COMMON_SGDMA (0x1000UL)
#define EDMA_OFFSET_ENGINE_REG (0x3000UL)
#define EDMA_DESC_CTRL_MASK (~(0x1F8UL)) // 0x00f000ffUL
#define EDMA_DESC_SET_CNTRL(next_adjacent) (0x00000000UL | ((next_adjacent) << 3))

/* upper 16-bits of engine identifier register */
#define EDMA_ID_HTC 0x3100U
#define EDMA_ID_CTH 0x4100U
#define CONFIG_BLOCK_ID 0x100003UL
#define IRQ_BLOCK_ID 0x100002UL

/* bits of engine identifier register */
#define EDMA_ID_STREAM_MODE 0x1000U

/* bits of the SGDMA descriptor control field */
#define EDMA_DESC_COMPLETED (1UL << 0)
#define EDMA_DESC_STOPPED (1UL << 1)
#define EDMA_DESC_EOP (1UL << 2)
#define EDMA_PERF_RUN (1UL << 0)
#define EDMA_PERF_CLEAR (1UL << 1)
#define EDMA_PERF_AUTO (1UL << 2)

/* bits of the SG DMA control register */
#define EDMA_CTRL_RUN_STOP (1UL << 0)
#define EDMA_CTRL_IE_INVALID_LENGTH (1UL << 1)
#define EDMA_CTRL_IE_IDLE_STOPPED (1UL << 2)
#define EDMA_CTRL_IE_DESC_ALIGN_MISMATCH (1UL << 3)
#define EDMA_CTRL_IE_MAGIC_STOPPED (1UL << 4)
#define EDMA_CTRL_IE_DESC_STOPPED (1UL << 5)
#define EDMA_CTRL_IE_DESC_COMPLETED (1UL << 6)
#define EDMA_CTRL_NON_INCR_ADDR (1UL << 9)
#define EDMA_CTRL_POLL_MODE_WB (1UL << 10)
#define EDMA_CTRL_STM_MODE_WB (1UL << 11)
#define EDMA_CTRL_IE_READ_ERROR (0x1FUL << 13)
#define EDMA_CTRL_IE_DESC_ERROR (0x1FUL << 23)

/* bits of the SG DMA interrupt mask enable register */
#define EDMA_INTR_MASK_ALIGN_MISMATCH (1UL << 1)
#define EDMA_INTR_MASK_MAGIC_STOPPED (1UL << 2)
#define EDMA_INTR_MASK_INVALID_LENGTH (1UL << 3)
#define EDMA_INTR_MASK_IDLE_STOPPED (1UL << 4)
#define EDMA_INTR_MASK_DESC_STOPPED (1UL << 5)
#define EDMA_INTR_MASK_DESC_COMPLETED (1UL << 6)
#define EDMA_INTR_MASK_DESC_ERROR (1UL << 9)
#define EDMA_INTR_MASK_WRITE_ERROR (1UL << 14)
#define EDMA_INTR_MASK_READ_ERROR (1UL << 19)

/* bits of the SG DMA status register */
#define EDMA_STAT_BUSY (1UL << 0)
#define EDMA_STAT_ALIGN_MISMATCH (1UL << 1)
#define EDMA_STAT_MAGIC_STOPPED (1UL << 2)
#define EDMA_STAT_INVALID_LEN (1UL << 3)
#define EDMA_STAT_IDLE_STOPPED (1UL << 4)
#define EDMA_STAT_DESC_STOPPED (1UL << 5)
#define EDMA_STAT_DESC_COMPLETED (1UL << 6)

#define EDMA_STAT_COMMON_ERR_MASK \
        (EDMA_STAT_ALIGN_MISMATCH | EDMA_STAT_MAGIC_STOPPED | EDMA_STAT_INVALID_LEN)

/* desc_error, CTH & HTC */
#define EDMA_STAT_DESC_UNSUPP_REQ (1UL << 9)
#define EDMA_STAT_DESC_COMPL_ABORT (1UL << 10)
#define EDMA_STAT_DESC_PARITY_ERR (1UL << 11)
#define EDMA_STAT_DESC_HEADER_EP (1UL << 12)
#define EDMA_STAT_DESC_UNEXP_COMPL (1UL << 13)

#define EDMA_STAT_DESC_ERR_MASK                                   \
        (EDMA_STAT_DESC_UNSUPP_REQ | EDMA_STAT_DESC_COMPL_ABORT | \
         EDMA_STAT_DESC_PARITY_ERR | EDMA_STAT_DESC_HEADER_EP |   \
         EDMA_STAT_DESC_UNEXP_COMPL)

/* read error: HTC */
#define EDMA_STAT_HTC_R_UNSUPP_REQ (1UL << 14)
#define EDMA_STAT_HTC_R_COMPL_ABORT (1UL << 15)
#define EDMA_STAT_HTC_R_PARITY_ERR (1UL << 16)
#define EDMA_STAT_HTC_R_HEADER_EP (1UL << 17)
#define EDMA_STAT_HTC_R_UNEXP_COMPL (1UL << 18)

#define EDMA_STAT_HTC_R_ERR_MASK                                    \
        (EDMA_STAT_HTC_R_UNSUPP_REQ | EDMA_STAT_HTC_R_COMPL_ABORT | \
         EDMA_STAT_HTC_R_PARITY_ERR | EDMA_STAT_HTC_R_HEADER_EP |   \
         EDMA_STAT_HTC_R_UNEXP_COMPL)

/* write error, HTC only */
#define EDMA_STAT_HTC_W_DECODE_ERR (1UL << 19)
#define EDMA_STAT_HTC_W_SLAVE_ERR (1UL << 20)

#define EDMA_STAT_HTC_W_ERR_MASK \
        (EDMA_STAT_HTC_W_DECODE_ERR | EDMA_STAT_HTC_W_SLAVE_ERR)

/* read error: CTH */
#define EDMA_STAT_CTH_R_DECODE_ERR (1UL << 19)
#define EDMA_STAT_CTH_R_SLAVE_ERR (1UL << 20)

#define EDMA_STAT_CTH_R_ERR_MASK (EDMA_STAT_CTH_R_DECODE_ERR | EDMA_STAT_CTH_R_SLAVE_ERR)

/* all combined */
#define EDMA_STAT_HTC_ERR_MASK (EDMA_STAT_COMMON_ERR_MASK | EDMA_STAT_DESC_ERR_MASK | \
                                EDMA_STAT_HTC_R_ERR_MASK | EDMA_STAT_HTC_W_ERR_MASK)

#define EDMA_STAT_CTH_ERR_MASK (EDMA_STAT_COMMON_ERR_MASK | EDMA_STAT_DESC_ERR_MASK | EDMA_STAT_CTH_R_ERR_MASK)

/* Configuration registers 0x0000 */
struct config_regs
{
        uint32_t identifier;    // 0x00
        uint32_t reserved_1[5]; // 0x04-0x14
        uint32_t msi_enable;    // 0x18
};

/* Engine common registers 0x1000 */
struct sgdma_common_regs
{
        uint32_t identifier;             // 0x00
        uint32_t credit_mode_enable_w1s; // 0x04
        uint32_t credit_mode_enable_w1c; // 0x08
        uint32_t desc_control_1;         // 0x0C
        uint32_t desc_control_2;         // 0x10
        uint32_t desc_control_3;         // 0x14
        uint32_t credit_mode_enable;     // 0x18
} __packed;

/* IRQ registers 0x2000 */
struct interrupt_regs
{
        uint32_t identifier;             // 0x00
        uint32_t user_int_request;       // 0x04
        uint32_t channel_int_request;    // 0x08
        uint32_t user_int_pending;       // 0x0C
        uint32_t channel_int_pending;    // 0x10
        uint32_t user_msi_vector[4];     // 0x14-0x20
        uint32_t channel_msi_vector[2];  // 0x24-0x28
        uint32_t user_int_enable;        // 0x2C
        uint32_t user_int_enable_w1s;    // 0x30
        uint32_t user_int_enable_w1c;    // 0x34
        uint32_t channel_int_enable;     // 0x38
        uint32_t channel_int_enable_w1s; // 0x3C
        uint32_t channel_int_enable_w1c; // 0x40
} __packed;

/* SGDMA control registers HTC=0x3000,CTH=0x4000 */
struct engine_regs
{
        uint32_t identifier;                // 0x00
        uint32_t first_desc_adjacent;       // 0x04
        uint32_t credits;                   // 0x08
        uint32_t first_desc_lo;             // 0x0C
        uint32_t first_desc_hi;             // 0x10
        uint32_t poll_mode_wb_lo;           // 0x14
        uint32_t poll_mode_wb_hi;           // 0x18
        uint32_t control;                   // 0x1C
        uint32_t control_w1s;               // 0x20
        uint32_t control_w1c;               // 0x24
        uint32_t status;                    // 0x28
        uint32_t status_rc;                 // 0x2C
        uint32_t completed_desc_count;      // 0x30
        uint32_t alignments;                // 0x34
        uint32_t interrupt_enable_mask;     // 0x38
        uint32_t interrupt_enable_mask_w1s; // 0x3C
        uint32_t interrupt_enable_mask_w1c; // 0x40

} __packed;

#endif /*__DMA_REGS_H__*/

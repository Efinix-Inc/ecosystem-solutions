module i2c_slave_regs (
    input  wire       clk,
    input  wire       rst,

    // I2C Physical Line Signals
    input  wire       scl_in,
    output wire       scl_out,
    output wire       scl_oe,
    input  wire       sda_in,
    output wire       sda_out,
    output wire       sda_oe,

    // Hardware Outputs Driven by Master Write Registers
    output reg  [7:0] reg_ctrl,
    output reg  [7:0] reg_config,
    output reg  [7:0] reg_outport, 
    output reg  [7:0] reg_extend_i2c_mux, 
    output reg  [7:0] reg_extend_i2c_config, 
    
    // Hardware Inputs Read by Master Read Registers
    input  wire [7:0] reg_status,
    input  wire [7:0] reg_version,
    input  wire [7:0] reg_inport

);

    // 8-bit Data Buses for IP User Interface
    wire [7:0] slave_din;
    wire [7:0] slave_data_out;
    wire [7:0] command_bytes;
    
    wire       ready_to_wr;
    wire       ready_to_rd;
    
    reg       r_ready_to_wr;
    reg       r_ready_to_rd;
    
    
    wire       rddata_valid;
    wire       busy;
    
    reg        slave_read_req;
    reg        slave_write_req;
    reg  [7:0] slave_din_reg;

    assign slave_din = slave_din_reg;

    // -------------------------------------------------------------------------
    // Instantiation of Efinix I2C Slave Core (DATA_WIDTH = 8)
    // -------------------------------------------------------------------------
    I2C_SLAVE u_i2c_slave (
        .clk           (clk),
        .rst           (rst),
        .slv_scl_in        (scl_in),
        .slv_scl_out       (scl_out),
        .slv_scl_oe        (scl_oe),
        .slv_sda_in        (sda_in),
        .slv_sda_out       (sda_out),
        .slv_sda_oe        (sda_oe),
        .slv_din           (slave_din),          // 8-bit bus
        .slv_read          (slave_read_req),
        .slv_data_out      (slave_data_out),     // 8-bit bus
        .slv_write         (slave_write_req),
        .slv_ready_to_wr   (ready_to_wr),
        .slv_ready_to_rd   (ready_to_rd),
        .slv_rddata_valid  (rddata_valid),
        .slv_busy          (busy),
        .slv_command_byte (command_bytes)
    );
    
    

    // -------------------------------------------------------------------------
    // Read Handling: Send 8-bit register content to Master
    // -------------------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            slave_write_req <= 1'b0;
            slave_din_reg   <= 8'h00;
             r_ready_to_wr <= 1'b0;
        end else begin
            slave_write_req <= 1'b0;
            r_ready_to_wr <= ready_to_wr;
            
            if (ready_to_wr & !r_ready_to_wr) begin
                slave_write_req <= 1'b1;
                // Decode 8-bit register data directly
                case (command_bytes)
                    8'h00: slave_din_reg <= reg_version;
                    8'h01: slave_din_reg <= reg_status;
                    8'h02: slave_din_reg <= reg_ctrl;
                    8'h03: slave_din_reg <= reg_config;
                    8'h04: slave_din_reg <= reg_outport;
                    8'h05: slave_din_reg <= reg_inport;
                    8'h06: slave_din_reg <= reg_extend_i2c_mux; 
                    8'h07: slave_din_reg <= reg_extend_i2c_config; 
                    default: slave_din_reg <= 8'h00;
                endcase
            end
            else 
            begin
                slave_write_req <= 1'b0;
            end
          
        end
    end

    // -------------------------------------------------------------------------
    // Write Handling: Store incoming 8-bit byte to target register
    // -------------------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            slave_read_req <= 1'b0;
            reg_ctrl    <= 8'h00;
            reg_config  <= 8'h00;
            r_ready_to_rd <= 1'b0;
            
        end else begin
            slave_read_req <= 1'b0;
            r_ready_to_rd <= ready_to_rd;

            if (ready_to_rd & !r_ready_to_rd) begin
                slave_read_req <= 1'b1;
            end
            else 
            begin
                slave_read_req <= 1'b0;
            end
            // Directly assign 8-bit output byte
            if (rddata_valid) begin
                case (command_bytes)
                    8'h02: reg_ctrl              <= slave_data_out;
                    8'h03: reg_config            <= slave_data_out;
                    8'h04: reg_outport           <= slave_data_out;
                    8'h06: reg_extend_i2c_mux    <= slave_data_out;
                    8'h07: reg_extend_i2c_config <= slave_data_out;
                    default: ;
                endcase
            end
        end
    end

endmodule
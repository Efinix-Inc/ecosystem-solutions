//--------------------------------------------------------------------------------------------------------------------------//
// APB Ctrl Module
//--------------------------------------------------------------------------------------------------------------------------//
module apb_ctrl 
(
    input  wire        apb_clk,
    input  wire        rstn,
    input  wire        start,
    output reg         done,
    input  wire        write_i,
    input  wire [31:0] pwdata_test,
    input  wire [ 3:0] pwdata_par_test,
    input  wire [23:0] paddr_test,
    output reg  [31:0] prdata_test,
    output wire [ 2:0] pstates_obs,
    
    // APB
    output reg  [23:0] paddr,
    output reg         psel,
    output reg         penable,
    output reg         pwrite,
    output reg  [31:0] pwdata,
    output reg  [ 3:0] pwdata_par,
    output reg  [ 3:0] pstrb,
    output reg         pstrb_par,
    input  wire [31:0] prdata,
    input  wire        pready,
    input  wire        pslverr
);
//--------------------------------------------------------------------------------------------------------------------------//
// Signals
//--------------------------------------------------------------------------------------------------------------------------//
// APB states
localparam
    PIDLE = 3'b000,
    PADR  = 3'b001,
    PENA  = 3'b010,
    PRDY  = 3'b011,
    PDONE = 3'b101;

reg       rstn_filt;
reg       rstn_sync;
reg       start_filt;
reg       start_apb;

reg [2:0] pstates;
reg [2:0] n_pstates;

//--------------------------------------------------------------------------------------------------------------------------//
// Behave
//--------------------------------------------------------------------------------------------------------------------------//
always @(posedge apb_clk or negedge rstn) 
begin
    if (!rstn) begin
        rstn_filt <= 1'b0;
        rstn_sync <= 1'b0;
    end else begin
        rstn_filt <= 1'b1;
        rstn_sync <= rstn_filt;
    end
end

always @(posedge apb_clk or negedge rstn_sync) 
begin
    if (~rstn_sync) begin
        start_filt <= 1'b0;
        start_apb  <= 1'b0;
    end else begin
        start_filt <= start;
        start_apb  <= start_filt;
    end
end

assign pstates_obs = pstates;

always @(posedge apb_clk or negedge rstn_sync) 
begin
    if (!rstn_sync) begin
        pstates <= PIDLE;
    end else begin
        pstates <= n_pstates;
    end
end

always @(pstates or start_apb or pready) 
begin
    case (pstates) 
        PIDLE  : n_pstates = (start_apb == 1'b1) ? PADR : PIDLE; 
        PADR   : n_pstates = PENA;
        PENA   : n_pstates = (pready == 1'b1) ? PRDY : PENA;    
        PRDY   : n_pstates = PDONE;
        PDONE  : n_pstates = (start_apb == 1'b0) ? PIDLE : PDONE;
        default: n_pstates = PIDLE;
    endcase
end

always @(posedge apb_clk or negedge rstn_sync) 
begin
    if (!rstn_sync) begin
        paddr       <= 24'd0;
        psel        <= 1'b0;
        penable     <= 1'b0;
        pwrite      <= 1'b0;
        pwdata      <= 32'd0;
        pwdata_par  <= 4'd0;
        pstrb       <= 4'd0;
        pstrb_par   <= 1'b0;
        prdata_test <= 32'd0;
        done        <= 1'b0;
    end else begin
        if (pready & ~write_i) begin
            prdata_test <= prdata;
        end
        if (pstates == PADR) begin
            if (write_i) begin
                pwrite     <= 1'b1;
                pwdata     <= pwdata_test;
                pwdata_par <= pwdata_par_test;
                pstrb      <= 4'b1111;
            end else begin
                pwrite     <= 1'b0;
            end
            psel    <= 1'b1;
            penable <= 1'b0;
            paddr   <= paddr_test;
        end else if (pstates == PENA) begin
            paddr  <= paddr;
            pwrite <= pwrite;
            pwdata <= pwdata;
            pstrb  <= pstrb;
            if (pready & penable) begin
                penable <= 1'b0;
                psel    <= 1'b0;
            end else begin
                penable <= 1'b1;
                psel    <= psel;    
            end 
        end else if (pstates == PRDY) begin
            penable <= 1'b0;
            pwrite  <= 1'b0;
            psel    <= 1'b0;
            pwdata  <= 32'd0;
            pstrb   <= 4'd0;
        end else if (pstates== PDONE) begin
            done    <= 1'b1;
            penable <= penable;
            pwrite  <= pwrite;
            psel    <= psel;
            pwdata  <= pwdata;
            pstrb   <= pstrb;
        end else if (pstates == PIDLE) begin
            penable <= 1'b0;
            pwrite  <= 1'b0;
            psel    <= 1'b0;
            pwdata  <= 32'd0;
            pstrb   <= 4'b0000;
        end
    end
end

//--------------------------------------------------------------------------------------------------------------------------//
endmodule
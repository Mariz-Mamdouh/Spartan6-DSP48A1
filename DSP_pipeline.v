module DSP_pipeline(clk,rst,CE,data_in,mux_sel,data_out);
parameter DATAIN_SIZE = 18;
parameter RSTTYPE = "SYNC";
input clk,rst,CE,mux_sel;
input [DATAIN_SIZE-1:0] data_in;
output reg [DATAIN_SIZE-1:0] data_out;

reg [DATAIN_SIZE-1:0] stage_reg;

// Pipeline register logic
generate
    if (RSTTYPE == "ASYNC") begin
        always @(posedge clk or posedge rst) begin
            if (rst) begin
                stage_reg <= 0;
            end else if (CE) begin
                stage_reg <= data_in;
            end
        end
    end else if (RSTTYPE == "SYNC") begin
        always @(posedge clk) begin
            if (rst) begin
                stage_reg <= 0;
            end else if (CE) begin
                stage_reg <= data_in;
            end
        end
    end
endgenerate

// MUX Selection: Select between registered and direct input
always @(*) begin
    if (mux_sel) begin
        data_out = stage_reg;
    end else begin
        data_out = data_in;
    end
end
endmodule
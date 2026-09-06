module Dynamic_Predictor (
    input wire clk,
    input wire [31:0] pc,
    input wire [31:0] pc_to_be_updated,
    input wire branch_taken,
    input wire update_valid,
    output reg prediction
);

    reg [1:0] mem [0:63];
    integer k;
    initial for (k = 0; k < 64; k = k + 1) mem[k] = 2'b01;

    reg [1:0] counter_next;

    // Combinationally compute what THIS address's counter should become,
    // reading directly from its own current table entry.
    always @(*) begin
        counter_next = mem[pc_to_be_updated[5:0]];
        if (branch_taken) begin
            if (counter_next < 2'b11)
                counter_next = counter_next + 2'b01;
        end else begin
            if (counter_next > 2'b00)
                counter_next = counter_next - 2'b01;
        end
    end

    // Reader
    always @(posedge clk) begin
        prediction <= (mem[pc[5:0]] >= 2'b10) ? 1'b1 : 1'b0;
    end

    // Writer
    always @(posedge clk) begin
        if (update_valid)
            mem[pc_to_be_updated[5:0]] <= counter_next;
    end

endmodule
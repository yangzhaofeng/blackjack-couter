module counter (
	input clk,
	input rst,
	input large_add,
	input seven_add,
	input small_add,
	input deck_add,
	input back,
	output reg[7:0] deck,
	output reg[15:0] total, // cards dealed. should it be cards remaining?
	//output reg[15:0] remain,
	output reg signed [15:0] offset
);
reg [15:0] small_total;
reg [15:0] seven_total;
reg [15:0] large_total;
reg [1:0] prev_add; // small 01 seven 10 large 11, only memorize one step

always @(posedge clk or posedge rst)
begin
	if(rst) begin
		total <= 16'd0;
		deck <= 8'd0;
		offset <= 16'd0;
		small_total <= 16'd0;
		seven_total <= 16'd0;
		large_total <= 16'd0;
		prev_add <= 2'b00;
	end
	else begin
		if(deck_add && total == 0 && deck < 255) begin // only add deck at start
			deck <= deck + 1;
			// remain <= remain + 52;
		end
		else begin
			if(back && prev_add != 2'b00 && total > 0) begin
				if(prev_add == 2'b01 && small_total > 0) begin
					small_total <= small_total - 1;
					offset <= offset + 1;
				end
				else if (prev_add == 2'b10 && seven_total > 0) begin
					seven_total <= small_total - 1;
					offset <= offset;
				end
				else if (prev_add == 2'b11 && large_total > 0) begin
					large_total <= small_total - 1;
					offset <= offset - 1;
				end
				total <= total - 1;
				prev_add <= 2'b00;
			end
			else begin
				if(large_add && large_total <= 24*deck && total < 52*deck) begin
					prev_add <= 2'b11;
					large_total <= large_total + 1;
					offset <= offset + 1;
					total <= total + 1;
				end else if(seven_add && seven_total <= 4*deck && total < 52*deck) begin
					prev_add <= 2'b10;
					seven_total <= seven_total + 1;
					offset <= offset;
					total <= total + 1;
				end else if(small_add && small_total <= 24*deck && total < 52*deck) begin
					prev_add <= 2'b01;
					small_total <= small_total + 1;
					offset <= offset - 1;
					total <= total + 1;
				end
			end
		end
	end
end

endmodule

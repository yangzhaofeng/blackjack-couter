module counter_chk (
	input clk,
	input rst,
	input large_add,
	input seven_add,
	input small_add,
	input deck_add,
	input back,
	input reg[7:0] deck,
	input reg[15:0] total,
	input reg signed [15:0] offset
);

AST_OFFSET_MIN: assert property($signed(offset) >= $signed(-24*deck));
AST_OFFSET_MAX: assert property($signed(offset) <= $signed(24*deck));
AST_TOTAL_MAX: assert property(total <= 52*deck);
AST_TOTAL_MUST_MAX: assert property(total >= counter.small_total && total >= counter.seven_total && total >= counter.large_total);
AST_TOTAL_IS_SUM: assert property(total == counter.small_total + counter.seven_total + counter.large_total);
AST_DECK_NO_ADD: assert property(if(total > 0) $stable(deck));

endmodule
bind counter counter_chk counter_chk_inst(.*);

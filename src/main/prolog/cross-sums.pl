/*
 * cross_sum(HORIZONTAL_CONSTAINTS_MATRIX, VERTICAL_CONSTAINTS_MATRIX, POSITION_MATRIX).
 *
 * Solve the cross-sum problem.
 *
 * In input constaints positive number means corresponding needed sum, 0 means empty placeholder and -1 means empty cell or constaint with unknown sum.
 *
 * @input-param HORIZONTAL_CONSTAINTS_MATRIX - matrix of horizontal constaints.
 * @input-param VERTICAL_CONSTAINTS_MATRIX - matrix of vertical constaints.
 * @output-param POSITION_MATRIX - answer for cross-sum game.
 */
cross_sum([_ | HORIZONTAL_CONSTAINTS_MATRIX_TAILLINES], VERTICAL_CONSTAINTS_MATRIX, POSITION_MATRIX) :- 
	generate_position_matrix_for_constaints(HORIZONTAL_CONSTAINTS_MATRIX_TAILLINES, VERTICAL_CONSTAINTS_MATRIX, [], 1, POSITION_MATRIX),
	format('INFO : POSITION_MATRIX FOR ALL CONSTRAINTS: ~w~n', [POSITION_MATRIX]).

/*
 * generate_position_matrix_for_constaints(HORIZONTAL_CONSTAINTS_MATRIX, VERTICAL_CONSTAINTS_MATRIX, POSITION_MATRIX_ACCUMULATOR, LINE_INDEX, POSITION_MATRIX).
 *
 * Generates position matrix that fit passed horizontal and vertical constaints.
 *
 * Matrix of vertical constaints should not contain first empty line.
 *
 * @input-param HORIZONTAL_CONSTAINTS_MATRIX - matrix of horizontal constaints.
 * @input-param VERTICAL_CONSTAINTS_MATRIX - matrix of vertical constaints.
 * @input-param POSITION_MATRIX_ACCUMULATOR - matrix of already generated position lines.
 * @input-param LINE_INDEX - number of currently calculated line.
 * @output-param POSITION_MATRIX - answer for cross-sum game.
 */
generate_position_matrix_for_constaints([], _, _, _, []).

generate_position_matrix_for_constaints(
		[HORIZONTAL_CONSTAINTS_MATRIX_HEADLINE | HORIZONTAL_CONSTAINTS_MATRIX_TAILLINES],
		VERTICAL_CONSTAINTS_MATRIX,
		POSITION_MATRIX_ACCUMULATOR,
		LINE_INDEX,
		[POSITION_MATRIX_HEADLINE | POSITION_MATRIX_TAILLINES]
	) :- 
	generate_position_line_for_horizontal_constraints(HORIZONTAL_CONSTAINTS_MATRIX_HEADLINE, POSITION_MATRIX_HEADLINE),
	
	append_element(POSITION_MATRIX_ACCUMULATOR, POSITION_MATRIX_HEADLINE, NEW_POSITION_MATRIX_ACCUMULATOR),
	fit_vertical_constraints(VERTICAL_CONSTAINTS_MATRIX, NEW_POSITION_MATRIX_ACCUMULATOR),
	
	format('INFO : POSITION FOR ~w PROCESSED LINES:~n ~w~n', [LINE_INDEX, NEW_POSITION_MATRIX_ACCUMULATOR]),
	NEW_LINE_INDEX is LINE_INDEX + 1,
	generate_position_matrix_for_constaints(
		HORIZONTAL_CONSTAINTS_MATRIX_TAILLINES, VERTICAL_CONSTAINTS_MATRIX, NEW_POSITION_MATRIX_ACCUMULATOR, NEW_LINE_INDEX, POSITION_MATRIX_TAILLINES
	).
	
/*
 * generate_position_line_for_horizontal_constraints(HORIZONTAL_CONSTAINTS_LINE, POSITION_LINE).
 * 
 * Generate one line for position matrix that fit passed horizontal constaints line.
 * 
 * @input-param HORIZONTAL_CONSTAINTS_LINE - line of horizontal constaints.
 * @output-param POSITION_LINE - position line that fit passed horizontal constaints.
 */
generate_position_line_for_horizontal_constraints([HORIZONTAL_CONSTAINTS_LINE_HEAD | HORIZONTAL_CONSTAINTS_LINE_TAIL], POSITION_LINE) :- 
	do_generate_position_for_line(HORIZONTAL_CONSTAINTS_LINE_HEAD, HORIZONTAL_CONSTAINTS_LINE_TAIL, 0, POSITION_LINE).

/*
 */
do_generate_position_for_line(NEEDED_SUM, [], SEQUENCE_SIZE, POSITION_SEQUENCE) :- 
	generate_position_for_sequence(NEEDED_SUM, SEQUENCE_SIZE, POSITION_SEQUENCE).
	
do_generate_position_for_line(NEEDED_SUM, [CONSTRAINT_LINE_HEAD | CONSTRAINT_LINE_TAIL], SEQUENCE_SIZE, POSITION_LINE ) :- 
	CONSTRAINT_LINE_HEAD = 0,
	NEW_SEQUENCE_SIZE is SEQUENCE_SIZE + 1,
	do_generate_position_for_line(NEEDED_SUM, CONSTRAINT_LINE_TAIL, NEW_SEQUENCE_SIZE, POSITION_LINE).
	
do_generate_position_for_line(NEEDED_SUM, [CONSTRAINT_LINE_HEAD | CONSTRAINT_LINE_TAIL], SEQUENCE_SIZE, POSITION_LINE) :- 
	CONSTRAINT_LINE_HEAD =\= 0,
	generate_position_for_sequence(NEEDED_SUM, SEQUENCE_SIZE, POSITION_SEQUENCE),
	append_element(POSITION_SEQUENCE, 0, POSITION_LINE_HEAD),
	do_generate_position_for_line(CONSTRAINT_LINE_HEAD, CONSTRAINT_LINE_TAIL, 0, POSITION_LINE_TAIL),
	append(POSITION_LINE_HEAD, POSITION_LINE_TAIL, POSITION_LINE).

/*
 */
generate_position_for_sequence(3, 2, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(3, 2, POSITION_SEQUENCE).
generate_position_for_sequence(5, 2, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(5, 2, POSITION_SEQUENCE).
generate_position_for_sequence(6, 3, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(6, 3, POSITION_SEQUENCE).
generate_position_for_sequence(7, 2, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(7, 2, POSITION_SEQUENCE).
generate_position_for_sequence(7, 3, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(7, 3, POSITION_SEQUENCE).
generate_position_for_sequence(8, 2, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(8, 2, POSITION_SEQUENCE).
generate_position_for_sequence(8, 3, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(8, 3, POSITION_SEQUENCE).
generate_position_for_sequence(10, 4, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(10, 4, POSITION_SEQUENCE).
generate_position_for_sequence(11, 2, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(11, 2, POSITION_SEQUENCE).
generate_position_for_sequence(14, 2, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(14, 2, POSITION_SEQUENCE).
generate_position_for_sequence(15, 5, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(15, 5, POSITION_SEQUENCE).
generate_position_for_sequence(16, 2, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(16, 2, POSITION_SEQUENCE).
generate_position_for_sequence(16, 5, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(16, 5, POSITION_SEQUENCE).
generate_position_for_sequence(17, 2, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(17, 2, POSITION_SEQUENCE).
generate_position_for_sequence(18, 3, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(18, 3, POSITION_SEQUENCE).
generate_position_for_sequence(20, 5, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(20, 5, POSITION_SEQUENCE).
generate_position_for_sequence(21, 4, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(21, 4, POSITION_SEQUENCE).
generate_position_for_sequence(21, 6, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(21, 6, POSITION_SEQUENCE).
generate_position_for_sequence(24, 3, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(24, 3, POSITION_SEQUENCE).
generate_position_for_sequence(24, 5, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(24, 5, POSITION_SEQUENCE).
generate_position_for_sequence(28, 7, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(28, 7, POSITION_SEQUENCE).
generate_position_for_sequence(29, 4, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(29, 4, POSITION_SEQUENCE).
generate_position_for_sequence(29, 5, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(29, 5, POSITION_SEQUENCE).
generate_position_for_sequence(29, 7, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(29, 7, POSITION_SEQUENCE).
generate_position_for_sequence(32, 5, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(32, 5, POSITION_SEQUENCE).
generate_position_for_sequence(35, 5, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(35, 5, POSITION_SEQUENCE).
generate_position_for_sequence(40, 7, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(40, 7, POSITION_SEQUENCE).
generate_position_for_sequence(45, 9, POSITION_SEQUENCE) :- !, do_generate_position_for_sequence(45, 9, POSITION_SEQUENCE).

generate_position_for_sequence(-1, SEQUENCE_SIZE, POSITION_SEQUENCE) :- !, generate_ordered_combination(SEQUENCE_SIZE, POSITION_SEQUENCE).

generate_position_for_sequence(NEEDED_SUM, SEQUENCE_SIZE, POSITION_SEQUENCE) :- 
	format("WARN : DON'T KNOW COMMUTATIONS FOR SEQUENCE WITH SUM ~w OF ~w ELEMENTS~n", [NEEDED_SUM, SEQUENCE_SIZE]),
	generate_ordered_combination(SEQUENCE_SIZE, POSITION_SEQUENCE),
	sum_of_list(POSITION_SEQUENCE, NEEDED_SUM).
	
/*
 */
do_generate_position_for_sequence(3, 2, COMMUTATION) :- generate_commutation([1,2], 2, COMMUTATION). 

do_generate_position_for_sequence(5, 2, COMMUTATION) :- generate_commutation([1,4], 2, COMMUTATION).
do_generate_position_for_sequence(5, 2, COMMUTATION) :- generate_commutation([2,3], 2, COMMUTATION).

do_generate_position_for_sequence(6, 3, COMMUTATION) :- generate_commutation([1,2,3], 3, COMMUTATION).
 
do_generate_position_for_sequence(7, 2, COMMUTATION) :- generate_commutation([1,6], 2, COMMUTATION).
do_generate_position_for_sequence(7, 2, COMMUTATION) :- generate_commutation([2,5], 2, COMMUTATION).
do_generate_position_for_sequence(7, 2, COMMUTATION) :- generate_commutation([3,4], 2, COMMUTATION).

do_generate_position_for_sequence(7, 3, COMMUTATION) :- generate_commutation([1,2,4], 3, COMMUTATION).

do_generate_position_for_sequence(8, 2, COMMUTATION) :- generate_commutation([1,7], 2, COMMUTATION).
do_generate_position_for_sequence(8, 2, COMMUTATION) :- generate_commutation([2,6], 2, COMMUTATION).
do_generate_position_for_sequence(8, 2, COMMUTATION) :- generate_commutation([3,5], 2, COMMUTATION).

do_generate_position_for_sequence(8, 3, COMMUTATION) :- generate_commutation([1,2,5], 3, COMMUTATION).
do_generate_position_for_sequence(8, 3, COMMUTATION) :- generate_commutation([1,3,4], 3, COMMUTATION).

do_generate_position_for_sequence(10, 4, COMMUTATION) :- generate_commutation([1,2,3,4], 4, COMMUTATION).

do_generate_position_for_sequence(11, 2, COMMUTATION) :- generate_commutation([2,9], 2, COMMUTATION).
do_generate_position_for_sequence(11, 2, COMMUTATION) :- generate_commutation([3,8], 2, COMMUTATION).
do_generate_position_for_sequence(11, 2, COMMUTATION) :- generate_commutation([4,7], 2, COMMUTATION).
do_generate_position_for_sequence(11, 2, COMMUTATION) :- generate_commutation([5,6], 2, COMMUTATION).

do_generate_position_for_sequence(14, 2, COMMUTATION) :- generate_commutation([5,9], 2, COMMUTATION).
do_generate_position_for_sequence(14, 2, COMMUTATION) :- generate_commutation([6,8], 2, COMMUTATION).

do_generate_position_for_sequence(15, 5, COMMUTATION) :- generate_commutation([1,2,3,4,5], 5, COMMUTATION).

do_generate_position_for_sequence(16, 2, COMMUTATION) :- generate_commutation([7,9], 2, COMMUTATION).

do_generate_position_for_sequence(16, 5, COMMUTATION) :- generate_commutation([1,2,3,4,6], 5, COMMUTATION).

do_generate_position_for_sequence(17, 2, COMMUTATION) :- generate_commutation([8,9], 2, COMMUTATION).

do_generate_position_for_sequence(18, 3, COMMUTATION) :- generate_commutation([1,8,9], 3, COMMUTATION).
do_generate_position_for_sequence(18, 3, COMMUTATION) :- generate_commutation([2,7,9], 3, COMMUTATION).
do_generate_position_for_sequence(18, 3, COMMUTATION) :- generate_commutation([3,6,9], 3, COMMUTATION).
do_generate_position_for_sequence(18, 3, COMMUTATION) :- generate_commutation([3,7,8], 3, COMMUTATION).
do_generate_position_for_sequence(18, 3, COMMUTATION) :- generate_commutation([4,5,9], 3, COMMUTATION).
do_generate_position_for_sequence(18, 3, COMMUTATION) :- generate_commutation([4,6,8], 3, COMMUTATION).
do_generate_position_for_sequence(18, 3, COMMUTATION) :- generate_commutation([5,6,7], 3, COMMUTATION).

do_generate_position_for_sequence(20, 5, COMMUTATION) :- generate_commutation([1,2,3,5,9], 5, COMMUTATION).
do_generate_position_for_sequence(20, 5, COMMUTATION) :- generate_commutation([1,2,3,6,8], 5, COMMUTATION).
do_generate_position_for_sequence(20, 5, COMMUTATION) :- generate_commutation([1,2,4,5,8], 5, COMMUTATION).
do_generate_position_for_sequence(20, 5, COMMUTATION) :- generate_commutation([1,2,4,6,7], 5, COMMUTATION).
do_generate_position_for_sequence(20, 5, COMMUTATION) :- generate_commutation([1,3,4,5,7], 5, COMMUTATION).
do_generate_position_for_sequence(20, 5, COMMUTATION) :- generate_commutation([2,3,4,5,6], 5, COMMUTATION).

do_generate_position_for_sequence(21, 4, COMMUTATION) :- generate_commutation([1,3,8,9], 4, COMMUTATION).
do_generate_position_for_sequence(21, 4, COMMUTATION) :- generate_commutation([1,4,7,9], 4, COMMUTATION).
do_generate_position_for_sequence(21, 4, COMMUTATION) :- generate_commutation([1,5,6,9], 4, COMMUTATION).
do_generate_position_for_sequence(21, 4, COMMUTATION) :- generate_commutation([1,5,7,8], 4, COMMUTATION).
do_generate_position_for_sequence(21, 4, COMMUTATION) :- generate_commutation([2,3,7,9], 4, COMMUTATION).
do_generate_position_for_sequence(21, 4, COMMUTATION) :- generate_commutation([2,4,6,9], 4, COMMUTATION).
do_generate_position_for_sequence(21, 4, COMMUTATION) :- generate_commutation([2,4,7,8], 4, COMMUTATION).
do_generate_position_for_sequence(21, 4, COMMUTATION) :- generate_commutation([2,5,6,8], 4, COMMUTATION).
do_generate_position_for_sequence(21, 4, COMMUTATION) :- generate_commutation([3,4,5,9], 4, COMMUTATION).
do_generate_position_for_sequence(21, 4, COMMUTATION) :- generate_commutation([3,4,6,8], 4, COMMUTATION).
do_generate_position_for_sequence(21, 4, COMMUTATION) :- generate_commutation([3,5,6,7], 4, COMMUTATION).

do_generate_position_for_sequence(21, 6, COMMUTATION) :- generate_commutation([1,2,3,4,5,6], 6, COMMUTATION).

do_generate_position_for_sequence(24, 3, COMMUTATION) :- generate_commutation([7,8,9], 3, COMMUTATION).

do_generate_position_for_sequence(24, 5, COMMUTATION) :- generate_commutation([1,2,4,8,9], 5, COMMUTATION).
do_generate_position_for_sequence(24, 5, COMMUTATION) :- generate_commutation([1,2,5,7,9], 5, COMMUTATION).
do_generate_position_for_sequence(24, 5, COMMUTATION) :- generate_commutation([1,2,6,7,8], 5, COMMUTATION).
do_generate_position_for_sequence(24, 5, COMMUTATION) :- generate_commutation([1,3,4,7,9], 5, COMMUTATION).
do_generate_position_for_sequence(24, 5, COMMUTATION) :- generate_commutation([1,3,5,6,9], 5, COMMUTATION).
do_generate_position_for_sequence(24, 5, COMMUTATION) :- generate_commutation([1,3,5,7,8], 5, COMMUTATION).
do_generate_position_for_sequence(24, 5, COMMUTATION) :- generate_commutation([1,4,5,6,8], 5, COMMUTATION).
do_generate_position_for_sequence(24, 5, COMMUTATION) :- generate_commutation([2,3,4,6,9], 5, COMMUTATION).
do_generate_position_for_sequence(24, 5, COMMUTATION) :- generate_commutation([2,3,4,7,8], 5, COMMUTATION).
do_generate_position_for_sequence(24, 5, COMMUTATION) :- generate_commutation([2,3,5,6,8], 5, COMMUTATION).
do_generate_position_for_sequence(24, 5, COMMUTATION) :- generate_commutation([2,4,5,6,7], 5, COMMUTATION).

do_generate_position_for_sequence(28, 7, COMMUTATION) :- generate_commutation([1,2,3,4,5,6,7], 7, COMMUTATION).

do_generate_position_for_sequence(29, 4, COMMUTATION) :- generate_commutation([5,7,8,9], 4, COMMUTATION).

do_generate_position_for_sequence(29, 5, COMMUTATION) :- generate_commutation([1,4,7,8,9], 5, COMMUTATION).
do_generate_position_for_sequence(29, 5, COMMUTATION) :- generate_commutation([1,5,6,8,9], 5, COMMUTATION).
do_generate_position_for_sequence(29, 5, COMMUTATION) :- generate_commutation([2,3,7,8,9], 5, COMMUTATION).
do_generate_position_for_sequence(29, 5, COMMUTATION) :- generate_commutation([2,4,6,8,9], 5, COMMUTATION).
do_generate_position_for_sequence(29, 5, COMMUTATION) :- generate_commutation([2,5,6,7,9], 5, COMMUTATION).
do_generate_position_for_sequence(29, 5, COMMUTATION) :- generate_commutation([3,4,5,8,9], 5, COMMUTATION).
do_generate_position_for_sequence(29, 5, COMMUTATION) :- generate_commutation([3,4,6,7,9], 5, COMMUTATION).
do_generate_position_for_sequence(29, 5, COMMUTATION) :- generate_commutation([3,5,6,7,8], 5, COMMUTATION).

do_generate_position_for_sequence(29, 7, COMMUTATION) :- generate_commutation([1,2,3,4,5,6,8], 7, COMMUTATION).

do_generate_position_for_sequence(32, 5, COMMUTATION) :- generate_commutation([2,6,7,8,9], 5, COMMUTATION).
do_generate_position_for_sequence(32, 5, COMMUTATION) :- generate_commutation([3,5,7,8,9], 5, COMMUTATION).
do_generate_position_for_sequence(32, 5, COMMUTATION) :- generate_commutation([4,5,6,8,9], 5, COMMUTATION).

do_generate_position_for_sequence(35, 5, COMMUTATION) :- generate_commutation([5,6,7,8,9], 5, COMMUTATION).

do_generate_position_for_sequence(40, 7, COMMUTATION) :- generate_commutation([1,4,5,6,7,8,9], 7, COMMUTATION).
do_generate_position_for_sequence(40, 7, COMMUTATION) :- generate_commutation([2,3,5,6,7,8,9], 7, COMMUTATION).

do_generate_position_for_sequence(45, 9, COMMUTATION) :- generate_commutation([1,2,3,4,5,6,7,8,9], 9, COMMUTATION).

/*
 */
generate_ordered_combination(COMBINATION_SIZE, COMBINATION) :- do_combinate([1,2,3,4,5,6,7,8,9], COMBINATION_SIZE, COMBINATION).

/*
 */
generate_commutation(COMMUTATION_ELEMENTS, COMMUTATION_SIZE, COMMUTATION) :- do_combinate(COMMUTATION_ELEMENTS, COMMUTATION_SIZE, COMMUTATION).

/*
 */
do_combinate(_, 0, []).
 
do_combinate(COMBINATION_ELEMENTS, SIZE, [ COMBINATION_HEAD | COMBINATION_TAIL ]) :- 
	generate_head(COMBINATION_ELEMENTS, COMBINATION_HEAD),
	remove_element(COMBINATION_ELEMENTS, COMBINATION_HEAD, LEFT_COMBINATION_ELEMENTS),
	NEW_SIZE is SIZE - 1,
	do_combinate(LEFT_COMBINATION_ELEMENTS, NEW_SIZE, COMBINATION_TAIL).
	
/*
 */
generate_head([ COMBINATION_ELEMENTS_HEAD | _ ], COMBINATION_ELEMENTS_HEAD).
generate_head([ _ | COMBINATION_ELEMENTS_TAIL ], COMBINATION_HEAD) :- generate_head(COMBINATION_ELEMENTS_TAIL, COMBINATION_HEAD).

/*
 */
sum_of_list([], 0).

sum_of_list([ LIST_HEAD | LIST_TAIL ], SUM) :- sum_of_list(LIST_TAIL, SUM_TAIL), SUM is SUM_TAIL + LIST_HEAD.
	
/*
 */
fit_vertical_constraints([[_ | Y_CONSTRAINTS_HEAD] | Y_CONSTRAINTS_TAIL], POSITION) :- 
	generate_empty_list_list(Y_CONSTRAINTS_HEAD, EMPTY_LIST_LIST),
	is_fit_vertical_constraints(Y_CONSTRAINTS_TAIL, POSITION, Y_CONSTRAINTS_HEAD, EMPTY_LIST_LIST, Y_CONSTRAINTS_HEAD).

/*
 */
is_fit_vertical_constraints([], [], POINTS_LEFT_LIST, _, SKIP_LIST) :- !, all_zeros(POINTS_LEFT_LIST, SKIP_LIST).
 
is_fit_vertical_constraints([CONSTRAINTS_HEAD | _], [], POINTS_LEFT_LIST, _, SKIP_LIST) :- !, check_last_available_vertical_constraints(CONSTRAINTS_HEAD, POINTS_LEFT_LIST, SKIP_LIST).

is_fit_vertical_constraints([CONSTRAINTS_HEAD | CONSTRAINTS_TAIL], [POSITION_HEAD | POSITION_TAIL], POINTS_LEFT_LIST, USED_NUMBERS_LIST, SKIP_LIST) :- 
	process_vertical_constraints(CONSTRAINTS_HEAD, POSITION_HEAD, POINTS_LEFT_LIST, USED_NUMBERS_LIST, SKIP_LIST, NEW_POINTS_LEFT_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST),
	is_fit_vertical_constraints(CONSTRAINTS_TAIL, POSITION_TAIL, NEW_POINTS_LEFT_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST).
	
/*
 */
process_vertical_constraints([_ | CONSTRAINTS_LINE_TAIL], POSITION_HEAD, POINTS_LEFT_LIST, USED_NUMBERS_LIST, SKIP_LIST, NEW_POINTS_LEFT_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST) :- 
	do_process_vertical_constraints(CONSTRAINTS_LINE_TAIL, POSITION_HEAD, POINTS_LEFT_LIST, USED_NUMBERS_LIST, SKIP_LIST, NEW_POINTS_LEFT_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST).
	
/*
 */
do_process_vertical_constraints([], [], _, _, _, [], [], []).

do_process_vertical_constraints(
		[CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], 
		[_ | POSITON_LINE_TAIL], 
		[POINTS_LEFT_HEAD | POINTS_LEFT_TAIL], 
		[_ | USER_NUMBERS_TAIL], 
		[SKIP_LIST_HEAD | SKIP_LIST_TAIL],
		[CONSTRAINTS_LINE_HEAD | NEW_POINTS_LEFT_LIST], 
		[[] | NEW_USED_NUMBERS_LIST],
		[CONSTRAINTS_LINE_HEAD | NEW_SKIP_LIST_TAIL]
	) :- 
	CONSTRAINTS_LINE_HEAD =\= 0, SKIP_LIST_HEAD > 0,
	POINTS_LEFT_HEAD = 0,
	do_process_vertical_constraints(CONSTRAINTS_LINE_TAIL, POSITON_LINE_TAIL, POINTS_LEFT_TAIL, USER_NUMBERS_TAIL, SKIP_LIST_TAIL, NEW_POINTS_LEFT_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST_TAIL).

do_process_vertical_constraints(
		[CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], 
		[_ | POSITON_LINE_TAIL], 
		[_ | POINTS_LEFT_TAIL], 
		[_ | USER_NUMBERS_TAIL], 
		[SKIP_LIST_HEAD | SKIP_LIST_TAIL],
		[CONSTRAINTS_LINE_HEAD | NEW_POINTS_LEFT_LIST], 
		[[] | NEW_USED_NUMBERS_LIST],
		[CONSTRAINTS_LINE_HEAD | NEW_SKIP_LIST_TAIL]
	) :- 
	CONSTRAINTS_LINE_HEAD =\= 0, SKIP_LIST_HEAD =< 0,
	do_process_vertical_constraints(CONSTRAINTS_LINE_TAIL, POSITON_LINE_TAIL, POINTS_LEFT_TAIL, USER_NUMBERS_TAIL, SKIP_LIST_TAIL, NEW_POINTS_LEFT_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST_TAIL).

do_process_vertical_constraints(
		[CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], 
		[POSITON_LINE_HEAD | POSITON_LINE_TAIL], 
		[POINTS_LEFT_HEAD | POINTS_LEFT_TAIL], 
		[USED_NUMBERS_HEAD | USER_NUMBERS_TAIL], 
		[SKIP_LIST_HEAD | SKIP_LIST_TAIL],
		[NEW_POINTS_LEFT_HEAD | NEW_POINTS_LEFT_LIST], 
		[[POSITON_LINE_HEAD | USED_NUMBERS_HEAD] | NEW_USED_NUMBERS_LIST],
		[SKIP_LIST_HEAD | NEW_SKIP_LIST_TAIL]
	) :- 
	CONSTRAINTS_LINE_HEAD = 0, SKIP_LIST_HEAD > 0,
	POINTS_LEFT_HEAD >= 0, not_contains(POSITON_LINE_HEAD, USED_NUMBERS_HEAD), NEW_POINTS_LEFT_HEAD is POINTS_LEFT_HEAD - POSITON_LINE_HEAD,
	do_process_vertical_constraints(CONSTRAINTS_LINE_TAIL, POSITON_LINE_TAIL, POINTS_LEFT_TAIL, USER_NUMBERS_TAIL, SKIP_LIST_TAIL, NEW_POINTS_LEFT_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST_TAIL).

do_process_vertical_constraints(
		[CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], 
		[POSITON_LINE_HEAD | POSITON_LINE_TAIL], 
		[POINTS_LEFT_HEAD | POINTS_LEFT_TAIL], 
		[USED_NUMBERS_HEAD | USER_NUMBERS_TAIL], 
		[SKIP_LIST_HEAD | SKIP_LIST_TAIL],
		[NEW_POINTS_LEFT_HEAD | NEW_POINTS_LEFT_LIST], 
		[[POSITON_LINE_HEAD | USED_NUMBERS_HEAD] | NEW_USED_NUMBERS_LIST],
		[SKIP_LIST_HEAD | NEW_SKIP_LIST_TAIL]
	) :- 
	CONSTRAINTS_LINE_HEAD = 0, SKIP_LIST_HEAD =< 0,
	not_contains(POSITON_LINE_HEAD, USED_NUMBERS_HEAD),
	NEW_POINTS_LEFT_HEAD is POINTS_LEFT_HEAD - POSITON_LINE_HEAD,
	do_process_vertical_constraints(CONSTRAINTS_LINE_TAIL, POSITON_LINE_TAIL, POINTS_LEFT_TAIL, USER_NUMBERS_TAIL, SKIP_LIST_TAIL, NEW_POINTS_LEFT_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST_TAIL).
	
/*
 */
check_last_available_vertical_constraints([_ | CONSTRAINTS_LINE_TAIL], POINTS_LEFT_LIST, SKIP_LIST) :-
	do_check_last_available_vertical_constraints(CONSTRAINTS_LINE_TAIL, POINTS_LEFT_LIST, SKIP_LIST).
	
/*
 */
do_check_last_available_vertical_constraints([], _, _).

do_check_last_available_vertical_constraints([CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], [POINTS_LEFT_HEAD | POINTS_LEFT_TAIL], [SKIP_LIST_HEAD | SKIP_LIST_TAIL]) :- 
	CONSTRAINTS_LINE_HEAD =\= 0, SKIP_LIST_HEAD > 0,
	POINTS_LEFT_HEAD = 0,
	do_check_last_available_vertical_constraints(CONSTRAINTS_LINE_TAIL, POINTS_LEFT_TAIL, SKIP_LIST_TAIL).

do_check_last_available_vertical_constraints([CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], [_ | POINTS_LEFT_TAIL], [SKIP_LIST_HEAD | SKIP_LIST_TAIL]) :- 
	CONSTRAINTS_LINE_HEAD =\= 0, SKIP_LIST_HEAD =< 0,
	do_check_last_available_vertical_constraints(CONSTRAINTS_LINE_TAIL, POINTS_LEFT_TAIL, SKIP_LIST_TAIL).

do_check_last_available_vertical_constraints([CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], [POINTS_LEFT_HEAD | POINTS_LEFT_TAIL], [SKIP_LIST_HEAD | SKIP_LIST_TAIL]) :- 
	CONSTRAINTS_LINE_HEAD = 0, SKIP_LIST_HEAD > 0,
	POINTS_LEFT_HEAD >= 0,
	do_check_last_available_vertical_constraints(CONSTRAINTS_LINE_TAIL, POINTS_LEFT_TAIL, SKIP_LIST_TAIL).

do_check_last_available_vertical_constraints([CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], [_ | POINTS_LEFT_TAIL], [SKIP_LIST_HEAD | SKIP_LIST_TAIL]) :- 
	CONSTRAINTS_LINE_HEAD = 0, SKIP_LIST_HEAD =< 0,
	do_check_last_available_vertical_constraints(CONSTRAINTS_LINE_TAIL, POINTS_LEFT_TAIL, SKIP_LIST_TAIL).

/*
 */
generate_empty_list_list([], []).

generate_empty_list_list([_ | TAIL], [[] | LIST]) :- generate_empty_list_list(TAIL, LIST).

/*
 */
all_zeros([], []).

all_zeros([0 | TAIL], [SKIP_LIST_HEAD | SKIP_LIST_TAIL]) :- SKIP_LIST_HEAD > 0, all_zeros(TAIL, SKIP_LIST_TAIL).

all_zeros([_ | TAIL], [SKIP_LIST_HEAD | SKIP_LIST_TAIL]) :- SKIP_LIST_HEAD =< 0, all_zeros(TAIL, SKIP_LIST_TAIL).

/*
 */
not_contains(_, []).

not_contains(ELEMENT, [ELEMENT | _]) :- false.

not_contains(ELEMENT, [LIST_HEAD | LIST_TAIL]) :- LIST_HEAD =\= ELEMENT, not_contains(ELEMENT, LIST_TAIL).

/*
 */
length_of([], 0).

length_of([_ | LIST_TAIL], LENGTH) :- length_of(LIST_TAIL, LENGTH_WITHOUT_HEAD), LENGTH is LENGTH_WITHOUT_HEAD + 1.
 
/*
 */
remove_element([], _, []).

remove_element([ELEMENT | LIST_TAIL], ELEMENT, NEW_LIST_TAIL) :- remove_element(LIST_TAIL, ELEMENT, NEW_LIST_TAIL).

remove_element([LIST_HEAD | LIST_TAIL], ELEMENT, [LIST_HEAD | NEW_LIST_TAIL]) :- LIST_HEAD =\= ELEMENT, remove_element(LIST_TAIL, ELEMENT, NEW_LIST_TAIL).

/*
 */
append_element([], ELEMENT, [ELEMENT]).

append_element([LIST_HEAD | LIST_TAIL], ELEMENT, [LIST_HEAD | APPEND_TAIL]) :- append_element(LIST_TAIL, ELEMENT, APPEND_TAIL).

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
	is_fit_vertical_constraints(VERTICAL_CONSTAINTS_MATRIX, NEW_POSITION_MATRIX_ACCUMULATOR),
	
	format('INFO : POSITION FOR ~w PROCESSED LINES:~n ~w~n', [LINE_INDEX, NEW_POSITION_MATRIX_ACCUMULATOR]),
	NEW_LINE_INDEX is LINE_INDEX + 1,
	generate_position_matrix_for_constaints(
		HORIZONTAL_CONSTAINTS_MATRIX_TAILLINES, VERTICAL_CONSTAINTS_MATRIX, NEW_POSITION_MATRIX_ACCUMULATOR, NEW_LINE_INDEX, POSITION_MATRIX_TAILLINES
	).
	
/*
 * generate_position_line_for_horizontal_constraints(HORIZONTAL_CONSTAINTS_LINE, POSITION_LINE).
 * 
 * Generate line for position matrix that fit passed horizontal constaints line.
 * 
 * @input-param HORIZONTAL_CONSTAINTS_LINE - line of horizontal constaints.
 * @output-param POSITION_LINE - position line that fit passed horizontal constaints.
 */
generate_position_line_for_horizontal_constraints([HORIZONTAL_CONSTAINTS_LINE_HEAD | HORIZONTAL_CONSTAINTS_LINE_TAIL], POSITION_LINE) :- 
	do_generate_position_line_for_horizontal_constraints(HORIZONTAL_CONSTAINTS_LINE_HEAD, HORIZONTAL_CONSTAINTS_LINE_TAIL, 0, POSITION_LINE).

/*
 * do_generate_position_line_for_horizontal_constraints(NEEDED_SUM, HORIZONTAL_CONSTAINTS_LINE, SEQUENCE_SIZE, POSITION_LINE).
 *
 * Private worker for @goal generate_position_line_for_horizontal_constraints.
 *
 * @input-param NEEDED_SUM - lates constaint, sum of numbers that is currently need to be collected.
 * @input-param HORIZONTAL_CONSTAINTS_LINE - line of horizontal constaints.
 * @input-param SEQUENCE_SIZE - count of numbers, that can be used to fit latest constaint.
 * @output-param POSITION_LINE - position line that fit passed horizontal constaints.
 */
do_generate_position_line_for_horizontal_constraints(NEEDED_SUM, [], SEQUENCE_SIZE, POSITION_SEQUENCE) :- 
	generate_position_sequence(NEEDED_SUM, SEQUENCE_SIZE, POSITION_SEQUENCE).
	
do_generate_position_line_for_horizontal_constraints(NEEDED_SUM, [HORIZONTAL_CONSTAINTS_LINE_HEAD | HORIZONTAL_CONSTAINTS_LINE_TAIL], SEQUENCE_SIZE, POSITION_LINE ) :- 
	HORIZONTAL_CONSTAINTS_LINE_HEAD = 0,
	NEW_SEQUENCE_SIZE is SEQUENCE_SIZE + 1,
	do_generate_position_line_for_horizontal_constraints(NEEDED_SUM, HORIZONTAL_CONSTAINTS_LINE_TAIL, NEW_SEQUENCE_SIZE, POSITION_LINE).
	
do_generate_position_line_for_horizontal_constraints(NEEDED_SUM, [HORIZONTAL_CONSTAINTS_LINE_HEAD | HORIZONTAL_CONSTAINTS_LINE_TAIL], SEQUENCE_SIZE, POSITION_LINE) :- 
	HORIZONTAL_CONSTAINTS_LINE_HEAD =\= 0,
	generate_position_sequence(NEEDED_SUM, SEQUENCE_SIZE, POSITION_SEQUENCE),
	append_element(POSITION_SEQUENCE, 0, POSITION_LINE_HEAD),
	do_generate_position_line_for_horizontal_constraints(HORIZONTAL_CONSTAINTS_LINE_HEAD, HORIZONTAL_CONSTAINTS_LINE_TAIL, 0, POSITION_LINE_TAIL),
	append(POSITION_LINE_HEAD, POSITION_LINE_TAIL, POSITION_LINE).

/*
 * generate_position_sequence(NEEDED_SUM, SEQUENCE_SIZE, POSITION_SEQUENCE).
 *
 * Generate number sequence for position line that fit passed sum and size constaints.
 *
 * If possible, take prepared information about possible sequnces (for example 3 = _ + _ is definitely 2 possibilities (either 3 = 1 + 2 or 3 = 2 + 1) from 72.
 * Otherwise trace over all possible number combinations without repetitions, until get needed sum.
 * `!` is used to prevent backtracing while prepared information about passed constraints exists.
 *
 * @input-param NEEDED_SUM - needed sum of numbers.
 * @input-param SEQUENCE_SIZE - possible count of numbers, that can be used to fit needed sum.
 * @output-param POSITION_SEQUENCE - number sequence that fit passed constaints.
 */
generate_position_sequence(3, 2, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(3, 2, POSITION_SEQUENCE).
generate_position_sequence(5, 2, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(5, 2, POSITION_SEQUENCE).
generate_position_sequence(6, 3, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(6, 3, POSITION_SEQUENCE).
generate_position_sequence(7, 2, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(7, 2, POSITION_SEQUENCE).
generate_position_sequence(7, 3, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(7, 3, POSITION_SEQUENCE).
generate_position_sequence(8, 2, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(8, 2, POSITION_SEQUENCE).
generate_position_sequence(8, 3, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(8, 3, POSITION_SEQUENCE).
generate_position_sequence(10, 4, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(10, 4, POSITION_SEQUENCE).
generate_position_sequence(11, 2, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(11, 2, POSITION_SEQUENCE).
generate_position_sequence(14, 2, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(14, 2, POSITION_SEQUENCE).
generate_position_sequence(15, 5, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(15, 5, POSITION_SEQUENCE).
generate_position_sequence(16, 2, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(16, 2, POSITION_SEQUENCE).
generate_position_sequence(16, 5, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(16, 5, POSITION_SEQUENCE).
generate_position_sequence(17, 2, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(17, 2, POSITION_SEQUENCE).
generate_position_sequence(18, 3, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(18, 3, POSITION_SEQUENCE).
generate_position_sequence(20, 5, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(20, 5, POSITION_SEQUENCE).
generate_position_sequence(21, 4, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(21, 4, POSITION_SEQUENCE).
generate_position_sequence(21, 6, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(21, 6, POSITION_SEQUENCE).
generate_position_sequence(24, 3, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(24, 3, POSITION_SEQUENCE).
generate_position_sequence(24, 5, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(24, 5, POSITION_SEQUENCE).
generate_position_sequence(28, 7, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(28, 7, POSITION_SEQUENCE).
generate_position_sequence(29, 4, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(29, 4, POSITION_SEQUENCE).
generate_position_sequence(29, 5, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(29, 5, POSITION_SEQUENCE).
generate_position_sequence(29, 7, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(29, 7, POSITION_SEQUENCE).
generate_position_sequence(32, 5, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(32, 5, POSITION_SEQUENCE).
generate_position_sequence(35, 5, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(35, 5, POSITION_SEQUENCE).
generate_position_sequence(40, 7, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(40, 7, POSITION_SEQUENCE).
generate_position_sequence(45, 9, POSITION_SEQUENCE) :- !, generate_prepared_position_sequence(45, 9, POSITION_SEQUENCE).

generate_position_sequence(-1, SEQUENCE_SIZE, POSITION_SEQUENCE) :- !, generate_combination(SEQUENCE_SIZE, POSITION_SEQUENCE).

generate_position_sequence(NEEDED_SUM, SEQUENCE_SIZE, POSITION_SEQUENCE) :- 
	format("WARN : DON'T KNOW COMMUTATIONS FOR SEQUENCE WITH SUM ~w OF ~w ELEMENTS~n", [NEEDED_SUM, SEQUENCE_SIZE]),
	generate_combination(SEQUENCE_SIZE, POSITION_SEQUENCE),
	sum_of_list(POSITION_SEQUENCE, NEEDED_SUM).
	
/*
 * generate_prepared_position_sequence(NEEDED_SUM, SEQUENCE_SIZE, POSITION_SEQUENCE).
 *
 * Takes number sequence for position line that fit passed sum and size constaints from prepared information.
 *
 * @input-param NEEDED_SUM - needed sum of numbers.
 * @input-param SEQUENCE_SIZE - possible count of numbers, that can be used to fit needed sum.
 * @output-param POSITION_SEQUENCE - number sequence that fit passed constaints.
 */
generate_prepared_position_sequence(3, 2, POSITION_SEQUENCE) :- generate_commutation([1,2], 2, POSITION_SEQUENCE). 

generate_prepared_position_sequence(5, 2, POSITION_SEQUENCE) :- generate_commutation([1,4], 2, POSITION_SEQUENCE).
generate_prepared_position_sequence(5, 2, POSITION_SEQUENCE) :- generate_commutation([2,3], 2, POSITION_SEQUENCE).

generate_prepared_position_sequence(6, 3, POSITION_SEQUENCE) :- generate_commutation([1,2,3], 3, POSITION_SEQUENCE).
 
generate_prepared_position_sequence(7, 2, POSITION_SEQUENCE) :- generate_commutation([1,6], 2, POSITION_SEQUENCE).
generate_prepared_position_sequence(7, 2, POSITION_SEQUENCE) :- generate_commutation([2,5], 2, POSITION_SEQUENCE).
generate_prepared_position_sequence(7, 2, POSITION_SEQUENCE) :- generate_commutation([3,4], 2, POSITION_SEQUENCE).

generate_prepared_position_sequence(7, 3, POSITION_SEQUENCE) :- generate_commutation([1,2,4], 3, POSITION_SEQUENCE).

generate_prepared_position_sequence(8, 2, POSITION_SEQUENCE) :- generate_commutation([1,7], 2, POSITION_SEQUENCE).
generate_prepared_position_sequence(8, 2, POSITION_SEQUENCE) :- generate_commutation([2,6], 2, POSITION_SEQUENCE).
generate_prepared_position_sequence(8, 2, POSITION_SEQUENCE) :- generate_commutation([3,5], 2, POSITION_SEQUENCE).

generate_prepared_position_sequence(8, 3, POSITION_SEQUENCE) :- generate_commutation([1,2,5], 3, POSITION_SEQUENCE).
generate_prepared_position_sequence(8, 3, POSITION_SEQUENCE) :- generate_commutation([1,3,4], 3, POSITION_SEQUENCE).

generate_prepared_position_sequence(10, 4, POSITION_SEQUENCE) :- generate_commutation([1,2,3,4], 4, POSITION_SEQUENCE).

generate_prepared_position_sequence(11, 2, POSITION_SEQUENCE) :- generate_commutation([2,9], 2, POSITION_SEQUENCE).
generate_prepared_position_sequence(11, 2, POSITION_SEQUENCE) :- generate_commutation([3,8], 2, POSITION_SEQUENCE).
generate_prepared_position_sequence(11, 2, POSITION_SEQUENCE) :- generate_commutation([4,7], 2, POSITION_SEQUENCE).
generate_prepared_position_sequence(11, 2, POSITION_SEQUENCE) :- generate_commutation([5,6], 2, POSITION_SEQUENCE).

generate_prepared_position_sequence(14, 2, POSITION_SEQUENCE) :- generate_commutation([5,9], 2, POSITION_SEQUENCE).
generate_prepared_position_sequence(14, 2, POSITION_SEQUENCE) :- generate_commutation([6,8], 2, POSITION_SEQUENCE).

generate_prepared_position_sequence(15, 5, POSITION_SEQUENCE) :- generate_commutation([1,2,3,4,5], 5, POSITION_SEQUENCE).

generate_prepared_position_sequence(16, 2, POSITION_SEQUENCE) :- generate_commutation([7,9], 2, POSITION_SEQUENCE).

generate_prepared_position_sequence(16, 5, POSITION_SEQUENCE) :- generate_commutation([1,2,3,4,6], 5, POSITION_SEQUENCE).

generate_prepared_position_sequence(17, 2, POSITION_SEQUENCE) :- generate_commutation([8,9], 2, POSITION_SEQUENCE).

generate_prepared_position_sequence(18, 3, POSITION_SEQUENCE) :- generate_commutation([1,8,9], 3, POSITION_SEQUENCE).
generate_prepared_position_sequence(18, 3, POSITION_SEQUENCE) :- generate_commutation([2,7,9], 3, POSITION_SEQUENCE).
generate_prepared_position_sequence(18, 3, POSITION_SEQUENCE) :- generate_commutation([3,6,9], 3, POSITION_SEQUENCE).
generate_prepared_position_sequence(18, 3, POSITION_SEQUENCE) :- generate_commutation([3,7,8], 3, POSITION_SEQUENCE).
generate_prepared_position_sequence(18, 3, POSITION_SEQUENCE) :- generate_commutation([4,5,9], 3, POSITION_SEQUENCE).
generate_prepared_position_sequence(18, 3, POSITION_SEQUENCE) :- generate_commutation([4,6,8], 3, POSITION_SEQUENCE).
generate_prepared_position_sequence(18, 3, POSITION_SEQUENCE) :- generate_commutation([5,6,7], 3, POSITION_SEQUENCE).

generate_prepared_position_sequence(20, 5, POSITION_SEQUENCE) :- generate_commutation([1,2,3,5,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(20, 5, POSITION_SEQUENCE) :- generate_commutation([1,2,3,6,8], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(20, 5, POSITION_SEQUENCE) :- generate_commutation([1,2,4,5,8], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(20, 5, POSITION_SEQUENCE) :- generate_commutation([1,2,4,6,7], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(20, 5, POSITION_SEQUENCE) :- generate_commutation([1,3,4,5,7], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(20, 5, POSITION_SEQUENCE) :- generate_commutation([2,3,4,5,6], 5, POSITION_SEQUENCE).

generate_prepared_position_sequence(21, 4, POSITION_SEQUENCE) :- generate_commutation([1,3,8,9], 4, POSITION_SEQUENCE).
generate_prepared_position_sequence(21, 4, POSITION_SEQUENCE) :- generate_commutation([1,4,7,9], 4, POSITION_SEQUENCE).
generate_prepared_position_sequence(21, 4, POSITION_SEQUENCE) :- generate_commutation([1,5,6,9], 4, POSITION_SEQUENCE).
generate_prepared_position_sequence(21, 4, POSITION_SEQUENCE) :- generate_commutation([1,5,7,8], 4, POSITION_SEQUENCE).
generate_prepared_position_sequence(21, 4, POSITION_SEQUENCE) :- generate_commutation([2,3,7,9], 4, POSITION_SEQUENCE).
generate_prepared_position_sequence(21, 4, POSITION_SEQUENCE) :- generate_commutation([2,4,6,9], 4, POSITION_SEQUENCE).
generate_prepared_position_sequence(21, 4, POSITION_SEQUENCE) :- generate_commutation([2,4,7,8], 4, POSITION_SEQUENCE).
generate_prepared_position_sequence(21, 4, POSITION_SEQUENCE) :- generate_commutation([2,5,6,8], 4, POSITION_SEQUENCE).
generate_prepared_position_sequence(21, 4, POSITION_SEQUENCE) :- generate_commutation([3,4,5,9], 4, POSITION_SEQUENCE).
generate_prepared_position_sequence(21, 4, POSITION_SEQUENCE) :- generate_commutation([3,4,6,8], 4, POSITION_SEQUENCE).
generate_prepared_position_sequence(21, 4, POSITION_SEQUENCE) :- generate_commutation([3,5,6,7], 4, POSITION_SEQUENCE).

generate_prepared_position_sequence(21, 6, POSITION_SEQUENCE) :- generate_commutation([1,2,3,4,5,6], 6, POSITION_SEQUENCE).

generate_prepared_position_sequence(24, 3, POSITION_SEQUENCE) :- generate_commutation([7,8,9], 3, POSITION_SEQUENCE).

generate_prepared_position_sequence(24, 5, POSITION_SEQUENCE) :- generate_commutation([1,2,4,8,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(24, 5, POSITION_SEQUENCE) :- generate_commutation([1,2,5,7,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(24, 5, POSITION_SEQUENCE) :- generate_commutation([1,2,6,7,8], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(24, 5, POSITION_SEQUENCE) :- generate_commutation([1,3,4,7,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(24, 5, POSITION_SEQUENCE) :- generate_commutation([1,3,5,6,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(24, 5, POSITION_SEQUENCE) :- generate_commutation([1,3,5,7,8], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(24, 5, POSITION_SEQUENCE) :- generate_commutation([1,4,5,6,8], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(24, 5, POSITION_SEQUENCE) :- generate_commutation([2,3,4,6,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(24, 5, POSITION_SEQUENCE) :- generate_commutation([2,3,4,7,8], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(24, 5, POSITION_SEQUENCE) :- generate_commutation([2,3,5,6,8], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(24, 5, POSITION_SEQUENCE) :- generate_commutation([2,4,5,6,7], 5, POSITION_SEQUENCE).

generate_prepared_position_sequence(28, 7, POSITION_SEQUENCE) :- generate_commutation([1,2,3,4,5,6,7], 7, POSITION_SEQUENCE).

generate_prepared_position_sequence(29, 4, POSITION_SEQUENCE) :- generate_commutation([5,7,8,9], 4, POSITION_SEQUENCE).

generate_prepared_position_sequence(29, 5, POSITION_SEQUENCE) :- generate_commutation([1,4,7,8,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(29, 5, POSITION_SEQUENCE) :- generate_commutation([1,5,6,8,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(29, 5, POSITION_SEQUENCE) :- generate_commutation([2,3,7,8,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(29, 5, POSITION_SEQUENCE) :- generate_commutation([2,4,6,8,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(29, 5, POSITION_SEQUENCE) :- generate_commutation([2,5,6,7,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(29, 5, POSITION_SEQUENCE) :- generate_commutation([3,4,5,8,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(29, 5, POSITION_SEQUENCE) :- generate_commutation([3,4,6,7,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(29, 5, POSITION_SEQUENCE) :- generate_commutation([3,5,6,7,8], 5, POSITION_SEQUENCE).

generate_prepared_position_sequence(29, 7, POSITION_SEQUENCE) :- generate_commutation([1,2,3,4,5,6,8], 7, POSITION_SEQUENCE).

generate_prepared_position_sequence(32, 5, POSITION_SEQUENCE) :- generate_commutation([2,6,7,8,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(32, 5, POSITION_SEQUENCE) :- generate_commutation([3,5,7,8,9], 5, POSITION_SEQUENCE).
generate_prepared_position_sequence(32, 5, POSITION_SEQUENCE) :- generate_commutation([4,5,6,8,9], 5, POSITION_SEQUENCE).

generate_prepared_position_sequence(35, 5, POSITION_SEQUENCE) :- generate_commutation([5,6,7,8,9], 5, POSITION_SEQUENCE).

generate_prepared_position_sequence(40, 7, POSITION_SEQUENCE) :- generate_commutation([1,4,5,6,7,8,9], 7, POSITION_SEQUENCE).
generate_prepared_position_sequence(40, 7, POSITION_SEQUENCE) :- generate_commutation([2,3,5,6,7,8,9], 7, POSITION_SEQUENCE).

generate_prepared_position_sequence(45, 9, POSITION_SEQUENCE) :- generate_commutation([1,2,3,4,5,6,7,8,9], 9, POSITION_SEQUENCE).

/*
 * generate_combination(COMBINATION_SIZE, COMBINATION).
 *
 * Generate combination of numbers with passed size and without repetitions.
 *
 * @input-param COMBINATION_SIZE - count of numbers, that can be used.
 * @output-param COMBINATION - number combintaion that has passed count of numbers and has no duplicates.
 */
generate_combination(COMBINATION_SIZE, COMBINATION) :- combinate_numbers([1,2,3,4,5,6,7,8,9], COMBINATION_SIZE, COMBINATION).

/*
 * generate_commutation(COMMUTATION_ELEMENTS, COMMUTATION_SIZE, COMMUTATION).
 *
 * Generate communtation using passed numbers.
 *
 * @input-param COMMUTATION_ELEMENTS - numbers that should be used in generated commutation.
 * @input-param COMMUTATION_SIZE - count of numbers, that can be used in commutation.
 * @output-param COMMUTATION - number commutation that consist of passed count of passed numbers and has no duplicates.
 */
generate_commutation(COMMUTATION_ELEMENTS, COMMUTATION_SIZE, COMMUTATION) :- combinate_numbers(COMMUTATION_ELEMENTS, COMMUTATION_SIZE, COMMUTATION).

/*
 * combinate_numbers(COMBINATION_ELEMENTS, COMBINATION_SIZE, COMBINATION).
 *
 * Generate combination of size COMBINATION_SIZE using numbers from COMBINATION_ELEMENTS.
 *
 * @input-param COMBINATION_ELEMENTS - numbers that should be used in generated combination.
 * @input-param COMBINATION_SIZE - count of numbers, that can be used in combination.
 * @output-param COMBINATION - number combination that consist of passed count of passed numbers and has no duplicates.
 */
combinate_numbers(_, 0, []).
 
combinate_numbers(COMBINATION_ELEMENTS, COMBINATION_SIZE, [ COMBINATION_HEAD | COMBINATION_TAIL ]) :- 
	take_one_element(COMBINATION_ELEMENTS, COMBINATION_HEAD),
	remove_element(COMBINATION_ELEMENTS, COMBINATION_HEAD, NEW_COMBINATION_ELEMENTS),
	NEW_COMBINATION_SIZE is COMBINATION_SIZE - 1,
	combinate_numbers(NEW_COMBINATION_ELEMENTS, NEW_COMBINATION_SIZE, COMBINATION_TAIL).
	
/*
 * take_one_element(LIST, ONE_ELEMENT).
 * 
 * Takes one element from list.
 *
 * During backtracing return all list elemtns in raw.
 *
 * @input-param LIST - some list of elements.
 * @output-param ONE_ELEMENT - one element from passed list.
 */
take_one_element([HEAD | _], HEAD).
take_one_element([_ | TAIL], ONE_ELEMENT) :- take_one_element(TAIL, ONE_ELEMENT).
	
/*
 * is_fit_vertical_constraints(VERTICAL_CONSTAINTS_MATRIX, POSITION_MATRIX).
 *
 * Succeed if passed POSITION_MATRIX fit passed VERTICAL_CONSTAINTS_MATRIX.
 *
 * @input-param VERTICAL_CONSTAINTS_MATRIX - matrix of vertical constaints.
 * @input-param POSITION_MATRIX - answer matrix for cross-sum game.
 */
is_fit_vertical_constraints( [ [_ | VERTICAL_CONSTAINTS_MATRIX_HEADLIST_TAIL] | VERTICAL_CONSTAINTS_MATRIX_TAILISTS ], POSITION_MATRIX) :- 
	generate_empty_list_list(VERTICAL_CONSTAINTS_MATRIX_HEADLIST_TAIL, EMPTY_LIST_LIST),
	do_is_fit_vertical_constraints(
		VERTICAL_CONSTAINTS_MATRIX_TAILISTS, POSITION_MATRIX, VERTICAL_CONSTAINTS_MATRIX_HEADLIST_TAIL, EMPTY_LIST_LIST, VERTICAL_CONSTAINTS_MATRIX_HEADLIST_TAIL
	).

/*
 * do_is_fit_vertical_constraints(VERTICAL_CONSTAINTS_MATRIX, POSITION_MATRIX, NEEDED_SUM_LIST, USED_NUMBERS_LIST, SKIP_LIST).
 *
 * Private worker for @goal is_fit_vertical_constraints.
 *
 * @input-param VERTICAL_CONSTAINTS_MATRIX - matrix of vertical constaints.
 * @input-param POSITION_MATRIX - answer matrix for cross-sum game.
 * @input-param NEEDED_SUM_LIST - list of needed sum constraint for each column.
 * @input-param USED_NUMBERS_LIST - list of list of numbers that was used for each column in position matrix.
 * @input-param SKIP_LIST - list of flags (positive number is false, negative is true, zero is undefined), that signal if needed sum constaint should be checked for each column.
 */
do_is_fit_vertical_constraints([], [], NEEDED_SUM_LIST, _, SKIP_LIST) :- !, all_zeros(NEEDED_SUM_LIST, SKIP_LIST).
 
do_is_fit_vertical_constraints([ [_ | VERTICAL_CONSTRAINTS_MATRIX_HEADLINE_TAIL] | _], [], NEEDED_SUM_LIST, _, SKIP_LIST) :- 
	!, process_last_available_line_to_check_vertical_constraints(VERTICAL_CONSTRAINTS_MATRIX_HEADLINE_TAIL, NEEDED_SUM_LIST, SKIP_LIST).

do_is_fit_vertical_constraints(
		[ [_ | VERTICAL_CONSTRAINTS_MATRIX_HEADLINE_TAIL] | VERTICAL_CONSTRAINTS_MATRIX_TAILLINES], 
		[POSITION_HEAD | POSITION_TAIL], 
		NEEDED_SUM_LIST, 
		USED_NUMBERS_LIST, 
		SKIP_LIST
	) :- 
	process_one_line_to_check_vertical_constraints(
		VERTICAL_CONSTRAINTS_MATRIX_HEADLINE_TAIL, POSITION_HEAD, NEEDED_SUM_LIST, USED_NUMBERS_LIST, SKIP_LIST, NEW_NEEDED_SUM_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST
	),
	do_is_fit_vertical_constraints(VERTICAL_CONSTRAINTS_MATRIX_TAILLINES, POSITION_TAIL, NEW_NEEDED_SUM_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST).
	
/*
 * process_one_line_to_check_vertical_constraints(
 *		VERTICAL_CONSTRAINTS_LINE, POSITION_LINE, NEEDED_SUM_LIST, USED_NUMBERS_LIST, SKIP_LIST, NEW_NEEDED_SUM_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST
 * )
 *
 * Do processing of one line to check if it fit vertical constraint: takes NEEDED_SUM_LIST, USED_NUMBERS_LIST, SKIP_LIST from previous line 
 * and calculates NEW_NEEDED_SUM_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST for this line.
 *
 * @input-param VERTICAL_CONSTRAINTS_LINE - line of vertical constaints matrix.
 * @input-param POSITION_LINE - line of answer matrix for cross-sum game.
 * @input-param NEEDED_SUM_LIST - list of needed sum constraint for each column from previous line.
 * @input-param USED_NUMBERS_LIST - list of list of numbers that was used for each column in position matrix from previous line.
 * @input-param SKIP_LIST - list of flags (positive number is false, negative is true, zero is undefined), 
 * 							that signal if needed sum constaint should be checked for each column from previous line.
 * @output-param NEW_NEEDED_SUM_LIST - list of needed sum constraint for each column for current line.
 * @output-param NEW_USED_NUMBERS_LIST - list of list of numbers that was used for each column in position matrix for current line.
 * @output-param NEW_SKIP_LIST - list of flags (positive number is false, negative is true, zero is undefined), 
 * 							that signal if needed sum constaint should be checked for each column for current line.
 */
process_one_line_to_check_vertical_constraints([], [], _, _, _, [], [], []).

process_one_line_to_check_vertical_constraints(
		[VERTICAL_CONSTRAINTS_LINE_HEAD | VERTICAL_CONSTRAINTS_LINE_TAIL], 
		[_ | POSITON_LINE_TAIL], 
		[NEEDED_SUM_LIST_HEAD | NEEDED_SUM_LIST_TAIL], 
		[_ | USER_NUMBERS_LIST_TAIL], 
		[SKIP_LIST_HEAD | SKIP_LIST_TAIL],
		[VERTICAL_CONSTRAINTS_LINE_HEAD | NEW_NEEDED_SUM_LIST_TAIL], 
		[[] | NEW_USED_NUMBERS_LIST_TAIL],
		[VERTICAL_CONSTRAINTS_LINE_HEAD | NEW_SKIP_LIST_TAIL]
	) :- 
	VERTICAL_CONSTRAINTS_LINE_HEAD =\= 0, SKIP_LIST_HEAD > 0,
	NEEDED_SUM_LIST_HEAD = 0,
	process_one_line_to_check_vertical_constraints(
		VERTICAL_CONSTRAINTS_LINE_TAIL, POSITON_LINE_TAIL, 
		NEEDED_SUM_LIST_TAIL, USER_NUMBERS_LIST_TAIL, SKIP_LIST_TAIL, 
		NEW_NEEDED_SUM_LIST_TAIL, NEW_USED_NUMBERS_LIST_TAIL, NEW_SKIP_LIST_TAIL
	).

process_one_line_to_check_vertical_constraints(
		[VERTICAL_CONSTRAINTS_LINE_HEAD | VERTICAL_CONSTRAINTS_LINE_TAIL], 
		[_ | POSITON_LINE_TAIL], 
		[_ | NEEDED_SUM_LIST_TAIL], 
		[_ | USER_NUMBERS_LIST_TAIL], 
		[SKIP_LIST_HEAD | SKIP_LIST_TAIL],
		[VERTICAL_CONSTRAINTS_LINE_HEAD | NEW_NEEDED_SUM_LIST_TAIL], 
		[[] | NEW_USED_NUMBERS_LIST_TAIL],
		[VERTICAL_CONSTRAINTS_LINE_HEAD | NEW_SKIP_LIST_TAIL]
	) :- 
	VERTICAL_CONSTRAINTS_LINE_HEAD =\= 0, SKIP_LIST_HEAD =< 0,
	process_one_line_to_check_vertical_constraints(
		VERTICAL_CONSTRAINTS_LINE_TAIL, POSITON_LINE_TAIL, 
		NEEDED_SUM_LIST_TAIL, USER_NUMBERS_LIST_TAIL, SKIP_LIST_TAIL, 
		NEW_NEEDED_SUM_LIST_TAIL, NEW_USED_NUMBERS_LIST_TAIL, NEW_SKIP_LIST_TAIL
	).

process_one_line_to_check_vertical_constraints(
		[VERTICAL_CONSTRAINTS_LINE_HEAD | VERTICAL_CONSTRAINTS_LINE_TAIL], 
		[POSITON_LINE_HEAD | POSITON_LINE_TAIL], 
		[NEEDED_SUM_LIST_HEAD | NEEDED_SUM_LIST_TAIL], 
		[USER_NUMBERS_LIST_HEAD | USER_NUMBERS_LIST_TAIL], 
		[SKIP_LIST_HEAD | SKIP_LIST_TAIL],
		[NEW_NEEDED_SUM_LIST_HEAD | NEW_NEEDED_SUM_LIST_TAIL], 
		[[POSITON_LINE_HEAD | USER_NUMBERS_LIST_HEAD] | NEW_USED_NUMBERS_LIST_TAIL],
		[SKIP_LIST_HEAD | NEW_SKIP_LIST_TAIL]
	) :- 
	VERTICAL_CONSTRAINTS_LINE_HEAD = 0, SKIP_LIST_HEAD > 0,
	NEEDED_SUM_LIST_HEAD >= 0, not_contains(POSITON_LINE_HEAD, USER_NUMBERS_LIST_HEAD), NEW_NEEDED_SUM_LIST_HEAD is NEEDED_SUM_LIST_HEAD - POSITON_LINE_HEAD,
	process_one_line_to_check_vertical_constraints(
		VERTICAL_CONSTRAINTS_LINE_TAIL, POSITON_LINE_TAIL, 
		NEEDED_SUM_LIST_TAIL, USER_NUMBERS_LIST_TAIL, SKIP_LIST_TAIL, 
		NEW_NEEDED_SUM_LIST_TAIL, NEW_USED_NUMBERS_LIST_TAIL, NEW_SKIP_LIST_TAIL
	).

process_one_line_to_check_vertical_constraints(
		[VERTICAL_CONSTRAINTS_LINE_HEAD | VERTICAL_CONSTRAINTS_LINE_TAIL], 
		[POSITON_LINE_HEAD | POSITON_LINE_TAIL], 
		[NEEDED_SUM_LIST_HEAD | NEEDED_SUM_LIST_TAIL], 
		[USER_NUMBERS_LIST_HEAD | USER_NUMBERS_LIST_TAIL], 
		[SKIP_LIST_HEAD | SKIP_LIST_TAIL],
		[NEW_NEEDED_SUM_LIST_HEAD | NEW_NEEDED_SUM_LIST_TAIL], 
		[[POSITON_LINE_HEAD | USER_NUMBERS_LIST_HEAD] | NEW_USED_NUMBERS_LIST_TAIL],
		[SKIP_LIST_HEAD | NEW_SKIP_LIST_TAIL]
	) :- 
	VERTICAL_CONSTRAINTS_LINE_HEAD = 0, SKIP_LIST_HEAD =< 0,
	not_contains(POSITON_LINE_HEAD, USER_NUMBERS_LIST_HEAD),
	NEW_NEEDED_SUM_LIST_HEAD is NEEDED_SUM_LIST_HEAD - POSITON_LINE_HEAD,
	process_one_line_to_check_vertical_constraints(
		VERTICAL_CONSTRAINTS_LINE_TAIL, POSITON_LINE_TAIL, 
		NEEDED_SUM_LIST_TAIL, USER_NUMBERS_LIST_TAIL, SKIP_LIST_TAIL, 
		NEW_NEEDED_SUM_LIST_TAIL, NEW_USED_NUMBERS_LIST_TAIL, NEW_SKIP_LIST_TAIL
	).
	
/*
 * process_last_available_line_to_check_vertical_constraints(VERTICAL_CONSTRAINTS_LINE, NEEDED_SUM_LIST, SKIP_LIST).
 *
 * Do processing of last currently available line to check if it fit vertical constraint.
 * As further lines are not calculated yet, checks only if it fit needed sum constaints.
 * Succeed if it fits.
 *
 * @input-param VERTICAL_CONSTRAINTS_LINE - line of vertical constaints matrix.
 * @input-param NEEDED_SUM_LIST - list of needed sum constraint for each column from previous line.
 * @input-param SKIP_LIST - list of flags (positive number is false, negative is true, zero is undefined), 
 * 							that signal if needed sum constaint should be checked for each column from previous line.
 */
process_last_available_line_to_check_vertical_constraints([], _, _).

process_last_available_line_to_check_vertical_constraints(
		[VERTICAL_CONSTRAINTS_LINE_HEAD | VERTICAL_CONSTRAINTS_LINE_TAIL], 
		[NEEDED_SUM_LIST_HEAD | NEEDED_SUM_LIST_TAIL], 
		[SKIP_LIST_HEAD | SKIP_LIST_TAIL]
	) :- 
 	VERTICAL_CONSTRAINTS_LINE_HEAD =\= 0, SKIP_LIST_HEAD > 0,
	NEEDED_SUM_LIST_HEAD = 0,
	process_last_available_line_to_check_vertical_constraints(VERTICAL_CONSTRAINTS_LINE_TAIL, NEEDED_SUM_LIST_TAIL, SKIP_LIST_TAIL).

process_last_available_line_to_check_vertical_constraints(
		[VERTICAL_CONSTRAINTS_LINE_HEAD | VERTICAL_CONSTRAINTS_LINE_TAIL], 
		[_ | NEEDED_SUM_LIST_TAIL], 
		[SKIP_LIST_HEAD | SKIP_LIST_TAIL]
	) :- 
	VERTICAL_CONSTRAINTS_LINE_HEAD =\= 0, SKIP_LIST_HEAD =< 0,
	process_last_available_line_to_check_vertical_constraints(VERTICAL_CONSTRAINTS_LINE_TAIL, NEEDED_SUM_LIST_TAIL, SKIP_LIST_TAIL).

process_last_available_line_to_check_vertical_constraints(
		[VERTICAL_CONSTRAINTS_LINE_HEAD | VERTICAL_CONSTRAINTS_LINE_TAIL], 
		[NEEDED_SUM_LIST_HEAD | NEEDED_SUM_LIST_TAIL], 
		[SKIP_LIST_HEAD | SKIP_LIST_TAIL]
	) :- 
	VERTICAL_CONSTRAINTS_LINE_HEAD = 0, SKIP_LIST_HEAD > 0,
	NEEDED_SUM_LIST_HEAD >= 0,
	process_last_available_line_to_check_vertical_constraints(VERTICAL_CONSTRAINTS_LINE_TAIL, NEEDED_SUM_LIST_TAIL, SKIP_LIST_TAIL).

process_last_available_line_to_check_vertical_constraints(
		[VERTICAL_CONSTRAINTS_LINE_HEAD | VERTICAL_CONSTRAINTS_LINE_TAIL], 
		[_ | NEEDED_SUM_LIST_TAIL], 
		[SKIP_LIST_HEAD | SKIP_LIST_TAIL]
	) :- 
	VERTICAL_CONSTRAINTS_LINE_HEAD = 0, SKIP_LIST_HEAD =< 0,
	process_last_available_line_to_check_vertical_constraints(VERTICAL_CONSTRAINTS_LINE_TAIL, NEEDED_SUM_LIST_TAIL, SKIP_LIST_TAIL).

/*
 * generate_empty_list_list(SOURCE_LIST, EMPTY_LIST_LIST).
 *
 * Generate list that contains as much empty lists as SOURCE_LIST has elements.
 *
 * @input-param SOURCE_LIST - used to get count of needed lists.
 * @output-param EMPTY_LIST_LIST - list of empty lists.
 */
generate_empty_list_list([], []).

generate_empty_list_list([_ | SOURCE_LIST_TAIL], [[] | EMPTY_LIST_LIST_TAIL]) :- generate_empty_list_list(SOURCE_LIST_TAIL, EMPTY_LIST_LIST_TAIL).

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

/*
 */
sum_of_list([], 0).

sum_of_list([ LIST_HEAD | LIST_TAIL ], SUM) :- sum_of_list(LIST_TAIL, SUM_TAIL), SUM is SUM_TAIL + LIST_HEAD.

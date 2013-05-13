cross_sum(X_CONSTRAINTS, Y_CONSTRAINTS, POSITION) :- 
	repeat, 
	generate_position(X_CONSTRAINTS, POSITION),
	format('POSSITION MAP: ~w~n', [POSITION]),
	fit_vertical_constraints(Y_CONSTRAINTS, POSITION).

generate_position([_ | X_CONSTRAINTS_TAIL], POSITION) :- do_generate_position(X_CONSTRAINTS_TAIL, POSITION, 1).

do_generate_position([], [], _).
do_generate_position([CONSTRAINTS_HEAD | CONSTRAINTS_TAIL], [POSITION_HEAD | POSITION_TAIL], INDEX) :- 
	first_position_list(CONSTRAINTS_HEAD, FIRST_POSITION_HEAD),
	format('SEARCHING AT LINE #~w: ~w~n', [INDEX, CONSTRAINTS_HEAD]),
	iterate_following_list(FIRST_POSITION_HEAD, POSITION_HEAD, CONSTRAINTS_HEAD),
	/*format('POSSITION LINE #~w: ~w~n', [INDEX, POSITION_HEAD]),*/
	fit_one_line_constraints(CONSTRAINTS_HEAD, POSITION_HEAD),
	format('HORIZONTAL POSSITION LINE #~w: ~w~n', [INDEX, POSITION_HEAD]),
	NEW_INDEX is INDEX + 1,
	do_generate_position(CONSTRAINTS_TAIL, POSITION_TAIL, NEW_INDEX).
	
first_position_list([_ | CONSTRAINT_LINE_TAIL], LIST_OF_ONE) :- do_first_position_list(CONSTRAINT_LINE_TAIL, LIST_OF_ONE, 1, []).

do_first_position_list([], LIST, _, LIST).
do_first_position_list([CONSTRAINT_LINE_HEAD | CONSTRAINT_LINE_TAIL], LIST, ELEMENT, ACCUMULATOR) :- 
	CONSTRAINT_LINE_HEAD = 0,
	NEW_ELEMENT is ELEMENT + 1,
	do_first_position_list(CONSTRAINT_LINE_TAIL, LIST, NEW_ELEMENT, [ELEMENT | ACCUMULATOR]).
do_first_position_list([CONSTRAINT_LINE_HEAD | CONSTRAINT_LINE_TAIL], NEW_LIST, _, ACCUMULATOR) :- 
	CONSTRAINT_LINE_HEAD =\= 0,
	append_element(ACCUMULATOR, 0, TEMP_LIST),
	append(TEMP_LIST, LIST, NEW_LIST),
	do_first_position_list(CONSTRAINT_LINE_TAIL, LIST, 1, []).

iterate_following_list(FIRST_LIST, FIRST_LIST, _).
iterate_following_list(FIRST_LIST, FOLLOWING_LIST, CONSTRAINT_LINE) :- 
	following_list(CONSTRAINT_LINE, FIRST_LIST, ITERATE_LIST), iterate_following_list(ITERATE_LIST, FOLLOWING_LIST, CONSTRAINT_LINE).

following_list([CONSTRAINT_LINE_HEAD | CONSTRAINT_LINE_TAIL], LIST, FOLLOWING_TAIL) :- 
	do_following_list(CONSTRAINT_LINE_HEAD, [], CONSTRAINT_LINE_TAIL, LIST, FOLLOWING_TAIL).

do_following_list(NEEDED_SUM, PLACEHOLDER_LIST, _, [], FOLLOWING_SEQUENCE) :- 
	do_following_sequence(NEEDED_SUM, PLACEHOLDER_LIST, FOLLOWING_SEQUENCE, 0).
do_following_list(NEEDED_SUM, PLACEHOLDER_LIST, [CONSTRAINT_LINE_HEAD | _], [_ | LIST_TAIL], FOLLOWING_LIST) :- 
	CONSTRAINT_LINE_HEAD =\= 0,
	do_following_sequence(NEEDED_SUM, PLACEHOLDER_LIST, FOLLOWING_SEQUENCE, 0),
	append_element(FOLLOWING_SEQUENCE, 0, TEMPORARY_SEQUENCE),
	append(TEMPORARY_SEQUENCE, LIST_TAIL, FOLLOWING_LIST).	
do_following_list(NEEDED_SUM, PLACEHOLDER_LIST, [CONSTRAINT_LINE_HEAD | CONSTRAINT_LINE_TAIL], [_ | LIST_TAIL], FOLLOWING_LIST) :- 
	CONSTRAINT_LINE_HEAD =\= 0,
	do_following_sequence(NEEDED_SUM, PLACEHOLDER_LIST, FOLLOWING_SEQUENCE, 1),
	do_following_list(CONSTRAINT_LINE_HEAD, [], CONSTRAINT_LINE_TAIL, LIST_TAIL, FOLLOWING_LIST_TAIL),
	append_element(FOLLOWING_SEQUENCE, 0, TEMPORARY_SEQUENCE),
	append(TEMPORARY_SEQUENCE, FOLLOWING_LIST_TAIL, FOLLOWING_LIST).	
do_following_list(NEEDED_SUM, PLACEHOLDER_LIST, [CONSTRAINT_LINE_HEAD | CONSTRAINT_LINE_TAIL], [LIST_HEAD | LIST_TAIL], FOLLOWING_LIST) :- 
	CONSTRAINT_LINE_HEAD = 0,
	append_element(PLACEHOLDER_LIST, LIST_HEAD, NEW_PLACEHOLDER_LIST),
	do_following_list(NEEDED_SUM, NEW_PLACEHOLDER_LIST, CONSTRAINT_LINE_TAIL, LIST_TAIL, FOLLOWING_LIST).
	
append_element([], ELEMENT, [ELEMENT]).
append_element([LIST_HEAD | LIST_TAIL], ELEMENT, [LIST_HEAD | APPEND_TAIL]) :- append_element(LIST_TAIL, ELEMENT, APPEND_TAIL).

do_following_sequence(11, [2,1], [9,2], 0) :- !.

do_following_sequence(8, [2,1], [7,1], 0) :- !.
do_following_sequence(8, [1,7], [7,1], 1) :- !.
do_following_sequence(8, [E1,E2], [F1,F2], 0) :- !, E1 > 1, F1 is E1 - 1, F2 is E2 + 1.

do_following_sequence(21, [E1, E2, E3, E4, E5, E6], FOLLOWING_SEQUENCE, LAST_SEQUENCE) 
	:- !, following_commutation([], [E1, E2, E3, E4, E5, E6], FOLLOWING_SEQUENCE, LAST_SEQUENCE).

do_following_sequence(35, [5, 4, 3, 2, 1], [9, 8, 7, 6, 5], 0).
do_following_sequence(35, [E1, E2, E3, E4, E5], FOLLOWING_SEQUENCE, LAST_SEQUENCE) 
	:- !, following_commutation([], [E1, E2, E3, E4, E5], FOLLOWING_SEQUENCE, LAST_SEQUENCE).

do_following_sequence(_, [], [], 1) .
do_following_sequence(NEEDED_SUM, [9 | SEQUENCE_TAIL], [1 | FOLLOWING_TAIL], LAST_SEQUENCE) :- do_following_sequence(NEEDED_SUM, SEQUENCE_TAIL, FOLLOWING_TAIL, LAST_SEQUENCE).
do_following_sequence(_, [SEQUENCE_HEAD | SEQUENCE_TAIL], [FOLLOWING_HEAD | SEQUENCE_TAIL], 0) :- SEQUENCE_HEAD < 9, FOLLOWING_HEAD is SEQUENCE_HEAD + 1.

following_commutation(ACCUMULATOR, [], FOLLOWING_COMMUTATION, 1) :- 
	sort_list(ACCUMULATOR, FOLLOWING_COMMUTATION).
following_commutation(ACCUMULATOR, [COMMUTATION_HEAD | COMMUTATION_TAIL], FOLLOWING_COMMUTATION, 0) :-
	next_element(ACCUMULATOR, COMMUTATION_HEAD, NEXT_ELEMENT),
	replace(ACCUMULATOR, NEXT_ELEMENT, COMMUTATION_HEAD, ACCUMULATOR_1),
	sort_list(ACCUMULATOR_1, ACCUMULATOR_2),
	append_element(ACCUMULATOR_2, NEXT_ELEMENT, ACCUMULATOR_3),
	append(ACCUMULATOR_3, COMMUTATION_TAIL, FOLLOWING_COMMUTATION).
following_commutation(ACCUMULATOR, [COMMUTATION_HEAD | COMMUTATION_TAIL], FOLLOWING_COMMUTATION, LAST_COMMUTATION) :-
	next_not_exists(ACCUMULATOR, COMMUTATION_HEAD),
	following_commutation([COMMUTATION_HEAD | ACCUMULATOR], COMMUTATION_TAIL, FOLLOWING_COMMUTATION, LAST_COMMUTATION).

sort_list([], []).
sort_list([LIST_HEAD], [LIST_HEAD]).
sort_list([LIST_HEAD | LIST_TAIL], SORTED_LIST) :-
	split_by_element(LIST_HEAD, [LIST_HEAD | LIST_TAIL], LIST1, LIST2),
	sort_list(LIST1, SORTED_LIST1),
	sort_list(LIST2, SORTED_LIST2),
	append_element(SORTED_LIST2, LIST_HEAD, TEMPORARY_LIST),
	append(TEMPORARY_LIST, SORTED_LIST1, SORTED_LIST).

split_by_element(_, [], [], []).
split_by_element(SPLIT_ELEMENT, [LIST_HEAD | LIST_TAIL], [LIST_HEAD | LESS_LIST_TAIL], MORE_LIST) :- 
	LIST_HEAD < SPLIT_ELEMENT, split_by_element(SPLIT_ELEMENT, LIST_TAIL, LESS_LIST_TAIL, MORE_LIST).
split_by_element(SPLIT_ELEMENT, [LIST_HEAD | LIST_TAIL], LESS_LIST, [LIST_HEAD | MORE_LIST_TAIL]) :- 
	LIST_HEAD > SPLIT_ELEMENT, split_by_element(SPLIT_ELEMENT, LIST_TAIL, LESS_LIST, MORE_LIST_TAIL).
split_by_element(SPLIT_ELEMENT, [LIST_HEAD | LIST_TAIL], LESS_LIST, MORE_LIST) :- 
	LIST_HEAD = SPLIT_ELEMENT, split_by_element(SPLIT_ELEMENT, LIST_TAIL, LESS_LIST, MORE_LIST).

next_element(ACCUMULATOR, REPLACE_ELEMENT, NEXT_ELEMENT) :- 
	sort_list(ACCUMULATOR, TEMPORARY_ACCUMULATOR), 
	reverse(TEMPORARY_ACCUMULATOR, SORTED_ACCUMULATOR),
	do_next_element(SORTED_ACCUMULATOR, REPLACE_ELEMENT, NEXT_ELEMENT).
	
do_next_element([SORTED_ACCUMULATOR_HEAD | _], REPLACE_ELEMENT, SORTED_ACCUMULATOR_HEAD) :- 
	SORTED_ACCUMULATOR_HEAD > REPLACE_ELEMENT.
do_next_element([SORTED_ACCUMULATOR_HEAD | SORTED_ACCUMULATOR_TAIL], REPLACE_ELEMENT, NEXT_ELEMENT) :- 
	SORTED_ACCUMULATOR_HEAD < REPLACE_ELEMENT, do_next_element(SORTED_ACCUMULATOR_TAIL, REPLACE_ELEMENT, NEXT_ELEMENT).

next_not_exists([], _).
next_not_exists([ACCUMULATOR_HEAD | ACCUMULATOR_TAIL], REPLACE_ELEMENT) :- 
	ACCUMULATOR_HEAD < REPLACE_ELEMENT, next_not_exists(ACCUMULATOR_TAIL, REPLACE_ELEMENT).

replace([], _, _, []).
replace([OLD_ELEMENT | LIST_TAIL], OLD_ELEMENT, NEW_ELEMENT, [NEW_ELEMENT | NEW_LIST_TAIL]) :- replace(LIST_TAIL, OLD_ELEMENT, NEW_ELEMENT, NEW_LIST_TAIL).
replace([LIST_HEAD | LIST_TAIL], OLD_ELEMENT, NEW_ELEMENT, [LIST_HEAD | NEW_LIST_TAIL]) :- 
	LIST_HEAD =\= OLD_ELEMENT, replace(LIST_TAIL, OLD_ELEMENT, NEW_ELEMENT, NEW_LIST_TAIL).

fit_one_line_constraints([CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], POSITON_LINE) :- 
	CONSTRAINTS_LINE_HEAD > 0, is_fit_one_line_constraints(CONSTRAINTS_LINE_TAIL, POSITON_LINE, CONSTRAINTS_LINE_HEAD, []).
fit_one_line_constraints([CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], POSITON_LINE) :- 
	CONSTRAINTS_LINE_HEAD =< 0, skip_one_line_constraints(CONSTRAINTS_LINE_TAIL, POSITON_LINE, []).

is_fit_one_line_constraints([], [], 0, _).
is_fit_one_line_constraints([CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], [_ | POSITON_LINE_TAIL], POINTS_LEFT, _) :- 
	CONSTRAINTS_LINE_HEAD > 0, POINTS_LEFT = 0, 
	is_fit_one_line_constraints(CONSTRAINTS_LINE_TAIL, POSITON_LINE_TAIL, CONSTRAINTS_LINE_HEAD, []).
is_fit_one_line_constraints([CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], [_ | POSITON_LINE_TAIL], POINTS_LEFT, _) :- 
	CONSTRAINTS_LINE_HEAD < 0, POINTS_LEFT = 0, 
	skip_one_line_constraints(CONSTRAINTS_LINE_TAIL, POSITON_LINE_TAIL, []).
is_fit_one_line_constraints([CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], [POSITON_LINE_HEAD | POSITON_LINE_TAIL], POINTS_LEFT, USED_NUMBERS) :- 
	CONSTRAINTS_LINE_HEAD = 0, POINTS_LEFT >= 0, not_contains(POSITON_LINE_HEAD, USED_NUMBERS), NEW_POINTS_LEFT is POINTS_LEFT - POSITON_LINE_HEAD, 
	is_fit_one_line_constraints(CONSTRAINTS_LINE_TAIL, POSITON_LINE_TAIL, NEW_POINTS_LEFT, [POSITON_LINE_HEAD | USED_NUMBERS]).
	
skip_one_line_constraints([], [], _).
skip_one_line_constraints([CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], [_ | POSITON_LINE_TAIL], _) :- 
	CONSTRAINTS_LINE_HEAD > 0, is_fit_one_line_constraints(CONSTRAINTS_LINE_TAIL, POSITON_LINE_TAIL, CONSTRAINTS_LINE_HEAD, []).
skip_one_line_constraints([CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], [_ | POSITON_LINE_TAIL], _) :- 
	CONSTRAINTS_LINE_HEAD < 0, skip_one_line_constraints(CONSTRAINTS_LINE_TAIL, POSITON_LINE_TAIL, []).
skip_one_line_constraints([CONSTRAINTS_LINE_HEAD | CONSTRAINTS_LINE_TAIL], [POSITON_LINE_HEAD | POSITON_LINE_TAIL], USED_NUMBERS) :- 
	CONSTRAINTS_LINE_HEAD = 0, not_contains(POSITON_LINE_HEAD, USED_NUMBERS), skip_one_line_constraints(CONSTRAINTS_LINE_TAIL, POSITON_LINE_TAIL, [POSITON_LINE_HEAD | USED_NUMBERS]).

not_contains(_, []).
not_contains(ELEMENT, [ELEMENT | _]) :- false.
not_contains(ELEMENT, [LIST_HEAD | LIST_TAIL]) :- LIST_HEAD =\= ELEMENT, not_contains(ELEMENT, LIST_TAIL).

fit_vertical_constraints([[_ | Y_CONSTRAINTS_HEAD] | Y_CONSTRAINTS_TAIL], POSITION) :- 
	generate_empty_list_list(POSITION, EMPTY_LIST_LIST),
	is_fit_vertical_constraints(Y_CONSTRAINTS_TAIL, POSITION, Y_CONSTRAINTS_HEAD, EMPTY_LIST_LIST, Y_CONSTRAINTS_HEAD).

is_fit_vertical_constraints([], [], POINTS_LEFT_LIST, _, SKIP_LIST) :- all_zeros(POINTS_LEFT_LIST, SKIP_LIST).
is_fit_vertical_constraints([CONSTRAINTS_HEAD | CONSTRAINTS_TAIL], [POSITION_HEAD | POSITION_TAIL], POINTS_LEFT_LIST, USED_NUMBERS_LIST, SKIP_LIST) :- 
	process_vertical_constraints(CONSTRAINTS_HEAD, POSITION_HEAD, POINTS_LEFT_LIST, USED_NUMBERS_LIST, SKIP_LIST, NEW_POINTS_LEFT_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST),
	is_fit_vertical_constraints(CONSTRAINTS_TAIL, POSITION_TAIL, NEW_POINTS_LEFT_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST).

process_vertical_constraints([_ | CONSTRAINTS_LINE_TAIL], POSITION_HEAD, POINTS_LEFT_LIST, USED_NUMBERS_LIST, SKIP_LIST, NEW_POINTS_LEFT_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST) :- 
	do_process_vertical_constraints(CONSTRAINTS_LINE_TAIL, POSITION_HEAD, POINTS_LEFT_LIST, USED_NUMBERS_LIST, SKIP_LIST, NEW_POINTS_LEFT_LIST, NEW_USED_NUMBERS_LIST, NEW_SKIP_LIST).
	
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
	
generate_empty_list_list([], []).
generate_empty_list_list([_ | TAIL], [[] | LIST]) :- generate_empty_list_list(TAIL, LIST).

all_zeros([], []).
all_zeros([0 | TAIL], [SKIP_LIST_HEAD | SKIP_LIST_TAIL]) :- SKIP_LIST_HEAD > 0, all_zeros(TAIL, SKIP_LIST_TAIL).
all_zeros([_ | TAIL], [SKIP_LIST_HEAD | SKIP_LIST_TAIL]) :- SKIP_LIST_HEAD =< 0, all_zeros(TAIL, SKIP_LIST_TAIL).
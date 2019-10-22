counts(_, _, _, _).

get_nth_col([], _, []).
get_nth_col([TH|TT], N, [CH|CT]):-
    nth(N, TH, CH),
    get_nth_col(TT, N, CT).

transpose(L, N, R):- transpose_helper(L, N, R, 1).
transpose_helper(_, N, [], D):- D =:= N + 1.
transpose_helper(L, N, [RH|RT], D):-
    get_nth_col(L, D, RH),
    D1 is D + 1,
    transpose_helper(L, N, RT, D1).

count_visible(V, M, N):-
    count_visible_helper(V, M, L),
    length(L, N).
count_visible_helper([], _, []).
count_visible_helper([Vh|Vt], M, L):-
    Vh > M,
    count_visible_helper(Vt, Vh, B),
    append([Vh], B, L).
count_visible_helper([Vh|Vt], M, L):-
    Vh =< M,
    count_visible_helper(Vt, M, L).

fd_all_permutation(_, [], []).
fd_all_permutation(N, [TH|TT], [RH|RT]):-
    fd_domain(TH, 1, N),
    fd_all_different(TH),
    fd_domain(RH, 1, N),
    fd_all_different(RH),
    fd_all_permutation(N, TT, RT).

gen_matrix(_, [], []).
gen_matrix(N, T, R):-
    length(T, N),
    maplist(length_of_list(N), T),
    transpose(T, N, R),
    fd_all_permutation(N, T, R).

tower_helper(N, _, counts([], [], [], []), _, D):- D =:= N + 1.
tower_helper(N, T, counts([Th|Tt], [Bh|Bt], [Lh|Lt], [Rh|Rt]), R, D):-
    nth(D, R, C1),
    fd_labeling(C1),
    count_visible(C1, 0, Th),
    reverse(C2, C1),
    count_visible(C2, 0, Bh),
    nth(D, T, R1),
    fd_labeling(R1),
    count_visible(R1, 0, Lh),
    reverse(R2, R1),
    count_visible(R2, 0, Rh),
    D1 is D + 1,
    tower_helper(N, T, counts(Tt, Bt, Lt, Rt), R, D1).

tower(N, T, C):-
    gen_matrix(N, T, R),    
    tower_helper(N, T, C, R, 1).

gen_sequence(N, V):-
    length(V, N),
    gen_sequence_helper(N, 0, V).
gen_sequence_helper(_, _, []).
gen_sequence_helper(N, M, [VH|VT]):-
    VH is M + 1,
    gen_sequence_helper(N, VH, VT).

all_permutation(_, [], []).
all_permutation(P, [TH|TT], [RH|RT]):-
    permutation(P, TH),
    permutation(P, RH),
    all_permutation(P, TT, RT).

length_of_list(N, L):-
    length(L, N).
plain_gen_matrix(N, T, R):-
    length(T, N),
    gen_sequence(N, P),
    maplist(length_of_list(N), T),
    transpose(T, N, R),
    all_permutation(P, T, R).

plain_tower_helper(N, _, counts([], [], [], []), _, D):- D =:= N + 1.
plain_tower_helper(N, T, counts([Th|Tt], [Bh|Bt], [Lh|Lt], [Rh|Rt]), R, D):-
    nth(D, R, C1),
    count_visible(C1, 0, Th),
    reverse(C2, C1),
    count_visible(C2, 0, Bh),
    nth(D, T, R1),
    count_visible(R1, 0, Lh),
    reverse(R2, R1),
    count_visible(R2, 0, Rh),
    D1 is D + 1,
    plain_tower_helper(N, T, counts(Tt, Bt, Lt, Rt), R, D1).

plain_tower(N, T, C):-
    plain_gen_matrix(N, T, R),
    plain_tower_helper(N, T, C, R, 1).

distinct_lists([], []):- fail.
distinct_lists([V1H|V1T], [V2H|V2T]):-
    V1H \= V2H;
    distinct_lists(V1T, V2T).

distinct_matrices([], []):- fail.
distinct_matrices([T1H|T1T], [T2H|T2T]):-
    distinct_lists(T1H, T2H);
    distinct_matrices(T1T, T2T).

ambiguous(N, C, T1, T2):-
    tower(N, T1, C),
    tower(N, T2, C),
    distinct_matrices(T1, T2).
    
speedup(R):-
    statistics(cpu_time, _),
    tower(6, [[_, _, _, 2|_], [_, 1, _, _, 3, _],
	      _, [_, _, _, 4|_], [3|_], _],
	  counts(
	      [4, 1, 2, 2, 3, 3],
	      [2, 3, 1, 4, 2, 3],
	      [2, 3, 3, 1, 3, 2],
	      [4, 2, 1, 3, 2, 3])),
    statistics(cpu_time, [_|T1]),
    plain_tower(6, [[_, _, _, 2|_], [_, 1, _, _, 3, _],
		    _, [_, _, _, 4|_], [3|_], _],
		counts(
		    [4, 1, 2, 2, 3, 3],
		    [2, 3, 1, 4, 2, 3],
		    [2, 3, 3, 1, 3, 2],
		    [4, 2, 1, 3, 2, 3])),
    statistics(cpu_time, [_|T2]),
    R is T2/T1.

let my_subset_test0 = subset [1; 2; 3] [4; 3; 5; 6; 2; 3; 1]
let my_subset_test1 = not (subset [1; 2; 3] [4; 3; 5; 6; 0; 3; 1])

let my_equal_sets_test0 = equal_sets [] []
let my_equal_sets_test1 = not (equal_sets [] [1])

let my_set_union_test0 = equal_sets (set_union [5; 6] [1; 2; 3]) [1; 2; 5; 6; 3]
let my_set_union_test1 = equal_sets (set_union [] [1; 2; 3]) [1; 2; 3]

let my_set_intersection_test0 =
  equal_sets (set_intersection [1] [2;3]) []
let my_set_intersection_test1 =
  equal_sets (set_intersection [3;6;0] [1;2;3]) [3]
let my_set_intersection_test2 =
  equal_sets (set_intersection [1;2;3;4] [3;1]) [3;1]

let my_set_diff_test0 = equal_sets (set_diff [1;3] [1;4;1]) [3]
let my_set_diff_test1 = equal_sets (set_diff [4;3;1;1;3] [1;3;4]) []

let my_computed_fixed_point_test0 =
  computed_fixed_point (=) (fun x -> x / 2) 9999 = 0
let my_computed_fixed_point_test2 =
  computed_fixed_point (=) sqrt 100. = 1.

type my_nonterminals =
  | A | B | C | D | E | X | Y

let my_rules =
  [A, [T"a"; N B; N C];
   B, [T"b"; N A; N E];
   C, [N B; N E; T"c"];
   D, [N X];
   E, [T"e"; N B];
   X, [N Y];
   Y, []]

let my_grammar = A, my_rules
  
let my_filter_reachable_test0 =
  filter_reachable my_grammar =
    (A,
     [A, [T"a"; N B; N C];
      B, [T"b"; N A; N E];
      C, [N B; N E; T"c"];
      E, [T"e"; N B]])
  
let my_filter_reachable_test1 =
  filter_reachable (X, my_rules) =
    (X,
     [X, [N Y];
      Y, []])


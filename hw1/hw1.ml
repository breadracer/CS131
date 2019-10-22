let rec subset a b = match (a, b) with
    ([], b) -> true
  | (a_hd :: [], b) -> List.exists (fun el -> (el = a_hd)) b
  | (a_hd :: a_tl, b) -> subset (a_hd :: []) b && subset a_tl b

let equal_sets a b = subset a b && subset b a

let rec set_union a b = match (a, b) with
    ([], b) -> b
  | (a, []) -> a
  | (a_hd :: a_tl, b_hd :: b_tl) -> a_hd :: b_hd :: set_union a_tl b_tl

let rec set_intersection a b = match (a, b) with
    ([], b) -> []
  | (a_hd :: a_tl, b) ->
     List.filter (fun el -> (el = a_hd)) b @ set_intersection a_tl b

let rec set_diff a b = match (a, b) with
    ([], b) -> []
  | (a_hd :: a_tl, b) ->
     (match List.exists (fun el -> (el = a_hd)) b with
        true -> set_diff a_tl b
      | false -> a_hd :: set_diff a_tl b)

let rec computed_fixed_point eq f x = match eq (f x) x with
    true -> x
  | false -> computed_fixed_point eq f (f x)

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

let rec find_reachable start rule_list = match rule_list with
    [] -> []
  | rules ->
     let rec scan_rules rules = match rules with
         [] -> []
       | rules_hd :: rules_tl ->
          let rec scan_rule rule = match rule with
              (lhs, rhs) ->
              (match lhs = start with
                 false -> []
               | true ->
                  (match rhs with
                     [] -> []
                   | T t :: rhs_tl -> scan_rule (start, rhs_tl)
                   | N n :: rhs_tl ->
                      (match n = start with
                         true -> scan_rule (start, rhs_tl)
                       | false ->
                          set_union
                            (scan_rule (start, rhs_tl))
                            (find_reachable n
                               (List.filter (fun el -> (fst el != start)) rule_list)))))
          in set_union (scan_rule rules_hd) (scan_rules rules_tl)
     in set_union (scan_rules rules) [start]

let filter_reachable g = match g with
    (start, rule_list) ->
    let rec filter_rules reachables rule_list = match rule_list with
        [] -> []
      | (lhs, rhs) :: rules_tl ->
         (match List.exists (fun el -> (el = lhs)) reachables with
            true -> set_union [(lhs, rhs)] (filter_rules reachables rules_tl)
          | false -> filter_rules reachables rules_tl)
    in (start, filter_rules (find_reachable start rule_list) rule_list)

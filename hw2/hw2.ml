type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

type ('nonterminal, 'terminal) parse_tree =
  | Node of 'nonterminal * ('nonterminal, 'terminal) parse_tree list
  | Leaf of 'terminal
          
let rec get_rhs_list nt = function
  | [] -> []
  | (lhs, rhs) :: rules_tl ->
     if lhs == nt
     then rhs :: (get_rhs_list nt rules_tl)
     else get_rhs_list nt rules_tl
    
let convert_grammar = function
  | start, rules -> start, function | nt -> get_rhs_list nt rules
                                          
let rec parse_tree_leaves = function
  | Leaf l -> [l]
  | Node (parent, children) ->
     let rec traverse_children = function
       | [] -> []
       | Leaf l :: children_tl ->
          l :: traverse_children children_tl
       | Node (p, c) :: children_tl ->
          parse_tree_leaves (Node (p, c)) @ traverse_children children_tl
     in traverse_children children

let match_empty accept prefix frag = accept prefix frag
let match_nothing accept prefix frag = None

let accept_empty_suffix prefix suffix = match suffix with
  | [] -> Some (prefix, suffix)
  | _ -> None                                     
                                     
let rec get_prefix_suffix gram = function
  | [] -> match_nothing
  | rule_hd :: rule_tl ->
     fun accept prefix frag ->
     let rec scan_rule = function
       | [] -> match_empty
       | N nt :: rule_tl ->
          let rules = snd gram nt
          in fun accept prefix frag ->
             let next_accept = scan_rule rule_tl accept
             in get_prefix_suffix (nt, snd gram) rules next_accept prefix frag
       | T t :: rule_tl ->
          fun accept prefix ->
          function | [] -> None
                   | frag_hd :: frag_tl ->
                      if frag_hd = t
                      then scan_rule rule_tl accept prefix frag_tl
                      else None in
     let head_matcher = scan_rule rule_hd accept (prefix @ [fst gram, rule_hd]) frag
     in match head_matcher with
        | None -> get_prefix_suffix gram rule_tl accept prefix frag
        | _ -> head_matcher
             
let make_matcher gram accept frag =
  let make_accept accept prefix frag = fun prefix frag ->
    match (accept frag) with
    | Some c -> Some ([], c)
    | None -> None in
  let new_accept = make_accept accept [] frag in
  match get_prefix_suffix gram (snd gram (fst gram)) new_accept [] frag with
  | Some (prefix, suffix) -> Some suffix
  | None -> None

let make_parser gram frag =
  match get_prefix_suffix gram (snd gram (fst gram)) accept_empty_suffix [] frag with
  | None -> None
  | Some (prefix, suffix) ->
     let rec construct_tree = function
       | [] -> [], Node (fst gram, [])
       | (nt, rhs) :: rules_tl ->
          let rec search_on_node rules_left = function
            | [] -> rules_left, []
            | N nt :: rhs_tl ->
               let current = search_on_node (fst (construct_tree rules_left)) rhs_tl
               in fst current, snd (construct_tree rules_left) :: snd current
            | T t :: rhs_tl ->
               let rest = search_on_node rules_left rhs_tl
               in fst rest, Leaf t :: snd rest
          in let next = search_on_node rules_tl rhs
             in fst next, Node (nt, snd (search_on_node rules_tl rhs))
     in Some (snd (construct_tree prefix))

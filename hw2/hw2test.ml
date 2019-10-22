type awksub_nonterminals =
  | Expr | Term | Lvalue | Incrop | Binop | Num
                                          
let awksub_rules =
  [Expr, [T"("; N Expr; T")"];
   Expr, [N Num];
   Expr, [N Expr; N Binop; N Expr];
   Expr, [N Lvalue];
   Expr, [N Incrop; N Lvalue];
   Expr, [N Lvalue; N Incrop];
   Lvalue, [T"$"; N Expr];
   Incrop, [T"++"];
   Incrop, [T"--"];
   Binop, [T"+"];
   Binop, [T"-"];
   Num, [T"0"];
   Num, [T"1"];
   Num, [T"2"];
   Num, [T"3"];
   Num, [T"4"];
   Num, [T"5"];
   Num, [T"6"];
   Num, [T"7"];
   Num, [T"8"];
   Num, [T"9"]]

let awksub_grammar = Expr, awksub_rules
                   
type giant_nonterminals =
  | Conversation | Sentence | Grunt | Snore | Shout | Quiet

let giant_grammar =
  Conversation,
  [Snore, [T"ZZZ"];
   Quiet, [];
   Grunt, [T"khrgh"];
   Shout, [T"aooogah!"];
   Sentence, [N Quiet];
   Sentence, [N Grunt];
   Sentence, [N Shout];
   Conversation, [N Snore];
   Conversation, [N Sentence; T","; N Conversation]]

let converted_awksub_grammar = convert_grammar awksub_grammar
let converted_giant_grammar = convert_grammar giant_grammar
                            
let my_convert_grammar_test0 =
  snd converted_awksub_grammar Expr =
    [[T "("; N Expr; T ")"]; [N Num]; [N Expr; N Binop; N Expr]; [N Lvalue];
     [N Incrop; N Lvalue]; [N Lvalue; N Incrop]]

let my_convert_grammar_test1 =
  snd converted_awksub_grammar Num =
    [[T "0"]; [T "1"]; [T "2"]; [T "3"]; [T "4"];
     [T "5"]; [T "6"]; [T "7"]; [T "8"]; [T "9"]]

let my_convert_grammar_test2 =
  snd converted_awksub_grammar Incrop =
    [[T "++"]; [T "--"]]

let my_convert_grammar_test3 =
  snd converted_giant_grammar Conversation =
    [[N Snore]; [N Sentence; T ","; N Conversation]]

let my_convert_grammar_test4 =
  snd converted_giant_grammar Quiet =
    [[]]

let tree =
  Node (Expr,
	[Node (Term,
	       [Node (Lvalue,
		      [Leaf "$";
		       Node (Expr,
			     [Node (Term,
				    [Node (Num,
					   [Leaf "1"])])])]);
		Node (Incrop, [Leaf "++"])]);
	 Node (Binop,
	       [Leaf "-"]);
	 Node (Expr,
	       [Node (Term,
		      [Node (Num,
			     [Leaf "2"])])])])

let my_parse_tree_leaves_test0 =
  parse_tree_leaves tree =
    ["$"; "1"; "++"; "-"; "2"]

let awkish_grammar =
  (Expr,
   function
   | Expr ->
      [[N Term; N Binop; N Expr];
       [N Term]]
   | Term ->
      [[N Num];
       [N Lvalue];
       [N Incrop; N Lvalue];
       [N Lvalue; N Incrop];
       [T"("; N Expr; T")"]]
   | Lvalue ->
      [[T"$"; N Expr]]
   | Incrop ->
      [[T"++"];
       [T"--"]]
   | Binop ->
      [[T"+"];
       [T"-"]]
   | Num ->
      [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
       [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]])

let accept_all string = Some string
let accept_empty_suffix = function
  | _::_ -> None
  | x -> Some x

let giant_grammar =
  Conversation,
  function
  | Snore -> [[T"ZZZ"];]
  | Quiet -> [[T"shh"];]
  | Grunt -> [[T"khrgh"];]
  | Shout -> [[T"aooogah!"];]
  | Sentence -> [[N Quiet]; [N Grunt]; [N Shout];]
  | Conversation -> [[N Snore]; [N Sentence; T","; N Conversation]]
                  
let my_make_matcher_test =
  make_matcher
    giant_grammar
    accept_all
    ["shh"; ","; "aooogah!"; ","; "ZZZ"]
  = Some []
  
let my_make_parser_test =
  make_parser giant_grammar ["shh"; ","; "aooogah!"; ","; "ZZZ"]
  = Some
      (Node (Conversation,
             [Node (Sentence, [Node (Quiet, [Leaf "shh"])]); Leaf ",";
              Node (Conversation,
                    [Node (Sentence, [Node (Shout, [Leaf "aooogah!"])]); Leaf ",";
                     Node (Conversation, [Node (Snore, [Leaf "ZZZ"])])])]))
      

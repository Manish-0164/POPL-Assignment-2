% P2 — Arithmetic Equation
% Implement generate_equation/2, all_equations/2 and count_equations/2.
% Keep arithmetic evaluation and canonical string formatting separate.

% split_equation(+Numbers, -Left, -Right) splits Numbers into a nonempty
% prefix and suffix. On backtracking, move one number from right to left.
split_equation([First, Second | Rest], [First], [Second | Rest]).
split_equation([First | Rest], [First | Left], Right) :-
    split_equation(Rest, Left, Right).

% expr_tree(+Numbers, -Tree) builds each binary expression over Numbers
% in order. A contiguous split selects the inputs for its two subtrees.
expr_tree([Number], num(Number)).
expr_tree(Numbers, node(Op, Left, Right)) :-
    split_equation(Numbers, LeftNumbers, RightNumbers),
    expr_tree(LeftNumbers, Left),
    expr_tree(RightNumbers, Right),
    member(Op, ['+', '-', '*', '/']).

% eval_expr(+Tree, -Value) computes the integer value of the tree.
% A division fails if its evaluated divisor is zero or leaves a remainder.
eval_expr(num(Number), Number).
eval_expr(node('+', Left, Right), Value) :-
    eval_expr(Left, LeftValue),
    eval_expr(Right, RightValue),
    Value is LeftValue + RightValue.
eval_expr(node('-', Left, Right), Value) :-
    eval_expr(Left, LeftValue),
    eval_expr(Right, RightValue),
    Value is LeftValue - RightValue.
eval_expr(node('*', Left, Right), Value) :-
    eval_expr(Left, LeftValue),
    eval_expr(Right, RightValue),
    Value is LeftValue * RightValue.
eval_expr(node('/', Left, Right), Value) :-
    eval_expr(Left, LeftValue),
    eval_expr(Right, RightValue),
    RightValue =\= 0,
    0 =:= LeftValue rem RightValue,
    Value is LeftValue // RightValue.

% op_precedence(+Op, -Precedence) gives the binding strength of Op.
% A higher number binds more tightly.
op_precedence('+', 1).
op_precedence('-', 1).
op_precedence('*', 2).
op_precedence('/', 2).

% needs_parens(+Child, +ParentOp, +Side) holds when a child needs parentheses.
% A number leaf never qualifies. Equal precedence needs them on the right.
needs_parens(node(ChildOp, _, _), ParentOp, Side) :-
    op_precedence(ChildOp, ChildPrecedence),
    op_precedence(ParentOp, ParentPrecedence),
    (   Side = left,
        ChildPrecedence < ParentPrecedence
    ;   Side = right,
        ChildPrecedence =< ParentPrecedence
    ).

% expr_to_string(+Tree, -String) renders a tree in P2's canonical form.
expr_to_string(num(Number), String) :-
    number_string(Number, String).
expr_to_string(node(Op, Left, Right), String) :-
    expr_to_string(Left, LeftString),
    expr_to_string(Right, RightString),
    (   needs_parens(Left, Op, left)
    ->  atomics_to_string(["(", LeftString, ")"], LeftOperand)
    ;   LeftOperand = LeftString
    ),
    (   needs_parens(Right, Op, right)
    ->  atomics_to_string(["(", RightString, ")"], RightOperand)
    ;   RightOperand = RightString
    ),
    atomics_to_string([LeftOperand, Op, RightOperand], String).

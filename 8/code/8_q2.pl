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

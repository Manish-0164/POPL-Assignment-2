% Run from the repository root: swipl -q -s 8/tests/p2_tests.pl -g run_tests -t halt
% These tests require the P2 public predicates; they do not implement them.
:- use_module(library(plunit)).
:- consult('../code/8_q2.pl').

:- begin_tests(p2).

% The seven equations from the handout, in standard string order.
handout_equations([
    "4*2-5=3",
    "4*2=5+3",
    "4-2=5-3",
    "4/2=5-3",
    "4=2*(5-3)",
    "4=2+(5-3)",
    "4=2+5-3"
]).

test(handout_equations) :-
    handout_equations(Expected),
    all_equations([4, 2, 5, 3], Equations),
    assertion(Equations == Expected).

test(generate_handout_equations_on_backtracking) :-
    handout_equations(Expected),
    findall(Equation, generate_equation([4, 2, 5, 3], Equation), Generated),
    % msort/2 keeps duplicate answers so the comparison detects them.
    msort(Generated, Sorted),
    assertion(Sorted == Expected).

test(count_handout_equations) :-
    count_equations([4, 2, 5, 3], Count),
    assertion(Count == 7).

test(single_multiplication_equation) :-
    all_equations([2, 4, 8], Equations),
    assertion(Equations == ["2*4=8"]),
    findall(Equation, generate_equation([2, 4, 8], Equation), Generated),
    assertion(Generated == ["2*4=8"]).

test(no_equations, [forall(member(Numbers, [[2, 3, 4], [], [2]]))]) :-
    findall(Equations, all_equations(Numbers, Equations), Lists),
    assertion(Lists == [[]]),
    findall(Count, count_equations(Numbers, Count), Counts),
    assertion(Counts == [0]),
    findall(Equation, generate_equation(Numbers, Equation), Generated),
    assertion(Generated == []).

test(two_equal_numbers) :-
    all_equations([0, 0], Equations),
    assertion(Equations == ["0=0"]).

test(zero_divisor_is_rejected) :-
    all_equations([0, 0, 0], Equations),
    assertion(Equations == ["0*0=0", "0+0=0", "0-0=0",
                            "0=0*0", "0=0+0", "0=0-0"]).

test(nested_zero_divisor_is_rejected) :-
    all_equations([1, 2, 2, 0, 0], Equations),
    assertion(\+ memberchk("1/(2-2)*0=0", Equations)).

test(exact_division) :-
    all_equations([12, 3, 4], Equations),
    assertion(Equations == ["12/3=4", "12=3*4"]).

test(repeated_numbers_yield_unique_equations) :-
    all_equations([1, 1, 1], Equations),
    assertion(Equations == ["1*1=1", "1/1=1", "1=1*1", "1=1/1"]),
    count_equations([1, 1, 1], Count),
    assertion(Count == 4).

test(inexact_intermediate_division_is_rejected) :-
    all_equations([1, 2, 0, 0], Equations),
    assertion(\+ memberchk("1/2*0=0", Equations)).

test(negative_intermediate_values) :-
    all_equations([1, 0, 2, 0, 2], Equations),
    assertion(memberchk("1=(0-2)/(0-2)", Equations)).

test(right_associated_parentheses_are_preserved) :-
    all_equations([1, 2, 3, 6], Equations),
    assertion(memberchk("1+2+3=6", Equations)),
    assertion(memberchk("1+(2+3)=6", Equations)).

% These rendering examples fix the exact parentheses chosen by the handout.
parentheses_example(node('*', node('+', num(4), num(2)), num(3)), "(4+2)*3").
parentheses_example(node('+', num(4), node('*', num(2), num(3))), "4+2*3").
parentheses_example(node('*', node('/', num(8), num(4)), num(2)), "8/4*2").
parentheses_example(node('/', num(8), node('*', num(4), num(2))), "8/(4*2)").
parentheses_example(node('-', node('-', num(1), num(2)), num(3)), "1-2-3").
parentheses_example(node('-', num(1), node('-', num(2), num(3))), "1-(2-3)").
parentheses_example(node('+', num(1), node('+', num(2), num(3))), "1+(2+3)").
parentheses_example(node('+', node('+', num(1), num(2)), num(3)), "1+2+3").

test(canonical_parentheses, [forall(parentheses_example(Tree, Expected))]) :-
    findall(String, expr_to_string(Tree, String), Renderings),
    assertion(Renderings == [Expected]).

test(sorted_unique_strings_and_matching_count,
     [forall(member(Numbers, [[4, 2, 5, 3], [2, 4, 8], [0, 0, 0]]))]) :-
    all_equations(Numbers, Equations),
    sort(Equations, Sorted),
    assertion(Equations == Sorted),
    forall(member(Equation, Equations),
           ( assertion(string(Equation)),
             assertion(\+ sub_string(Equation, _, _, _, " ")) )),
    length(Equations, ExpectedCount),
    count_equations(Numbers, Count),
    assertion(Count == ExpectedCount),
    once(generate_equation(Numbers, Generated)),
    assertion(memberchk(Generated, Equations)).

test(public_predicates_are_silent) :-
    with_output_to(string(Output),
                   ( once(generate_equation([2, 4, 8], _)),
                     all_equations([2, 4, 8], _),
                     count_equations([2, 4, 8], _) )),
    assertion(Output == "").

:- end_tests(p2).

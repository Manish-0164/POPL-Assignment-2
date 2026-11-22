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

test(generate_handout_equation) :-
    handout_equations(Expected),
    once(generate_equation([4, 2, 5, 3], Equation)),
    assertion(memberchk(Equation, Expected)).

test(count_handout_equations) :-
    count_equations([4, 2, 5, 3], Count),
    assertion(Count == 7).

test(single_multiplication_equation) :-
    all_equations([2, 4, 8], Equations),
    assertion(Equations == ["2*4=8"]).

test(no_equations, [forall(member(Numbers, [[2, 3, 4], [], [2]]))]) :-
    all_equations(Numbers, Equations),
    assertion(Equations == []),
    count_equations(Numbers, Count),
    assertion(Count == 0),
    assertion(\+ generate_equation(Numbers, _)).

test(two_equal_numbers) :-
    all_equations([0, 0], Equations),
    assertion(Equations == ["0=0"]).

test(zero_divisor_is_rejected) :-
    all_equations([0, 0, 0], Equations),
    assertion(memberchk("0+0=0", Equations)),
    assertion(\+ memberchk("0/0=0", Equations)),
    assertion(\+ memberchk("0=0/0", Equations)).

test(exact_division) :-
    all_equations([12, 3, 4], Equations),
    assertion(memberchk("12/3=4", Equations)).

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

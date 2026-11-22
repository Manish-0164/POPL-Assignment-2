% Run from the repository root: swipl -q -s 8/tests/p1_tests.pl -g run_tests -t halt
:- use_module(library(plunit)).
:- consult('../code/8_q1.pl').

:- begin_tests(p1).

% Each pattern fixes the attributes relevant to one case. Complete it before
% calling clue/2 so the remaining slots still form a valid assignment.
clue_case(1, ai_holder_allowed, 1, [p('Alex', design, _, 'AI'), _, _, _]).
clue_case(1, ai_holder_in_research, 0, [p('Alex', research, _, 'AI'), _, _, _]).
clue_case(1, dana_prefers_ai, 0, [_, _, _, p('Dana', design, _, 'AI')]).

clue_case(2, alex_allowed, 1, [p('Alex', design, java, _), _, _, _]).
clue_case(2, alex_in_development, 0, [p('Alex', development, java, _), _, _, _]).
clue_case(2, alex_prefers_cpp, 0, [p('Alex', design, 'c++', _), _, _, _]).

clue_case(3, testing_prefers_python, 1, [p('Alex', testing, python, _), _, _, _]).
clue_case(3, testing_prefers_java, 0, [p('Alex', testing, java, _), _, _, _]).

clue_case(4, ben_allowed, 1, [_, p('Ben', development, _, web), _, _]).
clue_case(4, ben_prefers_data, 0, [_, p('Ben', development, _, data), _, _]).
clue_case(4, ben_in_testing, 0, [_, p('Ben', testing, _, web), _, _]).

clue_case(5, java_user_in_design, 1, [p('Alex', design, java, _), _, _, _]).
clue_case(5, java_user_in_testing, 0, [p('Alex', testing, java, _), _, _, _]).

clue_case(6, carla_allowed, 1, [_, _, p('Carla', research, _, data), _]).
clue_case(6, carla_prefers_embedded, 0, [_, _, p('Carla', research, _, embedded), _]).
clue_case(6, carla_in_development, 0, [_, _, p('Carla', development, _, data), _]).

clue_case(7, dana_in_research, 1, [_, _, _, p('Dana', research, 'c++', _)]).
clue_case(7, dana_in_testing, 1, [_, _, _, p('Dana', testing, 'c++', _)]).
clue_case(7, dana_prefers_java, 0, [_, _, _, p('Dana', research, java, _)]).
clue_case(7, dana_in_design, 0, [_, _, _, p('Dana', design, 'c++', _)]).
clue_case(7, dana_in_development, 0, [_, _, _, p('Dana', development, 'c++', _)]).

clue_case(8, data_holder_allowed, 1, [p('Alex', research, python, data), _, _, _]).
clue_case(8, data_holder_outside_research, 0, [p('Alex', design, python, data), _, _, _]).
clue_case(8, data_holder_prefers_javascript, 0, [p('Alex', research, javascript, data), _, _, _]).

clue_case(9, testing_prefers_ai, 1, [p('Alex', testing, _, 'AI'), _, _, _]).
clue_case(9, testing_prefers_embedded, 0, [p('Alex', testing, _, embedded), _, _, _]).

test(clue, [forall(clue_case(Number, Case, Expected, Solution))]) :-
    once(p1_candidate(Solution)),
    assertion(ground(Solution)),
    findall(proof, clue(Number, Solution), Proofs),
    length(Proofs, Count),
    assertion(result(Number, Case, Count) == result(Number, Case, Expected)).

count_case([], 13824).
count_case([2, 8], 1440).
count_case([8, 2], 1440).
count_case([1, 2, 3, 4, 5, 6, 7, 8], 3).
count_case([1, 2, 3, 4, 5, 6, 7, 8, 9], 1).

test(count_solutions, [forall(count_case(Active, Expected))]) :-
    findall(N, count_solutions(Active, N), Counts),
    assertion(Counts == [Expected]).

test(main_output) :-
    with_output_to(string(Output), main),
    string_codes(Output, Codes),
    once(phrase(printed_rows(['Alex', 'Ben', 'Carla', 'Dana'], Solution), Codes)),
    findall(Dept, member(p(_, Dept, _, _), Solution), Depts),
    findall(Lang, member(p(_, _, Lang, _), Solution), Langs),
    findall(Project, member(p(_, _, _, Project), Solution), Projects),
    msort(Depts, SortedDepts),
    msort(Langs, SortedLangs),
    msort(Projects, SortedProjects),
    assertion(domain(department, SortedDepts)),
    assertion(domain(language, SortedLangs)),
    assertion(domain(project, SortedProjects)),
    forall(between(1, 8, Number), assertion(clue(Number, Solution))).

% The domains are listed in atom order for the msort/2 checks above.
domain(department, [design, development, research, testing]).
domain(language, ['c++', java, javascript, python]).
domain(project, ['AI', data, embedded, web]).

% Consume the entire output, including the newline after the fourth row.
printed_rows([], []) --> [].
printed_rows([Name|Names], [p(Name, Dept, Lang, Project)|Solution]) -->
    atom_text(Name), " = [",
    attribute_text(department, Dept), ", ",
    attribute_text(language, Lang), ", ",
    attribute_text(project, Project), "]\n",
    printed_rows(Names, Solution).

attribute_text(Kind, Atom) -->
    { domain(Kind, Values), member(Atom, Values) },
    atom_text(Atom).

atom_text(Atom) -->
    { atom_codes(Atom, Codes) },
    Codes.

:- end_tests(p1).

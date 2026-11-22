% P1 — Department Assignment Puzzle
% Implement clue/2, count_solutions/2 and main/0 below the course template line.
% Represent each person as p(Name, Dept, Lang, Project), in Alex–Dana order.
% Place the English wording directly above clue 9 as a % CLUE 9: comment.

% p1_candidate(?Candidate) holds for a complete assignment before any clues.
p1_candidate([
    p('Alex', AlexDept, AlexLang, AlexProject),
    p('Ben', BenDept, BenLang, BenProject),
    p('Carla', CarlaDept, CarlaLang, CarlaProject),
    p('Dana', DanaDept, DanaLang, DanaProject)
]) :-
    permutation([research, development, design, testing],
                [AlexDept, BenDept, CarlaDept, DanaDept]),
    permutation([python, java, 'c++', javascript],
                [AlexLang, BenLang, CarlaLang, DanaLang]),
    permutation(['AI', web, embedded, data],
                [AlexProject, BenProject, CarlaProject, DanaProject]).

% clue(?Number, +Candidate) holds when a complete candidate satisfies the clue.
clue(1, Candidate) :-
    ground(Candidate),
    member(p(Name, Dept, _, 'AI'), Candidate),
    Dept \= research,
    Name \= 'Dana'.

clue(2, Candidate) :-
    ground(Candidate),
    member(p('Alex', Dept, Lang, _), Candidate),
    Dept \= development,
    Lang \= 'c++'.

clue(3, Candidate) :-
    ground(Candidate),
    member(p(_, testing, python, _), Candidate).

clue(4, Candidate) :-
    ground(Candidate),
    member(p('Ben', Dept, _, web), Candidate),
    Dept \= testing.

clue(5, Candidate) :-
    ground(Candidate),
    member(p(_, design, java, _), Candidate).

clue(6, Candidate) :-
    ground(Candidate),
    member(p('Carla', Dept, _, Project), Candidate),
    Project \= embedded,
    Dept \= development.

clue(7, Candidate) :-
    ground(Candidate),
    member(p('Dana', Dept, Lang, _), Candidate),
    Lang \= java,
    memberchk(Dept, [research, testing]).

clue(8, Candidate) :-
    ground(Candidate),
    member(p(_, research, Lang, data), Candidate),
    Lang \= javascript.

% CLUE 9: The friend in the testing department prefers the AI project.
clue(9, Solution) :-
    ground(Solution),
    member(p(_, testing, _, 'AI'), Solution).

% p1_solution(+Active, ?Solution) holds when Solution satisfies every listed clue.
p1_solution(Active, Solution) :-
    p1_candidate(Solution),
    forall(member(Number, Active), clue(Number, Solution)).

% count_solutions(+Active, ?N) holds when N is the number of matching assignments.
count_solutions(Active, N) :-
    aggregate_all(count, p1_solution(Active, _), N).

% main/0 prints one assignment satisfying clues 1 through 8.
main :-
    once(p1_solution([1, 2, 3, 4, 5, 6, 7, 8], Solution)),
    forall(member(p(Name, Dept, Lang, Project), Solution),
           format('~a = [~a, ~a, ~a]~n', [Name, Dept, Lang, Project])).

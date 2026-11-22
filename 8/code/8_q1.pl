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

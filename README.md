# CS F301 POPL Assignment 2 — Group 8

Logic and functional programming coursework for Principles of Programming Languages.

| Problem | Group 8 source | Required behavior |
| --- | --- | --- |
| P1 — Department Assignment Puzzle | [8_q1.pl](8/code/8_q1.pl) | Print a solution, count solutions for selected clues, and add a ninth clue that makes the solution unique. |
| P2 — Arithmetic Equation | [8_q2.pl](8/code/8_q2.pl) | Generate, enumerate, and count equations using the input numbers in order, exact integer division, and canonical parentheses. |
| S1 — Binary Tree Traversals | [8_q3.rkt](8/code/8_q3.rkt) | Print inorder, preorder, postorder, and the tree height and leaf count. |
| S2 — Nested List Insertion | [8_q4.rkt](8/code/8_q4.rkt) | Read three datums and insert an atom at every qualifying list using a higher-order inserter and original list lengths. |

## Run from the repository root

Use SWI-Prolog 9.x and Racket 8.x. The commands apply once the source templates are implemented.

```bash
swipl -q -f 8/code/8_q1.pl
swipl -q -f 8/code/8_q1.pl -g 'count_solutions([1,2,3,4,5,6,7,8], N), writeln(N)' -t halt
swipl -q -f 8/code/8_q2.pl -g 'all_equations([2,4,8], Es), writeln(Es)' -t halt
racket 8/code/8_q3.rkt
printf '%s\n' '42 ((1 2) (3 4 5) (6) ()) 3' | racket 8/code/8_q4.rkt
```

## Submission files

- [Tests](8/tests) contains one test specification per problem, with handout examples and edge cases to turn into executable checks during implementation.
- [Prolog skill](8/skills/prolog-dev/SKILL.md) and [Scheme skill](8/skills/scheme-dev/SKILL.md) record language conventions, test commands, and review criteria.
- [Prompt logs](8/skills/prompts) hold verbatim AI prompts, one file per problem. Use one predicate, function, test file, or review per prompt and keep the work visible in incremental commits.
- [P1 report](8/P1_REPORT.md) records the measured count with clues 1–8 and what it implies.

The source files are scaffolds. Retain any instructor-supplied template lines and test calls when adding implementations. Submit this GitHub repository with its commit history and keep collaboration within Group 8.

---
name: prolog-dev
description: Work on one SWI-Prolog 9.x predicate, test file, or review for Group 8's CS F301 Assignment 2. Use for the department puzzle and clue counts in P1 or arithmetic equation generation, exact division, and canonical printing in P2.
---

# Prolog for Assignment 2

Start with the relevant problem in the handout, then read the source and its test notes under `8/`. The test notes describe expected behavior. Run the actual predicate or test before calling a result verified.

## How we work

- Keep each AI prompt to one predicate, one test file, or one review. For example, ask for a review of the division case in P2. Save the actual wording in `8/skills/prompts/P1.md` or `P2.md` and keep each code change small enough to explain in the viva.
- Use SWI-Prolog 9.x, `snake_case` for predicates, and descriptive variables such as `Active`, `Solution`, and `RightValue`. Give each predicate a short comment saying when it holds and which arguments the caller supplies. Comment a cut or an ordering dependency if it matters to correctness.
- Preserve the public names, arities, and course template. Write the solution below the template line. Use only `lists`, `apply`, `yall`, and `aggregate` when a library is needed. Avoid `assert`, `retract`, `b_setval`, and `nb_setval`.
- Use `=` for unification, `is` to evaluate bound arithmetic, and `=:=` to compare numeric values. Apply tests for inequality or negation after their relevant arguments are bound. Read each clause as a relation, then trace the goal order Prolog will actually use.

## P1 · Department Assignment Puzzle

Work in `8/code/8_q1.pl` and use `8/tests/P1.md`. Treat a candidate as four `p(Name, Dept, Lang, Project)` terms in the order `'Alex'`, `'Ben'`, `'Carla'`, `'Dana'`. Use each department, language, and project exactly once. Keep the handout's atoms, including `'AI'` and `'c++'`.

- In `clue/2`, give each numbered clue its own `clue(N, Solution)` clause that tests a complete candidate. Check positive and negative parts together. Pay special attention to clue 1's AI restrictions, clue 7's research-or-testing condition, and clue 8's two restrictions on the data-project holder. Trace one satisfying and one violating candidate when reviewing a clue.
- In `count_solutions/2`, read `Active` as the list of clue numbers. Enforce those clues and ignore the rest. Use `findall/3` or `aggregate_all/3` to count assignments. Check that a candidate has only one successful proof through the generator and clue checks. With no active clues, expect 13,824 distinct assignments. Measure the count with clues 1–8 and record the result and its meaning in `8/P1_REPORT.md`.
- Place the English wording directly above `clue(9, Solution)` on a line beginning `% CLUE 9:`. Refer to people through their attributes. Measure the count with clues 1–9 and confirm exactly one original candidate survives.
- Derive one solution to clues 1–8 in `main/0`. Print exactly four lines in name order, each in the form `Name = [department, language, project]` with the prescribed case, commas, spaces, and newline. The rows in the handout illustrate layout. Check stdout and the solution's truth conditions separately.

## P2 · Form a Valid Arithmetic Equation

Work in `8/code/8_q2.pl` and use `8/tests/P2.md`. Keep the expression structure, integer value, and printed form distinct.

- Split the input into two nonempty contiguous parts. Build binary expressions from each part, using every number once in order. Use exactly one equality between the sides. Leaves are the given nonnegative integers. Intermediate values can be negative. Check each division for a nonzero divisor and zero remainder before taking the integer quotient.
- Render the tree directly as a space-free SWI-Prolog string. Give `*` and `/` higher precedence than `+` and `-`. Parenthesize an operator on the left only at lower precedence. On the right, parenthesize at equal or lower precedence, even for addition or multiplication. Leave number leaves bare. For example, both `1+(2+3)=6` and `1+2+3=6` must survive for `[1,2,3,6]`.
- Let `generate_equation/2` find a valid equation and fail finitely when none exists, including for empty and singleton input. Use `sort/2` for the duplicate-free list from `all_equations/2`. Return `[]` when no equation exists and have `count_equations/2` count that list. Keep these predicates silent. Evaluate with the expression tree and integer operations. Keep parsing out of the evaluation path.
- Compare the seven sorted strings for `[4,2,5,3]` with the handout, the single result for `[2,4,8]`, and the no-result case `[2,3,4]`. Include repeated values, zeros, an inexact division, and a negative intermediate result when reviewing the relevant predicates.

## Run from the repository root

Use the course runner once the template and requested predicates are in place. For direct queries, pass the goal with `-g` and terminate through the runner's `-t halt`. Keep `halt/0` calls and `initialization(main, main)` out of the source. In these diagnostic commands, `writeln/1` belongs to the test goal.

```sh
swipl -q -f 8/code/8_q1.pl
swipl -q -f 8/code/8_q1.pl -g "count_solutions([], N), writeln(N)" -t halt
swipl -q -f 8/code/8_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8,9], 1)" -t halt
swipl -q -f 8/code/8_q2.pl -g "all_equations([4,2,5,3], Es), writeln(Es)" -t halt
```

## Before handing back a change

- [ ] The edit addresses the requested unit and preserves its interface, allowed libraries, and exact output.
- [ ] The predicate succeeds for the intended bindings, fails for a counterexample, and terminates in the tested input mode.
- [ ] Look for recurring AI mistakes. In P1, watch for treating omitted clues as false, bad negation on unbound terms, and counting duplicate proofs. In P2, watch for rounding division, trying a zero divisor, confusing atoms with strings, and dropping parentheses from a right child.
- [ ] State the command and observed result for the checks you ran. Explain one non-obvious clause or edge case in terms a teammate could use in the viva.

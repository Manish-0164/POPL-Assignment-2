---
name: prolog-dev
description: Develop and review one SWI-Prolog predicate or test at a time for POPL Assignment 2.
---

- Use SWI-Prolog 9.x, snake_case predicates, and descriptive variables. Comment each public predicate with its argument roles and what makes it true.
- Use only the permitted libraries lists, apply, yall, and aggregate. Avoid database mutation and global variables.
- Run P1 with `swipl -q -f 8/code/8_q1.pl` and query individual predicates using `swipl -q -f FILE -g 'GOAL' -t halt`. Keep stdout to the specified output, and avoid halt/0 and initialization(main, main).
- Before answering, check groundness before arithmetic and negation, finite failure, uniqueness in enumeration, and exact output. Review the cases in the corresponding test file.
- Common errors include treating inactive clues as false, duplicate solutions from overlapping clauses, arithmetic on unbound variables, mixed atoms and strings, division by zero, and losing parentheses on right operands.
- Address one requested unit per prompt. Record the prompt verbatim in the matching problem log.

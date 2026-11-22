---
name: scheme-dev
description: Develop and review one Racket function or test at a time for POPL Assignment 2.
---

- Use Racket 8.x with #lang racket/base. Prefer kebab-case names, explicit state parameters, and a short comment describing the base case and recursive step of each recursive function.
- Use only the handout's allowlist. Use read only in S2. Implement needed list helpers with permitted primitives. Prefer tail recursion where natural.
- Run `racket 8/code/8_q3.rkt` for S1 and pipe three datums into `racket 8/code/8_q4.rkt` for S2. Compare stdout with the matching test file, including final newlines.
- Before answering, check empty inputs, traversal order, output formatting, structural recursion, original lengths, and deep or wide lists where relevant.
- Common errors include using forbidden map or length, treating the empty list as an atom, measuring a list after insertion, revisiting an inserted atom, and leaving two definitions of insert-if-short.
- Address one requested unit per prompt. Record the prompt verbatim in the matching problem log.

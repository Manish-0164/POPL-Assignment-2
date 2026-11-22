---
name: scheme-dev
description: Work on one Scheme function, test file, or review for Group 8's CS F301 Assignment 2 in Racket 8.x. Use for S1 binary-tree traversals, height and leaves, or S2 nested-list insertion and higher-order functions.
---

# Scheme for Assignment 2

Start with the relevant problem in the handout, then read the source and test notes under `8/`. Keep computation in list or number helpers and put printing in the named entry points. It is easier to trace the recursion that way.

## How we work

- Keep each AI prompt to one function, one test file, or one review. For example, review whether `my-map` preserves order on a long list. Save the actual wording in `8/prompts/S1.md` or `S2.md` and keep each change small enough to explain in the viva.
- Use Racket 8.x with `#lang racket/base`. Follow the template and preserve the public function names and argument order. Use kebab-case, descriptive parameters, and a short comment for each function's inputs and result. For a recursive helper, say what shrinks, what the base case returns, and what any accumulator represents.
- Prefer ordinary structural recursion for trees and tail recursion where natural, especially for long flat lists. Pass state through arguments. Keep output in the required wrappers and compare the final newline along with the values.

## Built-ins to check against

The handout allows `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` with `else`, `and`, `or`, `not`, `begin`, `quote` written as `'`, `cons`, `car`, `cdr`, `list`, and combinations of `car` and `cdr` up to four levels. It also allows `null?`, `pair?`, `eq?`, `assq`, `assoc`, `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `display`, and `newline`. Only S2 also allows `read`.

Write the list helpers you need with those forms. Scan for familiar conveniences such as `append`, `reverse`, `map`, `length`, `filter`, `list?`, `max`, `member`, `memq`, `list-ref`, and `list-tail`. Keep mutation, vectors, hashes, strings, `for`, and `do` out of solution code.

## S1 · Binary Tree Traversals

Work in `8/code/8_q3.rkt` and use `8/tests/S1.md`. Keep the instructor's tree definitions and calls when available. A tree is either `'()` or `(value left right)`, with a number or single-character symbol as the value.

- In `print-inorder`, print one list in left–node–right order. In `print-all-traversals`, print inorder, preorder, and postorder on three lines. Preorder is node–left–right and postorder is left–right–node. Trace a tree with only a right child as well as a balanced tree.
- In `print-height-and-leaves`, display a two-element list. The empty tree has height 0 and no leaves. A node's height is 1 plus the larger child height. Only a node with two empty children is a leaf. A node with one child has the leaves of that child.
- Check the handout's balanced numeric tree, right chain, and symbol tree. Also check the empty tree and a single node. The empty tree gives `()` for each traversal and `(0 0)` for the height and leaf count. Use `display` and `newline` for each required output line.
- Check `'(9 (2 () (9 () ())) (1 () ()))` for inorder `(2 9 9 1)`, preorder `(9 2 9 1)`, postorder `(9 2 1 9)`, and `(3 2)` for height and leaves. This tree combines repeated values and a one-child node. Traversals follow the shape of the tree and preserve every occurrence.

## S2 · Conditionally Insert into a Nested List

Work in `8/code/8_q4.rkt` and use `8/tests/S2.md`. Every proper list is a candidate for insertion, including the outer list and each empty sublist.

- Write `my-length` to count the original immediate elements and `my-map` to process them in order. A nested list contributes one element to its parent's length. Recurse into pairs and empty lists. Preserve atoms and inspect only the original elements as you descend.
- Have `make-inserter` take `x` and a one-argument length predicate, then return a one-argument function on a list. Base each insertion on the original length at that level. Use `my-length` for the check and `my-map` to visit the original elements. Preserve their order and prepend `x` once to each qualifying list. Use that closure in the single final definition of `insert-if-short` with the strict test `(< len n)`.
- In `print-insert-result`, read `x`, `lst`, and `n` in that order from stdin. Print the result using `display` and one `newline`. The input consists of three Racket datums and may span lines. Keep prompts and debug messages off stdout.
- Use the handout's examples, a length exactly equal to `n`, nested empty lists, and the empty top-level list with `n = 0` and with positive `n`. Exercise `make-inserter` with an equality predicate as well as a threshold. Check nesting depth 100 and a flat list with 10,000 elements. Avoid repeatedly taking the length of successive tails or copying growing partial results.
- Try `x (() (a b) (c)) 2` and expect `((x) (a b) (x c))`. The empty child qualifies. The two-element child is exactly at the cutoff and the outer list has three elements. Feed the same three datums on separate lines and expect the same output.
- For the returned `make-inserter` function, use an equality predicate on length 1 and apply it to `'(a (()) ())`. With insertion atom `x`, expect `(a (x ()) ())`. On the 10,000-element input, check that the original elements stay in order and that the outer list grows by exactly one when the threshold rises from 10,000 to 10,001. For depth 100, confirm insertion reaches the innermost empty list.

## Run from the repository root

Use the commands when the template and requested functions are in place. Compare stdout with the handout and the corresponding test notes.

```powershell
racket 8/code/8_q3.rkt
'42 ((1 2) (3 4 5) (6) ()) 3' | racket 8/code/8_q4.rkt
'7 () 0' | racket 8/code/8_q4.rkt
```

The second command should print `((42 1 2) (3 4 5) (42 6) (42))`. The last should print `()`.

## Before handing back a change

- [ ] The edit addresses the requested unit. The template, function names, built-in allowlist, and output format still match the handout.
- [ ] The recursive call consumes a smaller tree or list. If it uses an accumulator, trace two steps and check the final order.
- [ ] Look for recurring AI mistakes. In S1, watch for swapped traversal order and counting the empty tree as a leaf. In S2, watch for skipping empty lists because `pair?` is false for `()`, using `<=` for the threshold, traversing the newly inserted item, and leaving two definitions of `insert-if-short`.
- [ ] State the command and observed result for the checks you ran. Explain the base case and one recursive step on a small input for the viva.

#lang racket/base
;; S1 — Binary Tree Traversals
;; Implement print-inorder, print-all-traversals and print-height-and-leaves.
;; Use the instructor template's trees and calls when available.

;; Join two lists by consuming the first list one element at a time.
(define (my-append first second)
  (if (null? first)
      second
      (cons (car first) (my-append (cdr first) second))))

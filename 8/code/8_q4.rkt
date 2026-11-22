#lang racket/base
;; S2 — Nested List Insertion
;; Implement print-insert-result, my-length, my-map, make-inserter
;; and the final insert-if-short that calls make-inserter.

;; Count immediate elements. The remaining list shrinks by one per step.
(define (my-length lst)
  (let count ([remaining lst] [total 0])
    (if (null? remaining)
        total
        (count (cdr remaining) (+ total 1)))))

;; Apply transform to each immediate element in order.
(define (my-map transform lst)
  (if (null? lst)
      '()
      (cons (transform (car lst))
            (my-map transform (cdr lst)))))

;; Capture the atom and length predicate for every level of the traversal.
(define (make-inserter x len-ok?)
  (letrec ([insert
            (lambda (lst)
              (let* ([insert-here? (len-ok? (my-length lst))]
                     [elements
                      (my-map (lambda (element)
                                (if (or (null? element) (pair? element))
                                    (insert element)
                                    element))
                              lst)])
                (if insert-here?
                    (cons x elements)
                    elements)))])
    insert))

;; Insert x at each level whose original length is strictly below n.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

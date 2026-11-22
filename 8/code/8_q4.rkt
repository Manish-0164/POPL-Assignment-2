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

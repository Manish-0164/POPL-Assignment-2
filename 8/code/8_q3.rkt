#lang racket/base
;; S1 — Binary Tree Traversals
;; Implement print-inorder, print-all-traversals and print-height-and-leaves.
;; Use the instructor template's trees and calls when available.

;; Join two lists by consuming the first list one element at a time.
(define (my-append first second)
  (if (null? first)
      second
      (cons (car first) (my-append (cdr first) second))))

;; Return the left subtree, root, and right subtree values in order.
(define (inorder tree)
  (if (null? tree)
      '()
      (my-append (inorder (cadr tree))
                 (cons (car tree) (inorder (caddr tree))))))

(define (print-inorder tree)
  (display (inorder tree))
  (newline))

;; Return the root, left subtree, and right subtree values in order.
(define (preorder tree)
  (if (null? tree)
      '()
      (cons (car tree)
            (my-append (preorder (cadr tree)) (preorder (caddr tree))))))

;; Return the left subtree, right subtree, and root values in order.
(define (postorder tree)
  (if (null? tree)
      '()
      (let* ([left (postorder (cadr tree))]
             [right (postorder (caddr tree))])
        (my-append left (my-append right (list (car tree)))))))

(define (print-all-traversals tree)
  (print-inorder tree)
  (display (preorder tree))
  (newline)
  (display (postorder tree))
  (newline))

;; Return (height leaf-count) after computing each child result once.
(define (tree-stats tree)
  (cond
    [(null? tree) (list 0 0)]
    [(and (null? (cadr tree)) (null? (caddr tree))) (list 1 1)]
    [else
     (let* ([left (tree-stats (cadr tree))]
            [right (tree-stats (caddr tree))]
            [left-height (car left)]
            [right-height (car right)])
       (list (+ 1 (if (> left-height right-height) left-height right-height))
             (+ (cadr left) (cadr right))))]))

(define (print-height-and-leaves tree)
  (display (tree-stats tree))
  (newline))

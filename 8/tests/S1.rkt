#lang racket/base

(require racket/runtime-path)

(define-runtime-path solution "../code/8_q3.rkt")

(define (capture-output action)
  (define output (open-output-string))
  (parameterize ([current-output-port output])
    (action))
  (get-output-string output))

(define (check-output label expected action)
  (define actual (capture-output action))
  (unless (string=? expected actual)
    (error 's1 "~a: expected ~s, got ~s" label expected actual)))

(check-output
 'handout-examples
 (string-append "(1 2 3 4 5 6 7)\n(1 2 3 4 5 6 7)\n"
                "(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n(3 4)\n"
                "(1 2 3)\n(1 2 3)\n(3 2 1)\n(3 1)\n"
                "(b a c)\n(a b c)\n(b c a)\n(2 2)\n"
                "()\n()\n()\n()\n(0 0)\n")
 (lambda () (dynamic-require solution #f)))
(define solution-namespace (module->namespace solution))
(define print-inorder (eval 'print-inorder solution-namespace))
(define print-all-traversals (eval 'print-all-traversals solution-namespace))
(define print-height-and-leaves
  (eval 'print-height-and-leaves solution-namespace))

(define (check-tree name tree inorder preorder postorder stats)
  (check-output (list name 'inorder) (string-append inorder "\n")
                (lambda () (print-inorder tree)))
  (check-output (list name 'traversals)
                (string-append inorder "\n" preorder "\n" postorder "\n")
                (lambda () (print-all-traversals tree)))
  (check-output (list name 'stats) (string-append stats "\n")
                (lambda () (print-height-and-leaves tree))))

(check-tree 'balanced
            '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ())))
            "(1 2 3 4 5 6 7)" "(4 2 1 3 6 5 7)" "(1 3 2 5 7 6 4)" "(3 4)")
(check-tree 'right-chain '(1 () (2 () (3 () ())))
            "(1 2 3)" "(1 2 3)" "(3 2 1)" "(3 1)")
(check-tree 'symbols '(a (b () ()) (c () ()))
            "(b a c)" "(a b c)" "(b c a)" "(2 2)")
(check-tree 'empty '() "()" "()" "()" "(0 0)")
(check-tree 'single '(z () ()) "(z)" "(z)" "(z)" "(1 1)")
(check-tree 'left-chain '(1 (2 (3 () ()) ()) ())
            "(3 2 1)" "(1 2 3)" "(3 2 1)" "(3 1)")
(check-tree 'repeated-values '(9 (2 () (9 () ())) (1 () ()))
            "(2 9 9 1)" "(9 2 9 1)" "(9 2 1 9)" "(3 2)")

(displayln "S1 passed 22 exact-output checks.")

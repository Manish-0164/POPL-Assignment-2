#lang racket/base

(require rackunit racket/list racket/runtime-path)

(define-runtime-path solution "../code/8_q4.rkt")

(module+ test
  ;; Access the grader's definitions without changing the submission module.
  (check-equal?
   (let ([output (open-output-string)])
     (parameterize ([current-output-port output])
       (dynamic-require solution #f))
     (get-output-string output))
   "")
  (define solution-namespace (module->namespace solution))
  (define my-length (eval 'my-length solution-namespace))
  (define my-map (eval 'my-map solution-namespace))
  (define make-inserter (eval 'make-inserter solution-namespace))
  (define insert-if-short (eval 'insert-if-short solution-namespace))
  (define print-insert-result (eval 'print-insert-result solution-namespace))

  (define (run-print input)
    (define output (open-output-string))
    (parameterize ([current-input-port (open-input-string input)]
                   [current-output-port output])
      (print-insert-result))
    (get-output-string output))

  (check-equal? (run-print "42 ((1 2) (3 4 5) (6) ()) 3")
                "((42 1 2) (3 4 5) (42 6) (42))\n")
  (check-equal? (run-print "0 (((1) 2) (3) ((4 5 6) ())) 3")
                "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))\n")
  (check-equal? (run-print "7 () 3") "(7)\n")
  (check-equal? (run-print "7 () 0") "()\n")
  (check-equal? (run-print "x\n(() (a b) (c))\n2\n")
                "((x) (a b) (x c))\n")
  (check-equal? (my-length '(a () (b c))) 3)
  (check-equal? (my-map add1 '(0 2 4)) '(1 3 5))
  (check-equal? (insert-if-short 'x '((())) 2) '(x (x (x))))
  (check-equal? (insert-if-short 'x '((())) 0) '((())))
  (check-equal? ((make-inserter 'x (lambda (len) (= len 1))) '(a (()) ()))
                '(a (x ()) ()))

  (define depth-input
    (for/fold ([nested '()]) ([_ (in-range 100)])
      (list nested)))
  (define depth-expected
    (for/fold ([nested '(x)]) ([_ (in-range 100)])
      (list 'x nested)))
  (check-equal? (insert-if-short 'x depth-input 2) depth-expected)

  (define long-input (range 10000))
  (check-equal? (insert-if-short 'x long-input 10000) long-input)
  (check-equal? (insert-if-short 'x long-input 10001) (cons 'x long-input)))

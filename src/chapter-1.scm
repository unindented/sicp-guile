(use-modules (srfi srfi-64))
(use-modules (utils test-runner))

(test-runner-factory test-runner-custom)

(test-begin "Chapter 1")

(test-begin "Exercise 1.2")
;; Translate an expression into prefix form.
(define expression-prefix-form
  (/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5)))))
     (* 3 (- 6 2) (- 2 7))))

(test-eqv (/ -37 150) expression-prefix-form)
(test-end "Exercise 1.2")

(test-begin "Exercise 1.3")
;; Define a procedure that takes three numbers as arguments and returns the sum
;; of the squares of the two larger numbers.
(define (sum-of-squared-largest-two x y z)
  (define (square x)
    (* x x))

  (define (sum-of-squares x y)
    (+ (square x) (square y)))

  (if (>= x y)
    (sum-of-squares x (if (>= y z) y z))
    (sum-of-squares y (if (>= x z) x z))))

(test-eqv 25 (sum-of-squared-largest-two 2 3 4))
(test-eqv 25 (sum-of-squared-largest-two 3 4 2))
(test-eqv 25 (sum-of-squared-largest-two 4 2 3))
(test-end "Exercise 1.3")

(test-begin "Exercise 1.4")
;; Our model of evaluation allows for combinations whose operators are compound
;; expressions.
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

(test-eqv 5 (a-plus-abs-b 3 2))
(test-eqv 5 (a-plus-abs-b 3 -2))
(test-end "Exercise 1.4")

(test-end "Chapter 1")

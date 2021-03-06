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

(test-begin "Exercise 1.5")
;; When evaluating `(test 0 (p))` using applicative-order evaluation, `(p)`
;; expands infinitely to itself.
(test-end "Exercise 1.5")

(test-begin "Exercise 1.6")
;; In our model, `if` needs to be a special form so that the alternative clause
;; is only expanded if the predicate is false.
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))
(test-end "Exercise 1.6")

(test-begin "Exercise 1.7 a")
(define (sqrt x)
  (define (sqrt-iter guess x)
    (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)))

  (define (good-enough? guess x)
    (< (abs (- (square guess) x)) 0.001))

  (define (improve guess x)
    (average guess (/ x guess)))

  (define (square x)
    (* x x))

  (define (average x y)
    (/ (+ x y) 2))

  (sqrt-iter 1.0 x))

(test-approximate 2 (sqrt 4) 0.0001)
(test-approximate 1.4142 (sqrt 2) 0.0001)
(test-expect-fail "insufficient precision")
(test-approximate "insufficient precision" 0.01 (sqrt 0.0001) 0.001)
(test-end "Exercise 1.7 a")

(test-begin "Exercise 1.7 b")
(define (sqrt-alt x)
  (define (sqrt-iter prev-guess curr-guess x)
    (if (good-enough? prev-guess curr-guess)
      curr-guess
      (sqrt-iter curr-guess (improve curr-guess x) x)))

  (define (good-enough? prev-guess curr-guess)
    (<= (abs (- curr-guess prev-guess))
        (* curr-guess 0.001)))

  (define (improve guess x)
    (average guess (/ x guess)))

  (define (square x)
    (* x x))

  (define (average x y)
    (/ (+ x y) 2))

  (sqrt-iter 0.0 1.0 x))

(test-approximate 2 (sqrt-alt 4) 0.0001)
(test-approximate 1.4142 (sqrt-alt 2) 0.0001)
(test-approximate 0.01 (sqrt-alt 0.0001) 0.0001)
(test-end "Exercise 1.7 b")

(test-begin "Exercise 1.8")
(define (cube-root x)
  (define (cube-root-iter prev-guess curr-guess x)
    (if (good-enough? prev-guess curr-guess)
      curr-guess
      (cube-root-iter curr-guess (improve curr-guess x) x)))

  (define (good-enough? prev-guess curr-guess)
    (<= (abs (- curr-guess prev-guess))
        (* curr-guess 0.001)))

  (define (improve guess x)
    (average (/ x (square guess)) guess guess))

  (define (average x y z)
    (/ (+ x y z) 3))

  (define (square x)
    (* x x))

  (cube-root-iter 0.0 1.0 x))

(test-approximate 3 (cube-root 27) 0.0001)
(test-approximate 1.4422 (cube-root 3) 0.0001)
(test-approximate 0.1 (cube-root 0.001) 0.0001)
(test-end "Exercise 1.8")

(test-begin "Exercise 1.9")
(define (sum-rec a b)
  (if (= a 0) b (1+ (sum-rec (1- a) b))))

(define (sum-iter a b)
  (if (= a 0) b (sum-iter (1- a) (1+ b))))

(test-eqv 9 (sum-rec 4 5))
(test-eqv 9 (sum-iter 4 5))
(test-end "Exercise 1.9")

(test-begin "Exercise 1.10")
(define (ackermann x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (ackermann (- x 1) (ackermann x (- y 1))))))

(test-eqv 16 (ackermann 0 8)) ;; 2*n
(test-eqv 1024 (ackermann 1 10)) ;; 2^n
(test-eqv 65536 (ackermann 2 4)) ;; 2^(a(n-1))
(test-end "Exercise 1.10")

(test-begin "Exercise 1.11")
(define (f-rec n)
  (if (< n 3)
    n
    (+ (f-rec (- n 1))
       (* 2 (f-rec (- n 2)))
       (* 3 (f-rec (- n 3))))))

(define (f-iter n)
  (define (iter i a b c)
    (cond ((< i 0) i)
          ((= i 0) a)
          (else (iter (- i 1) b c (+ c (* 2 b) (* 3 a))))))

  (iter n 0 1 2))

(test-eqv 1 (f-rec 1))
(test-eqv 2 (f-rec 2))
(test-eqv 4 (f-rec 3))
(test-eqv 11 (f-rec 4))
(test-eqv 1 (f-iter 1))
(test-eqv 2 (f-iter 2))
(test-eqv 4 (f-iter 3))
(test-eqv 11 (f-iter 4))
(test-end "Exercise 1.11")

(test-begin "Exercise 1.12")
(define (pascal-triangle row col)
  (cond ((> col row) 0)
        ((< col 0) 0)
        ((= col 1) 1)
        (else (+ (pascal-triangle (- row 1) (- col 1))
                 (pascal-triangle (- row 1) col)))))

(test-eqv 1 (pascal-triangle 1 1))
(test-eqv 1 (pascal-triangle 2 2))
(test-eqv 2 (pascal-triangle 3 2))
(test-eqv 3 (pascal-triangle 4 2))
(test-end "Exercise 1.12")

(test-begin "Exercise 1.14")
(define (count-change-rec amount)
  (define (cc amount kinds-of-coins)
    (cond ((= amount 0)
           1)
          ((or (< amount 0)
               (= kinds-of-coins 0))
           0)
          (else
            (+ (cc amount (- kinds-of-coins 1))
               (cc (- amount (first-denomination kinds-of-coins)) kinds-of-coins)))))

  (define (first-denomination kinds-of-coins)
    (cond ((= kinds-of-coins 1) 1)
          ((= kinds-of-coins 2) 5)
          ((= kinds-of-coins 3) 10)
          ((= kinds-of-coins 4) 25)
          ((= kinds-of-coins 5) 50)))

  (cc amount 5))

(test-eqv 4 (count-change-rec 11))
(test-end "Exercise 1.14")

(test-begin "Exercise 1.15")
(define (sine angle)
  (define (cube x) (* x x x))

  (define (p x) (- (* 3 x) (* 4 (cube x))))

  (if (not (> (abs angle) 0.1))
    angle
    (p (sine (/ angle 3.0)))))

(test-approximate 0.85 (sine 45) 0.1)
(test-end "Exercise 1.15")

(test-end "Chapter 1")

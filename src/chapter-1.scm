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

(test-end "Chapter 1")

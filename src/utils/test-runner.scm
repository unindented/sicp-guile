(define-module (utils test-runner)
   #:export (test-runner-custom))

(use-modules (srfi srfi-64))
(use-modules (ice-9 format))

(define (test-runner-custom)
  (define (format-msg str . args)
    (apply format #t str args))

  (define (format-count str count)
    (if (> count 0)
      (format #t str count)))

  (define (exit-with-code runner)
    (let ((errors (+ (test-runner-xpass-count runner)
                     (test-runner-fail-count runner))))
      (exit errors)))

  (define (test-on-group-begin-custom runner suite-name count)
    (format-msg "~a~%" suite-name))

  (define (test-on-test-end-custom runner)
    (case (test-result-kind runner)
      ((pass xpass)
        (let ((rez (test-result-alist runner)))
          (format-msg "ok - ~a~%"
                      (assoc-ref rez 'source-form))))
      ((fail xfail)
        (let ((rez (test-result-alist runner)))
          (format-msg "not ok - ~a~%"
                      (assoc-ref rez 'source-form))
          (format-msg "  ~a::~a~%"
                      (assoc-ref rez 'source-file)
                      (assoc-ref rez 'source-line))
          (format-msg "  expected value  ~a~%"
                      (assoc-ref rez 'expected-value))
          (format-msg "  actual value    ~a~%"
                      (assoc-ref rez 'actual-value))
          (format-msg "  error           ~a~%"
                      (assoc-ref rez 'actual-error))))
      (else #t)))

  (define (test-on-final-custom runner)
    (format-msg "~%")
    (format-count "# of expected passes       ~d~%"
                  (test-runner-pass-count runner))
    (format-count "# of expected failures     ~d~%"
                  (test-runner-xfail-count runner))
    (format-count "# of unexpected successes  ~d~%"
                  (test-runner-xpass-count runner))
    (format-count "# of unexpected failures   ~d~%"
                  (test-runner-fail-count runner))
    (format-count "# of skipped tests         ~d~%"
                  (test-runner-skip-count runner))
    (exit-with-code runner))

  (let ((runner (test-runner-null)))
    (test-runner-on-group-begin! runner test-on-group-begin-custom)
    (test-runner-on-test-end! runner test-on-test-end-custom)
    (test-runner-on-final! runner test-on-final-custom)
    runner))

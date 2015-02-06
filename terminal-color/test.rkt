#lang racket
(require rackunit
         "main.rkt")

;; off: must pass straight through with no changes
(parameterize ([current-output-color-mode 'off])
  ;; display
  (check-equal? (call-with-output-string
                 (λ (out)
                   (display-color "123" out #:fg 'yellow)))
                "123")
  (check-equal? (call-with-output-string
                 (λ (out)
                   (display-color "123\n456" out #:fg 'yellow)))
                "123\n456")
  ;; displayln
  (check-equal? (call-with-output-string
                 (λ (out)
                   (displayln-color "123" out #:fg 'yellow)))
                "123\n"))

;; ansi: 
;; TODO: Maybe we could check for the actual generated ANSI codes
;; but for now just check the output is changed in someway.
(parameterize ([current-output-color-mode 'ansi])
  ;; display
  (check-not-equal? (call-with-output-string
                 (λ (out)
                   (display-color "123" out #:fg 'yellow)))
                "123")
  (check-not-equal? (call-with-output-string
                 (λ (out)
                   (display-color "123\n456" out #:fg 'yellow)))
                "123\n456")
  ;; displayln
  (check-not-equal? (call-with-output-string
                 (λ (out)
                   (displayln-color "123" out #:fg 'yellow)))
                "123"))
#lang racket
(require terminal-color)

(define (display-test-output title)
  (displayln title)
  (displayln-color "1: Default colors")
  (displayln-color "2: Green" #:fg 'green)
  (displayln-color "3: White on red" #:fg 'white #:bg 'red)
  (newline))

(display-test-output "(guess-display-color-mode)")

(parameterize ([current-display-color-mode 'off])
  (display-test-output "'off"))

(parameterize ([current-display-color-mode 'ansi])
  (display-test-output "'ansi"))

; Only run on Windows.
;(parameterize ([current-display-color-mode 'win32])
;  (display-test-output "'win32"))


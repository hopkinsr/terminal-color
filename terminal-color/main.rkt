#lang racket/base
(provide current-display-color-mode
         guess-display-color-mode
         display-color
         displayln-color)

(require racket/runtime-path)

(define-runtime-path off-file "private/off.rkt")
(define-runtime-path ansi-file "private/ansi.rkt")
(define-runtime-path win32-file "private/win32.rkt")

(define (guess-display-color-mode)
  (if (terminal-port? (current-output-port))
      (case (system-type 'os)
        [(unix macosx) 'ansi]
        [(windows) 'win32]
        [else 'off])
      'off))

(define current-display-color-mode (make-parameter (guess-display-color-mode)))

(define-namespace-anchor a)

(define (load-plug-in file proc)
  (let ([ns (namespace-anchor->namespace a)])
    (parameterize ([current-namespace ns])
      (dynamic-require file proc))))

(define (display-color text #:fg (fg 'default) #:bg (bg 'default))
  (define display-variant
    (case (current-display-color-mode)
      [(ansi) (load-plug-in ansi-file 'display-color)]
      [(win32) (load-plug-in win32-file 'display-color)]
      [(off) (load-plug-in off-file 'display-color)]))
  (display-variant text #:fg fg #:bg bg))

(define (displayln-color text #:fg (fg 'default) #:bg (bg 'default))
  (define displayln-variant
    (case (current-display-color-mode)
      [(ansi) (load-plug-in ansi-file 'displayln-color)]
      [(win32) (load-plug-in win32-file 'displayln-color)]
      [(off) (load-plug-in off-file 'displayln-color)]))
  (displayln-variant text #:fg fg #:bg bg))


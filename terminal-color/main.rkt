#lang racket/base
(require racket/contract)

(provide (contract-out
          [output-color-mode? (-> any/c boolean?)]
          [guess-output-color-mode (-> output-color-mode?)]
          [current-output-color-mode (parameter/c output-color-mode?)]
          [current-output-color-fg (parameter/c terminal-color?)]
          [current-output-color-bg (parameter/c terminal-color?)]
          [terminal-color? (-> any/c boolean?)]))

(provide (contract-out
          [display-color (->* (any/c) (output-port? #:fg terminal-color? #:bg terminal-color?) void?)]
          [displayln-color (->* (any/c) (output-port? #:fg terminal-color? #:bg terminal-color?) void?)]
          [print-color (->* (any/c) (output-port? (or/c 0 1) #:fg terminal-color? #:bg terminal-color?) void?)]
          [write-color (->* (any/c) (output-port? #:fg terminal-color? #:bg terminal-color?) void?)]))

; compatibility: used before v1
(provide (contract-out
          [current-display-color-mode (parameter/c output-color-mode?)]
          [guess-display-color-mode (-> output-color-mode?)]))

(require racket/runtime-path)

(define-runtime-path off-file "private/off.rkt")
(define-runtime-path ansi-file "private/ansi.rkt")
(define-runtime-path win32-file "private/win32.rkt")

; compatibility: win32 was used before v1
(define (output-color-mode? v)
  (case v
    [(off ansi win32 windows) #t]
    [else #f]))

(define (guess-output-color-mode)
  (if (terminal-port? (current-output-port))
      (case (system-type 'os)
        [(unix macosx) 'ansi]
        [(windows) 'windows]
        [else 'off])
      'off))

(define current-output-color-mode (make-parameter (guess-output-color-mode)))
(define current-output-color-fg (make-parameter 'default))
(define current-output-color-bg (make-parameter 'default))

(define (terminal-color? v)
  (case v
    [(default
       black white
       red green blue
       cyan magenta yellow)
     #t]
    [else #f]))

(define-namespace-anchor a)

(define (load-plug-in file proc)
  (let ([ns (namespace-anchor->namespace a)])
    (parameterize ([current-namespace ns])
      (dynamic-require file proc))))

(define (display-color datum [out (current-output-port)] #:fg [fg (current-output-color-fg)] #:bg [bg (current-output-color-bg)])
  (define display-variant
    (case (current-output-color-mode)
      [(ansi) (load-plug-in ansi-file 'display-color)]
      [(win32 windows) (load-plug-in win32-file 'display-color)]
      [(off) (load-plug-in off-file 'display-color)]))
  (display-variant datum out #:fg fg #:bg bg))

(define (displayln-color datum [out (current-output-port)] #:fg [fg (current-output-color-fg)] #:bg [bg (current-output-color-bg)])
  (define displayln-variant
    (case (current-output-color-mode)
      [(ansi) (load-plug-in ansi-file 'displayln-color)]
      [(win32 windows) (load-plug-in win32-file 'displayln-color)]
      [(off) (load-plug-in off-file 'displayln-color)]))
  (displayln-variant datum out #:fg fg #:bg bg))

(define (print-color datum [out (current-output-port)] [quote-depth 0] #:fg [fg (current-output-color-fg)] #:bg [bg (current-output-color-bg)])
  (define print-variant
    (case (current-output-color-mode)
      [(ansi) (load-plug-in ansi-file 'print-color)]
      [(win32 windows) (load-plug-in win32-file 'print-color)]
      [(off) (load-plug-in off-file 'print-color)]))
  (print-variant datum out quote-depth #:fg fg #:bg bg))

(define (write-color datum [out (current-output-port)] #:fg [fg (current-output-color-fg)] #:bg [bg (current-output-color-bg)])
  (define write-variant
    (case (current-output-color-mode)
      [(ansi) (load-plug-in ansi-file 'write-color)]
      [(win32 windows) (load-plug-in win32-file 'write-color)]
      [(off) (load-plug-in off-file 'write-color)]))
  (write-variant datum out #:fg fg #:bg bg))

; compatibility
(define current-display-color-mode current-output-color-mode)
(define guess-display-color-mode guess-output-color-mode)

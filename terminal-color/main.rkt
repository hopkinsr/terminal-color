#lang racket/base
(require racket/contract
         racket/list
         racket/runtime-path)

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

(define-runtime-path off-plugin-path "private/off.rkt")
(define-runtime-path ansi-plugin-path "private/ansi.rkt")
(define-runtime-path windows-plugin-path "private/windows.rkt")

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

(define-namespace-anchor plugin-anchor)

(define (load-plug-in file proc)
  (let ([ns (namespace-anchor->namespace plugin-anchor)])
    (parameterize ([current-namespace ns])
      (dynamic-require file proc))))

(struct plugin (mode name method))

(define possible-plugins-to-load
  (let ([standard-plugins (list `(off ,off-plugin-path)
                                `(ansi ,ansi-plugin-path))])
    (if (equal? (system-type 'os) 'windows)
        (cons `(windows ,windows-plugin-path))
        standard-plugins)))

(define plugin-cache
  (for*/list ([p possible-plugins-to-load]
              [name '(display-color displayln-color print-color write-color)])
    (let ([mode (first p)]
          [file (second p)])
      (plugin mode name (load-plug-in file name)))))

(define (get-cached-plugin name [mode (current-output-color-mode)])
  (define matching (filter (λ (p)
                             (and (equal? (plugin-mode p) mode)
                                  (equal? (plugin-name p) name)))
                           plugin-cache))
  (first matching))

(define (get-cached-plugin-method name [mode (current-output-color-mode)])
  (plugin-method (get-cached-plugin name mode)))

(define (display-color datum [out (current-output-port)] #:fg [fg (current-output-color-fg)] #:bg [bg (current-output-color-bg)])
  (define display-variant (get-cached-plugin-method 'display-color))
  (display-variant datum out #:fg fg #:bg bg))

(define (displayln-color datum [out (current-output-port)] #:fg [fg (current-output-color-fg)] #:bg [bg (current-output-color-bg)])
  (define displayln-variant (get-cached-plugin-method 'displayln-color))
  (displayln-variant datum out #:fg fg #:bg bg))

(define (print-color datum [out (current-output-port)] [quote-depth 0] #:fg [fg (current-output-color-fg)] #:bg [bg (current-output-color-bg)])
  (define print-variant (get-cached-plugin-method 'print-color))
  (print-variant datum out quote-depth #:fg fg #:bg bg))

(define (write-color datum [out (current-output-port)] #:fg [fg (current-output-color-fg)] #:bg [bg (current-output-color-bg)])
  (define write-variant (get-cached-plugin-method 'write-color))
  (write-variant datum out #:fg fg #:bg bg))

; compatibility
(define current-display-color-mode current-output-color-mode)
(define guess-display-color-mode guess-output-color-mode)

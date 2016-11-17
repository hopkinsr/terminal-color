#lang racket
(provide display-color
         displayln-color
         print-color
         write-color)

; https://github.com/stamourv/roguelike/blob/master/utilities/terminal.rkt
(define (terminal-command out command)
  (fprintf out "~a~a" (integer->char #x1b) command))

(define (terminal-reset out)
  (terminal-command out "[0m"))

(define (terminal-colors out bg fg [bold? #f] [underline? #f])
  (if (and (number? bg) (number? fg)) ; call with 256
      (terminal-256-colors out bg fg)
      (terminal-command out
                        (format "[~a;~a~a~am"
                                (case bg
                                  ((black) "40") ((red)     "41")
                                  ((green) "42") ((yellow)  "43")
                                  ((blue)  "44") ((magenta) "45")
                                  ((cyan)  "46") ((white)   "47")
                                  ((default) "49"))
                                (case fg
                                  ((black) "30") ((red)     "31")
                                  ((green) "32") ((yellow)  "33")
                                  ((blue)  "34") ((magenta) "35")
                                  ((cyan)  "36") ((white)   "37")
                                  ((default) "39"))
                                (if bold?      ";1" "")
                                (if underline? ";4" "")))))

(define (terminal-256-colors out bg fg)
  (terminal-command out
                     (format "[38;5;~a;48;5;~am" fg bg)))

(define (output-color output-method datum out #:fg fg #:bg bg)
  (terminal-colors out bg fg #f #f)
  (output-method datum out)
  (terminal-reset out))

(define (display-color datum out #:fg fg #:bg bg)
  (output-color display datum out #:fg fg #:bg bg))

(define (displayln-color datum out #:fg fg #:bg bg)
  (terminal-colors out bg fg #f #f)
  (display datum out)
  (terminal-reset out)
  (newline out))

(define (print-color datum out quote-depth #:fg fg #:bg bg)
  (terminal-colors bg fg #f #f)
  (print datum out quote-depth)
  (terminal-reset out))

(define (write-color datum out #:fg fg #:bg bg)
  (output-color write datum out #:fg fg #:bg bg))

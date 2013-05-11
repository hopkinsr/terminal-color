#lang racket
(provide display-color
         displayln-color)

(define (display-color text #:fg fg #:bg bg)
  (terminal-colors bg fg #f #f)
  (display text)
  (terminal-reset))

(define (displayln-color text #:fg fg #:bg bg)
  (terminal-colors bg fg #f #f)
  (display text)
  (terminal-reset)
  (newline))

; https://github.com/stamourv/roguelike/blob/master/utilities/terminal.rkt
(define (terminal-command command)
  (printf "~a~a" (integer->char #x1b) command))
(define (terminal-reset) (terminal-command "[0m"))
(define (terminal-colors bg fg [bold? #f] [underline? #f])
  (terminal-command
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
           (if underline? ";4" ""))))

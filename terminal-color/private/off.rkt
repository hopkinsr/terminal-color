#lang racket
(provide display-color
         displayln-color
         print-color
         write-color)

(define (output-color output-method text #:fg fg #:bg bg)
  (output-method text))

(define (display-color text #:fg fg #:bg bg)
  (output-color display text #:fg fg #:bg bg))

(define (displayln-color text #:fg fg #:bg bg)
  (output-color displayln text #:fg fg #:bg bg))

(define (print-color text #:fg fg #:bg bg)
  (output-color print text #:fg fg #:bg bg))

(define (write-color text #:fg fg #:bg bg)
  (output-color write text #:fg fg #:bg bg))


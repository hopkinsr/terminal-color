#lang racket
(provide display-color
         displayln-color)

(define (display-color text #:fg fg #:bg bg)
  (display text))

(define (displayln-color text #:fg fg #:bg bg)
  (displayln text))


#lang racket
(provide display-color
         displayln-color
         print-color
         write-color)

(define (display-color datum out #:fg fg #:bg bg)
  (display datum out))

(define (displayln-color datum out #:fg fg #:bg bg)
  (displayln datum out))

(define (print-color datum out quote-depth #:fg fg #:bg bg)
  (print datum out quote-depth))

(define (write-color datum out #:fg fg #:bg bg)
  (write datum out))


#lang racket
(provide display-color
         displayln-color
         print-color
         write-color)

(define (output-color output-method datum out #:fg fg #:bg bg)
  (output-method datum out))

(define (display-color datum out #:fg fg #:bg bg)
  (output-color display datum out #:fg fg #:bg bg))

(define (displayln-color datum out #:fg fg #:bg bg)
  (output-color displayln datum out #:fg fg #:bg bg))

(define (print-color datum out quote-depth #:fg fg #:bg bg)
  (print datum out quote-depth #:fg fg #:bg bg))

(define (write-color datum out #:fg fg #:bg bg)
  (output-color write datum out #:fg fg #:bg bg))


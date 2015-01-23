#lang racket
(provide display-color
         displayln-color
         print-color
         write-color)

(require ffi/unsafe
         ffi/unsafe/define)

(define-ffi-definer define-win32-terminal (ffi-lib "kernel32"))
(define-win32-terminal GetStdHandle (_fun _int -> _intptr))
(define-win32-terminal SetConsoleTextAttribute (_fun _intptr _int16 -> _int))

(define STD_OUTPUT_HANDLE -11)

(define FOREGROUND_BLUE 1)
(define FOREGROUND_GREEN 2)
(define FOREGROUND_RED 4)
(define FOREGROUND_INTENSITY 8)
(define BACKGROUND_BLUE 16)
(define BACKGROUND_GREEN 32)
(define BACKGROUND_RED 64)
(define BACKGROUND_INTENSITY 128)

(define FOREGROUND_CYAN (bitwise-ior FOREGROUND_BLUE FOREGROUND_GREEN))
(define FOREGROUND_MAGENTA (bitwise-ior FOREGROUND_BLUE FOREGROUND_RED))
(define FOREGROUND_YELLOW (bitwise-ior FOREGROUND_GREEN FOREGROUND_RED))
(define FOREGROUND_WHITE (bitwise-ior FOREGROUND_BLUE FOREGROUND_GREEN FOREGROUND_RED))
(define FOREGROUND_BLACK 0)

(define BACKGROUND_CYAN (bitwise-ior BACKGROUND_BLUE BACKGROUND_GREEN))
(define BACKGROUND_MAGENTA (bitwise-ior BACKGROUND_BLUE BACKGROUND_RED))
(define BACKGROUND_YELLOW (bitwise-ior BACKGROUND_GREEN BACKGROUND_RED))
(define BACKGROUND_WHITE (bitwise-ior BACKGROUND_BLUE BACKGROUND_GREEN BACKGROUND_RED))
(define BACKGROUND_BLACK 0)

(define console (GetStdHandle STD_OUTPUT_HANDLE))

(define (set-terminal-color! fg bg)
  (flush-output)
  (define bgattr (case bg
                   ((black) BACKGROUND_BLACK) ((red)     BACKGROUND_RED)
                   ((green) BACKGROUND_GREEN) ((yellow)  BACKGROUND_YELLOW)
                   ((blue)  BACKGROUND_BLUE) ((magenta) BACKGROUND_MAGENTA)
                   ((cyan)  BACKGROUND_CYAN) ((white)   BACKGROUND_WHITE)
                   ((default) BACKGROUND_BLACK)))
  (define fgattr (case fg
                   ((black) FOREGROUND_BLACK) ((red)     FOREGROUND_RED)
                   ((green) FOREGROUND_GREEN) ((yellow)  FOREGROUND_YELLOW)
                   ((blue)  FOREGROUND_BLUE) ((magenta) FOREGROUND_MAGENTA)
                   ((cyan)  FOREGROUND_CYAN) ((white)   FOREGROUND_WHITE)
                   ((default) FOREGROUND_WHITE)))
  (SetConsoleTextAttribute console (bitwise-ior fgattr bgattr))
  (void))

(define (reset-terminal-color!)
  (set-terminal-color! 'white 'black))

(define (output-color output-method datum out #:fg fg #:bg bg)
  (set-terminal-color! fg bg)
  (output-method datum out)
  (reset-terminal-color!))

(define (display-color datum out #:fg fg #:bg bg)
  (output-color display datum out #:fg fg #:bg bg))

(define (displayln-color datum out #:fg fg #:bg bg)
  (set-terminal-color! fg bg)
  (display datum out)
  (reset-terminal-color!)
  (newline))

(define (print-color datum out quote-depth #:fg fg #:bg bg)
  (set-terminal-color! fg bg)
  (print datum out quote-depth)
  (reset-terminal-color!))

(define (write-color datum out #:fg fg #:bg bg)
  (output-color write datum out #:fg fg #:bg bg))

#lang scribble/manual
@(require scribble/eval)
@(require (for-label racket/base))

@title{terminal-color}

A Racket library to output colored text to the terminal on any platform, including Windows.

See the API section for what is provided and further usage instructions.

The short example below defines a helper procedure to output some text and then uses it
in each of the available output color modes.

@examples[(require terminal-color)
          
          (define (display-test-output title)
            (displayln title)
            (displayln-color "1: Default colors")
            (displayln-color "2: Green" #:fg 'green)
            (displayln-color "3: White on red" #:fg 'white #:bg 'red)
            (newline))
          
          (display-test-output "(guess-output-color-mode)")
          
          (parameterize ([current-output-color-mode 'off])
            (display-test-output "'off"))
          
          (parameterize ([current-output-color-mode 'ansi])
            (display-test-output "'ansi"))
          
          ; Only run on Windows.
          (when (equal? (system-type 'os) 'windows)
            (parameterize ([current-output-color-mode 'win32])
              (display-test-output "'win32")))]

@section{API}

@defmodule[terminal-color]

@defproc[(display-color [text string?] [#:fg fg symbol?] [#:bg bg symbol?])
         void?]{
A wrapper for the standard @code["display"] procedure that will output the text
in the requested color when possible.
}
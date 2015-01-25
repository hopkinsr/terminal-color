#lang scribble/manual
@(require scribble/eval)
@(require (for-label racket
                     terminal-color))

@author{Richard Hopkins}
@title{terminal-color}

A Racket library to output colored text to the terminal on any platform, including Windows.

See the API section for what is provided and further usage instructions.

The short example below defines a helper procedure to output some text and then uses it
in each of the available output color modes.

@examples[(require racket/port
                   terminal-color)
          
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
              (display-test-output "'win32")))
          
          (void (call-with-output-string
                 (λ (out)
                   (displayln-color "(current-output-port) and (currentoutput-color-mode)" #:fg 'cyan)
                   (displayln-color "to output string and (current-output-color-mode)" out #:fg 'cyan))))]

@section{API}

@defmodule[terminal-color]

@defproc[(output-color-mode? [v any/c]) boolean?]{
                                                  Returns @racket[#t] if @racket[v] is a valid output color mode, @racket[#f] otherwise.
                                                          
                                                          Valid modes are
                                                          
                                                          @itemlist[@item[@racket['off]]
                                                                     @item[@racket['ansi]]
                                                                     @item[@racket['win32] @(deprecated #:what "'win32" "'windows")]
                                                                     @item[@racket['windows]]]
                                                          }

@defparam[current-output-color-mode mode output-color-mode?
                                    #:value (guess-output-color-mode)]{
                                                                       A parameter that defines the current output color mode used by @code["display-color"], @code["displayln-color"], @code["print-color"], @code["write-color"].
                                                                                                                                      Default value is the result of @code["guess-output-color-mode"].
                                                                                                                                      }

@defparam[current-display-color-mode mode output-color-mode?
                                     #:value (guess-output-color-mode)]{
                                                                        @(deprecated #:what "current-display-color-mode" "current-output-color-mode")
                                                                         }

@defparam[current-output-color-fg mode terminal-color?
                                    #:value 'default]{
                                                                       A parameter that defines the current foreground color used by @code["display-color"], @code["displayln-color"], @code["print-color"], @code["write-color"]
                                                                                                                                     unless one is explicitly specified.
                                                                                                                                      Default value is @racket['default].
                                                                                                                                      }

@defparam[current-output-color-bg mode terminal-color?
                                    #:value 'default]{
                                                                       A parameter that defines the current background color used by @code["display-color"], @code["displayln-color"], @code["print-color"], @code["write-color"]
                                                                                                                                     unless one is explicitly specified.
                                                                                                                                      Default value is @racket['default].
                                                                                                                                      }

@defproc[(guess-output-color-mode) output-color-mode?]{
                                                       A helper to provide a sane value for @code["current-output-color-mode"].
                                                                                            
                                                                                            If the output is to a terminal then the operating system is checked:
                                                                                            unix-like will use ANSI codes (@racket['ansi]) and Windows will use Win32
                                                                                            API calls (@racket['windows]). Everything else will do nothing (@racket['off]).
                                                                                            }

@defproc[(guess-display-color-mode) output-color-mode?]{
                                                        @(deprecated #:what "guess-display-color-mode" "guess-output-color-mode")
                                                         }

@defproc[(terminal-color? [v any/c]) boolean?]{
                                               Returns @racket[#t] if @racket[v] is a valid color, @racket[#f] otherwise.
                                                       
                                                       Valid colors are
                                                       
                                                       @itemlist[@item[@racket['default]]
                                                                  @item[@racket['black]]
                                                                  @item[@racket['white]]
                                                                  @item[@racket['red]]
                                                                  @item[@racket['green]]
                                                                  @item[@racket['blue]]
                                                                  @item[@racket['cyan]]
                                                                  @item[@racket['magenta]]
                                                                  @item[@racket['yellow]]]
                                                       }

@defproc[(display-color [datum any/c] [out output-port? (current-output-port)] [#:fg fg terminal-color? 'default] [#:bg bg terminal-color? 'default])
         void?]{
                A wrapper for the standard @code["display"] procedure that will output @racket[datum]
                                           in the requested color if possible followed by resetting the terminal color.
                                           }

@defproc[(displayln-color [datum any/c] [out output-port? (current-output-port)] [#:fg fg terminal-color? 'default] [#:bg bg terminal-color? 'default])
         void?]{
                A wrapper for the standard @code["displayln"] procedure that will output @racket[datum]
                                           in the requested color if possible followed by resetting the terminal color.
                                           
                                           It's recommended to use this instead of @code["display-color"] for strings that end with a new line.
                                           This is because it will reset the terminal color before the new line as it can be significant on some terminals.
                                           }

@defproc[(print-color [datum any/c] [out output-port? (current-output-port)] [quote-depth (or/c 0 1) 0] [#:fg fg terminal-color? 'default] [#:bg bg terminal-color? 'default])
         void?]{
                A wrapper for the standard @code["print"] procedure that will output @racket[datum]
                                           in the requested color if possible followed by resetting the terminal color.
                                           }

@defproc[(write-color [datum any/c] [out output-port? (current-output-port)] [#:fg fg terminal-color? 'default] [#:bg bg terminal-color? 'default])
         void?]{
                A wrapper for the standard @code["write"] procedure that will output @racket[datum]
                                           in the requested color if possible followed by resetting the terminal color.
                                           }

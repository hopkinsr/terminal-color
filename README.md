terminal-color
==============

A Racket library to display colored text to the terminal

```racket
#lang racket
(require terminal-color)

(define (display-test-output title)
  (displayln title)
  (display-color "1: Default colors\n")
  (display-color "2: Green\n" #:fg 'green)
  (display-color "3: White on red\n" #:fg 'white #:bg 'red)
  (newline))

(display-test-output "(guess-display-color-mode)")

(parameterize ([current-display-color-mode 'off])
  (display-test-output "'off"))

(parameterize ([current-display-color-mode 'ansi])
  (display-test-output "'ansi"))

; Only run on Windows.
;(parameterize ([current-display-color-mode 'win32])
;  (display-test-output "'win32"))
```

API
---

Only 3 things are provided:

* current-display-color-mode
	A Racket parameter which determines how to output text when display-color
	is called. The default value is that returned by guess-display-color-mode.

* guess-display-color-mode
	A helper to provide a sane value for current-display-color-mode.
	If the output is to a terminal then the operating system is checked:
	unix-like will use ANSI codes ('ansi) and Windows will use Win32 API
	calls ('win32). Everything else will do nothing ('off).

* display-color text #:fg fg #:bg bg
	A wrapper for display and optionally sets the foreground and background
	of the terminal before calling display and resetting it afterwards.

Valid colors
------------

The following colors can be used as the foreground and background to display-color.

* 'default
* 'black
* 'red
* 'green
* 'blue
* 'cyan
* 'magenta
* 'yellow
* 'white


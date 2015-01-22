terminal-color
==============

A Racket library to output colored text to the terminal on any platform, including Windows.

See the API section for what is provided and further usage instructions.

The short example below defines a helper procedure to output some text and then uses it
in each of the available output color modes.

```racket
(require terminal-color)
      
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
```

API
---

Only 4 things are provided:

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

* displayln-color text #:fg fg #:bg bg
	Conceptually a wrapper for displayln. However, this will ensure the
	color reset is applied before the (newline) which can be significant
	on some terminals.

	It's recommended to use

	```racket
	(displayln-color "Hello" #:fg 'white #:bg 'red)
	```

	instead of

	```racket
	(display-color "Hello\n" #:fg 'white #:bg 'red)
	```

	Especially if there is an extra (newline) call immediately afterwards.

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


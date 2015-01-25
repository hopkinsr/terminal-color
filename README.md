terminal-color
==============

A Racket library to output colored text to the terminal on any platform, including Windows.

NOTE: This library is currently in development so things may change before
v1.0 is released. The current version should be usable on all platforms with
Racket 5.3.6 and 6.x series. Compatability will try to be kept for existing users.

Documentation
-------------

A rendered version of the documentation for this library is available via Github Pages:

* https://hopkinsr.github.io/terminal-color/

Example
-------

In short this library provides corresponding procedures for the standard display, displayln,
print and write procedures, allowing you to write things like

```racket
(require terminal-color)

(displayln-color "1: Default colors")
(displayln-color "2: Green" #:fg 'green)
(displayln-color "3: White on red" #:fg 'white #:bg 'red)
```

Requirements
------------

It should be possible to install this package as normal using raco on both Racket 5.3.6 and 6.x.


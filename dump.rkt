#lang racket
;; writes a bunch of tnetstrings to stdout
;; to read them into the reference implementation:
;;    racket dump.rkt | python reference/test.py
(require "main.rkt")

(write-tnetstring '#hash((#"foo" . #"bar")
			 (#"baz" . (#"quux" 1 3))))
(write-tnetstring #"pppooo face")
(write-tnetstring 1233999999999999999999.44444)
(write-tnetstring 0)
(write-tnetstring (void))
(write-tnetstring #t)
(write-tnetstring #f)
(write-tnetstring '())
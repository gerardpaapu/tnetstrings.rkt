#lang scribble/manual
@(require (for-label racket))

@title{Tagged Netstrings}

@defmodule[(planet sharkbrain/tnetstrings)]

@defproc[(read-tnetstring [port input-port? (current-input-port)])
	 any?]

Reads a single value (encoded as a tnetstring) from @racket[port], and 
returns it as a scheme value.

@defproc[(write-tnetstring [port output-port? (current-output-port)])
	 exact-nonnegative-integer?]

Encodes a single racket value as a tnetstring and writes it 
to @racket[port], the result is the number of bytes written.

@defproc[(value->bytes/tnetstring [val any?]) bytes?]

The result is a byte-string containing @racket[val] encoded as a tnetstring.

@defproc[(bytes->value/tnetstring [bstr bytes?]) any?]

The result is the value that was encoded in @racket[bstr]

This is how the Netstrings types are mapped to racket types.

@(tabular `(
	  ("string"  ,(racket bytes?))
	  ("integer"  ,(racket exact?))
	  ("float" ,(racket inexact?))
	  ("null" ,(racket void?))
	  ("boolean" ,(racket boolean?))
	  ("dictionary" ,(racket hash?))
	  ("list" ,(racket list?))
))

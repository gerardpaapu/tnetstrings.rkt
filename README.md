Tagged Netstrings
==

This is an implementation of [Tagged Netstrings](http://tnetstrings.org/) in racket.

The public interface is provided from "main.rkt".

`(read-tnetstring)` reads a single tnetstring from `current-input-port`.

`(read-tnetstring port)` reads a single tnetstring from `port`.

`(write-tnetstring val)` writes `val` (encoded as a tnetstring) to `current-output-port`.

`(write-tnetstring val port)` writes `val` (encoded as a tnetstring) to `port`.

`(value->bytes/tnetstring val)` returns `val` in a bytestring encoded as a tnetstring.

`(bytes->value/tnetstring bstr)` returns the valued encoded in `bstr` as a tnetstring.

This is how the Netstrings types are mapped to racket types.

    string     -> bytes
    integer    -> exact number
    float      -> inexact number
    null       -> void
    boolean    -> boolean
    dictionary -> dict (reads to hash)
    list       -> list

The contents of this repo are available under the BSD style license specified in LICENSE

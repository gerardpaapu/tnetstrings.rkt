#lang racket
(require (prefix-in r: "read.rkt")
         (prefix-in w: "write.rkt"))

(provide (all-defined-out))

(define (read-tnetstring [port (current-input-port)])
  (parameterize ([current-input-port port])
    (r:read-tnetstring)))

(define (write-tnestring val [port (current-output-port)])
  (parameterize ([current-output-port port])
    (w:write-tnetstring val)))

(define (bytes->value/tnetstring bytes)
  (parameterize ([current-input-port (open-input-bytes bytes)])
    (r:read-tnetstring)))

(define (value->bytes/tnetstring val)
  (define bytes (open-output-bytes))
  (parameterize ([current-output-port bytes])
    (w:write-tnetstring val))
  bytes)
#lang racket
(provide (all-defined-out))

(define (write-tnetstring val)
  (cond 
   [(void? val) (write-bytes #"0:~")]

   [(bytes? val) (write* val #",")]

   [(boolean? val)
    (write-bytes (if val #"4:true!" #"5:false!"))]
   
   [(list? val)
    (let ([body (to-bytes (lambda ()
			    (for-each write-tnetstring val)))])
      (write* body #"]"))]

   [(hash? val)
    (let ([body (to-bytes (lambda ()
			    (for ([(key val) (in-dict val)])
                                 (unless (bytes? key)
                                    (error "keys must be bytestrings"))
				 (write-tnetstring key)
				 (write-tnetstring val))))])
      (write* body #"}"))]
   
   [(integer? val) (write* (number->bytes val) #"#")]

   [(rational? val)
    (write* (number->bytes (if (exact? val)
			       (exact->inexact val)
			       val))
	    #"^")]

   [else (error (format "Can't write value: ~a" val))]))


(define (write* body type)
  (define n (number->bytes (bytes-length body)))
  (write-bytes (bytes-append n #":" body type)))

(define (to-bytes fn)
  (define b (open-output-bytes))
  (parameterize ([current-output-port b])
    (fn))
  (get-output-bytes b))

(define (number->bytes n)
  (string->bytes/latin-1 (number->string n)))
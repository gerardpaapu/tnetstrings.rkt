#lang racket
(require rackunit)
(require (prefix-in r: "read.rkt")
	 (prefix-in w: "write.rkt")
	 "main.rkt")

(define (round-trip val)
  (bytes->value/tnetstring (value->bytes/tnetstring val)))

(define (check-round-trip val)
  (check-equal? val (round-trip val)))

(check-equal? (w:remove-trailing-zeros "3.0000000") "3")
(check-equal? (w:remove-trailing-zeros "3.14159000") "3.14159")
(check-equal? (w:remove-trailing-zeros "3.") "3")
(check-equal? (w:remove-trailing-zeros "323124") "323124")
(check-equal? (w:remove-trailing-zeros "0") "0")

(check-eq? (r:with-bytes r:read-size #"45:") 45)
(check-eq? (r:with-bytes r:read-size #"23:") 23)
(check-eq? (r:with-bytes r:read-size #"45123:") 45123)
(check-eq? (r:with-bytes r:read-size #"123456789:") 123456789)
(check-eq? (r:with-bytes r:read-size #"0:") 0)
(check-eq? #f (r:with-bytes r:read-size #"45"))
(check-eq? #f (r:with-bytes r:read-size #"foo"))

(check-equal? (bytes->value/tnetstring #"0:~") (void))
(check-equal? (bytes->value/tnetstring #"2:11#") 11)
(check-equal? (bytes->value/tnetstring #"4:true!") #t)
(check-equal? (bytes->value/tnetstring #"5:false!") #f)
(check-equal? (bytes->value/tnetstring #"4:test,") #"test")

(check-round-trip '#hash((#"foo" . 1) 
			 (#"bar" . 2)
			 (#"baz" . 3)))

(check-round-trip '(1 2 3 4 5))
(check-round-trip '(1 (2 (3)) 3 4 5))
(check-round-trip #"foo")
(check-round-trip #t)
(check-round-trip #f)
(check-round-trip (void))
(check-round-trip 123)

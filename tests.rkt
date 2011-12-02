#lang racket
(require rackunit)
(require "read.rkt")
(require "write.rkt")

(check-eq? (with-bytes read-size #"45:") 45)
(check-eq? (with-bytes read-size #"23:") 23)
(check-eq? (with-bytes read-size #"45123:") 45123)
(check-eq? (with-bytes read-size #"123456789:") 123456789)
(check-eq? (with-bytes read-size #"0:") 0)
(check-eq? #f (with-bytes read-size #"45"))
(check-eq? #f (with-bytes read-size #"foo"))

(check-equal? (with-bytes read-object #"0:~") (void))

(check-equal? (with-bytes read-object #"2:11#") 11)

(check-equal? (with-bytes read-object #"4:true!") #t)

(check-equal? (with-bytes read-object #"5:false!") #f)

(check-equal? (with-bytes read-object #"4:test,") #"test")

(write-value '(1 2 3))
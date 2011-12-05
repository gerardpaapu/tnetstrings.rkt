#lang racket
(provide (all-defined-out))

(define (read-tnetstring)
  (define size (read-size))
  (if (not size)
      eof
      (let ([body (read-bytes size)]
	    [type-marker (read-byte)])
        (if (or (eof-object? type-marker)
                (not (= (bytes-length body) size)))
            (error (format "Error reading: ~a:~a" size body))
            (parse-object type-marker body)))))

(define (read-size)
  (define (rs ls)
    (let ([b (read-byte)])
      (cond [(eof-object? b) #f]

            [(> (length ls) 9)
             (error "Size should not be larger than 999,999,999 bytes")]
	    
	    [(= b (char->integer #\:))
	     (reverse ls)]
	    
	    [(<= (char->integer #\0) b (char->integer #\9)) 
	     (rs (cons b ls))]

	    [else #f])))

  (define nums (rs '()))

  (if (not nums)
      #f
      (bytes->number (list->bytes nums))))

(define (read-all)
  (let ([obj (read-tnetstring)])
    (if (eof-object? obj)
	'()
	(cons obj (read-all)))))

(define (with-bytes fn b)
  (parameterize ([current-input-port (open-input-bytes b)])
    (fn)))

(define (bytes->number b)
  (string->number (bytes->string/latin-1 b)))

(define (parse-object type-marker body)
  (case (integer->char type-marker)
    [(#\,) body]

    [(#\# #\^) (bytes->number body)]

    [(#\!) (equal? #"true" body)]

    [(#\~) (void)]
    
    [(#\}) (make-dictionary (with-bytes read-all body))]

    [(#\]) (with-bytes read-all body)]

    [else (error (format "Invalid type \"~A\"" type-marker))]))

(define (make-dictionary ls)
  (define (make-dictionary* ls)
    (if (empty? ls)
       '()
       (cons (let ([key (first ls)]
		   [value (second ls)])
	       (if (not (bytes? key))
		   (error "keys must be bytestrings")
		   (cons key value)))
	     (make-dictionary* (drop ls 2)))))
  (make-immutable-hash (make-dictionary* ls)))

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
   
   [(exact-integer? val) (write* (number->bytes val) #"#")]

   [(rational? val) (write* (number->bytes val) #"^")]

   [else (error (format "Can't write value: ~a" val))]))

(define (write* body type)
  (define len (bytes-length body))
  
  (when (> len 999999999)
    (error (format "Body too large at ~a bytes, maximum is 999999999 bytes" len)))

  (let* ([message (bytes-append (number->bytes len) #":" body type)]
	 [written (write-bytes message)])
    (unless (= written (bytes-length message))
      (error (format "Error writing: wrote ~a bytes out of ~a" written len )))))


(define (to-bytes fn)
  (define b (open-output-bytes))
  (parameterize ([current-output-port b])
    (fn))
  (get-output-bytes b))

(define (number->bytes n)
  (string->bytes/latin-1
   (if (integer? n)
       (number->string n)
       (remove-trailing-zeros (real->decimal-string n 99)))))

;; real->decimal-string returns a string with trailing zeros
;; we remove them so we're not sending them over the wire for no
;; reason
(define (remove-trailing-zeros str)
  ;; TODO: This function is super gross and I bet it's slow
  ;; I should just replace it with a regexp
  ;; 0            -> "0"
  ;; (\d+\.\d+)0+ -> $1
  ;; (\d).0+      -> $1
  (define (last-non-zero from)
    (cond [(= from 0) 0] 
	  [(not (eq? #\0 (string-ref str from))) from]
	  [else (last-non-zero (- from 1))]))

  (define (find-decimal-point from)
    (cond [(= from 0) 0]
	  [(eq? #\. (string-ref str from)) from]
	  [else (find-decimal-point (- from 1))]))
  (cond [(string=? str "0") "0"]
	;; Where lnz is the index of the last non-zero character
	;;   and dp  is the index of the decimal-point (or 0)
        ;; 
	;;   if there is no decimal point, return the whole string
        ;;   if the dp is the last non-zero character return the string truncated before the dp
	;;   otherwise truncate the string to the last non-zero character
	[else (let* ([lnz (last-non-zero (- (string-length str) 1))]
		     [dp  (find-decimal-point lnz)])
		(cond [(= dp 0) str]
		      [(= dp lnz) (substring str 0 dp)]
		      [else (substring str 0 (+ lnz 1))]))]))
(define (test-bit x)
  (if x "1" "0"))

(string-append
 (test-bit (equal? (expr-compare 12 12) 12))
 (test-bit (equal? (expr-compare 12 20) '(if % 12 20)))
 (test-bit (equal? (expr-compare #t #t) #t))
 (test-bit (equal? (expr-compare #f #f) #f))
 (test-bit (equal? (expr-compare #t #f) '%))
 (test-bit (equal? (expr-compare #f #t) '(not %)))
 (test-bit (equal? (expr-compare 'a '(cons a b)) '(if % a (cons a b))))
 (test-bit (equal? (expr-compare '(cons a b) '(cons a b)) '(cons a b)))
 (test-bit (equal? (expr-compare '(cons a b) '(cons a c)) '(cons a (if % b c))))
 (test-bit (equal?
	    (expr-compare '(cons (cons a b) (cons b c)) '(cons (cons a c) (cons a c)))
	    '(cons (cons a (if % b c)) (cons (if % b a) c))))
 (test-bit (equal? (expr-compare '(cons a b) '(list a b)) '((if % cons list) a b)))
 (test-bit (equal? (expr-compare '(list) '(list a)) '(if % (list) (list a))))
 (test-bit (equal? (expr-compare ''(a b) ''(a c)) '(if % '(a b) '(a c))))
 (test-bit (equal? (expr-compare '(quote (a b)) '(quote (a c))) '(if % '(a b) '(a c))))
 (test-bit (equal? (expr-compare '(quoth (a b)) '(quoth (a c))) '(quoth (a (if % b c)))))
 (test-bit (equal? (expr-compare '(if x y z) '(if x z z)) '(if x (if % y z) z)))
 (test-bit (equal? (expr-compare '(if x y z) '(g x y z)) '(if % (if x y z) (g x y z))))
 (test-bit (equal? (expr-compare '((lambda (a) (f a)) 1) '((lambda (a) (g a)) 2)) '((lambda (a) ((if % f g) a)) (if % 1 2))))
(test-bit (equal? (expr-compare '((lambda (a) (f a)) 1) '((λ (a) (g a)) 2)) '((λ (a) ((if % f g) a)) (if % 1 2))))
(test-bit (equal? (expr-compare '((lambda (a) a) c) '((lambda (b) b) d)) '((lambda (a!b) a!b) (if % c d))))
(test-bit (equal? (expr-compare ''((λ (a) a) c) ''((lambda (b) b) d)) '(if % '((λ (a) a) c) '((lambda (b) b) d))))
(test-bit (equal? (expr-compare '(+ #f ((λ (a b) (f a b)) 1 2))
              '(+ #t ((lambda (a c) (f a c)) 1 2))) '(+
     (not %)
     ((λ (a b!c) (f a b!c)) 1 2))))
(test-bit (equal? (expr-compare '((λ (a b) (f a b)) 1 2)
              '((λ (a b) (f b a)) 1 2)) '((λ (a b) (f (if % a b) (if % b a))) 1 2)))
(test-bit (equal? (expr-compare '((λ (a b) (f a b)) 1 2) '((λ (a c) (f c a)) 1 2))
		  '((λ (a b!c) (f (if % a b!c) (if % b!c a))) 1 2)))
(test-bit
 (equal?
  (expr-compare
   '((lambda (a) (eq? a ((λ (a b) ((λ (a b) (a b)) b a))
			 a (lambda (a) a)))) (lambda (b a) (b a)))
   '((λ (a) (eqv? a ((lambda (b a) ((lambda (a b) (a b)) b a))
		     a (λ (b) a)))) (lambda (a b) (a b))))
  '((λ (a) ((if % eq? eqv?) a
	    ((λ (a!b b!a) ((λ (a b) (a b)) (if % b!a a!b) (if % a!b b!a)))
	     a (λ (a!b) (if % a!b a))))) (lambda (b!a a!b) (b!a a!b)))))
; different arg-list length
(test-bit (equal? (expr-compare '(lambda (a b) a) '(lambda (a) a)) '(if % (lambda (a b) a) (lambda (a) a))))
; pair vs list for arguments
(test-bit (equal? (expr-compare '(lambda (a b) a) '(lambda (a . b) a)) '(if % (lambda (a b) a) (lambda (a . b) a))))
; arg with vs without parenthesis
(test-bit (equal? (expr-compare '(lambda a a) '(lambda (a) a)) '(if % (lambda a a) (lambda (a) a))))
; single value argument
(test-bit (equal? (expr-compare '(lambda a a) '(lambda b b)) '(lambda a!b a!b)))
; single argument but different symbol
(test-bit (equal? (expr-compare '(lambda (a b) a) '(lambda (a b) b)) '(lambda (a b) (if % a b))))
; single body element, do based on recursive call on body
(test-bit (equal? (expr-compare '(lambda (a b) (a b c)) '(lambda (a b) (c b a))) '(lambda (a b) ((if % a c) b (if % c a)))))
; single body in () vs single element
(test-bit (equal? (expr-compare '(lambda (a b) (a b c)) '(lambda (a b) a)) '(lambda (a b) (if % (a b c) a))))
; Only do this when same number of arguments. More examples on website
(test-bit (equal? (expr-compare '(lambda (a b) (b a)) '(lambda (b a) (a b))) '(lambda (a!b b!a) (b!a a!b))))
 ;; (test-bit (same-type? 'lambda 'λ))
 ;; (test-bit (same-type? 'λ 'lambda))
 ;; (test-bit (not (same-type? 'lambda 'g)))
 ;; (test-bit (not (same-type? 'if 'g)))
 ;; (test-bit (same-type? 'f 'g))
 ;; (test-bit (same-type? 'if 'if))
 ;; (test-bit (not (same-type? 'if 'lambda)))
 ;; (test-bit (not(same-type? 'if 'quote)))
 ;; (test-bit (equal? (bind-symbol 'ab 'cd) 'ab!cd))
 )

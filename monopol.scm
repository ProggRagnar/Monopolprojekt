;----Monopol----

(require (lib "trace.ss"))

;...:::Gata:::...;

(define gata
  
  ;Här går fakta från varje gata in. SENDA in all fakta.
  (let ((color 'blå)
        (pris 400)
        (hyra 20)
        (ägare '())
        (gatunamn 'Testgatan))
    
    ;Lambdan låter gatan kallas utan argument, första cond-satsen visar gatans status
    (lambda lst
      (cond
        ((null? lst)
         (display gatunamn)
         (newline)
         (display color)
         (newline)
         (if (eq? ägare '()) 
             (display "ingen ägare")
             (and (display "ägare: ") (display ägare)))
         (newline)
         (display "pris: ") (display pris) (display "kr")
         (newline)
         (display "hyra: ") (display hyra) (display "kr"))
        
        ;Om en spelare hamnar på gatan anropas gatan med denne spelares namn.
        ;Vid varje turbyte set! "player" till aktuell spelare...
        ;Alltid #t alltså... onödig men har inget bättre just nu.
        ((eq? (car lst) 'player)
         (cond 
           ((eq? ägare '())
            (and (display "Vill du köpa gatan?\n")
                 (if (eq? (read) 'ja)
                     (begin
                       ((acc1 'withdraw) pris)
                       (set! ägare (car lst))
                       (display "Gatan köpt!")
                       (newline))
                     (display "Gatan ej köpt...")))) 
           ((eq? ägare (car lst))
            (display "Du står på din egen gata"))
            (else (begin
              (display "Du äger inte denna gata")
              ((acc2 'withdraw) hyra) 
              ((acc1 'deposit) hyra))))) 
        (else (display "sista else"))
             
                                                  
                 
                 
            
        ))))
            
        
;...:::Bankkonto:::...; (Måste fixa ett bättre)

(define (make-account-1 balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount)) balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request" m))))
  dispatch)    
        
(define acc1 (make-account-1 500))

(define acc2 (make-account-1 500))

;...:::Tärning:::...;


(define (random-from-to from to)
  (+ from (random (- (+ to 1) from))))

(define (tärning)
  (random-from-to 1 6))


;...:::Turer och spelare:::...;

  

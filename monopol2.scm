;----Monopol----

(require (lib "trace.ss"))

;...:::Gata:::...;

(define gata%
  (class object%
    (super-new)
    (field (ägare false))
    (init-field gatunamn färg pris hyra)
    (define/public (get-gata-namn) gatunamn) ; här får vi namnet
    (define/public (get-gata-färg) färg)
    (define/public (get-gata-pris) pris)
    (define/public (get-gata-hyra) hyra)
    (define/public (get-gata-ägare) ägare)
    (define/public (on-landing)
      (cond 
           ((eq? ägare false)
            (display "Vill du köpa gatan?\n")
                 (if (eq? (read) 'ja) ; Ändra till knapptryckning med 2 alternativ.
                     (begin
                       (- (send spelare1 get-pengar) pris) ;Måste vara send (current-player).. osv.
                       (set! ägare (mcar (send world1 get-players)))
                       (display "Gatan köpt!")
                       (send world1 next-turn-2p))
                     (display "Gatan ej köpt..."))) 
           ((eq? ägare (mcar (send world1 get-players)))
            (display "Du står på din egen gata"))
            (else (begin
              (display "Du äger inte denna gata")
              (- (send spelare1 get-pengar) hyra) ;spelare 1 här ska vara car players.
              (+ (send spelare1 get-pengar) pris))))))) ;spelare 1 ska vara ägare

(define gata1
  (new gata%
      [gatunamn "Ryds Allé"]
      [färg "Blå"]
      [pris 400]
      [hyra 20]))

(define gata2
  (new gata%
       [gatunamn "Ryd Centrum"]
       [färg "Blå"]
       [pris 550]
       [hyra 30]))

;...:::Turer och spelare:::...;

(define spelare%
  (class object%
    (super-new)
    (field (pengar 8500))
    (init-field namn gator)
    (define/public (get-spelare-namn) namn)
    (define/public (get-pengar) pengar)
    (define/public (get-gator) gator)))

(define spelare1
  (new spelare%
       [namn "spelare1"]
       [gator void]))

(define spelare2
  (new spelare%
       [namn "spelare2"]
       [gator void]))

(define spelare3
  (new spelare%
       [namn "spelare3"]
       [gator void]))

(define spelare4
  (new spelare%
       [namn "spelare4"]
       [gator void]))

        
;...:::Tärning:::...;


(define (random-from-to from to)
  (+ from (random (- (+ to 1) from))))

(define (tärning)
  (random-from-to 1 6))


;...:::Spelplan:::...;

(define world%
  (class object%
    (super-new)
    (field (players '()))
    (define/public (get-players) players)
    (define/public (next-turn-2p)
      (set! players (mcons (mcdr players) (mcar players))))
    (define/public (start-game)
      (display "Hej, hur många spelare är ni?\n")
      (cond
        ((eq? (read) 2)
         (set! players (mcons (send spelare1 get-spelare-namn) (send spelare2 get-spelare-namn))))
        ((eq? (read) 3)
         (set! players (mcons (send spelare1 get-spelare-namn) (mcons (send spelare2 get-spelare-namn) (send spelare3 get-spelare-namn)))))
        ((eq? (read) 4)
         (set! players (mcons (send spelare1 get-spelare-namn) (mcons (send spelare2 get-spelare-namn) (mcons (send spelare3 get-spelare-namn) (send spelare4 get-spelare-namn))))))
        (else
         (display "error:") (display (read)) (display " är inte OK antal spelare"))))))

(define world1
  (new world%))
         
;...:::Turordning och aktuell spelare:::...;



;...:::Tangentbordsfunktion och speltillstånd:::...;

(define game-canvas%
  (class canvas%
    (inherit get-width
             get-height
             refresh)
    (init [keyboard-handler display])
    (define on-key-handle keyboard-handler)
    (define/override (on-char ke)
      (on-key-handle ke))
    (super-new)))


(define gamestate 'titelskärm)

;(define tangent



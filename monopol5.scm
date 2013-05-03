;----Monopol----

(require (lib "trace.ss"))

;...:::Gata:::...;
;Att göra:
;Ge gator koordinater, (field <koordinater> <position/index>)

(define gata%
  (class object%
    (super-new)
    (field (ägare false)
           (spelare false)) ;Tanken är att gatan ska veta vilken spelare som står på den. Vet inte hur dock.
    (init-field gatunamn färg pris hyra)
    (define/public (get-gata-namn) gatunamn) 
    (define/public (get-gata-färg) färg)
    (define/public (get-gata-pris) pris)
    (define/public (get-gata-hyra) hyra)
    (define/public (get-gata-ägare) ägare)
    (define/public (on-landing)
      (cond
        ((eq? ägare false)
         (display "Vill du köpa gatan?\n")
         (if (eq? (read) 'ja) ; Ska ändra till knapptryckning med 2 alternativ.
             (begin
               (set! ägare (send world1 current-player))
               (send ägare köp-gata)
               (display "Gatan köpt!")
               (send world1 next-turn-2p))
             (begin
               (display "Gatan ej köpt...")
               (send world1 next-turn-2p))))
        ((eq? ägare (send world1 current-player))
         (begin
           (display "Du står på din egen gata")
           (send world1 next-turn-2p)))
        (else
         (begin
           (display "Du äger inte denna gata")
           (send (send world1 current-player) betala-hyra)
           (send ägare inkassera-hyra)
           (send world1 next-turn-2p)))))))

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
;Att göra:
;Måste veta vilken gata spelaren står på (borde lösa sig med
;positioner och grafik... men ändå, vill fixa detta innan) 
;för att kunna set! spelarnas pengar vid gatuköp och hyra.
;Förbättra (aktuell-gata)


(define spelare%
  (class object%
    (super-new)
    (field (pengar 8500)
           (gata false)) ;Samma sak som i gatuklassen, vill att spelaren ska veta vilken gata denne står på.
    (init-field namn gator) ;onödig?
    (define/public (get-spelare-namn) namn)
    (define/public (get-pengar) pengar)
    (define/public (get-gator) gator) ;onödig?
    (define/public (aktuell-gata) gata1) ;Tillfälligt i testsyfte
    (define/public (köp-gata)
      (set! pengar (- pengar (send (aktuell-gata) get-gata-pris))))
    (define/public (betala-hyra)
      (set! pengar (- pengar (send (aktuell-gata) get-gata-hyra))))
    (define/public (inkassera-hyra)
      (set! pengar (+ pengar (send (aktuell-gata) get-gata-hyra))))))



(define spelare1
  (new spelare%
       [namn "spelare1"]
       [gator void])) ;Gator funkar inte så...

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

;Att göra:
;(read) ska bytas mot knapptryckningar, får implementera detta senare/samtidigt som grafiken.

(define world%
  (class object%
    (super-new)
    (field (players '()))
    (define/public (get-players) players)
    (define/public (current-player) (mcar players))
    (define/public (next-turn-2p)
      (set! players (mcons (mcdr players) (mcar players)))) ;Kastar om ordningen på listan av spelare (2p)
    (define/public (start-game)
      (display "Hej, hur många spelare är ni?\n") ;(read) är tillfälligt
      (cond
        ((eq? (read) 2)
         (set! players (mcons spelare1 spelare2))) ;OBS, du kan bara spela som 2 spelare.
        ((eq? (read) 3)
         (set! players (mcons spelare1 (mcons spelare2 spelare3)))) ;Ej en generell lösning, define (next-turn-3p) osv.
        ((eq? (read) 4)
         (set! players (mcons spelare1 (mcons spelare2 (mcons spelare3 spelare4)))))
        (else
         (display "error:") (display (read)) (display " är inte OK antal spelare")))))) 

(define world1
  (new world%))
         


;...:::Tangentbordsfunktion och speltillstånd:::...;
;Inte aktuellt ännu

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

;Det som går att göra just nu:
;(send world1 start-game), skriv 2.
;(send gata1 on-landing), skriv "ja" för att köpa, vadsomhelst för att inte köpa. Efter detta är din tur över.
;(send gata1 on-landing), Spelare2s tur nu, han kommer få betala hyra.

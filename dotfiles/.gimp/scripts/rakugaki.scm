; Rakugaki.scm Ver1.0  Etigoya
;                 Ver1.0    
;                                                                   
;                                                                               
;                                                                   "

(define (script-fu-rakugaki image drawable randpoint brush)

(let* ((old-brush (car (gimp-context-get-brush)))
       (old-fg (car (gimp-context-get-foreground)))
       (width (car (gimp-drawable-width drawable)))
       (height (car (gimp-drawable-height drawable)))
       (point 4)
       (count 1)
       (random-color)
       (segment)
       (r 0)(g 0)(b 0)
       (xa 0)(ya 0))
       

   (gimp-image-undo-group-start image)
   (gimp-context-set-brush (car brush))
		
   (while (<= count randpoint)
      (set! r (rand 255))
      (set! g (rand 255))
      (set! b (rand 255))
      (set! random-color (list r g b))
      (gimp-context-set-foreground random-color)

      (set! segment (cons-array 4 'double))
      (set! xa (rand width))
      (set! ya (rand height))
      (aset segment 0 (* 1 xa))
      (aset segment 1 (* 1 ya))
      (aset segment 2 (* 1 xa))
      (aset segment 3 (* 1 ya))
      (gimp-paintbrush-default drawable point segment)
      (set! count (+ count 1)) )

   (gimp-context-set-foreground old-fg)
   (gimp-context-set-brush old-brush)	
   (gimp-image-undo-group-end image)
   (gimp-displays-flush) ))

(script-fu-register "script-fu-rakugaki"
_"Rakugaki..."
"                                                            "
                    "         "
                    "         "
                    "2005/03/11"
                    "RGB* GRAY*"
                    SF-IMAGE      "Image"       0
                    SF-DRAWABLE   "Drawable"    0
                    SF-ADJUSTMENT "                      "  '(30 1 1000 1 10 0 1)
                    SF-BRUSH      "Brush"            '("Galaxy, Big" 1.0 20 0) )

(script-fu-menu-register "script-fu-rakugaki"
_"<Image>/Script-Fu/Alchemy")

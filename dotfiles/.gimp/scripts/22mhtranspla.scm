;;mhtranspla
;Kiki

(define (script-fu-mhtranspla text size font cc borc beb bor shbr shof hue ft)
  (let* ((img (car (gimp-image-new 256 256 RGB)))

;;    
	 (text-layer (car (gimp-text-fontname img -1 0 0 text 10 TRUE size PIXELS font)))

         (old-fg (car (gimp-palette-get-foreground)))
)
    (gimp-image-undo-disable img)

    (script-fu-mhtransplaimg img text-layer cc borc beb bor shbr shof hue ft)

    (gimp-palette-set-foreground old-fg)

    (gimp-image-undo-enable img)
    (gimp-display-new img)
))

(script-fu-register "script-fu-mhtranspla"
		    "<Toolbox>/Xtns/Script-Fu/MH/transplastic"
		    "mhtranspla"
		    "Kiki"
		    "Giants"
		    "2005/4"
		    ""
		    SF-STRING     "Text String"        "Transparent"
		    SF-ADJUSTMENT "Font Size (pixels)" '(120 2 1000 1 10 0 1)
		    SF-FONT       "Font"               "Action Is JL"
		    SF-COLOR      "Color"              '(140 140 140)
		    SF-COLOR      "Border Color"       '(0 0 0)
		    SF-ADJUSTMENT   "bevel"	    '(5 1 15 1 2 0 0)
		    SF-ADJUSTMENT   "border"	    '(7 1 100 1 2 0 0)
		    SF-ADJUSTMENT   "shadow blur"   '(12 1 50 1 2 0 0)
		    SF-ADJUSTMENT   "shadow offset" '(12 -50 50 1 2 0 0)
		    SF-ADJUSTMENT   "hue"	    '(0 -180 180 1 2 0 0)
                    SF-TOGGLE       "Flatten Image"  TRUE
)




(define (script-fu-mhtransplaimg img drawable cc borc beb bor shbr shof hue ft)
  (let* (

;;        
	 (width (car (gimp-drawable-width drawable)))
	 (height (car (gimp-drawable-height drawable)))

     (width (+ width (* bor 2)))
     (height (+ height (* bor 2)))
     (huet (+ hue 150))

;; w i
	 (bg-layer (car (gimp-layer-new img width height RGB-IMAGE "Background" 100 NORMAL-MODE)))
	 (g-layer (car (gimp-layer-new img width height RGBA-IMAGE "Gray" 100 NORMAL-MODE)))
	 (w-layer (car (gimp-layer-new img width height RGBA-IMAGE "White" 100 NORMAL-MODE)))
	 (br-layer (car (gimp-layer-new img width height RGBA-IMAGE "Brown" 100 NORMAL-MODE)))

     (old-fg (car (gimp-palette-get-foreground)))
     (l4)
	)
	
    (gimp-image-undo-group-start img)

    (if (> huet 181) (set! huet (- huet 360)))

;; T C Y    
    (gimp-image-resize img width height bor bor)
    (gimp-layer-resize drawable width height bor bor)

    (gimp-image-add-layer img bg-layer 1)
    (gimp-palette-set-foreground borc)
    (gimp-edit-fill bg-layer FOREGROUND-FILL)
    (gimp-image-add-layer img g-layer 1)
    (gimp-selection-all img)
    (gimp-selection-shrink img bor)
    (gimp-palette-set-foreground cc)
    (gimp-edit-fill g-layer FOREGROUND-FILL)
    (gimp-selection-invert img)
    (gimp-edit-clear g-layer)
    (gimp-selection-none img)
    (gimp-image-add-layer img w-layer 1)
    (gimp-image-add-layer img br-layer 1)
    (gimp-selection-all img)
    (gimp-edit-clear w-layer)
    (gimp-edit-clear br-layer)
    (gimp-selection-layer-alpha drawable)
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-edit-fill w-layer FOREGROUND-FILL)
    (gimp-image-remove-layer img drawable)

    (gimp-palette-set-foreground '(132 106 79))
    (gimp-edit-fill br-layer FOREGROUND-FILL)
    (gimp-selection-none img)
    (plug-in-gauss-iir2 1 img w-layer beb beb)
    (plug-in-bump-map 1 img br-layer w-layer 135 45 beb 0 0 0 0 FALSE FALSE 0)
    (gimp-selection-layer-alpha br-layer)
    (gimp-selection-shrink img 3)
    (define (splineValue)
      (let* ((a (make-vector 4 0)))
      	(vector-set! a 0 0)
		(vector-set! a 1 0)
		(vector-set! a 2 255)
		(vector-set! a 3 63)
        a
      )
    )
    (gimp-curves-spline br-layer HISTOGRAM-ALPHA 4 (splineValue))
    (gimp-image-remove-layer img w-layer)

    (set! l4 (car (gimp-layer-copy br-layer 0)))
    (gimp-image-add-layer img l4 0)
    (gimp-edit-clear br-layer)
    (gimp-selection-none img)
    (gimp-invert l4)

    (plug-in-gauss-iir2 1 img br-layer shbr shbr)
    (gimp-layer-translate br-layer shof shof)
    (gimp-hue-saturation l4 0 huet 0 0)
    (gimp-hue-saturation br-layer 0 hue 0 0)

    (if (= ft TRUE) (gimp-image-merge-visible-layers img 0))

    (gimp-palette-set-foreground old-fg)

    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
))

(script-fu-register "script-fu-mhtransplaimg"
		    "<Image>/Script-Fu/MH/transplastic"
		    "mhtranspla"
		    "Kiki"
		    "Giants"
		    "2005/4"
		    "RGBA"
		    SF-IMAGE        "Image"    0
		    SF-DRAWABLE     "Drawable" 0
		    SF-COLOR        "Color"         '(140 140 140)
		    SF-COLOR        "Border Color"  '(0 0 0)
		    SF-ADJUSTMENT   "bevel"	    '(5 1 15 1 2 0 0)
		    SF-ADJUSTMENT   "border"	    '(7 1 100 1 2 0 0)
		    SF-ADJUSTMENT   "shadow blur"   '(12 1 50 1 2 0 0)
		    SF-ADJUSTMENT   "shadow offset" '(12 -50 50 1 2 0 0)
		    SF-ADJUSTMENT   "hue"	    '(0 -180 180 1 2 0 0)
                    SF-TOGGLE       "Flatten Image"  TRUE
)

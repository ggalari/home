(define (apply-strdflash-effect img logo-layer noisev bcolor npix scolor numframe)
	(let* (	(width (car (gimp-drawable-width logo-layer)))
	 		(height (car (gimp-drawable-height logo-layer)))
	 		(tmpLayer)
	 		(txtLayer)
	 		(newLayer)
	 		(nframe)
	 		(cnt)
	 	)

    	(gimp-context-push)

		(script-fu-util-image-resize-from-layer img logo-layer)
		(gimp-selection-layer-alpha logo-layer)
		(gimp-selection-grow img npix)
		(set! tmpLayer (car (gimp-layer-copy logo-layer FALSE)))
		(gimp-image-add-layer img tmpLayer 0)
		(gimp-context-set-foreground bcolor)
    	(gimp-edit-fill tmpLayer FOREGROUND-FILL)
    	(gimp-selection-layer-alpha logo-layer)
    	(set! txtLayer (car (gimp-image-merge-visible-layers img 0)))
    	
    	(gimp-context-set-foreground scolor)
    	(gimp-edit-fill txtLayer FOREGROUND-FILL)
    	
    	(set! nframe (- numframe 1))
		(set! cnt 0)
		(while (< cnt nframe)
    		(set! newLayer (car (gimp-layer-copy txtLayer FALSE)))
			(gimp-image-add-layer img newLayer 0)
    		;(plug-in-scatter-rgb 1 img newLayer 0 0 noisev noisev noisev 0)
    		(plug-in-scatter-hsv 1 img newLayer noisev 20 0 255)
		
			(set! cnt (+ cnt 1))
		)
		;(plug-in-scatter-rgb 1 img txtLayer 0 0 noisev noisev noisev 0)
		(plug-in-scatter-hsv 1 img txtLayer noisev 20 0 255)
     
    	(gimp-selection-none img)
    	(gimp-context-set-foreground '(255 255 255))

    	(gimp-context-pop)
	)
)

(define (script-fu-strdflash text size font noisev bcolor npix scolor numframe)
	(let* (
		(img (car (gimp-image-new 256 256 RGB)))
	 	(text-layer (car (gimp-text-fontname img -1 0 0 text 10 0 size PIXELS font)))
		 )

		(gimp-image-undo-disable img)
		(gimp-drawable-set-name text-layer "      ")
		
		(apply-strdflash-effect img text-layer noisev bcolor npix scolor numframe)
		
		(gimp-image-undo-enable img)
		(gimp-display-new img)
	)
)

(script-fu-register "script-fu-strdflash"
		    _"_       ..."
		    "                           "
		    "JamesH"
		    "JamesH"
		    "09/19/2006"
		    ""
		    SF-TEXT       _"Text"                "The Gimp                "
		    SF-ADJUSTMENT _"Font size (pixels)" '(52 12 1000 1 10 0 1)
		    SF-FONT       _"Font"               "Becker"
		    SF-ADJUSTMENT  "            "        '(4 1 8 1 2 0 1)
		    SF-COLOR      _"            "         '(252 0 252)
		    SF-ADJUSTMENT "            "          '(2 1 16 1 8 0 0)
		    SF-COLOR      _"      "         '(0 192 252)
			SF-ADJUSTMENT "         "            '(3 2 32 1 8 0 0))
			
(script-fu-menu-register "script-fu-strdflash"
			 _"<Toolbox>/Xtns/Script-Fu/Logos")

;; tiles2anim.scm -*-scheme-*-
;; Converts a tiled animation to a layered animation
;; A tiled animation is one where each frame of the animation
;; is tiled across the image horizontally.  For example,
;; a 48x48 30 frame animation would be an image with the
;; size 1440x48.  Frame 1 is at (0,0)-(47,47), 2 at (48,0)-(95,47)
;; and so on
;; 
;; Version 1.2
;;
;; Copyright (C) 2007 by Brian Vanderburg II
;; <brianvanderburg@users.sourceforge.net>
;; 
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Internal function to create the layered animation
(define (script-fu-tiles2anim img drw frameWidth frameHeight frameStart frameCount frameDirection)

  (let*
    (
      (theWidth)
      (theHeight)
      (theCols)
      (theRows)
      (theCol)
      (theRow)
      (theImage)
      (theLayer)
      (framePos)
      (tmpLayer)
    )
    
    ; get image information
    (set! theWidth (car (gimp-image-width img)))
    (set! theHeight (car (gimp-image-height img)))
    
    ; create new image and layer
    (set! theImage (car (gimp-image-new theWidth theHeight RGB)))
    (set! theLayer (car (gimp-layer-new theImage theWidth theHeight RGBA-IMAGE "TMP" 100 NORMAL-MODE)))
    
    (gimp-image-add-layer theImage theLayer 0)
    (gimp-drawable-fill theLayer TRANSPARENT-FILL)
    
    ; copy visible portion of image
    (gimp-selection-none img)
    
    (if (= (car (gimp-edit-copy-visible img)) TRUE)
      (begin
        (gimp-rect-select theImage 0 0 theWidth theHeight CHANNEL-OP-REPLACE 0 0)
        (gimp-floating-sel-anchor (car (gimp-edit-paste theLayer FALSE)))
      )
    )
    
    ; frame width
    (if (= frameWidth 0) (set! frameWidth theWidth) )
    
    ; frame height
    (if (= frameHeight 0) (set! frameHeight theHeight) )
    
    ; number of columns and rows
    (set! theCols (floor (/ theWidth frameWidth)) )
    (set! theRows (floor (/ theHeight frameHeight)) )
    
    ; number of frames
    (if (= frameCount 0)
      (begin
      	(set! frameCount (* theCols theRows))
      	(if (> frameCount (* theCols theRows)) (set! frameCount (* theCols theRows)))
      )
      (begin
      	(set! frameCount (+ frameCount frameStart))
      	(if (> frameCount (* theCols theRows)) (set! frameCount (* theCols theRows)))
      )
    )
    
    ; process frames
    (set! framePos 0)
    (set! theCol 0)
    (set! theRow 0)
    
    (if (= frameDirection 0)
      (begin
      	(set! theRow (/ frameStart theCols) )
      	(set! framePos (* theRow theCols) )
        (set! theCol (- frameStart framePos) )
      )
      (begin
      	(set! theCol (/ frameStart theRows) )
      	(set! framePos (* theCol theRows) )
        (set! theRow (- frameStart framePos) )
      )
    )
    (set! framePos frameStart)
    
    (while (< framePos frameCount)
    
      ; create new layer and add it to image
      (set! tmpLayer (car (gimp-layer-new theImage frameWidth frameHeight RGBA-IMAGE "Layer" 100 NORMAL-MODE)))
      (gimp-image-add-layer theImage tmpLayer -1)
      (gimp-drawable-fill tmpLayer TRANSPARENT-FILL)
      
      ; copy
      (gimp-rect-select theImage (* theCol frameWidth) (* theRow frameHeight) frameWidth frameHeight CHANNEL-OP-REPLACE 0 0)
      
      (if (= (car (gimp-edit-copy theLayer)) TRUE)
        (begin
          (gimp-rect-select theImage 0 0 frameWidth theHeight CHANNEL-OP-REPLACE 0 0)
          (gimp-floating-sel-anchor (car (gimp-edit-paste tmpLayer FALSE) ) )
        )
      )
      
      (gimp-selection-none theImage)
        
      ; next frame
      (set! framePos (+ framePos 1))
      
      ; direction (0 = left to right first, else top to bottom first)
      (if (= frameDirection 0)
        (begin
          (set! theCol (+ theCol 1) )
          (if (>= theCol theCols)
            (begin
              (set! theCol 0)
              (set! theRow (+ theRow 1) )
            )
          )
        )
        (begin
          (set! theRow (+ theRow 1) )
          (if (>= theRow theRows)
            (begin
              (set! theRow 0)
              (set! theCol (+ theCol 1) )
            )
          )
        )
      )
    )
    
    ; Remove old layer
    (gimp-image-remove-layer theImage theLayer)
    
    ; set correct image size
    (gimp-image-resize theImage frameWidth frameHeight 0 0)
    
    ; show image
    (gimp-display-new theImage)
  )
            
) ; script-fu-tile2anim


(script-fu-register "script-fu-tiles2anim"
                    _"_Tiles2Animation..."
                    _"Converts a tile of frames to a layered animation."
                    "Brian Vanderburg II <brianvanderburg@users.sourceforge.net>"
                    "Brian Vanderburg II"
                    "August 2007"
                    "RGB*, INDEXED*, GRAY*"
                    SF-IMAGE       "Image"            0
                    SF-DRAWABLE    "Layer (unused)"   0
                    SF-ADJUSTMENT _"            (0=            )"   '(48 0 20000 1 10 0 0)
                    SF-ADJUSTMENT _"            (0=            )"   '(48 0 20000 1 10 0 0)
                    SF-ADJUSTMENT _"            "   '(0 0 100000 1 10 0 0)
                    SF-ADJUSTMENT _"         (0 for Auto)"   '(0 0 2000000 1 10 0 0)
                    ;SF-ADJUSTMENT _"Frame Width (0 for Image Width)"   '(48 0 20000 1 10 0 0)
                    ;SF-ADJUSTMENT _"Frame Height (0 for Image Height)"   '(48 0 20000 1 10 0 0)
                    ;SF-ADJUSTMENT _"Frame Start"   '(0 0 100000 1 10 0 0)
                    ;SF-ADJUSTMENT _"Frame Count (0 for Auto)"   '(0 0 2000000 1 10 0 0)
                    SF-OPTION _"Direction" '(_"            " _"            ") )
                    
(script-fu-menu-register "script-fu-tiles2anim"
                         ; _"<Image>/Script-Fu/Animators")
                           _"<Image>/Filters/Animation")
                         
                                             

;
; Spriteflip
;
; Flip regions of an image horizontally or vertically. Useful for creating
; reversed spritesheets. The image should be flattened in a single layer
;
; Copyright 2021 David Farrell

; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (script-fu-spriteflip img frameW frameH transID)
  (if (and (> frameW 0) (> frameH 0))
    (let* ((imgWidth (car (gimp-image-width img)))
           (imgHeight (car (gimp-image-height img)))
           (baseLayer (car (gimp-image-get-active-layer img))))
      (gimp-image-undo-group-start img)
      (do ((frameY 0 (+ frameY frameH))) ((>= frameY imgHeight))
        (do ((frameX 0 (+ frameX frameW))) ((>= frameX imgWidth))
          (script-fu-spriteflip-flip frameX
                                     frameY
                                     frameW
                                     frameH
                                     baseLayer
                                     img transID)))
      (gimp-image-merge-visible-layers img CLIP-TO-IMAGE)
      (gimp-displays-flush)
      (gimp-image-undo-group-end img))
    (gimp-message "Frame Width and Height must be higher than 0")))

(define (script-fu-spriteflip-flip x y w h layer img flipID)
  (gimp-image-select-rectangle img CHANNEL-OP-REPLACE x y w h)
  (gimp-floating-sel-to-layer (car (gimp-selection-float layer 0 0)))
  (gimp-item-transform-flip-simple
    (car (gimp-image-get-active-layer img)) flipID TRUE 0))

(script-fu-register "script-fu-spriteflip"
  "Spriteflip"
  "Flips frames on a spritesheet."
  "David Farrell"
  "copyright 2021 David Farrell"
  "March 8, 2021"
  "*" ;all img types
  SF-IMAGE "Image"        -1 ;current image obj
  SF-VALUE "Frame Width"  ""
  SF-VALUE "Frame Height" ""
  SF-OPTION "Transformation" '("Horizontal Flip" "Vertical Flip")
)

(script-fu-menu-register "script-fu-spriteflip"
                         "<Image>/Tools/Transform Tools")

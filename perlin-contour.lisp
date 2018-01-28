(in-package :cl-user)
(defpackage :my-sketches.perlin-contour
  (:use :cl :sketch)
  (:export :mysketch))
(in-package :my-sketches.perlin-contour)

(defparameter +width+ 400)
(defparameter +height+ 400)

(defun noise-2d (x y)
  (black-tie:perlin-noise x y 0))

(defsketch mysketch
    ((title "perlin contour")
     (width +width+)
     (height +height+))
  (with-pen (make-pen :fill (rgb 0.23 0.2 0.3))
    (rect 0 0 +width+ +height+))
  (let ((noise-factor 0.023))
    (dotimes (x +width+)
      (dotimes (y +height+)
        (let* ((noise (* 100 (normalize (noise-2d (* x noise-factor) (* y noise-factor)) -1 1)))
               (alpha (if (zerop (mod (floor noise) 14))
                          1
                          0))
               (color (hsb 0.4 0.5 0.7 alpha)))
          (with-pen (make-pen :fill nil :stroke color)
            (point x y)))))))

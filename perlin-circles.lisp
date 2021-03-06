(in-package :cl-user)
(defpackage :my-sketches.perlin-circles
  (:use :cl :sketch)
  (:export :mysketch))
(in-package :my-sketches.perlin-circles)

(defparameter +width+ 800)
(defparameter +height+ 600)

(defun noise-2d (x y)
  (black-tie:perlin-noise x y 0))

(defsketch mysketch
    ((title "perlin circle")
     (width +width+)
     (height +height+))
  (with-pen (make-pen :fill (rgb 0.11 0 0.1))
    (rect 0 0 +width+ +height+))
  (let ((interval 17)
        (noise-factor 0.1))
    (dotimes (x (ceiling (/ +width+ interval)))
      (dotimes (y (ceiling (/ +height+ interval)))
        (with-pen (make-pen :fill nil :stroke (rgb 0.4 0.6 0.9))
          (circle (* x interval) (* y interval)
                  (+ (/ interval 4)
                     (* 10 (noise-2d (* x noise-factor) (* y noise-factor))))))))))

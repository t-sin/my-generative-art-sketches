(in-package :cl-user)
(defpackage :perlin-circle
  (:use :cl :sketch)
  (:export :perlin-circle))
(in-package :perlin-circle)

(defparameter +width+ 800)
(defparameter +height+ 600)

(defun noise-2d (x y)
  (noise:noise-2d (coerce x 'double-float)
                  (coerce y 'double-float)))

(defsketch perlin-circle ((title "perlin circle")
                          (width +width+)
                          (height +height+))
  (with-pen (make-pen :fill (rgb 0.11 0 0.1))
    (rect 0 0 +width+ +height+))
  (let ((interval 17)
        (noise-factor 0.05))
    (dotimes (x (ceiling (/ +width+ interval)))
      (dotimes (y (ceiling (/ +height+ interval)))
        (with-pen (make-pen :fill nil :stroke (rgb 0.4 0.6 0.9))
          (circle (* x interval) (* y interval)
                  (+ (/ interval 4)
                     (* 3 (noise-2d (* x noise-factor) (* y noise-factor))))))))))

(in-package :my-sketches)

(defparameter +width+ 800)
(defparameter +height+ 600)

(defun noise-2d (x y)
  (black-tie:perlin-noise x y 0))

(defsketch perlin-cloud ((title "perlin cloud")
                         (width +width+)
                         (height +height+))
  (with-pen (make-pen :fill (rgb 0.2 0.1 0))
    (rect 0 0 +width+ +height+))
  (let ((noise-factor 0.04))
    (dotimes (x +width+)
      (dotimes (y +height+)
        (let ((color (hsb 0.1 0.5 0.7
                          (normalize (noise-2d (* x noise-factor) (* y noise-factor)) -1 1))))
          (with-pen (make-pen :fill nil :stroke color)
            (point x y)))))))

(in-package :my-sketches)

(defparameter +width+ 800)
(defparameter +height+ 600)

(defun noise (x)
  (black-tie:perlin-noise (coerce x 'double-float) 0 0))

(defun points-on-circle (x y deg radius)
  (list (+ x (* (sin (radians deg)) radius))
        (+ y (* (cos (radians deg)) radius))))

(defun flower (x y r from)
  (loop
     :for deg :from from :upto (+ from 720) :by 0.713
     :do (let* ((radius (* r (normalize (noise (* deg 0.02)) -1 1)))
                (green (normalize (noise (* deg 0.1)) 0.2 0.4))
                (alpha (normalize (noise (* deg 0.03)) 0 0.4))
                (color (rgb 0.83 green 0.8 alpha))
                (x (+ x (* (noise (* deg 0.02)) 10)))
                (y (+ y (* (noise (* deg 0.042)) 10))))
           (with-pen (make-pen :fill nil :stroke color)
             (apply #'line `(,@(points-on-circle x y deg radius)
                             ,@(points-on-circle x y (+ deg 160) radius)))))))

(defsketch line-flowers ((title "line flowers")
                         (width +width+)
                         (height +height+))
  (with-pen (make-pen :fill (rgb 0.1 0.1 0.14))
    (rect 0 0 +width+ +height+)
    (flower (/ +width+ 2) (/ +height+ 2) 500 2.12)))

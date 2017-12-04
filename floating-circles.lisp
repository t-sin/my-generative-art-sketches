(in-package :cl-user)
(defpackage :my-sketches.floating-circles
  (:use :cl :sketch)
  (:export :floating-circles))
(in-package :my-sketches.floating-circles)

(defparameter +width+ 600)
(defparameter +height+ 400)

(defstruct pt x y vx vy h)

(defun draw-point (p)
  (let ((x (pt-x p))
        (y (pt-y p))
        (h (pt-h p)))
    (with-pen (make-pen :stroke nil :fill (hsb h 0.5 0.8 0.2))
      (circle x y (+ 20 (* 10 (black-tie:perlin-noise (* x 0.1) (* y 0.1) 0)))))
    (with-pen (make-pen :stroke nil :fill (hsb h 0.5 0.8 1))
      (circle x y 1))))

(defun move-point (p)
  (incf (pt-x p) (pt-vx p))
  (incf (pt-y p) (pt-vy p))
  (setf (pt-vx p) (* (pt-vx p) 0.9891)
        (pt-vy p) (* (pt-vy p) 0.9891)))

(let ((points (make-array 100)))
  (loop
     :for i :from 0 :below (length points)
     :do (setf (aref points i) (make-pt :x (random +width+)
                                        :y (random +height+)
                                        :vx (- (random 4.0) 2)
                                        :vy (- (random 4.0) 2)
                                        :h (random 1.0))))
  (defsketch floating-circles
      ((title "floating-circles")
       (width +width+)
       (height +height+))
    (with-pen (make-pen :fill (hsb 0.4 0.01 0.95))
      (rect 0 0 +width+ +height+))
    (loop
       :for p :across points
       :do (draw-point p)
       :do (move-point p))))

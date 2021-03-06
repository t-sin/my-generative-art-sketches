(in-package :cl-user)
(defpackage :my-sketches.floating-circles
  (:use :cl :sketch)
  (:export :mysketch))
(in-package :my-sketches.floating-circles)

(defparameter +width+ 800)
(defparameter +height+ 600)

(defstruct pt x y vx vy h cycle tick)

(defun draw-point (p)
  (let ((x (pt-x p))
        (y (pt-y p))
        (h (pt-h p)))
    (with-pen (make-pen :stroke nil :fill (hsb h 0.5 0.9 0.4))
      (circle x y (+ 20 (* 10 (black-tie:perlin-noise (* x 0.1) (* y 0.1) 0)))))
    (with-pen (make-pen :stroke nil :fill (hsb h 0.5 0.8 1))
      (circle x y 1))))

(defun random-velocity ()
  (- (random 4.0) 2))

(defun to-center-velocity (pos len)
  (if (or (< pos 0) (> pos len))
      (/ (- (/ len 2) pos) len)
      0))

(defun move-point (p)
  (setf (pt-vx p) (* (pt-vx p) 0.9911)
        (pt-vy p) (* (pt-vy p) 0.9911))
  (incf (pt-x p) (pt-vx p))
  (incf (pt-y p) (pt-vy p))
  (when (zerop (mod (pt-tick p) (pt-cycle p)))
    (setf (pt-vx p) (+ (random-velocity) (to-center-velocity (pt-x p) +width+))
          (pt-vy p) (+ (random-velocity) (to-center-velocity (pt-y p) +height+))
          tick 0))
  (incf (pt-tick p)))

(let ((points (make-array 100)))
  (loop
     :for i :from 0 :below (length points)
     :do (setf (aref points i) (make-pt :x (random +width+)
                                        :y (random +height+)
                                        :vx (random-velocity)
                                        :vy (random-velocity)
                                        :h (random 1.0)
                                        :tick 0
                                        :cycle (+ 100 (random 150)))))
  (defsketch mysketch
      ((title "floating-circles")
       (width +width+)
       (height +height+))
    (with-pen (make-pen :fill (hsb 0.4 0.01 0.95))
      (rect 0 0 +width+ +height+))
    (loop
       :for p :across points
       :do (draw-point p)
       :do (move-point p))))

(in-package :cl-user)
(defpackage :my-sketches.corridor
  (:use :cl :sketch)
  (:export :mysketch))
(in-package :my-sketches.corridor)

(defparameter +width+ 800)
(defparameter +height+ 600)

(defun my-random (n &optional (rs *random-state*))
  (* (random n rs) (random n rs) (random n rs)))

(defun descrete (n interval)
  (* (ceiling (/ n interval)) interval))

(defsketch mysketch
    ((title "corridor")
     (width +width+)
     (height +height+))
  (let ((rs (make-random-state)))
    (with-pen (make-pen :fill (hsb 0.2 0.5 0.07))
      (rect 0 0 +width+ +height+))
    (with-pen (make-pen :stroke (hsb 0 0 0.8 0.04)
                        :fill nil)
      (loop
         :for n :from 0 :upto 1000
         :for nf := (float (* n 0.01))
         :for rand := (my-random 1.0 rs)
         :for x := (* rand +width+)
         :for y := (* rand +height+)
         :do (polyline x y
                       x (- +height+ y)
                       (- +width+ x) (- +height+ y)
                       (- +width+ x) y
                       x y)))))

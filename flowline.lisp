(in-package :cl-user)
(defpackage :my-sketches.flowline
  (:use :cl :sketch)
  (:export :mysketch))
(in-package :my-sketches.flowline)

(defparameter +width+ 800)
(defparameter +height+ 600)

(defun noise (x)
  (black-tie:perlin-noise x 0 0))

(defun yvalue (sx sy ex ey x)
  (let ((delta (/ (- ey sy) (- ex sx)))
        (y0 (/ (- (* sx ey) (* sy ex)) (- sx ex))))
    (+ (* x delta) y0)))
  

(defun make-control-points (sx sy ex ey)
  (let* ((xlis (let (nums)
                 (dotimes (n 2)
                   (setf nums (cons (- (random (- ex sx)) sx) nums)))
                 (append (list sx)
                         (sort nums #'<)
                         (list ex))))
         (ylis (loop
                  :for x :in xlis
                  :for n := 0 :then (incf n 2)
                  :collect (+ (yvalue sx sy ex ey x) (* n (- (random 150) 75))))))
    (loop
       :for x :in xlis
       :for y :in ylis
       :nconc (list x y))))

(let* ((sx (* +width+ -0.2))
       (sy (* +height+ 0.9))
       (ex (* +width+ 1.2))
       (ey (* +height+ 0.6))
       (rs (make-random-state)))
  (defsketch mysketch
      ((title "flowline")
       (width +width+)
       (height +height+)
       (copy-pixels t))
    (with-pen (make-pen :fill (hsb 0.6 0.9 0.15))
      (rect 0 0 +width+ +height+))
    (with-pen (make-pen :fill nil :stroke (hsb 0.7 0.4 0.8))
      (line sx sy ex ey))
    (with-pen (make-pen :fill nil :stroke (hsb 0.374 0.4 0.8 0.04))
      (let ((*random-state* (make-random-state rs)))
        (loop
           :for n :from 0 :upto 1000
           :do (apply #'bezier (make-control-points sx sy ex ey)))))))

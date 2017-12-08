(in-package :cl-user)
(defpackage :my-sketches.fire
  (:use :cl :sketch)
  (:export :mysketch))
(in-package :my-sketches.fire)

(defparameter +width+ 1000)
(defparameter +height+ 700)

(defparameter tick 0)
(defparameter particle-size 8)
(defparameter particle-life 150)

(defstruct particle x y vx vy start-tick)

(defparameter *particles* (make-array 1000 :initial-element nil))

(defun shot ()
  (let ((pos (position nil *particles*)))
    (when pos
      (setf (aref *particles* pos)
            (make-particle :x (/ +width+ 2)
                           :y (/ +height+ 1.2)
                           :vx (- (random 4.0) 2)
                           :vy (- (random 4.0) 2)
                           :start-tick tick)))))

(defun draw-particles ()
  (loop
     :for p :across *particles*
     :when (not (null p))
     :do (let ((alpha (- 1.0 (easing:in-out-sine (/ (- tick (particle-start-tick p))
                                                    particle-life)))))
           (with-pen (make-pen :fill (hsb 0.06 0.91 0.8 alpha)
                               :stroke (hsb 0.05 0.9 1 alpha))
             (circle (particle-x p) (particle-y p) particle-size)))))

(defun update-particles ()
  (loop
     :for idx :from 0 :below (length *particles*)
     :for p := (aref *particles* idx)
     :when (not (null p))
     :do (progn (setf (particle-x p) (+ (particle-x p) (particle-vx p))
                      (particle-y p) (+ (particle-y p) (particle-vy p)
                                        (* -0.04 (- tick (particle-start-tick p)))))
                (when (or (< (particle-x p) (- particle-size))
                          (> (particle-x p) (+ +width+ particle-size)))
                  (setf (aref *particles* idx) nil))
                (when (or (< (particle-y p) (- particle-size))
                          (> (particle-y p) (+ +height+ particle-size)))
                  (setf (aref *particles* idx) nil))
                (when (> (- tick (particle-start-tick p)) particle-life)
                  (setf (aref *particles* idx) nil)))))

(defsketch mysketch
    ((title "fire")
     (width +width+)
     (height +height+))
  (with-pen (make-pen :fill (hsb 0.05 0.9 0.1))
    (rect 0 0 +width+ +height+))
  (with-pen (make-pen :stroke nil :fill (hsb 0.05 0.6 0.7 0.4))
    (circle (/ +width+ 2) (/ +height+ 1.2) 10))
  (when (zerop (mod tick 0))
    (shot))
  (draw-particles)
  (update-particles)
  (incf tick))

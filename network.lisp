(in-package :cl-user)
(defpackage :my-sketches.network
  (:use :cl :sketch)
  (:export :mysketch))
(in-package :my-sketches.network)

(defparameter +width+ 1200)
(defparameter +height+ 900)

(defun randomv (n)
  (- (random (float n)) (float (/ n 2))))

(defun to-centerv (pos len)
  (if (or (< pos -100) (> pos (+ 100 len)))
      (/ (- (/ len 2) pos) len)
      0))

(defstruct object x y attrs)
(defparameter *objects* (make-array 100))

(defun init-objects (attrs-fn)
  (loop
     :for n :from 0 :below (length *objects*)
     :do (setf (aref *objects* n)
               (make-object :x (random +width+)
                            :y (random +height+)
                            :attrs (funcall attrs-fn)))
       :finally (return *objects*)))

(defun draw-object (p)
  (with-pen (make-pen :stroke (hsb 0 0 0.5 0.4)
                      :fill (hsb 0 0 0.5 0.2))
    (circle (object-x p) (object-y p) 20)))

(defun update-object (p)
  (let ((x (object-x p))
        (y (object-y p))
        (vx (getf (object-attrs p) :vx))
        (vy (getf (object-attrs p) :vy))
        (ax (getf (object-attrs p) :ax))
        (ay (getf (object-attrs p) :ay))
        (tick (getf (object-attrs p) :tick))
        (period (getf (object-attrs p) :period)))
    (setf (object-x p) (+ x vx)
          (object-y p) (+ y vy))
    (setf (getf (object-attrs p) :vx) (+ (* vx 0.991)
                                         (to-centerv x +width+)
                                         ax)
          (getf (object-attrs p) :vy) (+ (* vy 0.991)
                                         (to-centerv y +height+)
                                         ay))
    (when (>= tick (/ period 3))
      (setf (getf (object-attrs p) :ax) 0
            (getf (object-attrs p) :ay) 0))
    (when (>= tick period)
      (setf (getf (object-attrs p) :ax) (randomv 0.05)
            (getf (object-attrs p) :ay) (randomv 0.05)
            (getf (object-attrs p) :tick) 0))
    (incf (getf (object-attrs p) :tick))))      

(defun distance (o1 o2)
  (sqrt (+ (expt (- (object-x o1) (object-x o2)) 2)
           (expt (- (object-y o1) (object-y o2)) 2))))

(defun inter-object-lines (o objects)
  (loop
     :for o% :across objects
     :for d := (distance o o%)
     :when (< d 150)
     :do (with-pen (make-pen :stroke (hsb 0 0 1 (/ (- 150 d) 150))
                             :fill nil)
           (line (object-x o) (object-y o)
                 (object-x o%) (object-y o%)))))

(defun process-objects (ps)
  (loop
     :for p :across ps
     :do (progn
           (draw-object p)
           (draw-inter-object-lines p ps)
           (update-object p))))

(let* ((*random-state* *random-state*)
       (objects (init-objects (lambda ()
                                (list :vx (randomv 1.0)
                                      :vy (randomv 1.0)
                                      :ax (randomv 0.3)
                                      :ay (randomv 0.3)
                                      :period (+ (random 300) 100)
                                      :tick 0)))))
  (defsketch mysketch
      ((title "network")
       (width +width+)
       (height +height+))
    (with-pen (make-pen :stroke nil
                        :fill (hsb 0 0 0))
      (rect 0 0 +width+ +height+))
    (process-objects objects)))

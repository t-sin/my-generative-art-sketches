(in-package :cl-user)
(defpackage :my-sketches.bubbles
  (:use :cl :sketch)
  (:export :mysketch))
(in-package :my-sketches.bubbles)

(defparameter +width+ 1000)
(defparameter +height+ 700)

(defun random% ()
  (- (random 0.04) 0.02))

(defstruct cell x y vx vy ax ay tick period)

(defparameter *cells*
  (let ((cells (make-array 30)))
    (dotimes (n (length cells) cells)
      (setf (aref cells n)
            (make-cell :x (random +width+)
                       :y (random +height+)
                       :vx 0
                       :vy 0
                       :ax (random%)
                       :ay (random%)
                       :tick 0
                       :period (+ 150 (random 100)))))))

(defun to-center (pos len)
  (if (or (< pos 0) (> pos len))
      (/ (- (/ len 2) pos) len)
      0))

(defun draw-cell (c)
  (with-pen (make-pen :fill (hsb 0.2 0.2 0.3 0.2) :stroke (hsb 0 0 1 0.2))
    (circle (cell-x c) (cell-y c) 100)))

(defun update-cell (c)
  (let ((x (cell-x c))
        (y (cell-y c))
        (vx (cell-vx c))
        (vy (cell-vy c))
        (tick (cell-tick c))
        (period (cell-period c)))
    (setf (cell-x c) (+ x vx)
          (cell-y c) (+ y vy)
          (cell-vx c) (+ (* vx 0.991) (to-center x +width+) (cell-ax c))
          (cell-vy c) (+ (* vy 0.991) (to-center y +height+) (cell-ay c)))
    (when (>= tick (/ period 3))
      (setf (cell-ax c) 0
            (cell-ay c) 0))
    (when (>= tick period)
      (setf (cell-ax c) (random%)
            (cell-ay c) (random%)
            (cell-tick c) 0))
    (incf (cell-tick c))))
        

(defsketch mysketch
    ((title "bubbles")
     (width +width+)
     (height +height+))
  (with-pen (make-pen :fill (hsb 0.74 0.8 0.1))
    (rect 0 0 +width+ +height+))
  (loop
     :for c :across *cells*
     :do (draw-cell c)
     :do (update-cell c)))

(in-package :cl-user)
(defpackage :my-sketches.wall
  (:use :cl :sketch)
  (:export :mysketch))
(in-package :my-sketches.wall)

(defparameter +width+ 1000)
(defparameter +height+ 700)

(defun random-vel ()
  (- (random 5.0) 2.5))

(defstruct cell x y vx vy h tick period)

(defparameter *cells*
  (let ((cells (make-array 1)))
    (dotimes (n (length cells) cells)
      (setf (aref cells n)
            (make-cell :x (random +width+)
                       :y (random +height+)
                       :vx (random-vel)
                       :vy (random-vel)
                       :h (* n (/ +height+ (length cells)))
                       :tick 0
                       :period (+ 150 (random 100)))))))

(defun to-center (pos len)
  (if (or (< pos 0) (> pos len))
      (/ (- (/ len 2) pos) len)
      0))

(defun draw-cell (c)
  (with-pen (make-pen :fill (hsb 0.2 0.2 0.3 0.2) :stroke (hsb 0 0 1 0.3))
    (let ((n 50))
      (loop
         :for i :from 0 :upto n
         :do (line 0 (* i (/ +height+ n)) (cell-x c) (+ (* i 5) (cell-y c)))
         :do (line (cell-x c) (+ (* i 5) (cell-y c)) +width+ (* i (/ +height+ n)))))))
       

(defun update-cell (c)
  (let ((x (cell-x c))
        (y (cell-y c))
        (vx (cell-vx c))
        (vy (cell-vy c))
        (tick (cell-tick c))
        (period (cell-period c)))
    (setf (cell-x c) (+ x (* vx (/ tick period)))
          (cell-y c) (+ y (* vy (/ tick period))))
    (when (>= tick period)
      (setf (cell-vx c) (+ (random-vel) (to-center x +width+))
            (cell-vy c) (+ (random-vel) (to-center y +height+))
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

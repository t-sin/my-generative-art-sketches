(in-package :cl-user)
(defpackage :my-sketches.polyline
  (:use :cl :sketch)
  (:export :mysketch))
(in-package :my-sketches.polyline)

(defparameter +width+ 600)
(defparameter +height+ 400)
(defparameter *tick* 0)

(defun linearfn (sx sy ex ey x)
  (if (= sx ex)
      nil
      (let ((delta (/ (- ey sy) (- ex sx)))
            (y0 (/ (- (* sx ey) (* sy ex)) (- sx ex))))
        (+ (* x delta) y0))))

(defun to-center (pos len)
  (if (or (< pos 0) (> pos len))
      (/ (- (/ len 2) pos) len)
      0))

(defstruct line x1 y1 x2 y2)
(defstruct polyline lines)

(defun make-polyline% (&rest plis)
  (if (evenp (length plis))
      (let ((lines))
        (loop :named loop
           :for prev-x := nil :then x
           :for prev-y := nil :then y
           :for (x y) :on plis :by #'cddr
           :unless (null prev-x)
           :do (push (make-line :x1 prev-x :y1 prev-y :x2 x :y2 y) lines)
           :finally (return-from loop (make-polyline :lines (coerce (nreverse lines) 'vector)))))
      (error "invalid points")))

(defun draw-polyline (pl)
  (apply #'polyline
         (loop
            :for line :across (polyline-lines pl)
            :for first-p := t :then nil
            :if first-p
            :nconc (list (line-x1 line) (line-y1 line) (line-x2 line) (line-y2 line))
            :else
            :nconc (list (line-x2 line) (line-y2 line)))))

(defstruct point x y vx vy ax ay)
(defparameter *points*
  (let ((array (make-array 4)))
    (loop
       :for n :from 0 :below (length array)
       :do (setf (aref array n)
                 (make-point :x (random +width+)
                             :y (random +height+)
                             :vx (random 0.5)
                             :vy (random 0.5)
                             :ax (random 0.03)
                             :ay (random 0.03)))
       :finally (return array))))

(defun draw-point (p)
  (with-pen (make-pen :stroke (hsb 0.6 0.4 0.4 0.2)
                      :fill (hsb 0.6 0.4 0.8 0.03))
    (circle (point-x p) (point-y p) 69)))

(defun update-point (p tick)
  (setf (point-x p) (+ (point-x p) (point-vx p))
        (point-y p) (+ (point-y p) (point-vy p)))
  (setf (point-vx p) (+ (* (point-vx p) 0.991)
                        (* 0.5 (to-center (point-x p) +width+))
                        (point-ay p))
        (point-vy p) (+ (* (point-vy p) 0.996)
                        (* 0.5 (to-center (point-y p) +height+))
                        (point-ay p)))
  (when (>= tick 200)
    (setf (point-ax p) 0
          (point-ay p) 0))
  (flet ((random-acc ()
           (- (random 0.2) 0.1)))
    (when (>= tick 400)
      (setf (point-ax p) (random-acc)
            (point-ay p) (random-acc)))))

(defun process-points ()
  (loop
     :for p :across *points*
     :do (draw-point p)
     :do (update-point p *tick*)))

(defun draw-floating-polyline (plis)
  (apply #'polyline
         (loop
            :for p :across plis
            :nconc (list (point-x p) (point-y p)))))

(defstruct particle x y vx vy sx sy tx ty h)
(defparameter *particles*
  (let ((array (make-array 600)))
    (loop
       :for n :from 0 :below (length array)
       :do (setf (aref array n)
                 (make-particle :x (random +width+)
                                :y (random +height+)
                                :vx (- (random 0.2) 0.1)
                                :vy (- (random 0.2) 0.1)
                                :sx nil
                                :sy nil
                                :tx nil
                                :ty nil
                                :h (random 1.0)))
       :finally (return array))))

(defun draw-particle (p)
  (with-pen (make-pen :fill (hsb (particle-h p) 0.6 0.8 0.4)
                      :stroke nil)
    (circle (particle-x p) (particle-y p) 3)))
;; (defun draw-particle (p)
;;   (loop
;;      :for n :from 0.1 :below 0.5 :by 0.1
;;      :do (with-pen (make-pen :fill (hsb (particle-h p) 0.6 0.7 0.1)
;;                              :stroke nil)
;;            (circle (particle-x p) (particle-y p) (* (- 0.5 n) 20)))))

(let ((moving nil)
      (duration 70)
      (start-tick nil))
  (defun update-particle (p tick)
    (setf (particle-x p) (+ (particle-x p) (particle-vx p))
          (particle-y p) (+ (particle-y p) (particle-vy p)))
    (if moving
        (let ((ratio (/ (- tick start-tick) duration)))
          (if (= ratio 1.0)
              (setf moving nil
                    start-tick nil
                    (particle-vx p) (- (random 2.0) 1)
                    (particle-vy p) (- (random 2.0) 1))
              (setf (particle-x p) (+ (particle-sx p)
                                      (* (easing:in-out-exp ratio)
                                         (- (particle-tx p) (particle-sx p))))
                    (particle-y p) (+ (particle-sy p)
                                      (* (easing:in-out-exp ratio)
                                         (- (particle-ty p) (particle-sy p)))))))
        (setf (particle-vx p) (* (particle-vx p) 1)
              (particle-vy p) (* (particle-vy p) 1))))

  (defun switch-to-move (polyline tick)
    (loop
       :for p :across *particles*
       :do (let* ((lines (polyline-lines polyline))
                  (line (aref lines (random (length lines))))
                  (dx (abs (- (line-x1 line) (line-x2 line))))
                  (tx (if (zerop dx)
                          (line-x1 line)
                          (+ (random dx)
                             (if (< (line-x1 line) (line-x2 line))
                                 (line-x1 line)
                                 (line-x2 line)))))
                  (dy (abs (- (line-y1 line) (line-y2 line))))
                  (ty (if (zerop dy)
                          (line-y1 line)
                          (or (linearfn (line-x1 line) (line-y1 line)
                                        (line-x2 line) (line-y2 line) tx)
                              (+ (random dy)
                                 (if (< (line-y1 line) (line-y2 line))
                                     (line-y1 line)
                                     (line-y2 line)))))))
                          
             (setf (particle-sx p) (particle-x p)
                   (particle-sy p) (particle-y p)
                   (particle-tx p) tx
                   (particle-ty p) ty)))
    (setf moving t
          start-tick tick)))

(defsketch mysketch
    ((title "polyline with particles")
     (width +width+)
     (height +height+))
  (with-pen (make-pen :stroke nil
                      :fill (hsb 0.4 0.05 0.9))
    (rect 0 0 +width+ +height+))
  (process-points)
  (loop
     :for p :across *particles*
     :do (draw-particle p)
     :do (update-particle p *tick*))
  (let ((points-pl (apply #'make-polyline%
                          (loop
                             :for p :across *points*
                             :nconc (list (point-x p) (point-y p))))))
    (with-pen (make-pen :stroke (hsb 0 0 0 0.4))
      (draw-polyline points-pl))
    (incf *tick*)))

(defmethod kit.sdl2:mousebutton-event ((window mysketch) state ts b x y)
  (format t "~a ~a ~a" state ts b)
  (when (eq state :mousebuttondown)
    (switch-to-move (apply #'make-polyline%
                           (loop
                              :for p :across *points*
                              :nconc (list (point-x p) (point-y p))))
                    *tick*)))

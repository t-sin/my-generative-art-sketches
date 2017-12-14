(in-package :cl-user)
(defpackage :my-sketches
  (:use :cl)
  (:export :list-sketches
           :run-sketch))
(in-package :my-sketches)

(defvar +package-prefix+ "MY-SKETCHES.")

(defun sketch-name (pkg)
  (let* ((pname (package-name pkg))
         (pos (search +package-prefix+ pname)))
    (subseq pname (+ pos (length +package-prefix+)))))

(defun sketch-pkg-name (name)
  (string-upcase (format nil "MY-SKETCHES.~a" name)))

(defun sketch-class (name)
  (find-class (intern "MYSKETCH" (sketch-pkg-name name))))

(defun list-sketches ()
  (loop
     :for pkg :in (list-all-packages)
     :for start := (search +package-prefix+ (package-name pkg))
     :when (not (null start))
     :collect (sketch-name (package-name pkg))))

(defun run-sketch (name)
  (make-instance (sketch-class name)))

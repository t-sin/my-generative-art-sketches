(in-package :cl-user)
(defpackage :my-sketches-asd
  (:use :cl :asdf))
(in-package :my-sketches-asd)

(defsystem :my-sketches
  :description "my generative art sketches."
  :author "Shinichi TANAKA"
  :depends-on ("sketch"
               "noise")
  :components ((:file "package")
               (:file "perlin-circle")
               (:file "line-flowers")))

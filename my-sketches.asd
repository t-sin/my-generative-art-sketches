(in-package :cl-user)
(defpackage :my-sketches-asd
  (:use :cl :asdf))
(in-package :my-sketches-asd)

(defsystem :my-sketches
  :description "my generative art sketches."
  :author "Shinichi TANAKA"
  :depends-on ("black-tie"
               "easing"
               "sketch")
  :components ((:file "my-sketches")
               (:file "perlin-circles")
               (:file "perlin-cloud")
               (:file "line-flower")
               (:file "floating-circles")
               (:file "flowline")
               (:file "bubbles")
               (:file "wall")
               (:file "fire")
               (:file "polyline")
               (:file "network")
               (:file "perlin-contour")))

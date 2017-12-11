# Generative art practices and sketches

## To run

1. install prequisites

```sh
$ sudo apt install -y libsdl2-ttf-2.0-0 libsdl2-image-2.0-0
```

2. install with [roswell](https://github.com/roswell/roswell), Common Lisp implementation manager

```sh
$ ros install t-sin/my-generative-art-sketches
```

3. load system

```lisp
CL-USER> (ql:quickload :my-sketches)
```

4. run as making instance

```lisp
CL-USER> (make-instance 'my-sketches.perlin-circle:mysketch)
```

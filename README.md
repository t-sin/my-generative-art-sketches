# Generative art practices and sketches

## To run

1. install with roswell

```sh
$ ros install t-sin/my-generative-art-sketches
```

2. load system

```lisp
CL-USER> (ql:quickload :my-sketches)
```

3. run as making instance

```lisp
CL-USER> (make-instance 'my-sketches:perlin-circle)
```

# Generative art practices and sketches

## To run

1. install dependencies

```sh
$ ros install sketch
$ ros install sebity/noise
```

2. load any lisp files

```lisp
CL-USER> (load "perlin-circle.lisp")
```

3. run as making instance

```lisp
CL-USER> (make-instance 'perlin-circle:perlin-circle)
```

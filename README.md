# Generative art practices and sketches

## samples

![sample01](https://raw.githubusercontent.com/t-sin/my-generative-art-sketches/master/sample/01.png)
![sample02](https://raw.githubusercontent.com/t-sin/my-generative-art-sketches/master/sample/02.png)
![sample03](https://raw.githubusercontent.com/t-sin/my-generative-art-sketches/master/sample/03.png)

## Installation

### Preparation

1. install prequisites

```sh
$ sudo apt install -y libsdl2-ttf-2.0-0 libsdl2-image-2.0-0
```

2. install with [roswell](https://github.com/roswell/roswell), Common Lisp implementation manager

```sh
$ ros install t-sin/my-generative-art-sketches
```

### Run with REPL

1. load system

```lisp
CL-USER> (ql:quickload :my-sketches)
```

2. list available sketches

```lisp
CL-USER> (my-sketches:list-sketches)
...
```

3. run sketch

```lisp
CL-USER> (my-sketches:run-sketch :network)
```

### Run with CLI

1. list available sketches

```sh
$ my-sketches list
...
```

2. run sketch

```sh
$ my-sketches run network
```

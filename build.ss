#!/usr/local/bin/gxi
;; -*- Gerbil -*-

(import :std/make)

(def static? (make-parameter #f))

;; the library module build specification
(def build-spec '("colorstring.ss" "colorstring-test.ss"))

;; the source directory anchor
(def srcdir
  (path-normalize (path-directory (this-source-file))))

;; the main function of the script
(def (main . args)

  (match args
     ;; this action builds the library modules -- with static compilation artifacts

    (["static"]
     (static? #t)
     (main))

    ;; this is the default action, builds libraries and executables
    ([]
     (make srcdir: srcdir
           bindir: srcdir
           optimize: #t
           debug: 'src             ; enable debugger introspection for library modules
           static: (static?)              ; generate static compilation artifacts; required!
           prefix: "colorstring"
           build-spec))))

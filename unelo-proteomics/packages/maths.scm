(define-module (unelo-proteomics maths)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages pkg-config)
  #:use-module ((guix licenses) #:prefix license:)
  )
;; see also `clp' and `cbc' in (gnu packages maths)

(define-public coin-mp
  (package
    (name "coin-mp")
    (version "1.8.4")
    (home-page "https://www.coin-org.org")
    (source (origin
	      (method url-fetch)
	      (sha256
               (base32
		"13d3j1sdcjzpijp4qks3n0zibk649ac3hhv88hkk8ffxrc6gnn9l"
		  ))
	      (uri
	       (string-append "https://www.coin-or.org/download/source/CoinMP/CoinMP-" version ".tgz"))))
    (build-system gnu-build-system)
    (native-inputs
     (list gfortran pkg-config))
    (inputs
     (list openblas))
    (synopsis "Collection of coin-org projects")
    (description synopsis)
    (description name)
    (license license:epl1.0)))

(define gsl-1.16
  (package
    (name "gsl")
    (version "1.16")
    (source
     (origin
       (method url-fetch)
       (uri
	(string-append "mirror://gnu/gsl/gsl-"
		       version ".tar.gz"))
       (sha256
	(base32                 "0lrgipi0z6559jqh82yx8n4xgnxkhzj46v96dl77hahdp58jzg3k"))))
    (build-system gnu-build-system)
    ;; With parallel testing fscan fails.
    (arguments
     '(#:parallel-tests? #f))
    (native-inputs
     (list pkg-config))
    (home-page "https://www.gnu.org/software/gsl/")
    (synopsis "Numerical library for C and C++")
    (description      "The GNU Scientific Library is a library for numerical analysis in C and C++.  It includes a wide range of mathematical routines, with over 1000 functions in total.  Subject areas covered by the library include: differential equations, linear algebra, Fast Fourier Transforms and random numbers.")
    (license license:gpl3+)))

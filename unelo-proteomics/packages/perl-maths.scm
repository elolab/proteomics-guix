(define-module (unelo-proteomics packages perl-maths)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system perl)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages statistics)
  #:use-module (gnu packages perl-check))


(define-public perl-statistics-regression
  (package
    (name "perl-statistics-regression")
    (version "0.15")
    (source (origin
              (method url-fetch)
              (uri "mirror://cpan/authors/id/I/IA/IAWELCH/Statistics-Regression-0.53.tar.gz")
              (sha256
             (base32
              "16mnp1d7mr5qq22v86afc6kbgb87a6hlnybsbpmxr96xjqwkxi9c"))))
    (build-system perl-build-system)
    (native-inputs (list perl-module-install))
    (home-page "https://metacpan.org/release/Statistics-Regression")
    (synopsis "weighted linear regression package (line+plane fitting)")
    (description synopsis)
    (license license:gpl3+)))

(define-public perl-statistics-r
  (package
    (name "perl-statistics-r")
    (version "0.34")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "mirror://cpan/authors/id/F/FA/FANGLY/Statistics-R-" version
                    ".tar.gz"))
              (sha256
               (base32
		"1m5yix1id4ba17n7992vq11dy9z7n17z56bqv604djbahxjd0bbq"))))
    (build-system perl-build-system)
    (native-inputs (list perl-module-install))
    (inputs (list r))
    (propagated-inputs `(("perl-ipc-run" ,perl-ipc-run)
                       ("perl-regexp-common" ,perl-regexp-common)))
    (home-page "https://metacpan.org/release/Statistics-R")
    (synopsis "Perl interface with the R statistical program")
    (description synopsis)
    (license license:perl-license)))




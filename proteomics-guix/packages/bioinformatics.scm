(define-module (proteomics-guix packages bioinformatics)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system r)
  #:use-module (gnu packages cran)
  #:use-module (gnu packages statistics)
  #:use-module (gnu packages bioconductor)
  #:use-module (gnu packages bioinformatics))


(define-public r-aroma-apd
  (package
    (name "r-aroma-apd")
    (version "0.6.1")
    (source (origin
              (method url-fetch)
              (uri (cran-uri "aroma.apd" version))
              (sha256
               (base32
                "0by8nss4m1hrd33bv9vdqgf67117a48y3wdkyc3q35anlz7kn3yk"))))
    (properties `((upstream-name . "aroma.apd")))
    (build-system r-build-system)
    (propagated-inputs (list r-r-huge r-r-methodss3 r-r-oo r-r-utils))
    (home-page "https://github.com/HenrikBengtsson/aroma.apd")
    (synopsis
     "Probe-Level Data File Format Used by 'aroma.affymetrix' [deprecated]")
    (description
     "DEPRECATED. Do not start building new projects based on this package. (The
(in-house) APD file format was initially developed to store Affymetrix
probe-level data, e.g. normalized CEL intensities.  Chip types can be added to
APD file and similar to methods in the affxparser package, this package provides
methods to read APDs organized by units (probesets).  In addition, the probe
elements can be arranged optimally such that the elements are guaranteed to be
read in order when, for instance, data is read unit by unit.  This speeds up the
read substantially.  This package is supporting the Aroma framework and should
not be used elsewhere.)")
    (license license:lgpl2.1+)))

(define-public r-aroma-core
  (package
    (name "r-aroma-core")
    (version "3.3.0")
    (source (origin
              (method url-fetch)
              (uri (cran-uri "aroma.core" version))
              (sha256
               (base32
                "12118xdb74c4b2ca5dq57zxkrrcjjji10b5a1qxpixkrc36bfskv"))))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'install 'change-home-dir
           (lambda _
             ;; Change from /homeless-shelter to /tmp for write permission.
             (setenv "HOME" "/tmp"))))))
    (properties `((upstream-name . "aroma.core")))
    (build-system r-build-system)
    (propagated-inputs (list r-biocmanager
                             r-future
                             r-listenv
                             r-matrixstats
                             r-pscbs
                             r-r-cache
                             r-r-devices
                             r-r-filesets
                             r-r-methodss3
                             r-r-oo
                             r-r-rsp
                             r-r-utils
                             r-rcolorbrewer))
    (home-page "https://github.com/HenrikBengtsson/aroma.core")
    (synopsis
     "Core Methods and Classes Used by 'aroma.*' Packages Part of the Aroma Framework")
    (description
     "Core methods and classes used by higher-level aroma.* packages part of the Aroma
Project, e.g. aroma.affymetrix and aroma.cn'.")
    (license license:lgpl2.1+)))

(define-public r-aroma-affymetrix
  (package
    (name "r-aroma-affymetrix")
    (version "3.2.1")
    (source (origin
              (method url-fetch)
              (uri (cran-uri "aroma.affymetrix" version))
              (sha256
               (base32
                "1yzmqh7f3x5mzws7azxa6rgqv8kcm861y9pc5ppc0vsgz7fvpvvs"))))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'install 'change-home-dir
           (lambda _
             ;; Change from /homeless-shelter to /tmp for write permission.
             (setenv "HOME" "/tmp"))))))
    (properties `((upstream-name . "aroma.affymetrix")))
    (build-system r-build-system)
    (propagated-inputs (list r-aroma-apd
                             r-aroma-core
                             r-future
                             r-listenv
                             r-mass
                             r-matrixstats
                             r-r-cache
                             r-r-devices
                             r-r-filesets
                             r-r-methodss3
                             r-r-oo
                             r-r-utils))
    (home-page "https://www.aroma-project.org/")
    (synopsis "Analysis of Large Affymetrix Microarray Data Sets")
    (description
     "This package provides a cross-platform R framework that facilitates processing
of any number of Affymetrix microarray samples regardless of computer system.
The only parameter that limits the number of chips that can be processed is the
amount of available disk space.  The Aroma Framework has successfully been used
in studies to process tens of thousands of arrays.  This package has actively
been used since 2006.")
    (license license:lgpl2.1+)))

(define-public r-peca
  (let ((commit "c7ed55494482648eaa529793bd51ceb51da6e58b")
        (revision "1"))
    (package
      (name "r-peca")
      (version (git-version "1.37.0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://git.bioconductor.org/packages/PECA")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1sfdjmlqqiil3d5a9imkl3qb596ljmmjvgfdrpg351y79aarxdvm"))))
      (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'install 'change-home-dir
           (lambda _
             ;; Change from /homeless-shelter to /tmp for write permission.
             (setenv "HOME" "/tmp"))))))
      (properties `((upstream-name . "PECA")))
      (build-system r-build-system)
      (propagated-inputs (list r-affy
                               r-aroma-affymetrix
                               r-aroma-core
                               r-genefilter
                               r-limma
                               r-preprocesscore
                               r-rots
			       r-r-filesets))
      (home-page "https://git.bioconductor.org/packages/PECA")
      (synopsis "Probe-level Expression Change Averaging")
      (description
       "Calculates Probe-level Expression Change Averages (PECA) to identify
differential expression in Affymetrix gene expression microarray studies or in
proteomic studies using peptide-level mesurements respectively.")
      (license license:gpl2+))))

(define-public r-swath2stats
  (let ((commit "6e35f7d64629117688751d01e18b5b7ab0b360c8")
        (revision "1"))
    (package
      (name "r-swath2stats")
      (version (git-version "1.31.0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://git.bioconductor.org/packages/SWATH2stats")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1mmscb3mjy0qr9wck7vvgkx1gagl3d43n1p2bdc46q0qjh3gn3kv"))))
      (properties `((upstream-name . "SWATH2stats")))
      (build-system r-build-system)
      (propagated-inputs (list r-biomart r-data-table r-ggplot2 r-reshape2))
      (native-inputs (list r-knitr))
      (home-page "https://git.bioconductor.org/packages/SWATH2stats")
      (synopsis "Transform and Filter SWATH Data for Statistical Packages")
      (description
       "This package is intended to transform SWATH data from the OpenSWATH software
into a format readable by other statistics packages while performing filtering,
annotation and FDR estimation.")
      (license license:gpl3))))

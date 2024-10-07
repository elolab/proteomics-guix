;; Copyright (C) 2023

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(define-module (proteomics-guix packages perl-maths)
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
    ;; guix import cpan couldnt infer where to place the version string
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
    ;; the page says gpl but doesnt say which
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


(define-public perl-statistics-kernelestimation
  (package
    (name "perl-statistics-kernelestimation")
    (version "0.05")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "mirror://cpan/authors/id/J/JA/JANERT/Statistics-KernelEstimation-"
                    version ".tar.gz"))
              (sha256
               (base32
		"10pabjspdrs6s7wfl56bn70bq0961fr31a6q6cfs9ixmbkab31pm"))))
    (build-system perl-build-system)
    (home-page "https://metacpan.org/release/Statistics-KernelEstimation")
    (synopsis "Kernel Density Estimates and Histograms")
    (description synopsis)
    (license license:perl-license)))


;; DIA-MS2PEP

    
perl-statistics-kernelestimation


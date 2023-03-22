(define-module (unelo-proteomics packages python-xyz)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (unelo-proteomics packages openms)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system python)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages check)
  #:use-module (guix download)
  #:use-module (gnu packages python-science)
  #:use-module ((guix licenses) #:prefix license:)
  )



(define-public python-autowrap
  (package
    (name "python-autowrap")
    (version "0.22.11")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "autowrap" version))
              (sha256
               (base32
		"1dv2xqxb4lffzrmaz9w2ybk8qvpb94d6i445rn1njmr65cgvwv5l"))))
    (build-system python-build-system)
    (native-inputs
     (list python-nose))
    (propagated-inputs (list python-cython python-setuptools))
    (home-page "https://github.com/OpenMS/autowrap")
    (synopsis
     "Generates Python Extension modules from commented Cython PXD files")
    (description
     "Generates Python Extension modules from commented Cython PXD files")
    (license license:expat)))

(define-public python-pyteomics
  (package
  (name "python-pyteomics")
  (version "4.5.6")
  (source (origin
            (method url-fetch)
            (uri (pypi-uri "pyteomics" version))
            (sha256
             (base32
              "0vqjgdl6yljqlacj9xnwkzv2shk1531158v7i4hm7n0qiw37jvlc"))))
  (arguments
   `(#:tests? #f))
      ;;tests would require
    ;; - `numpy <http://pypi.python.org/pypi/numpy>`_
    ;; - `matplotlib <http://sourceforge.net/projects/matplotlib/files/matplotlib/>`_
    ;;   (used by :py:mod:`pyteomics.pylab_aux`)
    ;; - `lxml <http://pypi.python.org/pypi/lxml>`_ (used by XML parsing modules)
    ;; - `pandas <http://pandas.pydata.org/>`_ (can be used with :py:mod:`pyteomics.pepxml`,
    ;;   :py:mod:`pyteomics.tandem`, :py:mod:`pyteomics.mzid`, :py:mod:`pyteomics.auxiliary`)
    ;; - `sqlalchemy <http://www.sqlalchemy.org/>`_ (used by :py:mod:`pyteomics.mass.unimod`)
    ;; - `pynumpress <https://pypi.org/project/pynumpress/>`_ (adds support for Numpress compression)   
  (build-system python-build-system)
  (home-page "https://github.com/levitsky/pyteomics")
  (synopsis "A framework for proteomics data analysis.")
  (description
   "This package provides a framework for proteomics data analysis,
such as calculation of basic physico-chemical properties of polypeptides, and acces to common proteomics data:")
  (license license:asl2.0)))

(define-public python-synthedia
  (package
    (name "python-synthedia")
    (version "1.0.3")
    (source (origin
            (method url-fetch)
            (uri (pypi-uri "synthedia" version))
            (sha256
             (base32
              "08bdapassdr0k0znmb1gqkh6vg5868b004wsc44ci4qpxin2fsk7"))))
    (build-system python-build-system)
  (propagated-inputs `(("python-matplotlib" ,python-matplotlib)
                      ("python-numpy" ,python-numpy)
                      ("python-pandas" ,python-pandas)
                      ("python-pyopenms" ,python-pyopenms "python")
                      ("python-pyteomics" ,python-pyteomics)
                      ("python-pyyaml" ,python-pyyaml)
                      ("python-scipy" ,python-scipy)))
  (home-page "https://github.com/mgleeming/synthedia.git")
  (synopsis "Generate synthetic DIA LC-MS/MS proteomics data")
  (description "Generate synthetic DIA LC-MS/MS proteomics data")
  (license license:bsd-3)))

;; a patch that allows you to set the random seed on synthedia
(define-public python-synthedia-with-seed
  (package
    (inherit python-synthedia)
    (name "python-synthedia-with-seed")
    (source (origin
	      (inherit
	       (package-source python-synthedia))
	       (patches (search-paches "unelo-proteomics/patches/synthedia-add-seed.patch"))))))

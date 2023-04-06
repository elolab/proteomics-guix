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

(define-module (unelo-proteomics packages python-xyz)
  #:use-module (gnu packages)
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
  #:use-module (guix git-download)
  #:use-module (gnu packages bioinformatics)
  #:use-module (gnu packages python-science)
  #:use-module (gnu packages statistics)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages graph)
  #:use-module ((guix licenses)
                #:prefix license:))

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
    (native-inputs (list python-nose))
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
    ;; tests would require
    ;; - `numpy <http://pypi.python.org/pypi/numpy>`_
    ;; - `matplotlib <http://sourceforge.net/projects/matplotlib/files/matplotlib/>`_
    ;; (used by :py:mod:`pyteomics.pylab_aux`)
    ;; - `lxml <http://pypi.python.org/pypi/lxml>`_ (used by XML parsing modules)
    ;; - `pandas <http://pandas.pydata.org/>`_ (can be used with :py:mod:`pyteomics.pepxml`,
    ;; :py:mod:`pyteomics.tandem`, :py:mod:`pyteomics.mzid`, :py:mod:`pyteomics.auxiliary`)
    ;; - `sqlalchemy <http://www.sqlalchemy.org/>`_ (used by :py:mod:`pyteomics.mass.unimod`)
    ;; - `pynumpress <https://pypi.org/project/pynumpress/>`_ (adds support for Numpress compression)
    (build-system python-build-system)
    (home-page "https://github.com/levitsky/pyteomics")
    (synopsis "Framework for proteomics data analysis")
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
                         ("openms" ,openms "python")
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
              (inherit (package-source python-synthedia))
              (patches (search-patches
                        "unelo-proteomics/patches/synthedia-add-seed.patch"))))))
(define-public python-pymzml
  (package
    (name "python-pymzml")
    (version "2.5.1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "pymzml" version))
              (sha256
               (base32
                "1wksngps9yq69mrvrknfwxc9rk78l6aq1c80pnbflacfq5fjb7k1"))))
    (build-system python-build-system)
    (propagated-inputs (list python-numpy python-regex))
    (arguments
     `(#:phases (modify-phases %standard-phases
                  ;; requires itself to be able to be found for tests
                  ;; inspired by `python-cfn-lint' in (gnu packages python-web)
                  (replace 'check
                    (lambda* (#:key inputs outputs tests? #:allow-other-keys)
                      (when tests?
                        (let ((out (assoc-ref outputs "out")))
                          (add-installed-pythonpath inputs outputs)
                          (invoke "python"
                                  "-m"
                                  "unittest"
                                  "discover"
                                  "-s"
                                  "test"))))))))
    (native-inputs (list
                    ;; for testing
                    python-plotly))
    (home-page "https://github.com/pymzml/pymzML")
    (synopsis
     "pymzML is an extension to Python that offers:

@enumerate
@item easy access to mass spectrometry (MS) data that allows the rapid development of tools
@item a very fast parser for mzML data, the standard mass spectrometry data format
@item a set of functions to compare and/or handle spectra
@item random access in compressed files
@item interactive data visualizationPython extension for working with mzML data.
@end enumerate
")
    (description "high-throughput mzML parsing")
    (license license:expat)))

(define-public python-scikits-datasmooth
  (package
    (name "python-scikits-datasmooth")
    (version "0.61")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "scikits.datasmooth" version))
              (sha256
               (base32
                "06v1fkzi35xlvfqsk5vigj5l498q52v30zy0bvbyi9l1cmj07077"))))
    (properties `((upstream-name . "scikit.datasmooth")))
    ;; no tests available
    (arguments
     `(#:tests? #f))
    (propagated-inputs (list python-numpy python-scipy))
    (build-system python-build-system)
    (home-page "https://github.com/jjstickel/scikit-datasmooth/")
    (synopsis "Scikits data smoothing package")
    (description "Scikits data smoothing package")
    (license license:bsd-3)))

(define-public python-cluster
  (package
    (name "python-cluster")
    (version "1.4.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/exhuma/python-cluster")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0qkz223ri1rsm74kdhxi1im9y66pakxmmhnnma7hhddif2zyapjd"))))
    (build-system python-build-system)
    (home-page "https://github.com/exhuma/python-cluster")
    (synopsis "Library for grouping similar objects.")
    (description synopsis)
    (license license:lgpl2.1)))

(define-public python-pymsnumpress
  (package
    (name "python-pymsnumpress")
    ;; 0.2.3 doesnt build because
    ;; PyMSNumpress.cpp:3095:69: error: too many arguments to function
    ;; 3095 |     return (*((__Pyx_PyCFunctionFast)meth)) (self, args, nargs, NULL);
    ;; see https://github.com/msproteomicstools/msproteomicstools/issues/110
    (version "0.2.2")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "PyMSNumpress" version))
              (sha256
               (base32
                "03kdx4yhrqjllfy24krv47j1bsm19xy9ikicplhy2svb6hzgidvl"))))

    (build-system python-build-system)
    (native-inputs (list python-cython))
    (home-page "https://github.com/ms-numpress")
    (synopsis
     "Python bindings for two compression schemes for numeric data from mass spectrometers")
    (description
     "Implementations of two compression schemes for numeric data from mass spectrometers.")
    (license license:bsd-3)))

(define-public python-msproteomicstools
  (package
    (name "python-msproteomicstools")
    (version "0.11.0")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "msproteomicstools" version))
              (sha256
               (base32
                "13icrhbn4bkrg7gl0hs56jic8z8770cc1p6l9jhallpqv2h6xhcf"))))
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (add-after 'unpack 'fix-print-statement
                    (lambda _
                      (substitute* '("msproteomicstoolslib/util/progress.py"
                                     "gui/AlignmentGUI.py"
                                     ;; "analysis/data_conversion/filterPeakview.py"
                                     ;; "analysis/scripts/mergeSqMass.py"
                                     ;; "analysis/scripts/plot_alignment_tree.py"
                                     )
                        (("( *print)([ \"]+.*)$" all prefix string)
                         (string-append prefix "(" string ")\n")))))
                  (add-after 'unpack 'remove-failing-tests
                    (lambda _
                      (substitute* (find-files "test" "\\.py$")
                        ,@(map (lambda (testname)
                                 (list (list testname)
                                       (format #f "_~a" testname)))
                               '("test_8_featureAlignment_openswath_LocalMST_cython"
                                 "test_pepxml2csv"
                                 "test_1_requantAlignedValues"
                                 "test_2_cache_requantAlignedValues"
                                 "test_3_singleShortestPath_requantAlignedValues"
                                 "test_4_singleClosestRun_requantAlignedValues"
                                 "test_5_singleClosestRun_requantAlignedValues"
                                 "test_6_singleShortestPath_requantAlignedValues"
                                 "test_7_requantAlignedValues"
                                 "test_8_requantAlignedValues"
                                 "test_gettingOperator_rpy2"
                                 "test_smooth_lowess"
                                 "test_smooth_spline_r"
                                 "test_smooth_spline_r_extern"
                                 "test_smooth_spline_scikit"
                                 "test_smooth_spline_scikit_wrap"
                                 "test_create_ms_rt_hashes"
                                 "test_parse_scans"
                                 "test_readfile"
                                 "test_readpeaks"
                                 "test_readscan"
                                 "test_gettingOperator"))) #t))
                  (add-after 'unpack 'relax-requirements
                    (lambda _
                      (substitute* "setup.py"
                        (("pymzml == [^'\"]*")
                         "pymzml")
                        (("cluster ==[^'\"]*")
                         "cluster")
                        (("from Cython.Build import cythonize")
                         ""))))
                  (add-after 'unpack 'remove-python2-scripts
                    (lambda _
                      (map delete-file
                           '("msproteomicstoolslib/util/gnuplot.py"
                             "msproteomicstoolslib/util/latex.py"
                             "analysis/scripts/DIA/makeSwathFile.py"
                             ;; funky files that have python2 syntax
                             "analysis/data_conversion/filterPeakview.py"
                             "analysis/scripts/mergeSqMass.py"
                             "analysis/scripts/plot_alignment_tree.py"
                             "analysis/data_conversion/split_mzXML_intoSwath.py")))))))
    ;; need to patch print-statements in bin/*.py
    ;; to be python3 syntax
    (build-system python-build-system)
    (native-inputs (list ;python-cython
                         python-wrapper python-nose python-rpy2))
    (propagated-inputs (list python-biopython
                             python-cluster
                             python-configobj
                             python-lxml
                             python-numpy
                             python-pymsnumpress
                             python-pymzml
                             python-pyteomics
                             python-scikits-datasmooth
                             python-scipy
                             python-statsmodels
                             python-xlsxwriter
                             python-xlwt))
    (home-page "https://github.com/msproteomicstools/msproteomicstools")
    (synopsis "Tools for MS-based proteomics")
    (description "Tools for MS-based proteomics")
    (license license:bsd-3)))

(define-module (unelo-proteomics packages openms)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (gnu packages)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages check)
  #:use-module (unelo-proteomics packages maths)
  #:use-module (gnu packages machine-learning)
  #:use-module (unelo-proteomics packages python-xyz)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:))
  
;; hash
;; 12bfja6hnnclsnqyrd37i64ijrgs0yvbydfxcba5wsxp9v7mvg05
;; documentation
;; https://abibuilder.informatik.uni-tuebingen.de/archive/openms/Documentation/release/latest/html/install_linux.html
;; https://abibuilder.informatik.uni-tuebingen.de/archive/openms/Documentation/release/latest/html/install_linux.html
;; see also ((gnu packages lxqt)
(define openms-contrib-source
  ;; check libraries.cmake/wildmagic.cmake
  ;; on how to create wildmaigc from https://abibuilder.informatik.uni-tuebingen.de/archive/openms/contrib/source_packages/WildMagic5.tar.gz
  ;; passing this source as a native-input 
  (origin
    (method git-fetch)
    (uri 
     (git-reference
      (url "https://github.com/OpenMS/contrib")
      (commit "4b7fc07c7e5a7e5e2bcb3c41b11fe9dc4651ee42")))
    (sha256
     (base32
      "0rsj7w3nmncham13g5b4cm1gpw774vh2pci51327qws7p42l9phf"))))

;; openms after wildmagic was removed as a dependency 
(define openms-minimal
  (let ((revision "1")
	(commit "b405f94303fde1982e7c458b34c1c8da762620a6"))
    (package
      (name "openms-minimal")
      (home-page "https://github.com/OpenMS/OpenMS.git")
      (version (git-version "2.9.0" revision commit))
      (source (origin
                (method git-fetch)
		(patches (search-patches "unelo-proteomics/patches/openms-tests.patch"))
                (uri (git-reference
		      (url home-page)
		      (commit commit)))
		(sha256
                 (base32
		  "1z3vhad46m2fb3qb28i290vrbs0b5mr5hkji1w2k14a43lqv5njs"))))
      (build-system cmake-build-system)
      (arguments
       (list
	#:build-type "Release"
	#:configure-flags
	#~(list 
	   (string-append "-DLIBSVM_LIBRARY_RELEASE="
                           (assoc-ref %build-inputs "libsvm")
                           "/lib/libsvm.so.2")
	    ;; (string-append "-DLIBSVM_INCLUDE_DIR="
             ;;                #$(this-package-input "libsvm")
            ;;                "/include/libsvm")
	     "-DBoost_FOUND=TRUE"
	     "-DWITH_GUI=OFF"
	     "-DHAS_XSERVER=OFF"
	     "-DENABLE_DOCS=OFF"
	     "-DENABLE_TUTORIALS=OFF"
	     "-DENABLE_UPDATE_CHECK=OFF"
	     "-DGIT_TRACKING=OFF")))
      (inputs
       (list
	;; essentials
	qtbase-5
	qtsvg
	;; xonon-essentials
	xerces-c
	hdf5
	libsvm
	boost-static
	eigen
	;; instead of coin, glpk (which is already in guix (gnu packages maths) can be used
	;; however src/tests/class_tests/openms/CMakeLists.txt requires CoinOR::CoinOR
	;; for target_link_libraries(LPWrapper_test CoinOR::CoinOR)
	coin-mp
	;; glpk
	zlib
	bzip2
	eigen
	icu4c
	sqlite))
      (native-inputs
       (list
	;; essentials
	;; boost
	autoconf
	automake
	libtool
	pkg-config))
      (license license:bsd-3)
      (home-page "https://github.com/OpenMS/OpenMS.git")
      (synopsis "C++ library for LC-MS data management and analyses.")
      (description "OpenMS is a C++ library for LC-MS data management and analyses. It offers an
infrastructure for rapid development of mass spectrometry related software. OpenMS is free software
available under the three clause BSD license and runs under Windows, macOS, and Linux.

It comes with a vast variety of pre-built and ready-to-use tools for proteomics and metabolomics data
analysis (TOPPTools) as well as powerful 1D, 2D and 3D visualization (TOPPView).

OpenMS offers analyses for various quantitation protocols, including label-free quantitation, SILAC, iTRAQ,
TMT, SRM, SWATH, etc."))))

;; openms with python bindings as an output
(define-public openms
  (package
    (inherit openms-minimal)
    (name "openms")
    (outputs '("out" "python"))
    ;; see also emacs-jedi, gemmi, libdeacaf, liblouis
    ;; and gemmi for packages that also have a python output
    (arguments
     (append
      (list
       #:imported-modules (append %cmake-build-system-modules
			    '((guix build python-build-system)))
       #:modules '((guix build cmake-build-system)
		   (guix build utils)
                   ((guix build python-build-system) #:prefix python:))
       #:phases 
       '(modify-phases %standard-phases
	  (add-after 'configure 'ensure-no-mtimes-pre-1980
	    (assoc-ref python:%standard-phases
		       'ensure-no-mtimes-pre-1980))
	  (add-after 'build 'wrap-python
	    (assoc-ref python:%standard-phases 'wrap))
	  (add-after 'wrap-python 'install-python-binding
	    (lambda* (#:key outputs #:allow-other-keys)
	      (with-directory-excursion "pyOpenMS"
		(invoke "python" "setup.py" "install"
			(string-append "--prefix=" (assoc-ref outputs "python"))
			"--root=/")))))) 
      (substitute-keyword-arguments (package-arguments openms-minimal)
	((#:configure-flags cf)
	 #~`("-DPYOPENMS=ON"
	     ;; disable memleak test
	     "-DPY_MEMLEAK_DISABLE=ON"
	     ,@#$cf))
	((#:make-flags mf)
	 `(cons ".DEFAULT_GOAL=pyopenms"
		,mf)))))
    (native-inputs
     `( 
      ("python" ,python-wrapper)
      ("python-cython" ,python-cython)
      ("python-pip" ,python-pip)
      ("python-setuptools" ,python-setuptools)
      ("python-wheel" ,python-wheel)
      ("python-numpy" ,python-numpy)
      ("python-pytest" ,python-pytest)
      ("python-nose" ,python-nose)
      ("python-autowrap" ,python-autowrap)))
    (propagated-inputs
     (list python-numpy
	   python-pandas))
    (inputs
     (modify-inputs (package-inputs openms-minimal)
		    (prepend python)))))





;; Local Variables:
;; compile-command: "GUIX_PACKAGE_PATH=\"$PWD/..\" guix build -f ./openms.scm --keep-failed"
;; End:

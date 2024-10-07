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

(define-module (unelo-proteomics packages tpp)
  #:use-module (guix packages)
  #:use-module (ice-9 string-fun)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (gnu packages gd)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages machine-learning)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages image)
  #:use-module (guix svn-download)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages web)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages backup)
  #:use-module (gnu packages pkg-config)
  #:use-module (unelo-proteomics packages maths)
  #:use-module (unelo-proteomics packages perl-maths)
  #:use-module ((guix licenses)
                #:prefix license:))

(define gzstream-bpratt
  (package
    (inherit gzstream)
    (name "gztream-bpratt")
    (synopsis "gzstream with variable compression levels")
    (description
     "This variant of gzstream includes bpratt of Insilicos LLC mdoificiations, which allow one to specifiy the compression levels")
    (source (origin
              (inherit (package-source gzstream))
              (patches (search-patches
                        "unelo-proteomics/patches/gzstream-bpratt.patch"))))))

;; for an idea on how to handle the patches that tpp bundles
;; check out jami-apply-custom-patches in the module
;; (gnu packages jami)

;; 5.2.0 <-> r7901
;; 6.1.0 <-> r8676
;;  	[r8676] Tagging final 6.1.0 release 

;; see also http://tools.proteomecenter.org/wiki/index.php?title=TPP_6.2.0:_Installing_on_Ubuntu_22.04_LTS
;; for perl stuff compare `prinseq' from (gnu packages bioinformatics)
;; and clyrics from (gnu packages music)
;; moreutils
(define tpp-6.1.0-source
  (let ((name "tpp")
        (version "6.1.0"))
    (origin
      (method svn-fetch)
      (uri (svn-reference (url
                           "https://svn.code.sf.net/p/sashimi/code/tags/release_6-1-0/")
                          (revision 8676)))
      (modules '((guix build utils)))
      ;; in InteractParser rule -lraci is used evn though it is already in libtpp.a
      ;; weirdly enough the flag -lraci makes it seem like  a systems library
      ;; but they use the quoted include (which is for local).
      ;; and the RACI.o is already in libtpp.a, so its not needed to declare systems library here right?
      ;; see src/Visualization/Makefile
      
      ;; need to remove    # $(PWIZ_SRCDIR)/pwiz_aux/msrc/utility/vendor_api/thermo/ScanFilter.cpp \ from extern/ProteoWizard/Makefile
      (snippet `(begin
                  (substitute* (list "src/Visualization/Makefile"
                                     "extern/ProteoWizard/Makefile")
                    (("-lraci")
                     "")
                    ;; this one is just broken
                    (("\\$\\(PWIZ_SRCDIR)/pwiz_aux/msrc/utility/vendor_api/thermo/ScanFilter\\.cpp")
                     ""))
                  (substitute* (list "extern/ProteoWizard/Makefile"
                                     "extern/Makefile")
                    ;; disable install rules of things that are in guix
                    (("^install ::(.*)" all target)
                     (let ((external-packages '("d3" "mayu" "hardklor" "spare"
                                                "comet" "pwiz")))
                       (if (null? (filter (lambda (pkg)
                                            (string-contains-ci target pkg))
                                          external-packages)) "" all))))))
      (file-name (string-append name "-" version))
      (sha256 (base32
               "0w7yndpc96h3an9hcc7rj6snayl9k2g8xmbq711fmzcrxhni5qlb")))))

(define-public tpp
  (let* (;; these are bundled packages
         
         ;; that we actually want build
         ;; because they do not exist in guix
         (external-packages '("d3" "mayu" "hardklor" "spare" "comet" "pwiz"))
         ;; these with tpp bundled package have no rule to build their source
         (external-packages-without-source-rule '("mayu" "hardklor" "pwiz"))
         (extern-all-build (string-append "EXTERN_ALL="
                                          (string-join external-packages " ")))
         (extern-all-configure (string-append "EXTERN_ALL="
                                              (string-join (filter (lambda (s)
                                                                     (not (member
                                                                           s
                                                                           external-packages-without-source-rule)))
                                                            external-packages)
                                                           " "))))
    (package
      (name "tpp")
      (version "6.1.0")
      (synopsis "Data analysis software for proteomics")
      (description
       "The Trans-Proteomic Pipeline (TPP) is open-source data analysis software for
proteomics developed at the Institute for Systems Biology (ISB) under the 
Seattle Proteome Center.  The TPP includes tools such as PeptideProphet, 
ProteinProphet, ASAPRatio, XPRESS, and libra that can be used for statistical
validation, quantitation, visualization, and conversion of proteomics data.")
      (home-page
       "http://tools.proteomecenter.org/wiki/index.php?title=Software:TPP")
      (license license:lgpl2.1+)
      (inputs (list gd
                    libpng
                    zlib
                    ;; pwiz bundles its own eigen with nnls.h
                    ;; thats not in normal eigen
                    ;; alternattively we could remove everything from that eigen dir thats _not_ nnls.h
                    ;; and use guix's eigen and just that one
                    ;; eigen
                    bzip2
                    libxslt
                    expat
                    gnuplot
                    perl
                    boost
                    hdf5
                    fann
                    gsl-1.16
                    libsvm
                    ;; they spin their own gzsream
                    gzstream-bpratt
                    libarchive
                    ;; pwiz                             ;
		    ;; perl deps
		    perl-cgi ;; is this needed if we dont use a webserver?
		    perl-xml-parser
		    perl-xml-twig
		    perl-tie-ixhash
		    perl-statistics-regression
		    perl-statistics-r
                    ))
      (native-inputs (list unzip))
      (source tpp-6.1.0-source)
      (build-system gnu-build-system)
      (arguments
       (list
	#:parallel-build? #f ;; the makefile is not written in a way that allows parallel buids
        #:make-flags
        #~(cons*
           (format #f "TARGET=~a"
                   ;; TPP wants a target
                   ;; with exactly 3 dashes
                   ;; it doesn't like "linux-gnu"
                   #$(string-replace-substring (or (%current-target-system) (nix-system->gnu-triplet (%current-system))) "linux-gnu" "linux" ))
           "BUILD_DATE:=197001010000"
           ;;"PWIZ_LDFLAGS="
           ;; we could also in ProteoWizard/Makefile substitute
           ;; -I$(PWIZ_SRCDIR)/libraries/boost_1_76_0
           (string-append
            "PWIZ_CXXFLAGS="
            "-I$(TPP_EXT)/ProteoWizard/pwiz-src"
            " -I$(TPP_EXT)/ProteoWizard/pwiz-src/libraries/boost_aux"
            " -DPWIZ_USER_VERSION_INFO_H_STR=\"\\\"$(TPP_BUILDID)\"\\\" "
            " -D_USE_MATH_DEFINES"
            " -Wno-error=invalid-offsetof "
            " $(if $(HDF5_SUPPORT),,-DWITHOUT_MZ5)"
            " -MMD "
            " -I$(TPP_SRC)/Parsers/ramp "
            " -I$(PWIZ_SRCDIR) "
            ;; (format #f " -I~a/include/libsvm" #$(file-append libsvm))
            ;; the guix eigen is not fsufficient as pwiz needs nnls.h
            ;; (format #f " -I~a/include/eigen3/Eigen" #$(file-append eigen))
            " -I$(PWIZ_SRCDIR)/libraries/Eigen "
            " -I$(PWIZ_SRCDIR)/libraries/CSpline "
            " -I$(PWIZ_SRCDIR)/libraries/libsvm-3.0 ")
           ;; $(LIBARCHIVE_LIB) is a dep of $(LIBCOMMON)
           ;; but we already have this in guix
           ;; so we set the rule to empty
           (apply
            append
            (map
             (lambda (x)
               (list
                (format #f "~a_LIB=" (car x))
                (format #f "~a_LDFLAGS=~a"
                        (car x)
                        (if
                         (> (length x) 1)
                         (cadr x)
                         (format #f "-l~a"
                                 (substring
                                  (string-downcase (car x))
                                  (if
                                   (string-prefix-ci? "lib" (car x))
                                   3 0)))))))
             `(("LIBARCHIVE")
               ("GSL" "-lgsl -lgslcblas -lm -lm")
               ("GZSTREAM")
               ("FANN")))))
        #:phases
        #~(modify-phases %standard-phases
            (replace 'configure
              (lambda* (#:key make-flags #:allow-other-keys)
                (with-output-to-file "site.mk"
                  (lambda _
                    (format #t "\
TPP_BASEURL=tpp
INSTALL_DIR=~a
TPP_DATA_DIR=~a/share/tpp/
# fixing the bug that $(BUILD_DIR) makes $(BUILD_WWW) but doesnt declare it as an output
$(BUILD_WWW)/:
\tmkdir -p $@
"
                            #$output #$output)))
                (apply invoke "make" "extern-source" #$extern-all-configure make-flags)))
            (replace 'build
              (lambda* (#:key make-flags #:allow-other-keys)
                (apply invoke "make" "all" #$extern-all-build make-flags)))

	    (add-after 'install 'wrap-program
              (lambda _
                (for-each
                 (lambda (script)
                   (wrap-program script
                     `("PERL5LIB" ":" prefix (,(getenv "PERL5LIB")))))
		 (append
		  (find-files (string-append #$output "/cgi-bin"))
                  (find-files (string-append #$output "/bin"))))))
            (replace 'install
              (lambda* (#:key make-flags #:allow-other-keys)
                (apply invoke "make" "install" #$extern-all-build make-flags)))
            (delete 'check)))))))

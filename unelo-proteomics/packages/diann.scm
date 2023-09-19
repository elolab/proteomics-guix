(define-module (unelo-proteomics packages diann)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages pkg-config)
  #:use-module ((guix licenses)
                #:prefix license:))

;; this bundles cranium, eigen, mstoolkit and minidnn
;; later versions of this package are propriatary
;; this package builds statically linked.
(define-public diann
  (package
    (name "diann")
    (version "1.8")
    (home-page "https://github.com/vdemichev/diann")
    (source
     (origin
       (method git-fetch)
       (uri
	(git-reference
	 (url home-page)
	 (commit version)))
       (file-name (git-file-name name version))
       (sha256 (base32 "1pxf211i742ibjvmysnxad583vcjlc73035y3viiq1i7l6i4ajsc"))
       (snippet
        #~(begin
            (use-modules (guix build utils))
            (for-each delete-file
                      (append
                       (find-files "." "vcxproj")
		       (find-files "." "vdproj")
		       (find-files "." "AssemblyAttributes")
		       (find-files "." "\\.idb$")
		       ))))
                        ;; Generated by bison.


       (patches (search-patches
		 "unelo-proteomics/patches/diann-goto-fixes.patch"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f ;; no tests exist
      #:make-flags #~(list (string-append "CC=" #$(cxx-for-target)))
      #:phases
       #~(modify-phases %standard-phases
	 (delete 'configure)
	 (add-before 'build 'cd-to-mstoolkit
	   ;; 
	   (lambda _
	     (chdir "mstoolkit")))
	 (add-after 'build 'cd-back
	   (lambda _
	     (chdir "..")))
	 
	 (replace 'install
	   (lambda _
	     (install-file "diann-linux" (string-append #$output "/bin/")))))))
    (synopsis "DIANN")
    (description "DIANN")
    (license license:cc-by4.0)))

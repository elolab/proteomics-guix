(define-module (proteomics-guix packages perl-swissknife)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages perl-check)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system perl))


(define-public perl-swissknife
  (let ((commit "a078410d6b7570650285098810e68e4e26b7f2d7"))
    (package
      (name "perl-swissknife")
      (version "1.81")
      (home-page "https://swissknife.sourceforge.net/docs/")
      (source (origin
		(method git-fetch)
		(uri (git-reference
		      (url "https://git.code.sf.net/p/swissknife/git")
		      (commit commit)))
		(sha256
		 (base32 "1rfhn73xfb4h6l5mszaakyp6vb0x3y2rwfs2im0ni9gz9x2q0c84"))))
      (arguments
       `( #:phases
	 (modify-phases %standard-phases
	  ;; tests are give correct output but in different order so sort before diffing
	  (add-before 'check 'correct-tests
		       (lambda _
			 (substitute* (find-files "t" "\\.t$")
			   (("^.*diff \\$testout" m)
			     (string-append "system('sort',$testout,'-o',$testout);\nsystem('sort',$expectedout,'-o',$expectedout);" "\n" m))))))))
      
      (build-system perl-build-system)
      (license license:gpl3+)
      (synopsis "Swissknife is a Perl module for creating and parsing Swiss-Prot files.")
      (description synopsis)
      (native-inputs (list perl-module-build perl-test-pod perl-test-pod-coverage))
      (inputs (list perl-data-dumper
	       perl-carp
	       perl-exporter
	        )))))
perl-swissknife

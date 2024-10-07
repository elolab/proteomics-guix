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


;; should be in `(gnu packages bioinformatics)' upstream
(define-module (unelo-proteomics packages perl-diams2pep)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (gnu packages perl)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (unelo-proteomics packages perl-maths)
  #:use-module (guix build-system perl))

(define-public perl-diams2pep
  (let ((commit "609af80891041329060879d1239a24f1f19396a4")
	(version "0.0.1")
	(revision "2"))
    
  (package
    (name "perl-diams2pep")
    (version (git-version version revision commit))
    (home-page "https://github.com/SS2proteome/DIA-MS2pep")
    ;; not clear whether its gpl3 or gpl3+
    ;; no copyright lines in files
    (license license:gpl3+)
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32
	 "03xx1dagfscys14a52zs03ma6d4zafsdza2fmf23mc7gqcslh7f7"))))
    (synopsis name)
    (description name)
    ;; these can either be in propogated inputes or in just 'inputs'
    ;; because PERL5LIB has a reference to the store items.
    (inputs
      (list perl-statistics-kernelestimation
		  perl-parallel-forkmanager))
    (build-system perl-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
	  (delete 'configure)
	  (delete 'build)
	  (replace 'install
	    (lambda _
	      (for-each (lambda (x)
			  (chmod x #o755)
			  (install-file x (string-append #$output "/bin/")))
			(find-files "Scripts" ".pl$"))
	      (for-each (lambda (x) (install-file x (string-append #$output "/lib/"
								   "/perl5/site_perl/"
								   #$(package-version
								      perl)
								   "/")))
			(find-files "Scripts" ".pm"))))
	  (add-after 'install 'wrap-program
              (lambda _
                (for-each
                 (lambda (script)
                   (wrap-program script
                     `("PERL5LIB" ":" prefix (,
					      (string-append (getenv "PERL5LIB")
							     ":"
							     (string-append #$output "/lib/"
								   "/perl5/site_perl/"
								   ))))))
		 (append
		  (find-files (string-append #$output "/cgi-bin"))
                  (find-files (string-append #$output "/bin")))))))
	  

	#:tests? #f ;; no tests
	)))))
perl-diams2pep

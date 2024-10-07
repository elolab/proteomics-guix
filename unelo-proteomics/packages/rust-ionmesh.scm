;; Copyright (C) 2024  

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
;; Most of this was generated with cargo2guix, so sorry about the low quality code.

(define-module
  (unelo-proteomics packages rust-ionmesh)
  #:use-module
  ((guix licenses) #:prefix license:)
  #:use-module
  (guix build-system cargo)
  #:use-module (ice-9 match)
  #:use-module (guix derivations)
  #:use-module (guix packages)
  #:use-module (guix store)
  #:use-module (guix monads)
  #:use-module (guix gexp)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module
  (guix download)
  #:use-module
  (guix monads)
  #:use-module
  (guix store)
  #:use-module
  (guix gexp)
  #:use-module (guix git-download)
  
  #:use-module
  (guix packages))

;; rust-build-system expects tarballs,
;; the procedure this returns create one.
;; useful for git repos that have multiple crates
;; but you want to select one.
(define* (git-fetch-and-targz-factory path prefix #:optional tar-ball-name)
  "Similar to 'git-fetch' but pack PATH into a tarball with PREFIX, so that it behaves better for rust-build-system. Inspired by url-fetch/zipbomb.
A sensible value for PREFIX is (string-append PKG-NAME \"-\" VERSION)"
  (lambda* (ref hash-algo hash
                #:optional name
                #:key (system (%current-system)) guile git)
    (let* (;; what we save the tarball as
	   (file-name 
	    (or
	     tar-ball-name
	     name 
	     (basename (git-reference-url ref) ".git")))
	   (tar
	    (module-ref (resolve-interface '(gnu packages base)) 'tar))
	   (gzip
	    (module-ref (resolve-interface '(gnu packages compression)) 'gzip))
	   ;; find a character that we can use as sed seperator for tar's --transform option
	   ;; thats not in the string we are operating on.
	   (boundary-character
	    (car (filter  (lambda (c) (not (string-contains file-name
							    c)))
			  
			  (list "@" "%" "/" "&" ":")))))
      (mlet %store-monad ((drv
			   (apply
			    git-fetch ref
				     hash-algo
				     hash
				     (string-append "git-"
						    (basename file-name ".tar.gz"))
				     `(
				       ,@(if system `( #:system ,system) '())
				       ,@(if guile `( #:guile ,guile) '())
				       ,@(if git  `( #:git ,git) '()))))
			  #;(guile (package->derivation guile system)))
       (gexp->derivation file-name
			 (with-imported-modules '((guix build utils))
						  
			   #~(begin
			       (use-modules (guix build utils))
			       ;; tar -z requires gzip in PATH
			       (set-path-environment-variable "PATH" '("bin") '(#+gzip))

			       (invoke (string-append #+tar "/bin/tar")
				       "-czf" #$output
				       "-C" (string-append #$drv "/" #$path)
				       "--transform" #$(string-append "s" boundary-character "^\\." boundary-character prefix boundary-character)
				       "."
				       ))))))))


(define rust-ab-glyph-0.2
  (package
    (name "rust-ab-glyph")
    (version "0.2.26")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ab_glyph" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1zbcs6kh1jc16dgb0wgzjki8xl8a8k3f0ykqkfxd433nsniv0lrf"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-owned-ttf-parser"
          ,rust-owned-ttf-parser-0.21)
         ("rust-ab-glyph-rasterizer"
          ,rust-ab-glyph-rasterizer-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ab-glyph-rasterizer-0.1
  (package
    (name "rust-ab-glyph-rasterizer")
    (version "0.1.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ab_glyph_rasterizer" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ikhgzig59q8b1a1iw83sxfnvylg5gx6w2y8ynbnf231xs9if6y7"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-accesskit-0.12
  (package
    (name "rust-accesskit")
    (version "0.12.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "accesskit" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0szw1d6ml049779m55h0l107abhsmchmdx58rdfjbhcr7m7v393l"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-enumn" ,rust-enumn-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-accesskit-consumer-0.16
  (package
    (name "rust-accesskit-consumer")
    (version "0.16.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "accesskit_consumer" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1rj5vsaxn9m5aazr22vzlb5bxfbl28h2mck7hqldgyq97jjwq5wc"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-accesskit" ,rust-accesskit-0.12))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-accesskit-macos-0.10
  (package
    (name "rust-accesskit-macos")
    (version "0.10.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "accesskit_macos" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "19vpwi1cnyxbjal4ngjb2x7yhfm9x3yd63w41v8wxyxvxbhnlfyd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-once-cell" ,rust-once-cell-1)
         ("rust-objc2" ,rust-objc2-0.3)
         ("rust-accesskit-consumer"
          ,rust-accesskit-consumer-0.16)
         ("rust-accesskit" ,rust-accesskit-0.12))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-accesskit-unix-0.6
  (package
    (name "rust-accesskit-unix")
    (version "0.6.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "accesskit_unix" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "022a77nm8461v0f6mpzidamkci0h1kmkxl9x2bbim9lvv4c6rx09"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zbus" ,rust-zbus-3)
         ("rust-serde" ,rust-serde-1)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-futures-lite" ,rust-futures-lite-1)
         ("rust-atspi" ,rust-atspi-0.19)
         ("rust-async-once-cell"
          ,rust-async-once-cell-0.5)
         ("rust-async-channel" ,rust-async-channel-2)
         ("rust-accesskit-consumer"
          ,rust-accesskit-consumer-0.16)
         ("rust-accesskit" ,rust-accesskit-0.12))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-accesskit-windows-0.15
  (package
    (name "rust-accesskit-windows")
    (version "0.15.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "accesskit_windows" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "02sazww6l5h0wsgif0npdpkb5lczx0xph65kn31wfkwpq1zf5jmg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows" ,rust-windows-0.48)
         ("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-paste" ,rust-paste-1)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-accesskit-consumer"
          ,rust-accesskit-consumer-0.16)
         ("rust-accesskit" ,rust-accesskit-0.12))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-accesskit-winit-0.15
  (package
    (name "rust-accesskit-winit")
    (version "0.15.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "accesskit_winit" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0f57zanvrgjyhn8lagcprkd4f1mnp9v7l2vki3hp22g1qb79zqw8"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winit" ,rust-winit-0.28)
         ("rust-accesskit-windows"
          ,rust-accesskit-windows-0.15)
         ("rust-accesskit-unix" ,rust-accesskit-unix-0.6)
         ("rust-accesskit-macos"
          ,rust-accesskit-macos-0.10)
         ("rust-accesskit" ,rust-accesskit-0.12))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-addr2line-0.21
  (package
    (name "rust-addr2line")
    (version "0.21.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "addr2line" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1jx0k3iwyqr8klqbzk6kjvr496yd94aspis10vwsj5wy7gib4c4a"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-gimli" ,rust-gimli-0.28))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-adler-1
  (package
    (name "rust-adler")
    (version "1.0.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "adler" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1zim79cvzd5yrkzl3nyfx0avijwgk9fqv3yrscdy1cc79ih02qpj"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-adler32-1
  (package
    (name "rust-adler32")
    (version "1.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "adler32" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0d7jq7jsjyhsgbhnfq5fvrlh9j0i9g1fqrl2735ibv5f75yjgqda"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ahash-0.8
  (package
    (name "rust-ahash")
    (version "0.8.11")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ahash" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "04chdfkls5xmhp1d48gnjsmglbqibizs3bpbj6rsj604m10si7g8"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zerocopy" ,rust-zerocopy-0.7)
         ("rust-version-check" ,rust-version-check-0.9)
         ("rust-serde" ,rust-serde-1)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-getrandom" ,rust-getrandom-0.2)
         ("rust-const-random" ,rust-const-random-0.1)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-aho-corasick-1
  (package
    (name "rust-aho-corasick")
    (version "1.1.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "aho-corasick" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "05mrpkvdgp5d20y2p989f187ry9diliijgwrs254fs9s1m1x6q4f"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-memchr" ,rust-memchr-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-alloc-no-stdlib-2
  (package
    (name "rust-alloc-no-stdlib")
    (version "2.0.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "alloc-no-stdlib" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1cy6r2sfv5y5cigv86vms7n5nlwhx1rbyxwcraqnmm1rxiib2yyc"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-alloc-stdlib-0.2
  (package
    (name "rust-alloc-stdlib")
    (version "0.2.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "alloc-stdlib" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1kkfbld20ab4165p29v172h8g0wvq8i06z8vnng14whw0isq5ywl"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-alloc-no-stdlib" ,rust-alloc-no-stdlib-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-allocator-api2-0.2
  (package
    (name "rust-allocator-api2")
    (version "0.2.18")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "allocator-api2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0kr6lfnxvnj164j1x38g97qjlhb7akppqzvgfs0697140ixbav2w"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-android-activity-0.4
  (package
    (name "rust-android-activity")
    (version "0.4.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "android-activity" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1q7mhn9b43l6l6fnxpbgbqzafx4m8rgf8349s37188vwy8hrflk4"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num-enum" ,rust-num-enum-0.6)
         ("rust-ndk-sys" ,rust-ndk-sys-0.4)
         ("rust-ndk-context" ,rust-ndk-context-0.1)
         ("rust-ndk" ,rust-ndk-0.7)
         ("rust-log" ,rust-log-0.4)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-jni-sys" ,rust-jni-sys-0.3)
         ("rust-cc" ,rust-cc-1)
         ("rust-bitflags" ,rust-bitflags-1)
         ("rust-android-properties"
          ,rust-android-properties-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-android-properties-0.2
  (package
    (name "rust-android-properties")
    (version "0.2.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "android-properties" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "016slvg269c0y120p9qd8vdfqa2jbw4j0g18gfw6p3ain44v4zpw"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-android-tzdata-0.1
  (package
    (name "rust-android-tzdata")
    (version "0.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "android-tzdata" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1w7ynjxrfs97xg3qlcdns4kgfpwcdv824g611fq32cag4cdr96g9"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-android-system-properties-0.1
  (package
    (name "rust-android-system-properties")
    (version "0.1.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "android_system_properties" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "04b3wrz12837j7mdczqd95b732gw5q7q66cv4yn4646lvccp57l1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-anstream-0.6
  (package
    (name "rust-anstream")
    (version "0.6.14")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "anstream" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0nx1vnfs2lil1sl14l49i6jvp6zpjczn85wxx4xw1ycafvx7b321"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-utf8parse" ,rust-utf8parse-0.2)
         ("rust-is-terminal-polyfill"
          ,rust-is-terminal-polyfill-1)
         ("rust-colorchoice" ,rust-colorchoice-1)
         ("rust-anstyle-wincon" ,rust-anstyle-wincon-3)
         ("rust-anstyle-query" ,rust-anstyle-query-1)
         ("rust-anstyle-parse" ,rust-anstyle-parse-0.2)
         ("rust-anstyle" ,rust-anstyle-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-anstyle-1
  (package
    (name "rust-anstyle")
    (version "1.0.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "anstyle" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "06qxmrba0xbhv07jpdvrdrhw1hjlb9icj88bqvlnissz9bqgr383"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-anstyle-parse-0.2
  (package
    (name "rust-anstyle-parse")
    (version "0.2.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "anstyle-parse" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1m121pa4plpcb4g7xali2kv9njmgb3713q3fxf60b4jd0fli2fn0"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-utf8parse" ,rust-utf8parse-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-anstyle-query-1
  (package
    (name "rust-anstyle-query")
    (version "1.0.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "anstyle-query" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1x9pyl231rry5g45dvkdb2sfnl2dx2f4qd9a5v3ml8kr9ryr0k56"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-anstyle-wincon-3
  (package
    (name "rust-anstyle-wincon")
    (version "3.0.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "anstyle-wincon" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "06gv2vbj4hvwb8fxqjmvabp5kx2w01cjgh86pd98y1mpzr4q98v1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52)
         ("rust-anstyle" ,rust-anstyle-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-anyhow-1
  (package
    (name "rust-anyhow")
    (version "1.0.86")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "anyhow" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1nk301x8qhpdaks6a9zvcp7yakjqnczjmqndbg7vk4494d3d1ldk"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-apache-avro-0.16
  (package
    (name "rust-apache-avro")
    (version "0.16.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "apache-avro" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "180113hv4b7dw63szi5rzjb5pj8lwn5zyf8fnxq0kx7qna1wddyf"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-uuid" ,rust-uuid-1)
         ("rust-typed-builder" ,rust-typed-builder-0.16)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-strum-macros" ,rust-strum-macros-0.25)
         ("rust-strum" ,rust-strum-0.25)
         ("rust-serde-json" ,rust-serde-json-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-regex-lite" ,rust-regex-lite-0.1)
         ("rust-rand" ,rust-rand-0.8)
         ("rust-quad-rand" ,rust-quad-rand-0.2)
         ("rust-num-bigint" ,rust-num-bigint-0.4)
         ("rust-log" ,rust-log-0.4)
         ("rust-libflate" ,rust-libflate-2)
         ("rust-lazy-static" ,rust-lazy-static-1)
         ("rust-digest" ,rust-digest-0.10))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-arboard-3
  (package
    (name "rust-arboard")
    (version "3.4.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "arboard" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "12bzkkfgb8dy2hizf8928hs1sai4yhqbrg55a0a8zzz86fah1d4z"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-x11rb" ,rust-x11rb-0.13)
         ("rust-windows-sys" ,rust-windows-sys-0.48)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-objc2-foundation"
          ,rust-objc2-foundation-0.2)
         ("rust-objc2-app-kit" ,rust-objc2-app-kit-0.2)
         ("rust-objc2" ,rust-objc2-0.5)
         ("rust-log" ,rust-log-0.4)
         ("rust-image" ,rust-image-0.25)
         ("rust-core-graphics" ,rust-core-graphics-0.23)
         ("rust-clipboard-win" ,rust-clipboard-win-5))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-array-init-2
  (package
    (name "rust-array-init")
    (version "2.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "array-init" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1z0bh6grrkxlbknq3xyipp42rasngi806y92fiddyb2n99lvfqix"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-array-init-cursor-0.2
  (package
    (name "rust-array-init-cursor")
    (version "0.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "array-init-cursor" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0xpbqf7qkvzplpjd7f0wbcf2n1v9vygdccwxkd1amxp4il0hlzdz"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-arrayvec-0.7
  (package
    (name "rust-arrayvec")
    (version "0.7.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "arrayvec" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "04b7n722jij0v3fnm3qk072d5ysc2q30rl9fz33zpfhzah30mlwn"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-arrow-array-42
  (package
    (name "rust-arrow-array")
    (version "42.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "arrow-array" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1yv0swbrikb2fh2966qm1izixjv1v0wcj1zkjsnlqc112790z6pa"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num" ,rust-num-0.4)
         ("rust-hashbrown" ,rust-hashbrown-0.14)
         ("rust-half" ,rust-half-2)
         ("rust-chrono" ,rust-chrono-0.4)
         ("rust-arrow-schema" ,rust-arrow-schema-42)
         ("rust-arrow-data" ,rust-arrow-data-42)
         ("rust-arrow-buffer" ,rust-arrow-buffer-42)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-arrow-buffer-42
  (package
    (name "rust-arrow-buffer")
    (version "42.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "arrow-buffer" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1sz9f8a4w1r594a6851qib2bplmc7gxvby6f4d700warrwp39kih"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num" ,rust-num-0.4)
         ("rust-half" ,rust-half-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-arrow-cast-42
  (package
    (name "rust-arrow-cast")
    (version "42.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "arrow-cast" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "11ghcl6sk8f61ddn4ckvyl87c4lkymqbfkgfw81bpar7gp7a152b"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num" ,rust-num-0.4)
         ("rust-lexical-core" ,rust-lexical-core-0.8)
         ("rust-half" ,rust-half-2)
         ("rust-chrono" ,rust-chrono-0.4)
         ("rust-arrow-select" ,rust-arrow-select-42)
         ("rust-arrow-schema" ,rust-arrow-schema-42)
         ("rust-arrow-data" ,rust-arrow-data-42)
         ("rust-arrow-buffer" ,rust-arrow-buffer-42)
         ("rust-arrow-array" ,rust-arrow-array-42))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-arrow-data-42
  (package
    (name "rust-arrow-data")
    (version "42.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "arrow-data" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1hix53klh2ggnc0ifxg1rw9x7nfnc6yd61jifq3njgd5svd876hx"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num" ,rust-num-0.4)
         ("rust-half" ,rust-half-2)
         ("rust-arrow-schema" ,rust-arrow-schema-42)
         ("rust-arrow-buffer" ,rust-arrow-buffer-42))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-arrow-format-0.8
  (package
    (name "rust-arrow-format")
    (version "0.8.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "arrow-format" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1irj67p6c224dzw86jr7j3z9r5zfid52gy6ml8rdqk4r2si4x207"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-planus" ,rust-planus-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-arrow-ipc-42
  (package
    (name "rust-arrow-ipc")
    (version "42.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "arrow-ipc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "05mhz7x04kna974wbny6fc4jqy4qial4sxrqdcwf0m5873jaavd4"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-flatbuffers" ,rust-flatbuffers-23)
         ("rust-arrow-schema" ,rust-arrow-schema-42)
         ("rust-arrow-data" ,rust-arrow-data-42)
         ("rust-arrow-cast" ,rust-arrow-cast-42)
         ("rust-arrow-buffer" ,rust-arrow-buffer-42)
         ("rust-arrow-array" ,rust-arrow-array-42))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-arrow-schema-42
  (package
    (name "rust-arrow-schema")
    (version "42.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "arrow-schema" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0r921wmjnyynqvzbhn47b29vbs4n88fjijsp2jnrfz9dpm2x57ms"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-arrow-select-42
  (package
    (name "rust-arrow-select")
    (version "42.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "arrow-select" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1l5yrvhj06qv8xhdkdqf35vwdax3vpsa0r5f9g8b2rf5xdmbvj8d"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num" ,rust-num-0.4)
         ("rust-arrow-schema" ,rust-arrow-schema-42)
         ("rust-arrow-data" ,rust-arrow-data-42)
         ("rust-arrow-buffer" ,rust-arrow-buffer-42)
         ("rust-arrow-array" ,rust-arrow-array-42))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-arrow2-0.17
  (package
    (name "rust-arrow2")
    (version "0.17.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "arrow2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1yh40rdx0hwyag621byl6rk8w2jzvgvsj78sg1yp82qlxbd6ii2r"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-simdutf8" ,rust-simdutf8-0.1)
         ("rust-rustc-version" ,rust-rustc-version-0.4)
         ("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-hash-hasher" ,rust-hash-hasher-2)
         ("rust-getrandom" ,rust-getrandom-0.2)
         ("rust-foreign-vec" ,rust-foreign-vec-0.1)
         ("rust-ethnum" ,rust-ethnum-1)
         ("rust-either" ,rust-either-1)
         ("rust-dyn-clone" ,rust-dyn-clone-1)
         ("rust-comfy-table" ,rust-comfy-table-6)
         ("rust-chrono" ,rust-chrono-0.4)
         ("rust-bytemuck" ,rust-bytemuck-1)
         ("rust-arrow-format" ,rust-arrow-format-0.8)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ash-0.37
  (package
    (name "rust-ash")
    (version "0.37.3+1.3.251")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ash" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0jndbsi5c8xifh4fdp378xpbyzdhs7y38hmbhih0lsv8bn1w7s9r"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libloading" ,rust-libloading-0.7))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ashpd-0.6
  (package
    (name "rust-ashpd")
    (version "0.6.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ashpd" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "109d7w6v0rnpy9lv4kmhwgh0sff0440s2vybj1k0ik4ib3d2xhja"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zbus" ,rust-zbus-3)
         ("rust-url" ,rust-url-2)
         ("rust-serde-repr" ,rust-serde-repr-0.1)
         ("rust-serde" ,rust-serde-1)
         ("rust-rand" ,rust-rand-0.8)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-futures-util" ,rust-futures-util-0.3)
         ("rust-futures-channel"
          ,rust-futures-channel-0.3)
         ("rust-enumflags2" ,rust-enumflags2-0.7)
         ("rust-async-net" ,rust-async-net-2)
         ("rust-async-fs" ,rust-async-fs-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-broadcast-0.5
  (package
    (name "rust-async-broadcast")
    (version "0.5.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-broadcast" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0avdqbci1qdlfc4glc3wqrb0wi5ffc7bqv2q1wg14syayvdwqj3w"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-futures-core" ,rust-futures-core-0.3)
         ("rust-event-listener" ,rust-event-listener-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-channel-2
  (package
    (name "rust-async-channel")
    (version "2.3.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-channel" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0skvwxj6ysfc6d7bhczz9a2550260g62bm5gl0nmjxxyn007id49"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-futures-core" ,rust-futures-core-0.3)
         ("rust-event-listener-strategy"
          ,rust-event-listener-strategy-0.5)
         ("rust-concurrent-queue"
          ,rust-concurrent-queue-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-executor-1
  (package
    (name "rust-async-executor")
    (version "1.11.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-executor" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "16mj0v0ahpidhvyl739gh8dlnzp4qhi8p3ynk48kbcvq743040mi"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-slab" ,rust-slab-0.4)
         ("rust-futures-lite" ,rust-futures-lite-2)
         ("rust-fastrand" ,rust-fastrand-2)
         ("rust-concurrent-queue"
          ,rust-concurrent-queue-2)
         ("rust-async-task" ,rust-async-task-4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-fs-1
  (package
    (name "rust-async-fs")
    (version "1.6.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-fs" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "01if2h77mry9cnm91ql2md595108i2c1bfy9gaivzvjfcl2gk717"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-futures-lite" ,rust-futures-lite-1)
         ("rust-blocking" ,rust-blocking-1)
         ("rust-autocfg" ,rust-autocfg-1)
         ("rust-async-lock" ,rust-async-lock-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-fs-2
  (package
    (name "rust-async-fs")
    (version "2.1.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-fs" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0jp0p7lg9zqy2djgdmivbzx0yqmfn9sm2s9dkhaws3zlharhkkgb"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-futures-lite" ,rust-futures-lite-2)
         ("rust-blocking" ,rust-blocking-1)
         ("rust-async-lock" ,rust-async-lock-3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-io-1
  (package
    (name "rust-async-io")
    (version "1.13.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-io" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1byj7lpw0ahk6k63sbc9859v68f28hpaab41dxsjj1ggjdfv9i8g"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-waker-fn" ,rust-waker-fn-1)
         ("rust-socket2" ,rust-socket2-0.4)
         ("rust-slab" ,rust-slab-0.4)
         ("rust-rustix" ,rust-rustix-0.37)
         ("rust-polling" ,rust-polling-2)
         ("rust-parking" ,rust-parking-2)
         ("rust-log" ,rust-log-0.4)
         ("rust-futures-lite" ,rust-futures-lite-1)
         ("rust-concurrent-queue"
          ,rust-concurrent-queue-2)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-autocfg" ,rust-autocfg-1)
         ("rust-async-lock" ,rust-async-lock-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-io-2
  (package
    (name "rust-async-io")
    (version "2.3.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-io" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "110847w0ycfhklm3i928avd28x7lf9amblr2wjngi8ngk7sv1k6w"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52)
         ("rust-tracing" ,rust-tracing-0.1)
         ("rust-slab" ,rust-slab-0.4)
         ("rust-rustix" ,rust-rustix-0.38)
         ("rust-polling" ,rust-polling-3)
         ("rust-parking" ,rust-parking-2)
         ("rust-futures-lite" ,rust-futures-lite-2)
         ("rust-futures-io" ,rust-futures-io-0.3)
         ("rust-concurrent-queue"
          ,rust-concurrent-queue-2)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-async-lock" ,rust-async-lock-3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-lock-2
  (package
    (name "rust-async-lock")
    (version "2.8.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-lock" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0asq5xdzgp3d5m82y5rg7a0k9q0g95jy6mgc7ivl334x7qlp4wi8"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-event-listener" ,rust-event-listener-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-lock-3
  (package
    (name "rust-async-lock")
    (version "3.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-lock" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0yxflkfw46rad4lv86f59b5z555dlfmg1riz1n8830rgi0qb8d6h"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-event-listener-strategy"
          ,rust-event-listener-strategy-0.4)
         ("rust-event-listener" ,rust-event-listener-4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-net-2
  (package
    (name "rust-async-net")
    (version "2.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-net" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1xyc5a5vcp3a7h1q2lbfh79wz8136dig4q4x6g4w2ws8ml7h0j5r"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-futures-lite" ,rust-futures-lite-2)
         ("rust-blocking" ,rust-blocking-1)
         ("rust-async-io" ,rust-async-io-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-once-cell-0.5
  (package
    (name "rust-async-once-cell")
    (version "0.5.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-once-cell" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ss2ll9r92jiv4g0fdnwqggs3dn48sakij3fg0ba95dag077jf4k"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-process-1
  (package
    (name "rust-async-process")
    (version "1.8.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-process" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "126s968lvhg9rlwsnxp7wfzkfn7rl87p0dlvqqlibn081ax3hr7a"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.48)
         ("rust-rustix" ,rust-rustix-0.38)
         ("rust-futures-lite" ,rust-futures-lite-1)
         ("rust-event-listener" ,rust-event-listener-3)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-blocking" ,rust-blocking-1)
         ("rust-async-signal" ,rust-async-signal-0.2)
         ("rust-async-lock" ,rust-async-lock-2)
         ("rust-async-io" ,rust-async-io-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-recursion-1
  (package
    (name "rust-async-recursion")
    (version "1.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-recursion" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "04ac4zh8qz2xjc79lmfi4jlqj5f92xjvfaqvbzwkizyqd4pl4hrv"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-signal-0.2
  (package
    (name "rust-async-signal")
    (version "0.2.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-signal" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1nmgyb3a3n2k7yh37jx1ndkb3jxh41sxr6cgnxxrq0rmqf8n3rmg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52)
         ("rust-slab" ,rust-slab-0.4)
         ("rust-signal-hook-registry"
          ,rust-signal-hook-registry-1)
         ("rust-rustix" ,rust-rustix-0.38)
         ("rust-futures-io" ,rust-futures-io-0.3)
         ("rust-futures-core" ,rust-futures-core-0.3)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-atomic-waker" ,rust-atomic-waker-1)
         ("rust-async-lock" ,rust-async-lock-3)
         ("rust-async-io" ,rust-async-io-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-task-4
  (package
    (name "rust-async-task")
    (version "4.7.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-task" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1pp3avr4ri2nbh7s6y9ws0397nkx1zymmcr14sq761ljarh3axcb"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-async-trait-0.1
  (package
    (name "rust-async-trait")
    (version "0.1.80")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "async-trait" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1jip2xkv8l67bbg6jrz3b1sdb7api77vy38wrjl7sfkmya3j1yn6"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-atomic-waker-1
  (package
    (name "rust-atomic-waker")
    (version "1.1.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "atomic-waker" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1h5av1lw56m0jf0fd3bchxq8a30xv0b4wv8s4zkp4s0i7mfvs18m"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-atspi-0.19
  (package
    (name "rust-atspi")
    (version "0.19.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "atspi" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1jl7iv3bvnabg5jd4cpf8ba7zz2dbhk39cr70yh3wnbgmd8g6nb0"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-atspi-proxies" ,rust-atspi-proxies-0.3)
         ("rust-atspi-connection"
          ,rust-atspi-connection-0.3)
         ("rust-atspi-common" ,rust-atspi-common-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-atspi-common-0.3
  (package
    (name "rust-atspi-common")
    (version "0.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "atspi-common" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1xfdn94r697l98669gsq04rpfxysivkc4cn65fb1yhyjcvwrbbwj"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zvariant" ,rust-zvariant-3)
         ("rust-zbus-names" ,rust-zbus-names-2)
         ("rust-zbus" ,rust-zbus-3)
         ("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-enumflags2" ,rust-enumflags2-0.7))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-atspi-connection-0.3
  (package
    (name "rust-atspi-connection")
    (version "0.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "atspi-connection" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0fdrfsgjg3d84mkk6nk3knqz0ygryfdmsn1d7c74qvgqf1ymxim0"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zbus" ,rust-zbus-3)
         ("rust-futures-lite" ,rust-futures-lite-1)
         ("rust-atspi-proxies" ,rust-atspi-proxies-0.3)
         ("rust-atspi-common" ,rust-atspi-common-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-atspi-proxies-0.3
  (package
    (name "rust-atspi-proxies")
    (version "0.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "atspi-proxies" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0lmvfycsrach6phz1ymcg9lks8iqiy6bxp2njci7lgkhfc96d5b4"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zbus" ,rust-zbus-3)
         ("rust-serde" ,rust-serde-1)
         ("rust-atspi-common" ,rust-atspi-common-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-atty-0.2
  (package
    (name "rust-atty")
    (version "0.2.14")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "atty" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1s7yslcs6a28c5vz7jwj63lkfgyx8mx99fdirlhi9lbhhzhrpcyr"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi" ,rust-winapi-0.3)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-hermit-abi" ,rust-hermit-abi-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-autocfg-1
  (package
    (name "rust-autocfg")
    (version "1.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "autocfg" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1c3njkfzpil03k92q0mij5y1pkhhfr4j3bf0h53bgl2vs85lsjqc"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-az-1
  (package
    (name "rust-az")
    (version "1.2.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "az" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ww9k1w3al7x5qmb7f13v3s9c2pg1pdxbs8xshqy6zyrchj4qzkv"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-backtrace-0.3
  (package
    (name "rust-backtrace")
    (version "0.3.71")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "backtrace" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "17bgd7pbjb9gc8q47qwsg2lmy9i62x3bsjmmnjrwh5z8s805ic16"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-rustc-demangle" ,rust-rustc-demangle-0.1)
         ("rust-object" ,rust-object-0.32)
         ("rust-miniz-oxide" ,rust-miniz-oxide-0.7)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-cc" ,rust-cc-1)
         ("rust-addr2line" ,rust-addr2line-0.21))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-base64-0.13
  (package
    (name "rust-base64")
    (version "0.13.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "base64" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1s494mqmzjb766fy1kqlccgfg2sdcjb6hzbvzqv2jw65fdi5h6wy"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-base64-0.21
  (package
    (name "rust-base64")
    (version "0.21.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "base64" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0rw52yvsk75kar9wgqfwgb414kvil1gn7mqkrhn9zf1537mpsacx"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-base64-0.22
  (package
    (name "rust-base64")
    (version "0.22.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "base64" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1imqzgh7bxcikp5vx3shqvw9j09g9ly0xr0jma0q66i52r7jbcvj"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-bincode-1
  (package
    (name "rust-bincode")
    (version "1.3.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "bincode" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1bfw3mnwzx5g1465kiqllp5n4r10qrqy88kdlp3jfwnq2ya5xx5i"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-bit-set-0.5
  (package
    (name "rust-bit-set")
    (version "0.5.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "bit-set" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1wcm9vxi00ma4rcxkl3pzzjli6ihrpn9cfdi0c5b4cvga2mxs007"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-bit-vec" ,rust-bit-vec-0.6))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-bit-vec-0.6
  (package
    (name "rust-bit-vec")
    (version "0.6.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "bit-vec" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ywqjnv60cdh1slhz67psnp422md6jdliji6alq0gmly2xm9p7rl"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-bitflags-1
  (package
    (name "rust-bitflags")
    (version "1.3.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "bitflags" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "12ki6w8gn1ldq7yz9y680llwk5gmrhrzszaa17g1sbrw2r2qvwxy"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-bitflags-2
  (package
    (name "rust-bitflags")
    (version "2.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "bitflags" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1h91vdx1il069vdiiissj8ymzj130rbiic0dbs77yxjgjim9sjyg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-bytemuck" ,rust-bytemuck-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-block-0.1
  (package
    (name "rust-block")
    (version "0.1.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "block" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "16k9jgll25pzsq14f244q22cdv0zb4bqacldg3kx6h89d7piz30d"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-block-buffer-0.10
  (package
    (name "rust-block-buffer")
    (version "0.10.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "block-buffer" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0w9sa2ypmrsqqvc20nhwr75wbb5cjr4kkyhpjm1z1lv2kdicfy1h"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-generic-array" ,rust-generic-array-0.14))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-block-sys-0.1
  (package
    (name "rust-block-sys")
    (version "0.1.0-beta.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "block-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ihiar08hk0das4q0ii1gsmql975z3rslli1h13jb44hxr0mg98g"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc-sys" ,rust-objc-sys-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-block2-0.2
  (package
    (name "rust-block2")
    (version "0.2.0-alpha.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "block2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0hpcdl81rmwvhfni9413hrg1wd4xwf6vhch3yv15bxs42wyfdncd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc2-encode" ,rust-objc2-encode-2)
         ("rust-block-sys" ,rust-block-sys-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-block2-0.5
  (package
    (name "rust-block2")
    (version "0.5.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "block2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0pyiha5his2grzqr3mynmq244laql2j20992i59asp0gy7mjw4rc"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc2" ,rust-objc2-0.5))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-blocking-1
  (package
    (name "rust-blocking")
    (version "1.6.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "blocking" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "123yf6slr47jnwnmhimkhgkx5rqzr9x28d7b19pkbdv2x4272ps9"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-piper" ,rust-piper-0.2)
         ("rust-futures-lite" ,rust-futures-lite-2)
         ("rust-futures-io" ,rust-futures-io-0.3)
         ("rust-async-task" ,rust-async-task-4)
         ("rust-async-lock" ,rust-async-lock-3)
         ("rust-async-channel" ,rust-async-channel-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-brotli-3
  (package
    (name "rust-brotli")
    (version "3.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "brotli" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "14f34ml3i8qbnh4hhlv5r6j10bkx420gspsl1cgznl1wqrdx4h6n"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-brotli-decompressor"
          ,rust-brotli-decompressor-2)
         ("rust-alloc-stdlib" ,rust-alloc-stdlib-0.2)
         ("rust-alloc-no-stdlib" ,rust-alloc-no-stdlib-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-brotli-decompressor-2
  (package
    (name "rust-brotli-decompressor")
    (version "2.5.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "brotli-decompressor" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0kyyh9701dwqzwvn2frff4ww0zibikqd1s1xvl7n1pfpc3z4lbjf"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-alloc-stdlib" ,rust-alloc-stdlib-0.2)
         ("rust-alloc-no-stdlib" ,rust-alloc-no-stdlib-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-bstr-0.2
  (package
    (name "rust-bstr")
    (version "0.2.17")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "bstr" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "08rjbhysy6gg27db2h3pnhvr2mlr5vkj797i9625kwg8hgrnjdds"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-regex-automata" ,rust-regex-automata-0.1)
         ("rust-memchr" ,rust-memchr-2)
         ("rust-lazy-static" ,rust-lazy-static-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-bumpalo-3
  (package
    (name "rust-bumpalo")
    (version "3.16.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "bumpalo" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0b015qb4knwanbdlp1x48pkb4pm57b8gidbhhhxr900q2wb6fabr"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-bytecount-0.6
  (package
    (name "rust-bytecount")
    (version "0.6.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "bytecount" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1klqfjwn41fwmcqw4z03v6i4imgrf7lmf3b5s9v74hxir8hrps2w"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-bytemuck-1
  (package
    (name "rust-bytemuck")
    (version "1.16.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "bytemuck" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "19dwdvjri09mhgrngy0737965pchm25ix2yma8sgwpjxrcalr0vq"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-bytemuck-derive" ,rust-bytemuck-derive-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-bytemuck-derive-1
  (package
    (name "rust-bytemuck-derive")
    (version "1.6.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "bytemuck_derive" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0289v33y8ls2xc6ilmg13ljhixf9jghb4wr043wdimdylprgm71n"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-byteorder-1
  (package
    (name "rust-byteorder")
    (version "1.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "byteorder" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0jzncxyf404mwqdbspihyzpkndfgda450l0893pz5xj685cg5l0z"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-bytes-1
  (package
    (name "rust-bytes")
    (version "1.6.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "bytes" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1jf2awc1fywpk15m6pxay3wqcg65ararg9xi4b08vnszwiyy2kai"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-calloop-0.10
  (package
    (name "rust-calloop")
    (version "0.10.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "calloop" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1a04jp2v80rla3pqh6fwqqyn6yklqq0n5nnjjwd3f97an47d1q2j"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-vec-map" ,rust-vec-map-0.8)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-slotmap" ,rust-slotmap-1)
         ("rust-nix" ,rust-nix-0.25)
         ("rust-log" ,rust-log-0.4)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-camino-1
  (package
    (name "rust-camino")
    (version "1.1.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "camino" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ff28kc3qjcrmi8k88b2j2p7mzrvbag20yqcrj9sl30n3fanpv70"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-cargo-platform-0.1
  (package
    (name "rust-cargo-platform")
    (version "0.1.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "cargo-platform" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1z5b7ivbj508wkqdg2vb0hw4vi1k1pyhcn6h1h1b8svcb8vg1c94"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-cargo-metadata-0.14
  (package
    (name "rust-cargo-metadata")
    (version "0.14.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "cargo_metadata" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1yl1y40vby9cas4dlfc44szrbl4m4z3pahv3p6ckdqp8ksfv1jsa"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde-json" ,rust-serde-json-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-semver" ,rust-semver-1)
         ("rust-cargo-platform" ,rust-cargo-platform-0.1)
         ("rust-camino" ,rust-camino-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-cargo-metadata-0.18
  (package
    (name "rust-cargo-metadata")
    (version "0.18.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "cargo_metadata" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0drh0zndl4qgndy6kg6783cydbvhxgv0hcg7d9hhqx0zwi3nb21d"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-thiserror" ,rust-thiserror-1)
         ("rust-serde-json" ,rust-serde-json-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-semver" ,rust-semver-1)
         ("rust-cargo-platform" ,rust-cargo-platform-0.1)
         ("rust-camino" ,rust-camino-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-cc-1
  (package
    (name "rust-cc")
    (version "1.0.98")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "cc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0gzhij74hblfkzwwyysdc8crfd6fr0m226vzmijmwwhdakkp1hj1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-once-cell" ,rust-once-cell-1)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-jobserver" ,rust-jobserver-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-cesu8-1
  (package
    (name "rust-cesu8")
    (version "1.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "cesu8" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0g6q58wa7khxrxcxgnqyi9s1z2cjywwwd3hzr5c55wskhx6s0hvd"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-cfb-0.7
  (package
    (name "rust-cfb")
    (version "0.7.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "cfb" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "03y6p3dlm7gfds19bq4ba971za16rjbn7q2v0vqcri52l2kjv3yk"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-uuid" ,rust-uuid-1)
         ("rust-fnv" ,rust-fnv-1)
         ("rust-byteorder" ,rust-byteorder-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-cfg-if-1
  (package
    (name "rust-cfg-if")
    (version "1.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "cfg-if" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1za0vb97n4brpzpv8lsbnzmq5r8f2b0cpqqr0sy8h5bn751xxwds"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-cfg-aliases-0.1
  (package
    (name "rust-cfg-aliases")
    (version "0.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "cfg_aliases" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "17p821nc6jm830vzl2lmwz60g3a30hcm33nk6l257i1rjdqw85px"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-cfg-aliases-0.2
  (package
    (name "rust-cfg-aliases")
    (version "0.2.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "cfg_aliases" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "092pxdc1dbgjb6qvh83gk56rkic2n2ybm4yvy76cgynmzi3zwfk1"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-chrono-0.4
  (package
    (name "rust-chrono")
    (version "0.4.38")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "chrono" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "009l8vc5p8750vn02z30mblg4pv2qhkbfizhfwmzc6vpy5nr67x2"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-targets"
          ,rust-windows-targets-0.52)
         ("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-iana-time-zone" ,rust-iana-time-zone-0.1)
         ("rust-android-tzdata" ,rust-android-tzdata-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-clang-format-0.3
  (package
    (name "rust-clang-format")
    (version "0.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "clang-format" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0hwr869fr1956x47rd6y5sb1c7ajyvjr4jv1xq4d4f8s1ss86qk9"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-thiserror" ,rust-thiserror-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-clap-4
  (package
    (name "rust-clap")
    (version "4.5.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "clap" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1828wm9qws5gh2xnimnvmp2vria6d6hsxnqmhnm84dwjcxm0dg4h"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-clap-derive" ,rust-clap-derive-4)
         ("rust-clap-builder" ,rust-clap-builder-4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-clap-builder-4
  (package
    (name "rust-clap-builder")
    (version "4.5.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "clap_builder" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1d7p4hph4fyhaphkf0v5zv0kq4lz25a9jq2f901yrq3afqp9w4mf"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-strsim" ,rust-strsim-0.11)
         ("rust-clap-lex" ,rust-clap-lex-0.7)
         ("rust-anstyle" ,rust-anstyle-1)
         ("rust-anstream" ,rust-anstream-0.6))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-clap-derive-4
  (package
    (name "rust-clap-derive")
    (version "4.5.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "clap_derive" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0r2gs2p10pb435w52xzsgz2mmx5qd3qfkmk29y4mbz9ph11k30aj"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1)
         ("rust-heck" ,rust-heck-0.5))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-clap-lex-0.7
  (package
    (name "rust-clap-lex")
    (version "0.7.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "clap_lex" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1kh1sckgq71kay2rrr149pl9gbsrvyccsq6xm5xpnq0cxnyqzk4q"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-clean-path-0.2
  (package
    (name "rust-clean-path")
    (version "0.2.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "clean-path" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "19dna3ln8rbzhapijwjdxh54i9a15jvhjz3bpzlkgmx5cfrb99ma"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-clipboard-win-5
  (package
    (name "rust-clipboard-win")
    (version "5.3.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "clipboard-win" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ba48760mbzv6jsfxbqyhf3zdp86ix3p4adgrsd0vqj4a4zlgx3r"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-error-code" ,rust-error-code-3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-cocoa-0.24
  (package
    (name "rust-cocoa")
    (version "0.24.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "cocoa" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0flg2cwpqxyvsr1v3f54vi3d3qmbr1sn7gf3mr6nhb056xwxn9gl"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc" ,rust-objc-0.2)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-foreign-types" ,rust-foreign-types-0.3)
         ("rust-core-graphics" ,rust-core-graphics-0.22)
         ("rust-core-foundation"
          ,rust-core-foundation-0.9)
         ("rust-cocoa-foundation"
          ,rust-cocoa-foundation-0.1)
         ("rust-block" ,rust-block-0.1)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-cocoa-foundation-0.1
  (package
    (name "rust-cocoa-foundation")
    (version "0.1.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "cocoa-foundation" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1xwk1khdyqw3dwsl15vr8p86shdcn544fr60ass8biz4nb5k8qlc"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc" ,rust-objc-0.2)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-core-graphics-types"
          ,rust-core-graphics-types-0.1)
         ("rust-core-foundation"
          ,rust-core-foundation-0.9)
         ("rust-block" ,rust-block-0.1)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-codespan-reporting-0.11
  (package
    (name "rust-codespan-reporting")
    (version "0.11.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "codespan-reporting" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0vkfay0aqk73d33kh79k1kqxx06ka22894xhqi89crnc6c6jff1m"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-unicode-width" ,rust-unicode-width-0.1)
         ("rust-termcolor" ,rust-termcolor-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-color-quant-1
  (package
    (name "rust-color-quant")
    (version "1.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "color_quant" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "12q1n427h2bbmmm1mnglr57jaz2dj9apk0plcxw7nwqiai7qjyrx"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-colorchoice-1
  (package
    (name "rust-colorchoice")
    (version "1.0.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "colorchoice" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "08h4jsrd2j5k6lp1b9v5p1f1g7cmyzm4djsvb3ydywdb4hmqashb"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-com-rs-0.2
  (package
    (name "rust-com-rs")
    (version "0.2.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "com-rs" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0hk6051kwpabjs2dx32qkkpy0xrliahpqfh9df292aa0fv2yshxz"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-combine-4
  (package
    (name "rust-combine")
    (version "4.6.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "combine" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1z8rh8wp59gf8k23ar010phgs0wgf5i8cx4fg01gwcnzfn5k0nms"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-memchr" ,rust-memchr-2)
         ("rust-bytes" ,rust-bytes-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-comfy-table-6
  (package
    (name "rust-comfy-table")
    (version "6.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "comfy-table" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1fmqjhry6xa6a9kr0769wiw06694n60kxs5c6nfvzqv8h9w9v5by"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-unicode-width" ,rust-unicode-width-0.1)
         ("rust-strum-macros" ,rust-strum-macros-0.24)
         ("rust-strum" ,rust-strum-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-concurrent-queue-2
  (package
    (name "rust-concurrent-queue")
    (version "2.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "concurrent-queue" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0wrr3mzq2ijdkxwndhf79k952cp4zkz35ray8hvsxl96xrx1k82c"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-crossbeam-utils"
          ,rust-crossbeam-utils-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-console-0.15
  (package
    (name "rust-console")
    (version "0.15.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "console" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1sz4nl9nz8pkmapqni6py7jxzi7nzqjxzb3ya4kxvmkb0zy867qf"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52)
         ("rust-unicode-width" ,rust-unicode-width-0.1)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-lazy-static" ,rust-lazy-static-1)
         ("rust-encode-unicode" ,rust-encode-unicode-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-const-random-0.1
  (package
    (name "rust-const-random")
    (version "0.1.18")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "const-random" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0n8kqz3y82ks8znvz1mxn3a9hadca3amzf33gmi6dc3lzs103q47"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-const-random-macro"
          ,rust-const-random-macro-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-const-random-macro-0.1
  (package
    (name "rust-const-random-macro")
    (version "0.1.16")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "const-random-macro" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "03iram4ijjjq9j5a7hbnmdngj8935wbsd0f5bm8yw2hblbr3kn7r"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-tiny-keccak" ,rust-tiny-keccak-2)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-getrandom" ,rust-getrandom-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-convert-case-0.6
  (package
    (name "rust-convert-case")
    (version "0.6.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "convert_case" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1jn1pq6fp3rri88zyw6jlhwwgf6qiyc08d6gjv0qypgkl862n67c"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-unicode-segmentation"
          ,rust-unicode-segmentation-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-core-foundation-0.9
  (package
    (name "rust-core-foundation")
    (version "0.9.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "core-foundation" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "13zvbbj07yk3b61b8fhwfzhy35535a583irf23vlcg59j7h9bqci"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2)
         ("rust-core-foundation-sys"
          ,rust-core-foundation-sys-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-core-foundation-sys-0.8
  (package
    (name "rust-core-foundation-sys")
    (version "0.8.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "core-foundation-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "13w6sdf06r0hn7bx2b45zxsg1mm2phz34jikm6xc5qrbr6djpsh6"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-core-graphics-0.22
  (package
    (name "rust-core-graphics")
    (version "0.22.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "core-graphics" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1yz4xzbz36vbmlra0viazzlicp8kap1ldgshsp5nzz4g7fmvp095"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2)
         ("rust-foreign-types" ,rust-foreign-types-0.3)
         ("rust-core-graphics-types"
          ,rust-core-graphics-types-0.1)
         ("rust-core-foundation"
          ,rust-core-foundation-0.9)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-core-graphics-0.23
  (package
    (name "rust-core-graphics")
    (version "0.23.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "core-graphics" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "10dhv3gk4kmbzl14xxkrhhky4fdp8h6nzff6h0019qgr6nz84xy0"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2)
         ("rust-foreign-types" ,rust-foreign-types-0.5)
         ("rust-core-graphics-types"
          ,rust-core-graphics-types-0.1)
         ("rust-core-foundation"
          ,rust-core-foundation-0.9)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-core-graphics-types-0.1
  (package
    (name "rust-core-graphics-types")
    (version "0.1.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "core-graphics-types" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1bxg8nxc8fk4kxnqyanhf36wq0zrjr552c58qy6733zn2ihhwfa5"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2)
         ("rust-core-foundation"
          ,rust-core-foundation-0.9)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-core2-0.4
  (package
    (name "rust-core2")
    (version "0.4.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "core2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "01f5xv0kf3ds3xm7byg78hycbanb8zlpvsfv4j47y46n3bpsg6xl"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-memchr" ,rust-memchr-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-cpufeatures-0.2
  (package
    (name "rust-cpufeatures")
    (version "0.2.12")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "cpufeatures" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "012m7rrak4girqlii3jnqwrr73gv1i980q4wra5yyyhvzwk5xzjk"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-crc32fast-1
  (package
    (name "rust-crc32fast")
    (version "1.4.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "crc32fast" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1czp7vif73b8xslr3c9yxysmh9ws2r8824qda7j47ffs9pcnjxx9"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-crossbeam-0.8
  (package
    (name "rust-crossbeam")
    (version "0.8.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "crossbeam" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1a5c7yacnk723x0hfycdbl91ks2nxhwbwy46b8y5vyy0gxzcsdqi"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-crossbeam-utils"
          ,rust-crossbeam-utils-0.8)
         ("rust-crossbeam-queue"
          ,rust-crossbeam-queue-0.3)
         ("rust-crossbeam-epoch"
          ,rust-crossbeam-epoch-0.9)
         ("rust-crossbeam-deque"
          ,rust-crossbeam-deque-0.8)
         ("rust-crossbeam-channel"
          ,rust-crossbeam-channel-0.5))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-crossbeam-channel-0.5
  (package
    (name "rust-crossbeam-channel")
    (version "0.5.13")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "crossbeam-channel" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1wkx45r34v7g3wyi3lg2wz536lrrrab4h4hh741shfhr8rlhsj1k"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-crossbeam-utils"
          ,rust-crossbeam-utils-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-crossbeam-deque-0.8
  (package
    (name "rust-crossbeam-deque")
    (version "0.8.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "crossbeam-deque" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "03bp38ljx4wj6vvy4fbhx41q8f585zyqix6pncz1mkz93z08qgv1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-crossbeam-utils"
          ,rust-crossbeam-utils-0.8)
         ("rust-crossbeam-epoch"
          ,rust-crossbeam-epoch-0.9))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-crossbeam-epoch-0.9
  (package
    (name "rust-crossbeam-epoch")
    (version "0.9.18")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "crossbeam-epoch" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "03j2np8llwf376m3fxqx859mgp9f83hj1w34153c7a9c7i5ar0jv"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-crossbeam-utils"
          ,rust-crossbeam-utils-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-crossbeam-queue-0.3
  (package
    (name "rust-crossbeam-queue")
    (version "0.3.11")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "crossbeam-queue" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0d8y8y3z48r9javzj67v3p2yfswd278myz1j9vzc4sp7snslc0yz"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-crossbeam-utils"
          ,rust-crossbeam-utils-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-crossbeam-utils-0.8
  (package
    (name "rust-crossbeam-utils")
    (version "0.8.20")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "crossbeam-utils" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "100fksq5mm1n7zj242cclkw6yf7a4a8ix3lvpfkhxvdhbda9kv12"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-crunchy-0.2
  (package
    (name "rust-crunchy")
    (version "0.2.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "crunchy" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1dx9mypwd5mpfbbajm78xcrg5lirqk7934ik980mmaffg3hdm0bs"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-crypto-common-0.1
  (package
    (name "rust-crypto-common")
    (version "0.1.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "crypto-common" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1cvby95a6xg7kxdz5ln3rl9xh66nz66w46mm3g56ri1z5x815yqv"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-typenum" ,rust-typenum-1)
         ("rust-generic-array" ,rust-generic-array-0.14))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-csv-1
  (package
    (name "rust-csv")
    (version "1.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "csv" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1zjrlycvn44fxd9m8nwy8x33r9ncgk0k3wvy4fnvb9rpsks4ymxc"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-ryu" ,rust-ryu-1)
         ("rust-itoa" ,rust-itoa-1)
         ("rust-csv-core" ,rust-csv-core-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-csv-core-0.1
  (package
    (name "rust-csv-core")
    (version "0.1.11")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "csv-core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0w7s7qa60xb054rqddpyg53xq2b29sf3rbhcl8sbdx02g4yjpyjy"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-memchr" ,rust-memchr-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-d3d12-0.7
  (package
    (name "rust-d3d12")
    (version "0.7.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "d3d12" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "084z4nz0ddmsjn6qbrgxygr55pvpi3yjrrkvmzyxs79b56ml8vp1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi" ,rust-winapi-0.3)
         ("rust-libloading" ,rust-libloading-0.8)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-darling-0.20
  (package
    (name "rust-darling")
    (version "0.20.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "darling" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1q9zdyiva4p1ly6ip4lg9y8mfk6b59n6iphpxnjxsayij16ypcl3"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-darling-macro" ,rust-darling-macro-0.20)
         ("rust-darling-core" ,rust-darling-core-0.20))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-darling-core-0.20
  (package
    (name "rust-darling-core")
    (version "0.20.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "darling_core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "086i3kisa1yq8jsskahv1ywi2qbrym8r20lram7a0wmc1gz8f9k2"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1)
         ("rust-ident-case" ,rust-ident-case-1)
         ("rust-fnv" ,rust-fnv-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-darling-macro-0.20
  (package
    (name "rust-darling-macro")
    (version "0.20.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "darling_macro" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0y015yy33p85sgpq7shm49clss78p71871gf7sss3cc26jsang3k"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-darling-core" ,rust-darling-core-0.20))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-dary-heap-0.3
  (package
    (name "rust-dary-heap")
    (version "0.3.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "dary_heap" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1jm04p72s7xij3cr71h59dw07s63nah5b10sh8akcr2129zx2qkp"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-dashmap-5
  (package
    (name "rust-dashmap")
    (version "5.5.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "dashmap" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0miqnlxi501vfbv6mw5jbmzgnj0wjrch3p4abvpd59s9v30lg1wp"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-rayon" ,rust-rayon-1)
         ("rust-parking-lot-core"
          ,rust-parking-lot-core-0.9)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-lock-api" ,rust-lock-api-0.4)
         ("rust-hashbrown" ,rust-hashbrown-0.14)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-data-encoding-2
  (package
    (name "rust-data-encoding")
    (version "2.6.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "data-encoding" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1qnn68n4vragxaxlkqcb1r28d3hhj43wch67lm4rpxlw89wnjmp8"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-deranged-0.3
  (package
    (name "rust-deranged")
    (version "0.3.11")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "deranged" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1d1ibqqnr5qdrpw8rclwrf1myn3wf0dygl04idf4j2s49ah6yaxl"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-powerfmt" ,rust-powerfmt-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-derivative-2
  (package
    (name "rust-derivative")
    (version "2.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "derivative" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "02vpb81wisk2zh1d5f44szzxamzinqgq2k8ydrfjj2wwkrgdvhzw"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-1)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-digest-0.10
  (package
    (name "rust-digest")
    (version "0.10.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "digest" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "14p2n6ih29x81akj097lvz7wi9b6b9hvls0lwrv7b6xwyy0s5ncy"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-crypto-common" ,rust-crypto-common-0.1)
         ("rust-block-buffer" ,rust-block-buffer-0.10))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-directories-next-2
  (package
    (name "rust-directories-next")
    (version "2.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "directories-next" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1g1vq8d8mv0vp0l317gh9y46ipqg2fxjnbc7lnjhwqbsv4qf37ik"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-dirs-sys-next" ,rust-dirs-sys-next-0.1)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-dirs-sys-next-0.1
  (package
    (name "rust-dirs-sys-next")
    (version "0.1.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "dirs-sys-next" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0kavhavdxv4phzj4l0psvh55hszwnr0rcz8sxbvx20pyqi2a3gaf"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi" ,rust-winapi-0.3)
         ("rust-redox-users" ,rust-redox-users-0.4)
         ("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-dispatch-0.2
  (package
    (name "rust-dispatch")
    (version "0.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "dispatch" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0fwjr9b7582ic5689zxj8lf7zl94iklhlns3yivrnv8c9fxr635x"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-displaydoc-0.1
  (package
    (name "rust-displaydoc")
    (version "0.1.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "displaydoc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "06zl66x08jjd1lhk9hcva7v6fk4zwzjbb9p95687y48nb96sphmd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-1)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-dlib-0.5
  (package
    (name "rust-dlib")
    (version "0.5.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "dlib" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "04m4zzybx804394dnqs1blz241xcy480bdwf3w9p4k6c3l46031k"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libloading" ,rust-libloading-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-document-features-0.2
  (package
    (name "rust-document-features")
    (version "0.2.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "document-features" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "15cvgxqngxslgllz15m8aban6wqfgsi6nlhr0g25yfsnd6nq4lpg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-litrs" ,rust-litrs-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-downcast-rs-1
  (package
    (name "rust-downcast-rs")
    (version "1.2.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "downcast-rs" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1lmrq383d1yszp7mg5i7i56b17x2lnn3kb91jwsq0zykvg2jbcvm"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-dyn-clone-1
  (package
    (name "rust-dyn-clone")
    (version "1.0.17")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "dyn-clone" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "09cig7dgg6jnqa10p4233nd8wllbjf4ffsw7wj0m4lwa5w3z0vhd"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ecolor-0.24
  (package
    (name "rust-ecolor")
    (version "0.24.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ecolor" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0whrk6jxqk7jfai7z76sd9vsqqf09zzr1b0vjd97xlbl5vy3fxjb"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-bytemuck" ,rust-bytemuck-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-eframe-0.24
  (package
    (name "rust-eframe")
    (version "0.24.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "eframe" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ynw7nq1gj91ynaysy4ib3ybzx1xjzm8hwadzdz5mhr8m0c3kmyd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winit" ,rust-winit-0.28)
         ("rust-winapi" ,rust-winapi-0.3)
         ("rust-wgpu" ,rust-wgpu-0.18)
         ("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-wasm-bindgen-futures"
          ,rust-wasm-bindgen-futures-0.4)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-ron" ,rust-ron-0.8)
         ("rust-raw-window-handle"
          ,rust-raw-window-handle-0.5)
         ("rust-puffin" ,rust-puffin-0.18)
         ("rust-pollster" ,rust-pollster-0.3)
         ("rust-percent-encoding"
          ,rust-percent-encoding-2)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-objc" ,rust-objc-0.2)
         ("rust-log" ,rust-log-0.4)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-image" ,rust-image-0.24)
         ("rust-egui-glow" ,rust-egui-glow-0.24)
         ("rust-egui-winit" ,rust-egui-winit-0.24)
         ("rust-egui-wgpu" ,rust-egui-wgpu-0.24)
         ("rust-egui" ,rust-egui-0.24)
         ("rust-directories-next"
          ,rust-directories-next-2)
         ("rust-cocoa" ,rust-cocoa-0.24)
         ("rust-bytemuck" ,rust-bytemuck-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-egui-0.24
  (package
    (name "rust-egui")
    (version "0.24.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "egui" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0szfj7r2vvipcq91bb9q0wjplrap8y9bhf2sa64vhkkn9f3cnny5"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-ron" ,rust-ron-0.8)
         ("rust-puffin" ,rust-puffin-0.18)
         ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
         ("rust-log" ,rust-log-0.4)
         ("rust-epaint" ,rust-epaint-0.24)
         ("rust-backtrace" ,rust-backtrace-0.3)
         ("rust-ahash" ,rust-ahash-0.8)
         ("rust-accesskit" ,rust-accesskit-0.12))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-egui-wgpu-0.24
  (package
    (name "rust-egui-wgpu")
    (version "0.24.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "egui-wgpu" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0lshd739dd94j6qc8446z5k9m3ra18crnb5cbxibwjcn68xsg3id"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winit" ,rust-winit-0.28)
         ("rust-wgpu" ,rust-wgpu-0.18)
         ("rust-type-map" ,rust-type-map-0.5)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-puffin" ,rust-puffin-0.18)
         ("rust-log" ,rust-log-0.4)
         ("rust-epaint" ,rust-epaint-0.24)
         ("rust-egui" ,rust-egui-0.24)
         ("rust-bytemuck" ,rust-bytemuck-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-egui-winit-0.24
  (package
    (name "rust-egui-winit")
    (version "0.24.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "egui-winit" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "112f5qs7qk0lp0haadnv0brwzx9bi3br8c9sbswi4sv0nq33crrv"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winit" ,rust-winit-0.28)
         ("rust-webbrowser" ,rust-webbrowser-0.8)
         ("rust-web-time" ,rust-web-time-0.2)
         ("rust-smithay-clipboard"
          ,rust-smithay-clipboard-0.6)
         ("rust-serde" ,rust-serde-1)
         ("rust-raw-window-handle"
          ,rust-raw-window-handle-0.5)
         ("rust-puffin" ,rust-puffin-0.18)
         ("rust-log" ,rust-log-0.4)
         ("rust-egui" ,rust-egui-0.24)
         ("rust-arboard" ,rust-arboard-3)
         ("rust-accesskit-winit"
          ,rust-accesskit-winit-0.15))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-egui-commonmark-0.10
  (package
    (name "rust-egui-commonmark")
    (version "0.10.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "egui_commonmark" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "051ill43qp9mfwi6v5p57zx9jmf1s0z5bqm45z67dxdffixvwbkc"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pulldown-cmark" ,rust-pulldown-cmark-0.9)
         ("rust-egui-extras" ,rust-egui-extras-0.24)
         ("rust-egui" ,rust-egui-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-egui-extras-0.24
  (package
    (name "rust-egui-extras")
    (version "0.24.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "egui_extras" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1dapdkfmrrsvw8ynk3vwmxdnb63p2qp72gisblk5hq512yplwqlp"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-puffin" ,rust-puffin-0.18)
         ("rust-mime-guess2" ,rust-mime-guess2-2)
         ("rust-log" ,rust-log-0.4)
         ("rust-image" ,rust-image-0.24)
         ("rust-enum-map" ,rust-enum-map-2)
         ("rust-ehttp" ,rust-ehttp-0.3)
         ("rust-egui" ,rust-egui-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-egui-glow-0.24
  (package
    (name "rust-egui-glow")
    (version "0.24.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "egui_glow" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "12fl0jd53x66v774vf86n2q6w2h5krxz4ihalh17qmbwspwm2896"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-puffin" ,rust-puffin-0.18)
         ("rust-memoffset" ,rust-memoffset-0.7)
         ("rust-log" ,rust-log-0.4)
         ("rust-glow" ,rust-glow-0.12)
         ("rust-egui-winit" ,rust-egui-winit-0.24)
         ("rust-egui" ,rust-egui-0.24)
         ("rust-bytemuck" ,rust-bytemuck-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-egui-plot-0.24
  (package
    (name "rust-egui-plot")
    (version "0.24.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "egui_plot" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "04p4m8z7hx0gz260vv2nmgqz1gjj1ya1l59l1bs6lcsv3a189d19"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-egui" ,rust-egui-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-egui-tiles-0.5
  (package
    (name "rust-egui-tiles")
    (version "0.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "egui_tiles" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "02ml4qqv9859fzc0mddmc82x95nsphddzaygzvxzc7w5275fw9jq"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-log" ,rust-log-0.4)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-egui" ,rust-egui-0.24)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ehttp-0.3
  (package
    (name "rust-ehttp")
    (version "0.3.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ehttp" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0pd7cy3kr98nifdwdxqp2kh2wdfq1a8wjawygpy6myan4dk4b3zq"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-wasm-streams" ,rust-wasm-streams-0.3)
         ("rust-wasm-bindgen-futures"
          ,rust-wasm-bindgen-futures-0.4)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-ureq" ,rust-ureq-2)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-futures-util" ,rust-futures-util-0.3)
         ("rust-document-features"
          ,rust-document-features-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-either-1
  (package
    (name "rust-either")
    (version "1.12.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "either" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "12xmhlrv5gfsraimh6xaxcmb0qh6cc7w7ap4sw40ky9wfm095jix"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-emath-0.24
  (package
    (name "rust-emath")
    (version "0.24.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "emath" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1r6caqgn0ral6kxbkk6a4yn82a5l78c9s7pw2f2yjdabnk0ccid0"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-bytemuck" ,rust-bytemuck-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-encode-unicode-0.3
  (package
    (name "rust-encode-unicode")
    (version "0.3.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "encode_unicode" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "07w3vzrhxh9lpjgsg2y5bwzfar2aq35mdznvcp3zjl0ssj7d4mx3"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-enum-map-2
  (package
    (name "rust-enum-map")
    (version "2.7.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "enum-map" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1sgjgl4mmz93jdkfdsmapc3dmaq8gddagw9s0fd501w2vyzz6rk8"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-enum-map-derive"
          ,rust-enum-map-derive-0.17))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-enum-map-derive-0.17
  (package
    (name "rust-enum-map-derive")
    (version "0.17.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "enum-map-derive" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1sv4mb343rsz4lc3rh7cyn0pdhf7fk18k1dgq8kfn5i5x7gwz0pj"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-enumflags2-0.7
  (package
    (name "rust-enumflags2")
    (version "0.7.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "enumflags2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "13cfkn555q8v6rrbld8m2xjb14pnap9w1x5wv98hlpk7zgawjy1j"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-enumflags2-derive"
          ,rust-enumflags2-derive-0.7))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-enumflags2-derive-0.7
  (package
    (name "rust-enumflags2-derive")
    (version "0.7.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "enumflags2_derive" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1i1vjp2si8jq7cib97c26d3cysm0xip30fs5f84l46qv0xs54y2w"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-enumn-0.1
  (package
    (name "rust-enumn")
    (version "0.1.13")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "enumn" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0hnvrp440hwjfd4navbni2mhcjd63adxp8ryk6z3prw8d7yh1l3g"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-enumset-1
  (package
    (name "rust-enumset")
    (version "1.1.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "enumset" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0z80d7v4fih563ysg8vny8kpspk3y340v7ncwmbzn4rc8skhsv12"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-enumset-derive" ,rust-enumset-derive-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-enumset-derive-0.8
  (package
    (name "rust-enumset-derive")
    (version "0.8.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "enumset_derive" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1bykfx8qm48payzbksna5vg1ddxbgc6a2jwn8j4g0w1dp1m6r2z0"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1)
         ("rust-darling" ,rust-darling-0.20))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-env-logger-0.7
  (package
    (name "rust-env-logger")
    (version "0.7.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "env_logger" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0djx8h8xfib43g5w94r1m1mkky5spcw4wblzgnhiyg5vnfxknls4"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-termcolor" ,rust-termcolor-1)
         ("rust-regex" ,rust-regex-1)
         ("rust-log" ,rust-log-0.4)
         ("rust-humantime" ,rust-humantime-1)
         ("rust-atty" ,rust-atty-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-env-logger-0.10
  (package
    (name "rust-env-logger")
    (version "0.10.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "env_logger" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1005v71kay9kbz1d5907l0y7vh9qn2fqsp2yfgb8bjvin6m0bm2c"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-termcolor" ,rust-termcolor-1)
         ("rust-log" ,rust-log-0.4)
         ("rust-is-terminal" ,rust-is-terminal-0.4)
         ("rust-humantime" ,rust-humantime-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-epaint-0.24
  (package
    (name "rust-epaint")
    (version "0.24.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "epaint" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1f7szv3waqb5jcip4v3zfwzqpqjvfkvzjy6f6nsvkfi11l09w6vx"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
         ("rust-log" ,rust-log-0.4)
         ("rust-emath" ,rust-emath-0.24)
         ("rust-ecolor" ,rust-ecolor-0.24)
         ("rust-bytemuck" ,rust-bytemuck-1)
         ("rust-ahash" ,rust-ahash-0.8)
         ("rust-ab-glyph" ,rust-ab-glyph-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-equivalent-1
  (package
    (name "rust-equivalent")
    (version "1.0.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "equivalent" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1malmx5f4lkfvqasz319lq6gb3ddg19yzf9s8cykfsgzdmyq0hsl"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-errno-0.3
  (package
    (name "rust-errno")
    (version "0.3.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "errno" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1fi0m0493maq1jygcf1bya9cymz2pc1mqxj26bdv7yjd37v5qk2k"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52)
         ("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-error-chain-0.12
  (package
    (name "rust-error-chain")
    (version "0.12.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "error-chain" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1z6y5isg0il93jp287sv7pn10i4wrkik2cpyk376wl61rawhcbrd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-version-check" ,rust-version-check-0.9))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-error-code-3
  (package
    (name "rust-error-code")
    (version "3.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "error-code" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0nqpbhi501z3ydaxg4kjyb68xcw025cj22prwabiky0xsljl8ix0"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ethnum-1
  (package
    (name "rust-ethnum")
    (version "1.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ethnum" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0b68ngvisb0d40vc6h30zlhghbb3mc8wlxjbf8gnmavk1dca435r"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-event-listener-2
  (package
    (name "rust-event-listener")
    (version "2.5.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "event-listener" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1q4w3pndc518crld6zsqvvpy9lkzwahp2zgza9kbzmmqh9gif1h2"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-event-listener-3
  (package
    (name "rust-event-listener")
    (version "3.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "event-listener" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1hihkg6ihvb6p9yi7nq11di8mhd5y0iqv81ij6h0rf0fvsy7ff6r"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-parking" ,rust-parking-2)
         ("rust-concurrent-queue"
          ,rust-concurrent-queue-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-event-listener-4
  (package
    (name "rust-event-listener")
    (version "4.0.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "event-listener" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0vk4smw1vf871vi76af1zn7w69jg3zmpjddpby2qq91bkg21bck7"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-parking" ,rust-parking-2)
         ("rust-concurrent-queue"
          ,rust-concurrent-queue-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-event-listener-5
  (package
    (name "rust-event-listener")
    (version "5.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "event-listener" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "091a6bgxzjnycqa10l2sqwzzy0j9vpw7a1w0nbglqlqkraw496bd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-parking" ,rust-parking-2)
         ("rust-concurrent-queue"
          ,rust-concurrent-queue-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-event-listener-strategy-0.4
  (package
    (name "rust-event-listener-strategy")
    (version "0.4.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "event-listener-strategy" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1lwprdjqp2ibbxhgm9khw7s7y7k4xiqj5i5yprqiks6mnrq4v3lm"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-event-listener" ,rust-event-listener-4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-event-listener-strategy-0.5
  (package
    (name "rust-event-listener-strategy")
    (version "0.5.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "event-listener-strategy" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "18f5ri227khkayhv3ndv7yl4rnasgwksl2jhwgafcxzr7324s88g"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-event-listener" ,rust-event-listener-5))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ewebsock-0.4
  (package
    (name "rust-ewebsock")
    (version "0.4.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ewebsock" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1pkdx768d47c93wvdqflx9iq68fl1gj9nmba2jwify6fsnj33l42"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-wasm-bindgen-futures"
          ,rust-wasm-bindgen-futures-0.4)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-tungstenite" ,rust-tungstenite-0.21)
         ("rust-log" ,rust-log-0.4)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-document-features"
          ,rust-document-features-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-fallible-iterator-0.2
  (package
    (name "rust-fallible-iterator")
    (version "0.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "fallible-iterator" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1xq759lsr8gqss7hva42azn3whgrbrs2sd9xpn92c5ickxm1fhs4"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-fallible-streaming-iterator-0.1
  (package
    (name "rust-fallible-streaming-iterator")
    (version "0.1.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "fallible-streaming-iterator" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0nj6j26p71bjy8h42x6jahx1hn0ng6mc2miwpgwnp8vnwqf4jq3k"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-fastrand-1
  (package
    (name "rust-fastrand")
    (version "1.9.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "fastrand" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1gh12m56265ihdbzh46bhh0jf74i197wm51jg1cw75q7ggi96475"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-instant" ,rust-instant-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-fastrand-2
  (package
    (name "rust-fastrand")
    (version "2.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "fastrand" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "06p5d0rxq7by260m4ym9ial0bwgi0v42lrvhl6nm2g7h0h2m3h4z"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-fdeflate-0.3
  (package
    (name "rust-fdeflate")
    (version "0.3.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "fdeflate" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ig65nz4wcqaa3y109sh7yv155ldfyph6bs2ifmz1vad1vizx6sg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-simd-adler32" ,rust-simd-adler32-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-filetime-0.2
  (package
    (name "rust-filetime")
    (version "0.2.23")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "filetime" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1za0sbq7fqidk8aaq9v7m9ms0sv8mmi49g6p5cphpan819q4gr0y"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52)
         ("rust-redox-syscall" ,rust-redox-syscall-0.4)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-fixed-1
  (package
    (name "rust-fixed")
    (version "1.27.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "fixed" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0j108xgqaawwl6kihc2g05c0p7r0ik7rpmzwhzs5nyzaig9ibirg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-typenum" ,rust-typenum-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-half" ,rust-half-2)
         ("rust-bytemuck" ,rust-bytemuck-1)
         ("rust-az" ,rust-az-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-flatbuffers-23
  (package
    (name "rust-flatbuffers")
    (version "23.5.26")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "flatbuffers" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0h46mg8yb9igda4ff5dajkzc6k5mf4ix472asqb8rmv24ki57b2d"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-rustc-version" ,rust-rustc-version-0.4)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-flate2-1
  (package
    (name "rust-flate2")
    (version "1.0.30")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "flate2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1bjx56n0wq5w7vsjn7b5rbmqiw0vc3mfzz1rl7i2jy0wzmy44m2z"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-miniz-oxide" ,rust-miniz-oxide-0.7)
         ("rust-crc32fast" ,rust-crc32fast-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-flume-0.11
  (package
    (name "rust-flume")
    (version "0.11.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "flume" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "10girdbqn77wi802pdh55lwbmymy437k7kklnvj12aaiwaflbb2m"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-spin" ,rust-spin-0.9)
         ("rust-nanorand" ,rust-nanorand-0.7)
         ("rust-futures-sink" ,rust-futures-sink-0.3)
         ("rust-futures-core" ,rust-futures-core-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-fnv-1
  (package
    (name "rust-fnv")
    (version "1.0.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "fnv" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1hc2mcqha06aibcaza94vbi81j6pr9a1bbxrxjfhc91zin8yr7iz"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-foreign-types-0.3
  (package
    (name "rust-foreign-types")
    (version "0.3.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "foreign-types" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1cgk0vyd7r45cj769jym4a6s7vwshvd0z4bqrb92q1fwibmkkwzn"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-foreign-types-shared"
          ,rust-foreign-types-shared-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-foreign-types-0.5
  (package
    (name "rust-foreign-types")
    (version "0.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "foreign-types" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0rfr2zfxnx9rz3292z5nyk8qs2iirznn5ff3rd4vgdwza6mdjdyp"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-foreign-types-shared"
          ,rust-foreign-types-shared-0.3)
         ("rust-foreign-types-macros"
          ,rust-foreign-types-macros-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-foreign-types-macros-0.2
  (package
    (name "rust-foreign-types-macros")
    (version "0.2.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "foreign-types-macros" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0hjpii8ny6l7h7jpns2cp9589016l8mlrpaigcnayjn9bdc6qp0s"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-foreign-types-shared-0.1
  (package
    (name "rust-foreign-types-shared")
    (version "0.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "foreign-types-shared" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0jxgzd04ra4imjv8jgkmdq59kj8fsz6w4zxsbmlai34h26225c00"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-foreign-types-shared-0.3
  (package
    (name "rust-foreign-types-shared")
    (version "0.3.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "foreign-types-shared" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0nykdvv41a3d4py61bylmlwjhhvdm0b3bcj9vxhqgxaxnp5ik6ma"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-foreign-vec-0.1
  (package
    (name "rust-foreign-vec")
    (version "0.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "foreign_vec" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0wv6p8yfahcqbdg2wg7wxgj4dm32g2b6spa5sg5sxg34v35ha6zf"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-form-urlencoded-1
  (package
    (name "rust-form-urlencoded")
    (version "1.2.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "form_urlencoded" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0milh8x7nl4f450s3ddhg57a3flcv6yq8hlkyk6fyr3mcb128dp1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-percent-encoding"
          ,rust-percent-encoding-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-fsevent-sys-4
  (package
    (name "rust-fsevent-sys")
    (version "4.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "fsevent-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1liz67v8b0gcs8r31vxkvm2jzgl9p14i78yfqx81c8sdv817mvkn"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-futures-channel-0.3
  (package
    (name "rust-futures-channel")
    (version "0.3.30")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "futures-channel" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0y6b7xxqdjm9hlcjpakcg41qfl7lihf6gavk8fyqijsxhvbzgj7a"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-futures-core" ,rust-futures-core-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-futures-core-0.3
  (package
    (name "rust-futures-core")
    (version "0.3.30")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "futures-core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "07aslayrn3lbggj54kci0ishmd1pr367fp7iks7adia1p05miinz"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-futures-io-0.3
  (package
    (name "rust-futures-io")
    (version "0.3.30")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "futures-io" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1hgh25isvsr4ybibywhr4dpys8mjnscw4wfxxwca70cn1gi26im4"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-futures-lite-1
  (package
    (name "rust-futures-lite")
    (version "1.13.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "futures-lite" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1kkbqhaib68nzmys2dc8j9fl2bwzf2s91jfk13lb2q3nwhfdbaa9"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-waker-fn" ,rust-waker-fn-1)
         ("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-parking" ,rust-parking-2)
         ("rust-memchr" ,rust-memchr-2)
         ("rust-futures-io" ,rust-futures-io-0.3)
         ("rust-futures-core" ,rust-futures-core-0.3)
         ("rust-fastrand" ,rust-fastrand-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-futures-lite-2
  (package
    (name "rust-futures-lite")
    (version "2.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "futures-lite" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "19gk4my8zhfym6gwnpdjiyv2hw8cc098skkbkhryjdaf0yspwljj"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-parking" ,rust-parking-2)
         ("rust-futures-io" ,rust-futures-io-0.3)
         ("rust-futures-core" ,rust-futures-core-0.3)
         ("rust-fastrand" ,rust-fastrand-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-futures-macro-0.3
  (package
    (name "rust-futures-macro")
    (version "0.3.30")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "futures-macro" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1b49qh9d402y8nka4q6wvvj0c88qq91wbr192mdn5h54nzs0qxc7"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-futures-sink-0.3
  (package
    (name "rust-futures-sink")
    (version "0.3.30")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "futures-sink" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1dag8xyyaya8n8mh8smx7x6w2dpmafg2din145v973a3hw7f1f4z"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-futures-task-0.3
  (package
    (name "rust-futures-task")
    (version "0.3.30")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "futures-task" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "013h1724454hj8qczp8vvs10qfiqrxr937qsrv6rhii68ahlzn1q"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-futures-util-0.3
  (package
    (name "rust-futures-util")
    (version "0.3.30")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "futures-util" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0j0xqhcir1zf2dcbpd421kgw6wvsk0rpxflylcysn1rlp3g02r1x"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-slab" ,rust-slab-0.4)
         ("rust-pin-utils" ,rust-pin-utils-0.1)
         ("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-memchr" ,rust-memchr-2)
         ("rust-futures-task" ,rust-futures-task-0.3)
         ("rust-futures-sink" ,rust-futures-sink-0.3)
         ("rust-futures-macro" ,rust-futures-macro-0.3)
         ("rust-futures-io" ,rust-futures-io-0.3)
         ("rust-futures-core" ,rust-futures-core-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-generic-array-0.14
  (package
    (name "rust-generic-array")
    (version "0.14.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "generic-array" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "16lyyrzrljfq424c3n8kfwkqihlimmsg5nhshbbp48np3yjrqr45"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-version-check" ,rust-version-check-0.9)
         ("rust-typenum" ,rust-typenum-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-gethostname-0.4
  (package
    (name "rust-gethostname")
    (version "0.4.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "gethostname" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "063qqhznyckwx9n4z4xrmdv10s0fi6kbr17r6bi1yjifki2y0xh1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-targets"
          ,rust-windows-targets-0.48)
         ("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-getrandom-0.2
  (package
    (name "rust-getrandom")
    (version "0.2.15")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "getrandom" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1mzlnrb3dgyd1fb84gvw10pyr8wdqdl4ry4sr64i1s8an66pqmn4"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-wasi" ,rust-wasi-0.11)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-gimli-0.26
  (package
    (name "rust-gimli")
    (version "0.26.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "gimli" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0pafbk64rznibgnvfidhm1pqxd14a5s9m50yvsgnbv38b8n0w0r2"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-stable-deref-trait"
          ,rust-stable-deref-trait-1)
         ("rust-indexmap" ,rust-indexmap-1)
         ("rust-fallible-iterator"
          ,rust-fallible-iterator-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-gimli-0.28
  (package
    (name "rust-gimli")
    (version "0.28.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "gimli" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0lv23wc8rxvmjia3mcxc6hj9vkqnv1bqq0h8nzjcgf71mrxx6wa2"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-gl-generator-0.14
  (package
    (name "rust-gl-generator")
    (version "0.14.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "gl_generator" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0k8j1hmfnff312gy7x1aqjzcm8zxid7ij7dlb8prljib7b1dz58s"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-xml-rs" ,rust-xml-rs-0.8)
         ("rust-log" ,rust-log-0.4)
         ("rust-khronos-api" ,rust-khronos-api-3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-glam-0.22
  (package
    (name "rust-glam")
    (version "0.22.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "glam" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0x57gyrxyfs409b3f5i64yy2pbcgkr2qkq8v3a0mmm8vdkargx8j"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-bytemuck" ,rust-bytemuck-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-glob-0.3
  (package
    (name "rust-glob")
    (version "0.3.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "glob" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "16zca52nglanv23q5qrwd5jinw3d3as5ylya6y1pbx47vkxvrynj"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-glow-0.12
  (package
    (name "rust-glow")
    (version "0.12.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "glow" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0a1p6c9nff09m4gn0xnnschcpjq35y7c12w69ar8l2mnwj0fa3ya"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-slotmap" ,rust-slotmap-1)
         ("rust-js-sys" ,rust-js-sys-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-glow-0.13
  (package
    (name "rust-glow")
    (version "0.13.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "glow" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1c91n554dp4bdp5d86rpl77ryv6rjyrqn7735m7mfcivqh28wd5x"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-slotmap" ,rust-slotmap-1)
         ("rust-js-sys" ,rust-js-sys-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-gltf-1
  (package
    (name "rust-gltf")
    (version "1.4.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "gltf" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1xxcijdpjw6dlmbijb0n4qmhr94nb8n5902fqxmcw8sp34c1kkp3"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-urlencoding" ,rust-urlencoding-2)
         ("rust-serde-json" ,rust-serde-json-1)
         ("rust-lazy-static" ,rust-lazy-static-1)
         ("rust-image" ,rust-image-0.25)
         ("rust-gltf-json" ,rust-gltf-json-1)
         ("rust-byteorder" ,rust-byteorder-1)
         ("rust-base64" ,rust-base64-0.13))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-gltf-derive-1
  (package
    (name "rust-gltf-derive")
    (version "1.4.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "gltf-derive" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0lac9yrbbyhdx9fvz8qijaxmskmqpisdnzl0difvmbrq2mqhw1ql"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1)
         ("rust-inflections" ,rust-inflections-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-gltf-json-1
  (package
    (name "rust-gltf-json")
    (version "1.4.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "gltf-json" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "055b0fpwkhdw1glf2yha37lvvvaxc146bsg8fylb1sm7c2fny5z6"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde-json" ,rust-serde-json-1)
         ("rust-serde-derive" ,rust-serde-derive-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-gltf-derive" ,rust-gltf-derive-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-glutin-wgl-sys-0.5
  (package
    (name "rust-glutin-wgl-sys")
    (version "0.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "glutin_wgl_sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1b9f6qjc8gwhfxac4fpxkvv524l493f6b6q764nslpwmmjnri03c"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-gl-generator" ,rust-gl-generator-0.14))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-gpu-alloc-0.6
  (package
    (name "rust-gpu-alloc")
    (version "0.6.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "gpu-alloc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0wd1wq7qs8ja0cp37ajm9p1r526sp6w0kvjp3xx24jsrjfx2vkgv"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-gpu-alloc-types"
          ,rust-gpu-alloc-types-0.3)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-gpu-alloc-types-0.3
  (package
    (name "rust-gpu-alloc-types")
    (version "0.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "gpu-alloc-types" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "190wxsp9q8c59xybkfrlzqqyrxj6z39zamadk1q7v0xad2s07zwq"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-gpu-allocator-0.23
  (package
    (name "rust-gpu-allocator")
    (version "0.23.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "gpu-allocator" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1bbzb93z1gilzdpxjrvcnxkfn71g5y03qnjf1a6c6q2xl341gzj0"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows" ,rust-windows-0.51)
         ("rust-winapi" ,rust-winapi-0.3)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-presser" ,rust-presser-0.3)
         ("rust-log" ,rust-log-0.4)
         ("rust-backtrace" ,rust-backtrace-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-gpu-descriptor-0.2
  (package
    (name "rust-gpu-descriptor")
    (version "0.2.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "gpu-descriptor" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0b38pi460ajx8ksb61zxardwkpa27qgz8fpm252mczlfrqddy4fc"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-hashbrown" ,rust-hashbrown-0.14)
         ("rust-gpu-descriptor-types"
          ,rust-gpu-descriptor-types-0.1)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-gpu-descriptor-types-0.1
  (package
    (name "rust-gpu-descriptor-types")
    (version "0.1.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "gpu-descriptor-types" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "135pp1b3bzyr7bfnb30rf9pkgy61h75w0jabi8fpw2q9dxpb7w3b"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-h2-0.3
  (package
    (name "rust-h2")
    (version "0.3.26")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "h2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1s7msnfv7xprzs6xzfj5sg6p8bjcdpcqcmjjbkd345cyi1x55zl1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-tracing" ,rust-tracing-0.1)
         ("rust-tokio-util" ,rust-tokio-util-0.7)
         ("rust-tokio" ,rust-tokio-1)
         ("rust-slab" ,rust-slab-0.4)
         ("rust-indexmap" ,rust-indexmap-2)
         ("rust-http" ,rust-http-0.2)
         ("rust-futures-util" ,rust-futures-util-0.3)
         ("rust-futures-sink" ,rust-futures-sink-0.3)
         ("rust-futures-core" ,rust-futures-core-0.3)
         ("rust-fnv" ,rust-fnv-1)
         ("rust-bytes" ,rust-bytes-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-half-2
  (package
    (name "rust-half")
    (version "2.4.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "half" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "123q4zzw1x4309961i69igzd1wb7pj04aaii3kwasrz3599qrl3d"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-crunchy" ,rust-crunchy-0.2)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-bytemuck" ,rust-bytemuck-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-hash-hasher-2
  (package
    (name "rust-hash-hasher")
    (version "2.0.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "hash_hasher" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "034cd4m3znwff3cd1i54c40944y999jz086d70rwpl0jfl01swkl"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-hashbrown-0.12
  (package
    (name "rust-hashbrown")
    (version "0.12.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "hashbrown" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1268ka4750pyg2pbgsr43f0289l5zah4arir2k4igx5a8c6fg7la"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-hashbrown-0.14
  (package
    (name "rust-hashbrown")
    (version "0.14.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "hashbrown" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1wa1vy1xs3mp11bn3z9dv0jricgr6a2j0zkf1g19yz3vw4il89z5"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-allocator-api2" ,rust-allocator-api2-0.2)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-hashlink-0.8
  (package
    (name "rust-hashlink")
    (version "0.8.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "hashlink" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1xy8agkyp0llbqk9fcffc1xblayrrywlyrm2a7v93x8zygm4y2g8"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-hashbrown" ,rust-hashbrown-0.14))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-hassle-rs-0.10
  (package
    (name "rust-hassle-rs")
    (version "0.10.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "hassle-rs" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1c5kgi0car30i4ik132irjq725y61xzp047j1ld8ks0mwc76b5qk"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi" ,rust-winapi-0.3)
         ("rust-widestring" ,rust-widestring-1)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-libloading" ,rust-libloading-0.7)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-com-rs" ,rust-com-rs-0.2)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-heck-0.3
  (package
    (name "rust-heck")
    (version "0.3.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "heck" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0b0kkr790p66lvzn9nsmfjvydrbmh9z5gb664jchwgw64vxiwqkd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-unicode-segmentation"
          ,rust-unicode-segmentation-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-heck-0.4
  (package
    (name "rust-heck")
    (version "0.4.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "heck" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1a7mqsnycv5z4z5vnv1k34548jzmc0ajic7c1j8jsaspnhw5ql4m"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-heck-0.5
  (package
    (name "rust-heck")
    (version "0.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "heck" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1sjmpsdl8czyh9ywl3qcsfsq9a307dg4ni2vnlwgnzzqhc4y0113"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-hermit-abi-0.1
  (package
    (name "rust-hermit-abi")
    (version "0.1.19")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "hermit-abi" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0cxcm8093nf5fyn114w8vxbrbcyvv91d4015rdnlgfll7cs6gd32"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-hermit-abi-0.3
  (package
    (name "rust-hermit-abi")
    (version "0.3.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "hermit-abi" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "092hxjbjnq5fmz66grd9plxd0sh6ssg5fhgwwwqbrzgzkjwdycfj"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-hex-0.4
  (package
    (name "rust-hex")
    (version "0.4.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "hex" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0w1a4davm1lgzpamwnba907aysmlrnygbqmfis2mqjx5m552a93z"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-hexf-parse-0.2
  (package
    (name "rust-hexf-parse")
    (version "0.2.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "hexf-parse" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1pr3a3sk66ddxdyxdxac7q6qaqjcn28v0njy22ghdpfn78l8d9nz"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-home-0.5
  (package
    (name "rust-home")
    (version "0.5.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "home" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "19grxyg35rqfd802pcc9ys1q3lafzlcjcv2pl2s5q8xpyr5kblg3"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-http-0.2
  (package
    (name "rust-http")
    (version "0.2.12")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "http" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1w81s4bcbmcj9bjp7mllm8jlz6b31wzvirz8bgpzbqkpwmbvn730"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-itoa" ,rust-itoa-1)
         ("rust-fnv" ,rust-fnv-1)
         ("rust-bytes" ,rust-bytes-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-http-1
  (package
    (name "rust-http")
    (version "1.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "http" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0n426lmcxas6h75c2cp25m933pswlrfjz10v91vc62vib2sdvf91"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-itoa" ,rust-itoa-1)
         ("rust-fnv" ,rust-fnv-1)
         ("rust-bytes" ,rust-bytes-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-http-body-0.4
  (package
    (name "rust-http-body")
    (version "0.4.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "http-body" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1lmyjfk6bqk6k9gkn1dxq770sb78pqbqshga241hr5p995bb5skw"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-http" ,rust-http-0.2)
         ("rust-bytes" ,rust-bytes-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-httparse-1
  (package
    (name "rust-httparse")
    (version "1.8.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "httparse" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "010rrfahm1jss3p022fqf3j3jmm72vhn4iqhykahb9ynpaag75yq"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-httpdate-1
  (package
    (name "rust-httpdate")
    (version "1.0.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "httpdate" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1aa9rd2sac0zhjqh24c9xvir96g188zldkx0hr6dnnlx5904cfyz"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-humantime-1
  (package
    (name "rust-humantime")
    (version "1.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "humantime" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0krwgbf35pd46xvkqg14j070vircsndabahahlv3rwhflpy4q06z"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-quick-error" ,rust-quick-error-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-humantime-2
  (package
    (name "rust-humantime")
    (version "2.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "humantime" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1r55pfkkf5v0ji1x6izrjwdq9v6sc7bv99xj6srywcar37xmnfls"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-hyper-0.14
  (package
    (name "rust-hyper")
    (version "0.14.28")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "hyper" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "107gkvqx4h9bl17d602zkm2dgpfq86l2dr36yzfsi8l3xcsy35mz"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-want" ,rust-want-0.3)
         ("rust-tracing" ,rust-tracing-0.1)
         ("rust-tower-service" ,rust-tower-service-0.3)
         ("rust-tokio" ,rust-tokio-1)
         ("rust-socket2" ,rust-socket2-0.5)
         ("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-itoa" ,rust-itoa-1)
         ("rust-httpdate" ,rust-httpdate-1)
         ("rust-httparse" ,rust-httparse-1)
         ("rust-http-body" ,rust-http-body-0.4)
         ("rust-http" ,rust-http-0.2)
         ("rust-h2" ,rust-h2-0.3)
         ("rust-futures-util" ,rust-futures-util-0.3)
         ("rust-futures-core" ,rust-futures-core-0.3)
         ("rust-futures-channel"
          ,rust-futures-channel-0.3)
         ("rust-bytes" ,rust-bytes-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-iana-time-zone-0.1
  (package
    (name "rust-iana-time-zone")
    (version "0.1.60")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "iana-time-zone" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0hdid5xz3jznm04lysjm3vi93h3c523w0hcc3xba47jl3ddbpzz7"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-core" ,rust-windows-core-0.52)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-iana-time-zone-haiku"
          ,rust-iana-time-zone-haiku-0.1)
         ("rust-core-foundation-sys"
          ,rust-core-foundation-sys-0.8)
         ("rust-android-system-properties"
          ,rust-android-system-properties-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-iana-time-zone-haiku-0.1
  (package
    (name "rust-iana-time-zone-haiku")
    (version "0.1.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "iana-time-zone-haiku" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "17r6jmj31chn7xs9698r122mapq85mfnv98bb4pg6spm0si2f67k"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-cc" ,rust-cc-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-id-arena-2
  (package
    (name "rust-id-arena")
    (version "2.2.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "id-arena" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "01ch8jhpgnih8sawqs44fqsqpc7bzwgy0xpi6j0f4j0i5mkvr8i5"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ident-case-1
  (package
    (name "rust-ident-case")
    (version "1.0.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ident_case" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0fac21q6pwns8gh1hz3nbq15j8fi441ncl6w4vlnd1cmc55kiq5r"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-idna-0.5
  (package
    (name "rust-idna")
    (version "0.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "idna" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1xhjrcjqq0l5bpzvdgylvpkgk94panxgsirzhjnnqfdgc4a9nkb3"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-unicode-normalization"
          ,rust-unicode-normalization-0.1)
         ("rust-unicode-bidi" ,rust-unicode-bidi-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-image-0.24
  (package
    (name "rust-image")
    (version "0.24.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "image" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "17gnr6ifnpzvhjf6dwbl9hki8x6bji5mwcqp0048x1jm5yfi742n"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-png" ,rust-png-0.17)
         ("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-color-quant" ,rust-color-quant-1)
         ("rust-byteorder" ,rust-byteorder-1)
         ("rust-bytemuck" ,rust-bytemuck-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-image-0.25
  (package
    (name "rust-image")
    (version "0.25.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "image" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "049xrrdvxaj23zlhqwzmz6j8b9xcc79smgi4qn97cqkkwxhdcm7x"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zune-jpeg" ,rust-zune-jpeg-0.4)
         ("rust-zune-core" ,rust-zune-core-0.4)
         ("rust-tiff" ,rust-tiff-0.9)
         ("rust-png" ,rust-png-0.17)
         ("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-byteorder" ,rust-byteorder-1)
         ("rust-bytemuck" ,rust-bytemuck-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-indent-0.1
  (package
    (name "rust-indent")
    (version "0.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "indent" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "19hg1mbmjpbcr7ixfdhn2dcq8kqzkwqyzy7x0kr70acpgmvs1wfr"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-indexmap-1
  (package
    (name "rust-indexmap")
    (version "1.9.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "indexmap" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "16dxmy7yvk51wvnih3a3im6fp5lmx0wx76i03n06wyak6cwhw1xx"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-hashbrown" ,rust-hashbrown-0.12)
         ("rust-autocfg" ,rust-autocfg-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-indexmap-2
  (package
    (name "rust-indexmap")
    (version "2.2.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "indexmap" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "09hgwi2ig0wyj5rjziia76zmhgfj95k0jb4ic3iiawm4vlavg3qn"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-hashbrown" ,rust-hashbrown-0.14)
         ("rust-equivalent" ,rust-equivalent-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-indicatif-0.17
  (package
    (name "rust-indicatif")
    (version "0.17.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "indicatif" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "18xyqxw9i5x4sbpzckhfz3nm984iq9r7nbi2lk76nz888n7mlfkn"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-unicode-width" ,rust-unicode-width-0.1)
         ("rust-rayon" ,rust-rayon-1)
         ("rust-portable-atomic" ,rust-portable-atomic-1)
         ("rust-number-prefix" ,rust-number-prefix-0.4)
         ("rust-instant" ,rust-instant-0.1)
         ("rust-console" ,rust-console-0.15))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-infer-0.15
  (package
    (name "rust-infer")
    (version "0.15.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "infer" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "16d1b83h5m87h6kq4z8kwjrzll5dq6rijg2iz437m008m4nn4cyb"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-cfb" ,rust-cfb-0.7))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-inflections-1
  (package
    (name "rust-inflections")
    (version "1.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "inflections" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0yl3gas612q25c72lwf04405i87yxr02vgv3ckcnz2fyvhpmhmx2"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-inotify-0.9
  (package
    (name "rust-inotify")
    (version "0.9.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "inotify" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1zxb04c4qccp8wnr3v04l503qpxzxzzzph61amlqbsslq4z9s1pq"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2)
         ("rust-inotify-sys" ,rust-inotify-sys-0.1)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-inotify-sys-0.1
  (package
    (name "rust-inotify-sys")
    (version "0.1.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "inotify-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1syhjgvkram88my04kv03s0zwa66mdwa5v7ddja3pzwvx2sh4p70"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-instant-0.1
  (package
    (name "rust-instant")
    (version "0.1.13")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "instant" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "08h27kzvb5jw74mh0ajv0nv9ggwvgqm8ynjsn2sa9jsks4cjh970"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-integer-encoding-3
  (package
    (name "rust-integer-encoding")
    (version "3.0.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "integer-encoding" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "00ng7jmv6pqwqc8w1297f768bn0spwwicdr7hb40baax00r3gc4b"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-io-lifetimes-1
  (package
    (name "rust-io-lifetimes")
    (version "1.0.11")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "io-lifetimes" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1hph5lz4wd3drnn6saakwxr497liznpfnv70via6s0v8x6pbkrza"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.48)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-hermit-abi" ,rust-hermit-abi-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define-public rust-ionmesh-0.1
  (package
    (name "rust-ionmesh")
    (version "0.1.0")
    (source
      (origin
            (method git-fetch)
      (uri (git-reference
            (url "https://github.com/TalusBio/ionmesh")
            (commit "7d94a23f8b68fb2941e692b44eb35497bc9d8cfc")))
      (modules '((guix build utils)))
      (snippet '(begin
		 (substitute*
		     "Cargo.toml"
		   (("^sage-core = .*$") "sage-core = \"0.14.7\"\n"))))  
      (sha256
        (base32 "08l4v8m3h921dd0kh4lrfzp9z7b2vsjhm7yksyy9jk42y1bi6cbk"))))

    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #f
        #:cargo-inputs
        (("rust-toml" ,rust-toml-0.8)
         ("rust-timsrust" ,rust-timsrust-0.2)
         ("rust-serde-json" ,rust-serde-json-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-sage-core" ,rust-sage-core-0.14)
         ("rust-rusqlite" ,rust-rusqlite-0.29)
         ("rust-rerun" ,rust-rerun-0.12)
         ("rust-rayon" ,rust-rayon-1)
         ("rust-rand" ,rust-rand-0.8)
         ("rust-pretty-env-logger"
          ,rust-pretty-env-logger-0.4)
         ("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-num" ,rust-num-0.4)
         ("rust-log" ,rust-log-0.4)
         ("rust-indicatif" ,rust-indicatif-0.17)
         ("rust-csv" ,rust-csv-1)
         ("rust-clap" ,rust-clap-4)
         ("rust-apache-avro" ,rust-apache-avro-0.16))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-is-terminal-0.4
  (package
    (name "rust-is-terminal")
    (version "0.4.12")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "is-terminal" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "12vk6g0f94zlxl6mdh5gc4jdjb469n9k9s7y3vb0iml05gpzagzj"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-hermit-abi" ,rust-hermit-abi-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-is-terminal-polyfill-1
  (package
    (name "rust-is-terminal-polyfill")
    (version "1.70.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "is_terminal_polyfill" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0018q5cf3rifbnzfc1w1z1xcx9c6i7xlywp2n0fw4limq1vqaizq"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-itertools-0.10
  (package
    (name "rust-itertools")
    (version "0.10.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "itertools" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ww45h7nxx5kj6z2y6chlskxd1igvs4j507anr6dzg99x1h25zdh"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-either" ,rust-either-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-itertools-0.12
  (package
    (name "rust-itertools")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "itertools" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0s95jbb3ndj1lvfxyq5wanc0fm0r6hg6q4ngb92qlfdxvci10ads"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-either" ,rust-either-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-itoa-1
  (package
    (name "rust-itoa")
    (version "1.0.11")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "itoa" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0nv9cqjwzr3q58qz84dcz63ggc54yhf1yqar1m858m1kfd4g3wa9"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-jni-0.21
  (package
    (name "rust-jni")
    (version "0.21.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "jni" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "15wczfkr2r45slsljby12ymf2hij8wi5b104ghck9byjnwmsm1qs"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.45)
         ("rust-walkdir" ,rust-walkdir-2)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-log" ,rust-log-0.4)
         ("rust-jni-sys" ,rust-jni-sys-0.3)
         ("rust-combine" ,rust-combine-4)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-cesu8" ,rust-cesu8-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-jni-sys-0.3
  (package
    (name "rust-jni-sys")
    (version "0.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "jni-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0c01zb9ygvwg9wdx2fii2d39myzprnpqqhy7yizxvjqp5p04pbwf"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-jobserver-0.1
  (package
    (name "rust-jobserver")
    (version "0.1.31")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "jobserver" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0vnyfxr5gm03j3lpnd1zswnyvqa40kbssy08pz2m35salfm9kc6j"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-jpeg-decoder-0.3
  (package
    (name "rust-jpeg-decoder")
    (version "0.3.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "jpeg-decoder" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1c1k53svpdyfhibkmm0ir5w0v3qmcmca8xr8vnnmizwf6pdagm7m"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-js-sys-0.3
  (package
    (name "rust-js-sys")
    (version "0.3.69")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "js-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0v99rz97asnzapb0jsc3jjhvxpfxr7h7qd97yqyrf9i7viimbh99"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-khronos-egl-6
  (package
    (name "rust-khronos-egl")
    (version "6.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "khronos-egl" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0xnzdx0n1bil06xmh8i1x6dbxvk7kd2m70bbm6nw1qzc43r1vbka"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pkg-config" ,rust-pkg-config-0.3)
         ("rust-libloading" ,rust-libloading-0.8)
         ("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-khronos-api-3
  (package
    (name "rust-khronos-api")
    (version "3.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "khronos_api" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1p0xj5mlbagqyvvnv8wmv3cr7l9y1m153888pxqwg3vk3mg5inz2"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-kqueue-1
  (package
    (name "rust-kqueue")
    (version "1.0.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "kqueue" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "033x2knkbv8d3jy6i9r32jcgsq6zm3g97zh5la43amkv3g5g2ivl"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2)
         ("rust-kqueue-sys" ,rust-kqueue-sys-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-kqueue-sys-1
  (package
    (name "rust-kqueue-sys")
    (version "1.0.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "kqueue-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "12w3wi90y4kwis4k9g6fp0kqjdmc6l00j16g8mgbhac7vbzjb5pd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-lazy-static-1
  (package
    (name "rust-lazy-static")
    (version "1.4.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "lazy_static" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0in6ikhw8mgl33wjv6q6xfrb5b9jr16q8ygjy803fay4zcisvaz2"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-leb128-0.2
  (package
    (name "rust-leb128")
    (version "0.2.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "leb128" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0rxxjdn76sjbrb08s4bi7m4x47zg68f71jzgx8ww7j0cnivjckl8"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-lexical-core-0.8
  (package
    (name "rust-lexical-core")
    (version "0.8.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "lexical-core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ihf0x3vrk25fq3bv9q35m0xax0wmvwkh0j0pjm2yk4ddvh5vpic"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-lexical-write-integer"
          ,rust-lexical-write-integer-0.8)
         ("rust-lexical-write-float"
          ,rust-lexical-write-float-0.8)
         ("rust-lexical-util" ,rust-lexical-util-0.8)
         ("rust-lexical-parse-integer"
          ,rust-lexical-parse-integer-0.8)
         ("rust-lexical-parse-float"
          ,rust-lexical-parse-float-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-lexical-parse-float-0.8
  (package
    (name "rust-lexical-parse-float")
    (version "0.8.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "lexical-parse-float" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0py0gp8hlzcrlvjqmqlpl2v1as65iiqxq2xsabxvhc01pmg3lfv8"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-lexical-util" ,rust-lexical-util-0.8)
         ("rust-lexical-parse-integer"
          ,rust-lexical-parse-integer-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-lexical-parse-integer-0.8
  (package
    (name "rust-lexical-parse-integer")
    (version "0.8.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "lexical-parse-integer" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1sayji3mpvb2xsjq56qcq3whfz8px9a6fxk5v7v15hyhbr4982bd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-lexical-util" ,rust-lexical-util-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-lexical-util-0.8
  (package
    (name "rust-lexical-util")
    (version "0.8.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "lexical-util" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1z73qkv7yxhsbc4aiginn1dqmsj8jarkrdlyxc88g2gz2vzvjmaj"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-static-assertions"
          ,rust-static-assertions-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-lexical-write-float-0.8
  (package
    (name "rust-lexical-write-float")
    (version "0.8.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "lexical-write-float" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0qk825l0csvnksh9sywb51996cjc2bylq6rxjaiha7sqqjhvmjmc"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-lexical-write-integer"
          ,rust-lexical-write-integer-0.8)
         ("rust-lexical-util" ,rust-lexical-util-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-lexical-write-integer-0.8
  (package
    (name "rust-lexical-write-integer")
    (version "0.8.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "lexical-write-integer" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ii4hmvqrg6pd4j9y1pkhkp0nw2wpivjzmljh6v6ca22yk8z7dp1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-lexical-util" ,rust-lexical-util-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-libc-0.2
  (package
    (name "rust-libc")
    (version "0.2.155")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "libc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0z44c53z54znna8n322k5iwg80arxxpdzjj5260pxxzc9a58icwp"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-libflate-2
  (package
    (name "rust-libflate")
    (version "2.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "libflate" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "07mj9z89vbhq837q58m4v2nblgsmrn6vrp8w1j8g0kpa2kfdzna5"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libflate-lz77" ,rust-libflate-lz77-2)
         ("rust-dary-heap" ,rust-dary-heap-0.3)
         ("rust-crc32fast" ,rust-crc32fast-1)
         ("rust-core2" ,rust-core2-0.4)
         ("rust-adler32" ,rust-adler32-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-libflate-lz77-2
  (package
    (name "rust-libflate-lz77")
    (version "2.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "libflate_lz77" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0gc6h98jwigscasz8vw1vv65b3rismqcbndb8hf6yf4z6qxxgq76"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-rle-decode-fast" ,rust-rle-decode-fast-1)
         ("rust-hashbrown" ,rust-hashbrown-0.14)
         ("rust-core2" ,rust-core2-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-libloading-0.7
  (package
    (name "rust-libloading")
    (version "0.7.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "libloading" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "17wbccnjvhjd9ibh019xcd8kjvqws8lqgq86lqkpbgig7gyq0wxn"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi" ,rust-winapi-0.3)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-libloading-0.8
  (package
    (name "rust-libloading")
    (version "0.8.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "libloading" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "06awqx9glr3i7mcs6csscr8d6dbd9rrk6yglilmdmsmhns7ijahc"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-targets"
          ,rust-windows-targets-0.52)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-libm-0.2
  (package
    (name "rust-libm")
    (version "0.2.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "libm" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0n4hk1rs8pzw8hdfmwn96c4568s93kfxqgcqswr7sajd2diaihjf"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-libredox-0.0.2
  (package
    (name "rust-libredox")
    (version "0.0.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "libredox" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "01v6pb09j7dl2gnbvzz6zmy2k4zyxjjzvl7wacwjjffqsxajry9s"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-redox-syscall" ,rust-redox-syscall-0.4)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-libredox-0.1
  (package
    (name "rust-libredox")
    (version "0.1.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "libredox" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "139602gzgs0k91zb7dvgj1qh4ynb8g1lbxsswdim18hcb6ykgzy0"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-libsqlite3-sys-0.26
  (package
    (name "rust-libsqlite3-sys")
    (version "0.26.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "libsqlite3-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "09j3v5nhgvjdyskgwajhg9g6v3b2ij0lxiz8qqav2cxic7zjxhmg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-vcpkg" ,rust-vcpkg-0.2)
         ("rust-pkg-config" ,rust-pkg-config-0.3)
         ("rust-cc" ,rust-cc-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-linked-hash-map-0.5
  (package
    (name "rust-linked-hash-map")
    (version "0.5.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "linked-hash-map" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "03vpgw7x507g524nx5i1jf5dl8k3kv0fzg8v3ip6qqwbpkqww5q7"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-linreg-0.2
  (package
    (name "rust-linreg")
    (version "0.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "linreg" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0iglzmdddv2w5pwzd9f0iplc4viaxjsf9knvk39bcf4k1cpzvipq"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-displaydoc" ,rust-displaydoc-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-linux-raw-sys-0.3
  (package
    (name "rust-linux-raw-sys")
    (version "0.3.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "linux-raw-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "068mbigb3frrxvbi5g61lx25kksy98f2qgkvc4xg8zxznwp98lzg"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-linux-raw-sys-0.4
  (package
    (name "rust-linux-raw-sys")
    (version "0.4.14")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "linux-raw-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "12gsjgbhhjwywpqcrizv80vrp7p7grsz5laqq773i33wphjsxcvq"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-litrs-0.4
  (package
    (name "rust-litrs")
    (version "0.4.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "litrs" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "19cssch9gc0x2snd9089nvwzz79zx6nzsi3icffpx25p4hck1kml"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-lock-api-0.4
  (package
    (name "rust-lock-api")
    (version "0.4.12")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "lock_api" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "05qvxa6g27yyva25a5ghsg85apdxkvr77yhkyhapj6r8vnf8pbq7"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-scopeguard" ,rust-scopeguard-1)
         ("rust-autocfg" ,rust-autocfg-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-log-0.4
  (package
    (name "rust-log")
    (version "0.4.21")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "log" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "074hldq1q8rlzq2s2qa8f25hj4s3gpw71w64vdwzjd01a4g8rvch"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-log-once-0.4
  (package
    (name "rust-log-once")
    (version "0.4.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "log-once" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1w7bdibhraiyn9xjc5cqqpfbwqkhp9dkwddzdldpnccvhzihb2kd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-log" ,rust-log-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-lz4-1
  (package
    (name "rust-lz4")
    (version "1.24.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "lz4" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1wad97k0asgvaj16ydd09gqs2yvgaanzcvqglrhffv7kdpc2v7ky"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-lz4-sys" ,rust-lz4-sys-1)
         ("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-lz4-sys-1
  (package
    (name "rust-lz4-sys")
    (version "1.9.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "lz4-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0059ik4xlvnss5qfh6l691psk4g3350ljxaykzv10yr0gqqppljp"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2)
         ("rust-cc" ,rust-cc-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-lz4-flex-0.11
  (package
    (name "rust-lz4-flex")
    (version "0.11.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "lz4_flex" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1xg3h3y0ghnq3widdssd36s02pvy29c0afbwgq6mh3ibmri12xkm"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-twox-hash" ,rust-twox-hash-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-macaw-0.18
  (package
    (name "rust-macaw")
    (version "0.18.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "macaw" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1yrdfqcpkd17pbgb515l3k2nzd54n1z45zdpmy831rd70zgvzzdq"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-glam" ,rust-glam-0.22))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-malloc-buf-0.0.6
  (package
    (name "rust-malloc-buf")
    (version "0.0.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "malloc_buf" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1jqr77j89pwszv51fmnknzvd53i1nkmcr8rjrvcxhm4dx1zr1fv2"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-matrixmultiply-0.3
  (package
    (name "rust-matrixmultiply")
    (version "0.3.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "matrixmultiply" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1whgrp8ph7904aslqx87h9qm0ks4pxdj2nysffmrhiys6v7w2x3m"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-rawpointer" ,rust-rawpointer-0.2)
         ("rust-autocfg" ,rust-autocfg-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-memchr-2
  (package
    (name "rust-memchr")
    (version "2.7.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "memchr" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "07bcqxb0vx4ji0648ny5xsicjnpma95x1n07v7mi7jrhsz2l11kc"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-memmap2-0.5
  (package
    (name "rust-memmap2")
    (version "0.5.10")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "memmap2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "09xk415fxyl4a9pgby4im1v2gqlb5lixpm99dczkk30718na9yl3"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-memmap2-0.9
  (package
    (name "rust-memmap2")
    (version "0.9.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "memmap2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "08hkmvri44j6h14lyq4yw5ipsp91a9jacgiww4bs9jm8whi18xgy"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-memoffset-0.6
  (package
    (name "rust-memoffset")
    (version "0.6.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "memoffset" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1kkrzll58a3ayn5zdyy9i1f1v3mx0xgl29x0chq614zazba638ss"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-autocfg" ,rust-autocfg-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-memoffset-0.7
  (package
    (name "rust-memoffset")
    (version "0.7.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "memoffset" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1x2zv8hv9c9bvgmhsjvr9bymqwyxvgbca12cm8xkhpyy5k1r7s2x"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-autocfg" ,rust-autocfg-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-memoffset-0.9
  (package
    (name "rust-memoffset")
    (version "0.9.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "memoffset" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "12i17wh9a9plx869g7j4whf62xw68k5zd4k0k5nh6ys5mszid028"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-autocfg" ,rust-autocfg-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-memory-stats-1
  (package
    (name "rust-memory-stats")
    (version "1.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "memory-stats" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1k5amihbjv30wbz2z2kcqp9gh4hr7wka3k9s952rap2cjvwrrxrl"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi" ,rust-winapi-0.3)
         ("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-metal-0.27
  (package
    (name "rust-metal")
    (version "0.27.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "metal" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "09bz461vyi9kw69k55gy2fpd3hz17j6g2n0v08gm3glc7yap6gy4"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-paste" ,rust-paste-1)
         ("rust-objc" ,rust-objc-0.2)
         ("rust-log" ,rust-log-0.4)
         ("rust-foreign-types" ,rust-foreign-types-0.5)
         ("rust-core-graphics-types"
          ,rust-core-graphics-types-0.1)
         ("rust-block" ,rust-block-0.1)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-mime-0.3
  (package
    (name "rust-mime")
    (version "0.3.17")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "mime" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "16hkibgvb9klh0w0jk5crr5xv90l3wlf77ggymzjmvl1818vnxv8"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-mime-guess2-2
  (package
    (name "rust-mime-guess2")
    (version "2.0.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "mime_guess2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0h8c0bf58s469lph49nflis2hxy1nhwnlxnw3rh015b0n4xk78r5"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-unicase" ,rust-unicase-2)
         ("rust-mime" ,rust-mime-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-miniz-oxide-0.7
  (package
    (name "rust-miniz-oxide")
    (version "0.7.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "miniz_oxide" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1bndap8kj8ihlaz23a5cq0ihc09xh3c1m4ip5dbnpilmw4gx1pw7"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-simd-adler32" ,rust-simd-adler32-0.3)
         ("rust-adler" ,rust-adler-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-mio-0.8
  (package
    (name "rust-mio")
    (version "0.8.11")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "mio" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "034byyl0ardml5yliy1hmvx8arkmn9rv479pid794sm07ia519m4"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.48)
         ("rust-wasi" ,rust-wasi-0.11)
         ("rust-log" ,rust-log-0.4)
         ("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-naga-0.14
  (package
    (name "rust-naga")
    (version "0.14.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "naga" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "17i4j40xq67qkia5p0q44y4pbjgdj94spwf05a2ghk2invs5sn5f"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-unicode-xid" ,rust-unicode-xid-0.2)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-termcolor" ,rust-termcolor-1)
         ("rust-spirv" ,rust-spirv-0.2)
         ("rust-rustc-hash" ,rust-rustc-hash-1)
         ("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-log" ,rust-log-0.4)
         ("rust-indexmap" ,rust-indexmap-2)
         ("rust-hexf-parse" ,rust-hexf-parse-0.2)
         ("rust-codespan-reporting"
          ,rust-codespan-reporting-0.11)
         ("rust-bitflags" ,rust-bitflags-2)
         ("rust-bit-set" ,rust-bit-set-0.5))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-nanorand-0.7
  (package
    (name "rust-nanorand")
    (version "0.7.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "nanorand" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1hr60b8zlfy7mxjcwx2wfmhpkx7vfr3v9x12shmv1c10b0y32lba"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-getrandom" ,rust-getrandom-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-natord-1
  (package
    (name "rust-natord")
    (version "1.0.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "natord" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0z75spwag3ch20841pvfwhh3892i2z2sli4pzp1jgizbipdrd39h"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ndarray-0.15
  (package
    (name "rust-ndarray")
    (version "0.15.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ndarray" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0cpsm28hyk8qfjs4g9649dprv3hm53z12qqwyyjqbi3yjr72vcdd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-rawpointer" ,rust-rawpointer-0.2)
         ("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-num-integer" ,rust-num-integer-0.1)
         ("rust-num-complex" ,rust-num-complex-0.4)
         ("rust-matrixmultiply" ,rust-matrixmultiply-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ndk-0.7
  (package
    (name "rust-ndk")
    (version "0.7.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ndk" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "180sjpyf1ylqgqw4ni8jcg3kv96vvrddzamknp4730kiwjvj4525"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-thiserror" ,rust-thiserror-1)
         ("rust-raw-window-handle"
          ,rust-raw-window-handle-0.5)
         ("rust-num-enum" ,rust-num-enum-0.5)
         ("rust-ndk-sys" ,rust-ndk-sys-0.4)
         ("rust-jni-sys" ,rust-jni-sys-0.3)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ndk-context-0.1
  (package
    (name "rust-ndk-context")
    (version "0.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ndk-context" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "12sai3dqsblsvfd1l1zab0z6xsnlha3xsfl7kagdnmj3an3jvc17"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ndk-sys-0.4
  (package
    (name "rust-ndk-sys")
    (version "0.4.1+23.1.7779620")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ndk-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "18z5xsnrnpq65aspavb8cg925m3scs8hb1b9a2n2q8xxb3lsmwiw"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-jni-sys" ,rust-jni-sys-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-never-0.1
  (package
    (name "rust-never")
    (version "0.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "never" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "149whplrasa92hdyg0bfcih2xy71d6ln6snxysrinq3pm1dblsn9"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-nix-0.24
  (package
    (name "rust-nix")
    (version "0.24.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "nix" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0sc0yzdl51b49bqd9l9cmimp1sw1hxb8iyv4d35ww6d7m5rfjlps"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-memoffset" ,rust-memoffset-0.6)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-nix-0.25
  (package
    (name "rust-nix")
    (version "0.25.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "nix" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1r4vyp5g1lxzpig31bkrhxdf2bggb4nvk405x5gngzfvwxqgyipk"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-memoffset" ,rust-memoffset-0.6)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-bitflags" ,rust-bitflags-1)
         ("rust-autocfg" ,rust-autocfg-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-nix-0.26
  (package
    (name "rust-nix")
    (version "0.26.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "nix" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "06xgl4ybb8pvjrbmc3xggbgk3kbs1j0c4c0nzdfrmpbgrkrym2sr"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-memoffset" ,rust-memoffset-0.7)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-nohash-hasher-0.2
  (package
    (name "rust-nohash-hasher")
    (version "0.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "nohash-hasher" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0lf4p6k01w4wm7zn4grnihzj8s7zd5qczjmzng7wviwxawih5x9b"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-notify-6
  (package
    (name "rust-notify")
    (version "6.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "notify" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0bad98r0ilkhhq2jg3zs11zcqasgbvxia8224wpasm74n65vs1b2"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.48)
         ("rust-walkdir" ,rust-walkdir-2)
         ("rust-mio" ,rust-mio-0.8)
         ("rust-log" ,rust-log-0.4)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-kqueue" ,rust-kqueue-1)
         ("rust-inotify" ,rust-inotify-0.9)
         ("rust-fsevent-sys" ,rust-fsevent-sys-4)
         ("rust-filetime" ,rust-filetime-0.2)
         ("rust-crossbeam-channel"
          ,rust-crossbeam-channel-0.5)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ntapi-0.4
  (package
    (name "rust-ntapi")
    (version "0.4.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ntapi" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1r38zhbwdvkis2mzs6671cm1p6djgsl49i7bwxzrvhwicdf8k8z8"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi" ,rust-winapi-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-0.4
  (package
    (name "rust-num")
    (version "0.4.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "08yb2fc1psig7pkzaplm495yp7c30m4pykpkwmi5bxrgid705g9m"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-num-rational" ,rust-num-rational-0.4)
         ("rust-num-iter" ,rust-num-iter-0.1)
         ("rust-num-integer" ,rust-num-integer-0.1)
         ("rust-num-complex" ,rust-num-complex-0.4)
         ("rust-num-bigint" ,rust-num-bigint-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-bigint-0.4
  (package
    (name "rust-num-bigint")
    (version "0.4.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num-bigint" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1mrnnlyjsip3mhgn4ghbiy5lhkznvz7x438wa9rnyxngcjmsjrf1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-num-integer" ,rust-num-integer-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-complex-0.4
  (package
    (name "rust-num-complex")
    (version "0.4.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num-complex" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "15cla16mnw12xzf5g041nxbjjm9m85hdgadd5dl5d0b30w9qmy3k"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num-traits" ,rust-num-traits-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-conv-0.1
  (package
    (name "rust-num-conv")
    (version "0.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num-conv" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ndiyg82q73783jq18isi71a7mjh56wxrk52rlvyx0mi5z9ibmai"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-derive-0.4
  (package
    (name "rust-num-derive")
    (version "0.4.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num-derive" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "00p2am9ma8jgd2v6xpsz621wc7wbn1yqi71g15gc3h67m7qmafgd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-integer-0.1
  (package
    (name "rust-num-integer")
    (version "0.1.46")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num-integer" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "13w5g54a9184cqlbsq80rnxw4jj4s0d8wv75jsq5r2lms8gncsbr"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num-traits" ,rust-num-traits-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-iter-0.1
  (package
    (name "rust-num-iter")
    (version "0.1.45")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num-iter" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1gzm7vc5g9qsjjl3bqk9rz1h6raxhygbrcpbfl04swlh0i506a8l"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-num-integer" ,rust-num-integer-0.1)
         ("rust-autocfg" ,rust-autocfg-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-rational-0.4
  (package
    (name "rust-num-rational")
    (version "0.4.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num-rational" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "093qndy02817vpgcqjnj139im3jl7vkq4h68kykdqqh577d18ggq"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-num-integer" ,rust-num-integer-0.1)
         ("rust-num-bigint" ,rust-num-bigint-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-traits-0.2
  (package
    (name "rust-num-traits")
    (version "0.2.19")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num-traits" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0h984rhdkkqd4ny9cif7y2azl3xdfb7768hb9irhpsch4q3gq787"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libm" ,rust-libm-0.2)
         ("rust-autocfg" ,rust-autocfg-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-cpus-1
  (package
    (name "rust-num-cpus")
    (version "1.16.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num_cpus" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0hra6ihpnh06dvfvz9ipscys0xfqa9ca9hzp384d5m02ssvgqqa1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2)
         ("rust-hermit-abi" ,rust-hermit-abi-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-enum-0.5
  (package
    (name "rust-num-enum")
    (version "0.5.11")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num_enum" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1japmqhcxwn1d3k7q8jw58y7xfby51s16nzd6dkj483cj2pnqr0z"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num-enum-derive"
          ,rust-num-enum-derive-0.5))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-enum-0.6
  (package
    (name "rust-num-enum")
    (version "0.6.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num_enum" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "18bna04g6zq978z2b4ygz0f8pbva37id4xnpgwh8l41w1m1mn0bs"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num-enum-derive"
          ,rust-num-enum-derive-0.6))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-enum-derive-0.5
  (package
    (name "rust-num-enum-derive")
    (version "0.5.11")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num_enum_derive" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "16f7r4jila0ckcgdnfgqyhhb90w9m2pdbwayyqmwcci0j6ygkgyw"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-1)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1)
         ("rust-proc-macro-crate"
          ,rust-proc-macro-crate-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-enum-derive-0.6
  (package
    (name "rust-num-enum-derive")
    (version "0.6.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num_enum_derive" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "19k57c0wg56vzzj2w77jsi8nls1b8xh8pvpzjnrgf8d9cnvpsrln"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1)
         ("rust-proc-macro-crate"
          ,rust-proc-macro-crate-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-num-threads-0.1
  (package
    (name "rust-num-threads")
    (version "0.1.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "num_threads" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ngajbmhrgyhzrlc4d5ga9ych1vrfcvfsiqz6zv0h2dpr2wrhwsw"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-number-prefix-0.4
  (package
    (name "rust-number-prefix")
    (version "0.4.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "number_prefix" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1wvh13wvlajqxkb1filsfzbrnq0vrmrw298v2j3sy82z1rm282w3"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc-0.2
  (package
    (name "rust-objc")
    (version "0.2.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1cbpf6kz8a244nn1qzl3xyhmp05gsg4n313c9m3567625d3innwi"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc-exception" ,rust-objc-exception-0.1)
         ("rust-malloc-buf" ,rust-malloc-buf-0.0.6))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc-foundation-0.1
  (package
    (name "rust-objc-foundation")
    (version "0.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc-foundation" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1y9bwb3m5fdq7w7i4bnds067dhm4qxv4m1mbg9y61j9nkrjipp8s"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc-id" ,rust-objc-id-0.1)
         ("rust-objc" ,rust-objc-0.2)
         ("rust-block" ,rust-block-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc-sys-0.2
  (package
    (name "rust-objc-sys")
    (version "0.2.0-beta.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1msm1bwv69k12ikxm71mi1ifrbx2bzsmk2w2bah98mp9q4s9hfyz"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc-sys-0.3
  (package
    (name "rust-objc-sys")
    (version "0.3.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0423gry7s3rmz8s3pzzm1zy5mdjif75g6dbzc2lf2z0c77fipffd"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc2-0.3
  (package
    (name "rust-objc2")
    (version "0.3.0-beta.3.patch-leaks.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0s54wfgw20ypg4ibzldwkqvv6b2kkqbmwcl0pq5j5c9ckw7n80by"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc2-encode" ,rust-objc2-encode-2)
         ("rust-objc-sys" ,rust-objc-sys-0.2)
         ("rust-block2" ,rust-block2-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc2-0.5
  (package
    (name "rust-objc2")
    (version "0.5.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "015qa2d3vh7c1j2736h5wjrznri7x5ic35vl916c22gzxva8b9s6"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc2-encode" ,rust-objc2-encode-4)
         ("rust-objc-sys" ,rust-objc-sys-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc2-app-kit-0.2
  (package
    (name "rust-objc2-app-kit")
    (version "0.2.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc2-app-kit" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1zqyi5l1bm26j1bgmac9783ah36m5kcrxlqp5carglnpwgcrms74"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc2-quartz-core"
          ,rust-objc2-quartz-core-0.2)
         ("rust-objc2-foundation"
          ,rust-objc2-foundation-0.2)
         ("rust-objc2-core-image"
          ,rust-objc2-core-image-0.2)
         ("rust-objc2-core-data"
          ,rust-objc2-core-data-0.2)
         ("rust-objc2" ,rust-objc2-0.5)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-block2" ,rust-block2-0.5)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc2-core-data-0.2
  (package
    (name "rust-objc2-core-data")
    (version "0.2.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc2-core-data" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1vvk8zjylfjjj04dzawydmqqz5ajvdkhf22cnb07ihbiw14vyzv1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc2-foundation"
          ,rust-objc2-foundation-0.2)
         ("rust-objc2" ,rust-objc2-0.5)
         ("rust-block2" ,rust-block2-0.5)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc2-core-image-0.2
  (package
    (name "rust-objc2-core-image")
    (version "0.2.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc2-core-image" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "102csfb82zi2sbzliwsfd589ckz0gysf7y6434c9zj97lmihj9jm"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc2-metal" ,rust-objc2-metal-0.2)
         ("rust-objc2-foundation"
          ,rust-objc2-foundation-0.2)
         ("rust-objc2" ,rust-objc2-0.5)
         ("rust-block2" ,rust-block2-0.5))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc2-encode-2
  (package
    (name "rust-objc2-encode")
    (version "2.0.0-pre.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc2-encode" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "04h5wns3hxmc9g652hr9xqzrijs4ij9sdnlgc0ha202v050srz5b"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc-sys" ,rust-objc-sys-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc2-encode-4
  (package
    (name "rust-objc2-encode")
    (version "4.0.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc2-encode" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1y7hjg4k828zhn4fjnbidrz3vzw4llk9ldy92drj47ydjc9yg4bq"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc2-foundation-0.2
  (package
    (name "rust-objc2-foundation")
    (version "0.2.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc2-foundation" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1a6mi77jsig7950vmx9ydvsxaighzdiglk5d229k569pvajkirhf"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc2" ,rust-objc2-0.5)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-block2" ,rust-block2-0.5)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc2-metal-0.2
  (package
    (name "rust-objc2-metal")
    (version "0.2.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc2-metal" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1mmdga66qpxrcfq3gxxhysfx3zg1hpx4z886liv3j0pnfq9bl36x"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc2-foundation"
          ,rust-objc2-foundation-0.2)
         ("rust-objc2" ,rust-objc2-0.5)
         ("rust-block2" ,rust-block2-0.5)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc2-quartz-core-0.2
  (package
    (name "rust-objc2-quartz-core")
    (version "0.2.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc2-quartz-core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ynw8819c36l11rim8n0yzk0fskbzrgaqayscyqi8swhzxxywaz4"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc2-metal" ,rust-objc2-metal-0.2)
         ("rust-objc2-foundation"
          ,rust-objc2-foundation-0.2)
         ("rust-objc2" ,rust-objc2-0.5)
         ("rust-block2" ,rust-block2-0.5)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc-exception-0.1
  (package
    (name "rust-objc-exception")
    (version "0.1.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc_exception" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "191cmdmlypp6piw67y4m8y5swlxf5w0ss8n1lk5xd2l1ans0z5xd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-cc" ,rust-cc-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-objc-id-0.1
  (package
    (name "rust-objc-id")
    (version "0.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "objc_id" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0fq71hnp2sdblaighjc82yrac3adfmqzhpr11irhvdfp9gdlsbf9"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-objc" ,rust-objc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-object-0.32
  (package
    (name "rust-object")
    (version "0.32.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "object" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0hc4cjwyngiy6k51hlzrlsxgv5z25vv7c2cp0ky1lckfic0259m6"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-memchr" ,rust-memchr-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-once-cell-1
  (package
    (name "rust-once-cell")
    (version "1.19.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "once_cell" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "14kvw7px5z96dk4dwdm1r9cqhhy2cyj1l5n5b29mynbb8yr15nrz"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-orbclient-0.3
  (package
    (name "rust-orbclient")
    (version "0.3.47")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "orbclient" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0rk144mqpv27r390bjn6dfcp2314xxfila6g3njx6x4pvr5xbw2j"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libredox" ,rust-libredox-0.0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ordered-float-2
  (package
    (name "rust-ordered-float")
    (version "2.10.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ordered-float" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "075i108hr95pr7hy4fgxivib5pky3b6b22rywya5qyd2wmkrvwb8"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num-traits" ,rust-num-traits-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ordered-float-4
  (package
    (name "rust-ordered-float")
    (version "4.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ordered-float" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0kjqcvvbcsibbx3hnj7ag06bd9gv2zfi5ja6rgyh2kbxbh3zfvd7"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num-traits" ,rust-num-traits-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ordered-stream-0.2
  (package
    (name "rust-ordered-stream")
    (version "0.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ordered-stream" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0l0xxp697q7wiix1gnfn66xsss7fdhfivl2k7bvpjs4i3lgb18ls"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-futures-core" ,rust-futures-core-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-owned-ttf-parser-0.21
  (package
    (name "rust-owned-ttf-parser")
    (version "0.21.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "owned_ttf_parser" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1mb7f0b0n8sgfpszrcj78fh1pi42rmfby0r29b3lcg665y6l6hbb"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-ttf-parser" ,rust-ttf-parser-0.21))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-parking-2
  (package
    (name "rust-parking")
    (version "2.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "parking" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1blwbkq6im1hfxp5wlbr475mw98rsyc0bbr2d5n16m38z253p0dv"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-parking-lot-0.12
  (package
    (name "rust-parking-lot")
    (version "0.12.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "parking_lot" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ys2dzz6cysjmwyivwxczl1ljpcf5cj4qmhdj07d5bkc9z5g0jky"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-parking-lot-core"
          ,rust-parking-lot-core-0.9)
         ("rust-lock-api" ,rust-lock-api-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-parking-lot-core-0.9
  (package
    (name "rust-parking-lot-core")
    (version "0.9.10")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "parking_lot_core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1y3cf9ld9ijf7i4igwzffcn0xl16dxyn4c5bwgjck1dkgabiyh0y"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-targets"
          ,rust-windows-targets-0.52)
         ("rust-smallvec" ,rust-smallvec-1)
         ("rust-redox-syscall" ,rust-redox-syscall-0.5)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-parquet-42
  (package
    (name "rust-parquet")
    (version "42.0.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "parquet" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1j6ngrskg3jlsfc30di1839zjcx7l03d6xymnj0hnc68n4v9raxs"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zstd" ,rust-zstd-0.12)
         ("rust-twox-hash" ,rust-twox-hash-1)
         ("rust-thrift" ,rust-thrift-0.17)
         ("rust-snap" ,rust-snap-1)
         ("rust-seq-macro" ,rust-seq-macro-0.3)
         ("rust-paste" ,rust-paste-1)
         ("rust-num-bigint" ,rust-num-bigint-0.4)
         ("rust-num" ,rust-num-0.4)
         ("rust-lz4" ,rust-lz4-1)
         ("rust-hashbrown" ,rust-hashbrown-0.14)
         ("rust-flate2" ,rust-flate2-1)
         ("rust-chrono" ,rust-chrono-0.4)
         ("rust-bytes" ,rust-bytes-1)
         ("rust-brotli" ,rust-brotli-3)
         ("rust-base64" ,rust-base64-0.21)
         ("rust-arrow-select" ,rust-arrow-select-42)
         ("rust-arrow-schema" ,rust-arrow-schema-42)
         ("rust-arrow-ipc" ,rust-arrow-ipc-42)
         ("rust-arrow-data" ,rust-arrow-data-42)
         ("rust-arrow-cast" ,rust-arrow-cast-42)
         ("rust-arrow-buffer" ,rust-arrow-buffer-42)
         ("rust-arrow-array" ,rust-arrow-array-42)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-paste-1
  (package
    (name "rust-paste")
    (version "1.0.15")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "paste" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "02pxffpdqkapy292harq6asfjvadgp1s005fip9ljfsn9fvxgh2p"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-pathdiff-0.2
  (package
    (name "rust-pathdiff")
    (version "0.2.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "pathdiff" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1pa4dcmb7lwir4himg1mnl97a05b2z0svczg62l8940pbim12dc8"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-peg-0.6
  (package
    (name "rust-peg")
    (version "0.6.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "peg" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0rqkllpmcsda51wkhghyrp0wcg77wg12lzivqdx1fbr75246fxlz"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-peg-runtime" ,rust-peg-runtime-0.6)
         ("rust-peg-macros" ,rust-peg-macros-0.6))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-peg-macros-0.6
  (package
    (name "rust-peg-macros")
    (version "0.6.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "peg-macros" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0kdisa6di5gkgpw97897lg78jhsx6nliax3d4s6y8cvnz6n60vb3"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1)
         ("rust-peg-runtime" ,rust-peg-runtime-0.6))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-peg-runtime-0.6
  (package
    (name "rust-peg-runtime")
    (version "0.6.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "peg-runtime" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1i99fq2xj1isx44d2b06m31f58spqga9kiyka20xg69d9m8v2mcm"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-percent-encoding-2
  (package
    (name "rust-percent-encoding")
    (version "2.3.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "percent-encoding" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0gi8wgx0dcy8rnv1kywdv98lwcx67hz0a0zwpib5v2i08r88y573"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-pin-project-lite-0.2
  (package
    (name "rust-pin-project-lite")
    (version "0.2.14")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "pin-project-lite" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "00nx3f04agwjlsmd3mc5rx5haibj2v8q9b52b0kwn63wcv4nz9mx"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-pin-utils-0.1
  (package
    (name "rust-pin-utils")
    (version "0.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "pin-utils" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "117ir7vslsl2z1a7qzhws4pd01cg2d3338c47swjyvqv2n60v1wb"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-piper-0.2
  (package
    (name "rust-piper")
    (version "0.2.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "piper" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1bxgm1b56qbpfvyazixdw676bmddqkgcqlylnpmi6ywicp3b0ka6"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-futures-io" ,rust-futures-io-0.3)
         ("rust-fastrand" ,rust-fastrand-2)
         ("rust-atomic-waker" ,rust-atomic-waker-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-pkg-config-0.3
  (package
    (name "rust-pkg-config")
    (version "0.3.30")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "pkg-config" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1v07557dj1sa0aly9c90wsygc0i8xv5vnmyv0g94lpkvj8qb4cfj"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-planus-0.3
  (package
    (name "rust-planus")
    (version "0.3.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "planus" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "17x8mr175b9clg998xpi5z45f9fsspb0ncfnx2644bz817fr25pw"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-array-init-cursor"
          ,rust-array-init-cursor-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ply-rs-0.1
  (package
    (name "rust-ply-rs")
    (version "0.1.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ply-rs" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0qw9p0lbd7vqpq0d11f638fidn7v9zk6z0349kg1dmbr9b5zkbfv"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-skeptic" ,rust-skeptic-0.13)
         ("rust-peg" ,rust-peg-0.6)
         ("rust-linked-hash-map"
          ,rust-linked-hash-map-0.5)
         ("rust-byteorder" ,rust-byteorder-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-png-0.17
  (package
    (name "rust-png")
    (version "0.17.13")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "png" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1qdmajjzkdbmk5zk7qb5pc6927xa26hr2v68hbkpa9ris79v1r06"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-miniz-oxide" ,rust-miniz-oxide-0.7)
         ("rust-flate2" ,rust-flate2-1)
         ("rust-fdeflate" ,rust-fdeflate-0.3)
         ("rust-crc32fast" ,rust-crc32fast-1)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-poll-promise-0.3
  (package
    (name "rust-poll-promise")
    (version "0.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "poll-promise" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1pxprny826xsy1jbppb8xsnd324ps97ww86vpijqknprrgz5hsjz"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen-futures"
          ,rust-wasm-bindgen-futures-0.4)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-document-features"
          ,rust-document-features-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-polling-2
  (package
    (name "rust-polling")
    (version "2.8.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "polling" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1kixxfq1af1k7gkmmk9yv4j2krpp4fji2r8j4cz6p6d7ihz34bab"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.48)
         ("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-log" ,rust-log-0.4)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-concurrent-queue"
          ,rust-concurrent-queue-2)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-bitflags" ,rust-bitflags-1)
         ("rust-autocfg" ,rust-autocfg-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-polling-3
  (package
    (name "rust-polling")
    (version "3.7.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "polling" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1qvvccdbk49xmrwic5ljikgjvf8zrxlaf0lx44jfymj46k7r6m34"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52)
         ("rust-tracing" ,rust-tracing-0.1)
         ("rust-rustix" ,rust-rustix-0.38)
         ("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-hermit-abi" ,rust-hermit-abi-0.3)
         ("rust-concurrent-queue"
          ,rust-concurrent-queue-2)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-pollster-0.3
  (package
    (name "rust-pollster")
    (version "0.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "pollster" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1wn73ljx1pcb4p69jyiz206idj7nkfqknfvdhp64yaphhm3nys12"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-portable-atomic-1
  (package
    (name "rust-portable-atomic")
    (version "1.6.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "portable-atomic" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1h77x9qx7pns0d66vdrmdbmwpi7586h7ysnkdnhrn5mwi2cyyw3i"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-powerfmt-0.2
  (package
    (name "rust-powerfmt")
    (version "0.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "powerfmt" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "14ckj2xdpkhv3h6l5sdmb9f1d57z8hbfpdldjc2vl5givq2y77j3"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ppv-lite86-0.2
  (package
    (name "rust-ppv-lite86")
    (version "0.2.17")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ppv-lite86" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1pp6g52aw970adv3x2310n7glqnji96z0a9wiamzw89ibf0ayh2v"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-presser-0.3
  (package
    (name "rust-presser")
    (version "0.3.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "presser" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ykvqx861sjmhkdh540aafqba7i7li7gqgwrcczy6v56i9m8xkz8"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-pretty-env-logger-0.4
  (package
    (name "rust-pretty-env-logger")
    (version "0.4.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "pretty_env_logger" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "17gva1rlf9fhgr0jr19kv39f8bir3f4pa4jz02qbhl9qanwkcvcj"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-log" ,rust-log-0.4)
         ("rust-env-logger" ,rust-env-logger-0.7))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-prettyplease-0.2
  (package
    (name "rust-prettyplease")
    (version "0.2.20")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "prettyplease" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0pk4vm9fir1p0bl11p9fkgl9r1x9vi4avv8l7flb1wx2i1a364jz"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-proc-macro-crate-1
  (package
    (name "rust-proc-macro-crate")
    (version "1.3.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "proc-macro-crate" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "069r1k56bvgk0f58dm5swlssfcp79im230affwk6d9ck20g04k3z"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-toml-edit" ,rust-toml-edit-0.19)
         ("rust-once-cell" ,rust-once-cell-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-proc-macro2-1
  (package
    (name "rust-proc-macro2")
    (version "1.0.83")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "proc-macro2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0hwzkqwnam5b2fsh6nsszc20jbwx9z8klnz5m5ic7pi7qdbfncqb"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-unicode-ident" ,rust-unicode-ident-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-profiling-1
  (package
    (name "rust-profiling")
    (version "1.0.15")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "profiling" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0n5y50w07m95mk2yn94wcrbz4kip30anv7vzf5rjdjbag8flvn23"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-puffin" ,rust-puffin-0.19)
         ("rust-profiling-procmacros"
          ,rust-profiling-procmacros-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-profiling-procmacros-1
  (package
    (name "rust-profiling-procmacros")
    (version "1.0.15")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "profiling-procmacros" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1zf3a6wc21l43ckmyhfd56pyq255i9msq9i5zhn4777cr1cwy8c0"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-puffin-0.18
  (package
    (name "rust-puffin")
    (version "0.18.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "puffin" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ip8dgmqc6sb6kzpfz09qfw17a0aq4j2cx0ga43j1z5abiwhycq2"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-lz4-flex" ,rust-lz4-flex-0.11)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-byteorder" ,rust-byteorder-1)
         ("rust-bincode" ,rust-bincode-1)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-puffin-0.19
  (package
    (name "rust-puffin")
    (version "0.19.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "puffin" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0bx0hyifrr2n9fhc718zyk8za7rqnv5p5pvjwpadx7q4pga6mxxr"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-byteorder" ,rust-byteorder-1)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-puffin-http-0.15
  (package
    (name "rust-puffin-http")
    (version "0.15.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "puffin_http" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1f1ivhnb354cf6lwsc1731v09h2rx22rl27809xq0s85y0nfby7w"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-puffin" ,rust-puffin-0.18)
         ("rust-log" ,rust-log-0.4)
         ("rust-crossbeam-channel"
          ,rust-crossbeam-channel-0.5)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-pulldown-cmark-0.9
  (package
    (name "rust-pulldown-cmark")
    (version "0.9.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "pulldown-cmark" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0av876a31qvqhy7gzdg134zn4s10smlyi744mz9vrllkf906n82p"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-unicase" ,rust-unicase-2)
         ("rust-memchr" ,rust-memchr-2)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-quad-rand-0.2
  (package
    (name "rust-quad-rand")
    (version "0.2.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "quad-rand" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "125bw7b295khgwk7bnb6vkcdjyki1xbfzrcygh2mzk54yzxa33v5"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-quick-error-1
  (package
    (name "rust-quick-error")
    (version "1.2.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "quick-error" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1q6za3v78hsspisc197bg3g7rpc989qycy8ypr8ap8igv10ikl51"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-quote-1
  (package
    (name "rust-quote")
    (version "1.0.36")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "quote" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "19xcmh445bg6simirnnd4fvkmp6v2qiwxh5f6rw4a70h76pnm9qg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rand-0.8
  (package
    (name "rust-rand")
    (version "0.8.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rand" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "013l6931nn7gkc23jz5mm3qdhf93jjf0fg64nz2lp4i51qd8vbrl"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-rand-core" ,rust-rand-core-0.6)
         ("rust-rand-chacha" ,rust-rand-chacha-0.3)
         ("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rand-chacha-0.3
  (package
    (name "rust-rand-chacha")
    (version "0.3.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rand_chacha" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "123x2adin558xbhvqb8w4f6syjsdkmqff8cxwhmjacpsl1ihmhg6"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-rand-core" ,rust-rand-core-0.6)
         ("rust-ppv-lite86" ,rust-ppv-lite86-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rand-core-0.6
  (package
    (name "rust-rand-core")
    (version "0.6.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rand_core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0b4j2v4cb5krak1pv6kakv4sz6xcwbrmy2zckc32hsigbrwy82zc"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-getrandom" ,rust-getrandom-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-range-alloc-0.1
  (package
    (name "rust-range-alloc")
    (version "0.1.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "range-alloc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1azfwh89nd4idj0s272qgmw3x1cj6m7d3f44b2la02wzvkyrk2lw"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-raw-window-handle-0.5
  (package
    (name "rust-raw-window-handle")
    (version "0.5.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "raw-window-handle" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1f9k10fgda464ia1b2hni8f0sa8i0bphdsbs3di032x80qgrmzzj"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rawpointer-0.2
  (package
    (name "rust-rawpointer")
    (version "0.2.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rawpointer" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1qy1qvj17yh957vhffnq6agq0brvylw27xgks171qrah75wmg8v0"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rayon-1
  (package
    (name "rust-rayon")
    (version "1.10.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rayon" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ylgnzwgllajalr4v00y4kj22klq2jbwllm70aha232iah0sc65l"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-rayon-core" ,rust-rayon-core-1)
         ("rust-either" ,rust-either-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rayon-core-1
  (package
    (name "rust-rayon-core")
    (version "1.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rayon-core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1qpwim68ai5h0j7axa8ai8z0payaawv3id0lrgkqmapx7lx8fr8l"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-crossbeam-utils"
          ,rust-crossbeam-utils-0.8)
         ("rust-crossbeam-deque"
          ,rust-crossbeam-deque-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-analytics-0.12
  (package
    (name "rust-re-analytics")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_analytics" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1pcrs0qjnk7lx8cbg0jz2zn3x376r0xs1lrjwi2i4h53v033s9g8"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-uuid" ,rust-uuid-1)
         ("rust-time" ,rust-time-0.3)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-sha2" ,rust-sha2-0.10)
         ("rust-serde-json" ,rust-serde-json-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-build-tools" ,rust-re-build-tools-0.12)
         ("rust-re-build-info" ,rust-re-build-info-0.12)
         ("rust-ehttp" ,rust-ehttp-0.3)
         ("rust-directories-next"
          ,rust-directories-next-2)
         ("rust-crossbeam" ,rust-crossbeam-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-build-info-0.12
  (package
    (name "rust-re-build-info")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_build_info" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1bk32xs7l9fz5q60jlrlanrb0xhs0qd2zbsnapqxmr874dy5isgn"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-build-tools-0.12
  (package
    (name "rust-re-build-tools")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_build_tools" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0xwjnv8gyi7z6kbs8k17h4img8f3v8c14c7c5a62wd6qs5vywjph"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-walkdir" ,rust-walkdir-2)
         ("rust-unindent" ,rust-unindent-0.1)
         ("rust-time" ,rust-time-0.3)
         ("rust-sha2" ,rust-sha2-0.10)
         ("rust-glob" ,rust-glob-0.3)
         ("rust-cargo-metadata" ,rust-cargo-metadata-0.18)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-build-web-viewer-0.12
  (package
    (name "rust-re-build-web-viewer")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_build_web_viewer" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1s67vkidg450xar0pwi6pcdix59m389mcv2hs9355s1233rmcb85"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen-cli-support"
          ,rust-wasm-bindgen-cli-support-0.2)
         ("rust-re-error" ,rust-re-error-0.12)
         ("rust-cargo-metadata" ,rust-cargo-metadata-0.18)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-crash-handler-0.12
  (package
    (name "rust-re-crash-handler")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_crash_handler" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0k7hpmdmjva85631zhlhi2rzrx4sa9zhk1y9d9m6v29is5frpqrn"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-re-build-info" ,rust-re-build-info-0.12)
         ("rust-re-analytics" ,rust-re-analytics-0.12)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-backtrace" ,rust-backtrace-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-data-source-0.12
  (package
    (name "rust-re-data-source")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_data_source" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ylsh3vh3y3xhy1jg7jxrvibc85hy2m82xl7ps36mwpq2k01bkrj"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-walkdir" ,rust-walkdir-2)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-re-ws-comms" ,rust-re-ws-comms-0.12)
         ("rust-re-types" ,rust-re-types-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-smart-channel"
          ,rust-re-smart-channel-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log-encoding"
          ,rust-re-log-encoding-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-build-tools" ,rust-re-build-tools-0.12)
         ("rust-rayon" ,rust-rayon-1)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-image" ,rust-image-0.24)
         ("rust-anyhow" ,rust-anyhow-1)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-data-store-0.12
  (package
    (name "rust-re-data-store")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_data_store" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0byyz63zg2bqq0ffs0jp3d375a3z1d978m7vrc41mp6zjqr04klz"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-time" ,rust-web-time-0.2)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-smallvec" ,rust-smallvec-1)
         ("rust-re-types-core" ,rust-re-types-core-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-format" ,rust-re-format-0.12)
         ("rust-re-error" ,rust-re-error-0.12)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-indent" ,rust-indent-0.1)
         ("rust-document-features"
          ,rust-document-features-0.2)
         ("rust-arrow2" ,rust-arrow2-0.17)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-data-ui-0.12
  (package
    (name "rust-re-data-ui")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_data_ui" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "14mwxyllvmjn5agj80wckrhfnph78hngan1jkhn7d2mnikh667bs"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-rfd" ,rust-rfd-0.12)
         ("rust-re-viewer-context"
          ,rust-re-viewer-context-0.12)
         ("rust-re-ui" ,rust-re-ui-0.12)
         ("rust-re-types" ,rust-re-types-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-renderer" ,rust-re-renderer-0.12)
         ("rust-re-query" ,rust-re-query-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-format" ,rust-re-format-0.12)
         ("rust-re-error" ,rust-re-error-0.12)
         ("rust-re-entity-db" ,rust-re-entity-db-0.12)
         ("rust-re-data-store" ,rust-re-data-store-0.12)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-image" ,rust-image-0.24)
         ("rust-egui-plot" ,rust-egui-plot-0.24)
         ("rust-egui-extras" ,rust-egui-extras-0.24)
         ("rust-egui" ,rust-egui-0.24)
         ("rust-bytemuck" ,rust-bytemuck-1)
         ("rust-anyhow" ,rust-anyhow-1)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-entity-db-0.12
  (package
    (name "rust-re-entity-db")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_entity_db" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1y6l4ri25d600v24xhphhg341rph8q558px9rhnrzb5dldx0vd76"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-time" ,rust-web-time-0.2)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-rmp-serde" ,rust-rmp-serde-1)
         ("rust-re-types-core" ,rust-re-types-core-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-smart-channel"
          ,rust-re-smart-channel-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-int-histogram"
          ,rust-re-int-histogram-0.12)
         ("rust-re-format" ,rust-re-format-0.12)
         ("rust-re-data-store" ,rust-re-data-store-0.12)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-getrandom" ,rust-getrandom-0.2)
         ("rust-emath" ,rust-emath-0.24)
         ("rust-egui-plot" ,rust-egui-plot-0.24)
         ("rust-document-features"
          ,rust-document-features-0.2)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-error-0.12
  (package
    (name "rust-re-error")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_error" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1nwl1ih0db47i0w6jnb4bq9rqmnx85cfcwhfnfha8idp8b27dnac"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-format-0.12
  (package
    (name "rust-re-format")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_format" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "08wnjf52aniv884z2hmz1lryf7d3y7rchpppz6ra9v4d0qx2bxqp"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-re-types-core" ,rust-re-types-core-0.12)
         ("rust-re-tuid" ,rust-re-tuid-0.12)
         ("rust-comfy-table" ,rust-comfy-table-6)
         ("rust-arrow2" ,rust-arrow2-0.17))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-int-histogram-0.12
  (package
    (name "rust-re-int-histogram")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_int_histogram" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "012w12xhknplcczs2n9x6ihvs6rsbxbkh4zq53a7jdmq3gj0lh07"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-smallvec" ,rust-smallvec-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-log-0.12
  (package
    (name "rust-re-log")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_log" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0dkbwgh0gds49crravfqv171dlw63a1c5whhalwsc83lq6r8kzs5"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-tracing" ,rust-tracing-0.1)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-log-once" ,rust-log-once-0.4)
         ("rust-log" ,rust-log-0.4)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-env-logger" ,rust-env-logger-0.10))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-log-encoding-0.12
  (package
    (name "rust-re-log-encoding")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_log_encoding" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0r9w50ciwrc753p1xz9rh6yqcbj0b8wzzlgwq65f24m2yyn2f810"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-time" ,rust-web-time-0.2)
         ("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-wasm-bindgen-futures"
          ,rust-wasm-bindgen-futures-0.4)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-rmp-serde" ,rust-rmp-serde-1)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-smart-channel"
          ,rust-re-smart-channel-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-build-info" ,rust-re-build-info-0.12)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-lz4-flex" ,rust-lz4-flex-0.11)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-ehttp" ,rust-ehttp-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-log-types-0.12
  (package
    (name "rust-re-log-types")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_log_types" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1s3ygrgyvv6wh093vgzqdynf8c6bs83vrsvl4j85ipbvxv1qlk1j"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-time" ,rust-web-time-0.2)
         ("rust-uuid" ,rust-uuid-1)
         ("rust-typenum" ,rust-typenum-1)
         ("rust-time" ,rust-time-0.3)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-smallvec" ,rust-smallvec-1)
         ("rust-similar-asserts" ,rust-similar-asserts-1)
         ("rust-serde-bytes" ,rust-serde-bytes-0.11)
         ("rust-serde" ,rust-serde-1)
         ("rust-re-types-core" ,rust-re-types-core-0.12)
         ("rust-re-tuid" ,rust-re-tuid-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-string-interner"
          ,rust-re-string-interner-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-format" ,rust-re-format-0.12)
         ("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-num-derive" ,rust-num-derive-0.4)
         ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
         ("rust-natord" ,rust-natord-1)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-half" ,rust-half-2)
         ("rust-fixed" ,rust-fixed-1)
         ("rust-document-features"
          ,rust-document-features-0.2)
         ("rust-crossbeam" ,rust-crossbeam-0.8)
         ("rust-clean-path" ,rust-clean-path-0.2)
         ("rust-bytemuck" ,rust-bytemuck-1)
         ("rust-backtrace" ,rust-backtrace-0.3)
         ("rust-arrow2" ,rust-arrow2-0.17)
         ("rust-anyhow" ,rust-anyhow-1)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-memory-0.12
  (package
    (name "rust-re-memory")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_memory" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1qpkgk1zq7r0bij6hzs3x95na1p2nc8lz63hjqjdh4fap7iwk8bc"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-time" ,rust-web-time-0.2)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-sysinfo" ,rust-sysinfo-0.30)
         ("rust-smallvec" ,rust-smallvec-1)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-format" ,rust-re-format-0.12)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
         ("rust-memory-stats" ,rust-memory-stats-1)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-emath" ,rust-emath-0.24)
         ("rust-backtrace" ,rust-backtrace-0.3)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-query-0.12
  (package
    (name "rust-re-query")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_query" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "18srx025b2ryjk1qx6a54damcr3g0dwns6dbfmjcyb7n8a2skpan"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-thiserror" ,rust-thiserror-1)
         ("rust-re-types-core" ,rust-re-types-core-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-format" ,rust-re-format-0.12)
         ("rust-re-entity-db" ,rust-re-entity-db-0.12)
         ("rust-re-data-store" ,rust-re-data-store-0.12)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-document-features"
          ,rust-document-features-0.2)
         ("rust-backtrace" ,rust-backtrace-0.3)
         ("rust-arrow2" ,rust-arrow2-0.17))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-renderer-0.12
  (package
    (name "rust-re-renderer")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_renderer" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0x54r9mfzxxky8nkbh72bjssa9c9cfi2qbn744q48r73fb0x0q7v"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wgpu-core" ,rust-wgpu-core-0.18)
         ("rust-wgpu" ,rust-wgpu-0.18)
         ("rust-wasm-bindgen-futures"
          ,rust-wasm-bindgen-futures-0.4)
         ("rust-walkdir" ,rust-walkdir-2)
         ("rust-type-map" ,rust-type-map-0.5)
         ("rust-tobj" ,rust-tobj-4)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-smallvec" ,rust-smallvec-1)
         ("rust-slotmap" ,rust-slotmap-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-error" ,rust-re-error-0.12)
         ("rust-re-build-tools" ,rust-re-build-tools-0.12)
         ("rust-profiling" ,rust-profiling-1)
         ("rust-pathdiff" ,rust-pathdiff-0.2)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-ordered-float" ,rust-ordered-float-4)
         ("rust-notify" ,rust-notify-6)
         ("rust-never" ,rust-never-0.1)
         ("rust-macaw" ,rust-macaw-0.18)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-half" ,rust-half-2)
         ("rust-gltf" ,rust-gltf-1)
         ("rust-glam" ,rust-glam-0.22)
         ("rust-enumset" ,rust-enumset-1)
         ("rust-ecolor" ,rust-ecolor-0.24)
         ("rust-document-features"
          ,rust-document-features-0.2)
         ("rust-crossbeam" ,rust-crossbeam-0.8)
         ("rust-clean-path" ,rust-clean-path-0.2)
         ("rust-cfg-aliases" ,rust-cfg-aliases-0.2)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-bytemuck" ,rust-bytemuck-1)
         ("rust-bitflags" ,rust-bitflags-2)
         ("rust-arrow2" ,rust-arrow2-0.17)
         ("rust-anyhow" ,rust-anyhow-1)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-sdk-0.12
  (package
    (name "rust-re-sdk")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_sdk" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0zrfz5qf33c105mdzxmg17ip5vrjgh1znxn4afcl0p3lndyid2rd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-thiserror" ,rust-thiserror-1)
         ("rust-re-types-core" ,rust-re-types-core-0.12)
         ("rust-re-sdk-comms" ,rust-re-sdk-comms-0.12)
         ("rust-re-memory" ,rust-re-memory-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log-encoding"
          ,rust-re-log-encoding-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-build-tools" ,rust-re-build-tools-0.12)
         ("rust-re-build-info" ,rust-re-build-info-0.12)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-document-features"
          ,rust-document-features-0.2)
         ("rust-crossbeam" ,rust-crossbeam-0.8)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-sdk-comms-0.12
  (package
    (name "rust-re-sdk-comms")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_sdk_comms" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1wyfa4spjxvqzgy9mir7xq6vksiihk6i9673kdq2gkyh8a96xjwj"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-tokio" ,rust-tokio-1)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-re-smart-channel"
          ,rust-re-smart-channel-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log-encoding"
          ,rust-re-log-encoding-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-rand" ,rust-rand-0.8)
         ("rust-document-features"
          ,rust-document-features-0.2)
         ("rust-crossbeam" ,rust-crossbeam-0.8)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-smart-channel-0.12
  (package
    (name "rust-re-smart-channel")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_smart_channel" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1pl5ns0i5g768zfjcilcibhlmcis7f7v3w3d79nz517pd6zj1nv9"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-time" ,rust-web-time-0.2)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-crossbeam" ,rust-crossbeam-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-space-view-0.12
  (package
    (name "rust-re-space-view")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_space_view" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1iwhv49hvc9c8865d8cn2x40p865m855gw7hkpcb232j454s9r8q"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-smallvec" ,rust-smallvec-1)
         ("rust-slotmap" ,rust-slotmap-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-re-viewer-context"
          ,rust-re-viewer-context-0.12)
         ("rust-re-types-core" ,rust-re-types-core-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-entity-db" ,rust-re-entity-db-0.12)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-egui" ,rust-egui-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-space-view-bar-chart-0.12
  (package
    (name "rust-re-space-view-bar-chart")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_space_view_bar_chart" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "17gs03l7vx8ln06icn6rarvksnqc4c0sh83l2iy6jkc1db0yrxja"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-re-viewer-context"
          ,rust-re-viewer-context-0.12)
         ("rust-re-ui" ,rust-re-ui-0.12)
         ("rust-re-types" ,rust-re-types-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-space-view" ,rust-re-space-view-0.12)
         ("rust-re-renderer" ,rust-re-renderer-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-entity-db" ,rust-re-entity-db-0.12)
         ("rust-re-data-store" ,rust-re-data-store-0.12)
         ("rust-egui-plot" ,rust-egui-plot-0.24)
         ("rust-egui" ,rust-egui-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-space-view-dataframe-0.12
  (package
    (name "rust-re-space-view-dataframe")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_space_view_dataframe" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1lb9l0ni4yrvgzs21sakf497x5gzh35xm0lk9jykdd99z21dcm90"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-re-viewer-context"
          ,rust-re-viewer-context-0.12)
         ("rust-re-ui" ,rust-re-ui-0.12)
         ("rust-re-types" ,rust-re-types-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-renderer" ,rust-re-renderer-0.12)
         ("rust-re-query" ,rust-re-query-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-entity-db" ,rust-re-entity-db-0.12)
         ("rust-re-data-ui" ,rust-re-data-ui-0.12)
         ("rust-re-data-store" ,rust-re-data-store-0.12)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-egui-extras" ,rust-egui-extras-0.24)
         ("rust-egui" ,rust-egui-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-space-view-spatial-0.12
  (package
    (name "rust-re-space-view-spatial")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_space_view_spatial" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0w31k5c18fs35kjwa9h9vxqi5mbnccc6l50m94nqwg0adnsx9r01"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-smallvec" ,rust-smallvec-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-re-viewer-context"
          ,rust-re-viewer-context-0.12)
         ("rust-re-ui" ,rust-re-ui-0.12)
         ("rust-re-types" ,rust-re-types-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-space-view" ,rust-re-space-view-0.12)
         ("rust-re-renderer" ,rust-re-renderer-0.12)
         ("rust-re-query" ,rust-re-query-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-format" ,rust-re-format-0.12)
         ("rust-re-error" ,rust-re-error-0.12)
         ("rust-re-entity-db" ,rust-re-entity-db-0.12)
         ("rust-re-data-ui" ,rust-re-data-ui-0.12)
         ("rust-re-data-store" ,rust-re-data-store-0.12)
         ("rust-rayon" ,rust-rayon-1)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
         ("rust-macaw" ,rust-macaw-0.18)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-glam" ,rust-glam-0.22)
         ("rust-egui" ,rust-egui-0.24)
         ("rust-bytemuck" ,rust-bytemuck-1)
         ("rust-anyhow" ,rust-anyhow-1)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-space-view-tensor-0.12
  (package
    (name "rust-re-space-view-tensor")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_space_view_tensor" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ydi3yii6i82n74bgqkh0wmi1n2zvk73gckk8k0w5dr0yp1rjdh4"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wgpu" ,rust-wgpu-0.18)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-re-viewer-context"
          ,rust-re-viewer-context-0.12)
         ("rust-re-ui" ,rust-re-ui-0.12)
         ("rust-re-types" ,rust-re-types-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-space-view" ,rust-re-space-view-0.12)
         ("rust-re-renderer" ,rust-re-renderer-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-entity-db" ,rust-re-entity-db-0.12)
         ("rust-re-data-ui" ,rust-re-data-ui-0.12)
         ("rust-re-data-store" ,rust-re-data-store-0.12)
         ("rust-ndarray" ,rust-ndarray-0.15)
         ("rust-half" ,rust-half-2)
         ("rust-egui" ,rust-egui-0.24)
         ("rust-bytemuck" ,rust-bytemuck-1)
         ("rust-anyhow" ,rust-anyhow-1)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-space-view-text-document-0.12
  (package
    (name "rust-re-space-view-text-document")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_space_view_text_document" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0sv4pc7rdxwajn2bpjiqi4p9f71rs31i9w4aysabbaibwwbykyjh"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-re-viewer-context"
          ,rust-re-viewer-context-0.12)
         ("rust-re-ui" ,rust-re-ui-0.12)
         ("rust-re-types" ,rust-re-types-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-renderer" ,rust-re-renderer-0.12)
         ("rust-re-query" ,rust-re-query-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-data-store" ,rust-re-data-store-0.12)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-egui-commonmark"
          ,rust-egui-commonmark-0.10)
         ("rust-egui" ,rust-egui-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-space-view-text-log-0.12
  (package
    (name "rust-re-space-view-text-log")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_space_view_text_log" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "17kssd6i6d30fs63a2jcv5hsgcfrx8fk1z8n43m2dw0vii84kd05"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-re-viewer-context"
          ,rust-re-viewer-context-0.12)
         ("rust-re-ui" ,rust-re-ui-0.12)
         ("rust-re-types" ,rust-re-types-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-renderer" ,rust-re-renderer-0.12)
         ("rust-re-query" ,rust-re-query-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-entity-db" ,rust-re-entity-db-0.12)
         ("rust-re-data-ui" ,rust-re-data-ui-0.12)
         ("rust-re-data-store" ,rust-re-data-store-0.12)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-egui-extras" ,rust-egui-extras-0.24)
         ("rust-egui" ,rust-egui-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-space-view-time-series-0.12
  (package
    (name "rust-re-space-view-time-series")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_space_view_time_series" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1nfwb626zyysrd6c2wz8ghf2rkg69bxsw36f73g3p1dwwrf538rf"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-re-viewer-context"
          ,rust-re-viewer-context-0.12)
         ("rust-re-ui" ,rust-re-ui-0.12)
         ("rust-re-types" ,rust-re-types-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-space-view" ,rust-re-space-view-0.12)
         ("rust-re-renderer" ,rust-re-renderer-0.12)
         ("rust-re-query" ,rust-re-query-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-format" ,rust-re-format-0.12)
         ("rust-re-data-store" ,rust-re-data-store-0.12)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-egui-plot" ,rust-egui-plot-0.24)
         ("rust-egui" ,rust-egui-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-string-interner-0.12
  (package
    (name "rust-re-string-interner")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_string_interner" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1nw3gvyc73rnppzwm4sqbcn5v2bq8gjhradilv8alfnr60zvm5qb"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-time-panel-0.12
  (package
    (name "rust-re-time-panel")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_time_panel" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "05mfp37p3h3lvvnp3hwzy128mgqsc48snl9jz5b8fchn6ycd6zwm"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-vec1" ,rust-vec1-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-re-viewer-context"
          ,rust-re-viewer-context-0.12)
         ("rust-re-ui" ,rust-re-ui-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-format" ,rust-re-format-0.12)
         ("rust-re-entity-db" ,rust-re-entity-db-0.12)
         ("rust-re-data-ui" ,rust-re-data-ui-0.12)
         ("rust-re-data-store" ,rust-re-data-store-0.12)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-egui" ,rust-egui-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-tracing-0.12
  (package
    (name "rust-re-tracing")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_tracing" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0l3qz73p76fqipqkjw3yz4gfldk6ax1shcyzaksz6s5nf6lkim1a"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-rfd" ,rust-rfd-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-puffin-http" ,rust-puffin-http-0.15)
         ("rust-puffin" ,rust-puffin-0.18))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-tuid-0.12
  (package
    (name "rust-re-tuid")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_tuid" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "19j1qzfimjsd6w1pq76rs5kvwbk3gmpc1bkz3wphmw51m3g7s47b"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-time" ,rust-web-time-0.2)
         ("rust-serde" ,rust-serde-1)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-getrandom" ,rust-getrandom-0.2)
         ("rust-document-features"
          ,rust-document-features-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-types-0.12
  (package
    (name "rust-re-types")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_types" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "14a2rakcln1n40w2acf5n8nnz0cglsc77zqzvzfjvvhwqg2cpl8m"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zune-jpeg" ,rust-zune-jpeg-0.4)
         ("rust-zune-core" ,rust-zune-core-0.4)
         ("rust-uuid" ,rust-uuid-1)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-smallvec" ,rust-smallvec-1)
         ("rust-re-types-core" ,rust-re-types-core-0.12)
         ("rust-re-types-builder"
          ,rust-re-types-builder-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-build-tools" ,rust-re-build-tools-0.12)
         ("rust-rayon" ,rust-rayon-1)
         ("rust-ply-rs" ,rust-ply-rs-0.1)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-ndarray" ,rust-ndarray-0.15)
         ("rust-mime-guess2" ,rust-mime-guess2-2)
         ("rust-linked-hash-map"
          ,rust-linked-hash-map-0.5)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-infer" ,rust-infer-0.15)
         ("rust-image" ,rust-image-0.24)
         ("rust-half" ,rust-half-2)
         ("rust-glam" ,rust-glam-0.22)
         ("rust-ecolor" ,rust-ecolor-0.24)
         ("rust-document-features"
          ,rust-document-features-0.2)
         ("rust-bytemuck" ,rust-bytemuck-1)
         ("rust-arrow2" ,rust-arrow2-0.17)
         ("rust-array-init" ,rust-array-init-2)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-types-builder-0.12
  (package
    (name "rust-re-types-builder")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_types_builder" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0j9p536xvmq87k51c164mhbaqvmhswyj713fxa9y10xpym3a9rb2"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-xshell" ,rust-xshell-0.2)
         ("rust-unindent" ,rust-unindent-0.1)
         ("rust-tempfile" ,rust-tempfile-3)
         ("rust-syn" ,rust-syn-2)
         ("rust-rust-format" ,rust-rust-format-0.3)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-build-tools" ,rust-re-build-tools-0.12)
         ("rust-rayon" ,rust-rayon-1)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1)
         ("rust-prettyplease" ,rust-prettyplease-0.2)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-indent" ,rust-indent-0.1)
         ("rust-flatbuffers" ,rust-flatbuffers-23)
         ("rust-convert-case" ,rust-convert-case-0.6)
         ("rust-clang-format" ,rust-clang-format-0.3)
         ("rust-camino" ,rust-camino-1)
         ("rust-arrow2" ,rust-arrow2-0.17)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-types-core-0.12
  (package
    (name "rust-re-types-core")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_types_core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "170hpzvh4vmwg617ijsb8a9ijnd07v65z1szmyznqih41asm9pkg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-thiserror" ,rust-thiserror-1)
         ("rust-smallvec" ,rust-smallvec-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-re-tuid" ,rust-re-tuid-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-string-interner"
          ,rust-re-string-interner-0.12)
         ("rust-re-error" ,rust-re-error-0.12)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-document-features"
          ,rust-document-features-0.2)
         ("rust-backtrace" ,rust-backtrace-0.3)
         ("rust-arrow2" ,rust-arrow2-0.17)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-ui-0.12
  (package
    (name "rust-re-ui")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_ui" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "04ngrpc8llg0wr0jyaizbkk2z0nshch1d03rlq34byxbp8hgbvja"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-sublime-fuzzy" ,rust-sublime-fuzzy-0.7)
         ("rust-strum-macros" ,rust-strum-macros-0.24)
         ("rust-strum" ,rust-strum-0.24)
         ("rust-serde-json" ,rust-serde-json-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-egui-extras" ,rust-egui-extras-0.24)
         ("rust-egui-commonmark"
          ,rust-egui-commonmark-0.10)
         ("rust-egui" ,rust-egui-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-viewer-0.12
  (package
    (name "rust-re-viewer")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_viewer" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0yza79mnh7ddmsnnyng4jyph0wswyv317y4kjrf618h2dva7cnyg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wgpu" ,rust-wgpu-0.18)
         ("rust-web-time" ,rust-web-time-0.2)
         ("rust-wasm-bindgen-futures"
          ,rust-wasm-bindgen-futures-0.4)
         ("rust-time" ,rust-time-0.3)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-serde-json" ,rust-serde-json-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-ron" ,rust-ron-0.8)
         ("rust-rfd" ,rust-rfd-0.12)
         ("rust-re-ws-comms" ,rust-re-ws-comms-0.12)
         ("rust-re-viewport" ,rust-re-viewport-0.12)
         ("rust-re-viewer-context"
          ,rust-re-viewer-context-0.12)
         ("rust-re-ui" ,rust-re-ui-0.12)
         ("rust-re-types-core" ,rust-re-types-core-0.12)
         ("rust-re-types" ,rust-re-types-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-time-panel" ,rust-re-time-panel-0.12)
         ("rust-re-space-view-time-series"
          ,rust-re-space-view-time-series-0.12)
         ("rust-re-space-view-text-log"
          ,rust-re-space-view-text-log-0.12)
         ("rust-re-space-view-text-document"
          ,rust-re-space-view-text-document-0.12)
         ("rust-re-space-view-tensor"
          ,rust-re-space-view-tensor-0.12)
         ("rust-re-space-view-spatial"
          ,rust-re-space-view-spatial-0.12)
         ("rust-re-space-view-dataframe"
          ,rust-re-space-view-dataframe-0.12)
         ("rust-re-space-view-bar-chart"
          ,rust-re-space-view-bar-chart-0.12)
         ("rust-re-space-view" ,rust-re-space-view-0.12)
         ("rust-re-smart-channel"
          ,rust-re-smart-channel-0.12)
         ("rust-re-renderer" ,rust-re-renderer-0.12)
         ("rust-re-memory" ,rust-re-memory-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log-encoding"
          ,rust-re-log-encoding-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-format" ,rust-re-format-0.12)
         ("rust-re-error" ,rust-re-error-0.12)
         ("rust-re-entity-db" ,rust-re-entity-db-0.12)
         ("rust-re-data-ui" ,rust-re-data-ui-0.12)
         ("rust-re-data-store" ,rust-re-data-store-0.12)
         ("rust-re-data-source" ,rust-re-data-source-0.12)
         ("rust-re-build-tools" ,rust-re-build-tools-0.12)
         ("rust-re-build-info" ,rust-re-build-info-0.12)
         ("rust-re-analytics" ,rust-re-analytics-0.12)
         ("rust-poll-promise" ,rust-poll-promise-0.3)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-image" ,rust-image-0.24)
         ("rust-ehttp" ,rust-ehttp-0.3)
         ("rust-egui-tiles" ,rust-egui-tiles-0.5)
         ("rust-egui-plot" ,rust-egui-plot-0.24)
         ("rust-egui-wgpu" ,rust-egui-wgpu-0.24)
         ("rust-egui" ,rust-egui-0.24)
         ("rust-eframe" ,rust-eframe-0.24)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-bytemuck" ,rust-bytemuck-1)
         ("rust-anyhow" ,rust-anyhow-1)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-viewer-context-0.12
  (package
    (name "rust-re-viewer-context")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_viewer_context" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "03a1klc2b38nrvk3mlzg2d383fsaqw57wvcjg09fkk44fm86xqjw"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wgpu" ,rust-wgpu-0.18)
         ("rust-uuid" ,rust-uuid-1)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-smallvec" ,rust-smallvec-1)
         ("rust-slotmap" ,rust-slotmap-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-re-ui" ,rust-re-ui-0.12)
         ("rust-re-types" ,rust-re-types-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-string-interner"
          ,rust-re-string-interner-0.12)
         ("rust-re-renderer" ,rust-re-renderer-0.12)
         ("rust-re-query" ,rust-re-query-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-entity-db" ,rust-re-entity-db-0.12)
         ("rust-re-data-store" ,rust-re-data-store-0.12)
         ("rust-re-data-source" ,rust-re-data-source-0.12)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
         ("rust-ndarray" ,rust-ndarray-0.15)
         ("rust-macaw" ,rust-macaw-0.18)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-half" ,rust-half-2)
         ("rust-glam" ,rust-glam-0.22)
         ("rust-egui-tiles" ,rust-egui-tiles-0.5)
         ("rust-egui-wgpu" ,rust-egui-wgpu-0.24)
         ("rust-egui" ,rust-egui-0.24)
         ("rust-bytemuck" ,rust-bytemuck-1)
         ("rust-bit-vec" ,rust-bit-vec-0.6)
         ("rust-arboard" ,rust-arboard-3)
         ("rust-anyhow" ,rust-anyhow-1)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-viewport-0.12
  (package
    (name "rust-re-viewport")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_viewport" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1h4skbvnhy4jdgynarwnpnn5mmw609q05kip30n9x4r84n7snm59"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-tinyvec" ,rust-tinyvec-1)
         ("rust-rmp-serde" ,rust-rmp-serde-1)
         ("rust-re-viewer-context"
          ,rust-re-viewer-context-0.12)
         ("rust-re-ui" ,rust-re-ui-0.12)
         ("rust-re-types-core" ,rust-re-types-core-0.12)
         ("rust-re-types" ,rust-re-types-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-space-view-time-series"
          ,rust-re-space-view-time-series-0.12)
         ("rust-re-space-view" ,rust-re-space-view-0.12)
         ("rust-re-renderer" ,rust-re-renderer-0.12)
         ("rust-re-query" ,rust-re-query-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-entity-db" ,rust-re-entity-db-0.12)
         ("rust-re-data-ui" ,rust-re-data-ui-0.12)
         ("rust-re-data-store" ,rust-re-data-store-0.12)
         ("rust-rayon" ,rust-rayon-1)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-image" ,rust-image-0.24)
         ("rust-glam" ,rust-glam-0.22)
         ("rust-egui-tiles" ,rust-egui-tiles-0.5)
         ("rust-egui" ,rust-egui-0.24)
         ("rust-arrow2" ,rust-arrow2-0.17)
         ("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-web-viewer-server-0.12
  (package
    (name "rust-re-web-viewer-server")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_web_viewer_server" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1gr2yffhlf3az03j9i0j8y6x9r6qv70kxlr96xhfn26xb3npskvn"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-webbrowser" ,rust-webbrowser-0.8)
         ("rust-tokio" ,rust-tokio-1)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-error" ,rust-re-error-0.12)
         ("rust-re-build-web-viewer"
          ,rust-re-build-web-viewer-0.12)
         ("rust-re-build-tools" ,rust-re-build-tools-0.12)
         ("rust-re-analytics" ,rust-re-analytics-0.12)
         ("rust-hyper" ,rust-hyper-0.14)
         ("rust-futures-util" ,rust-futures-util-0.3)
         ("rust-document-features"
          ,rust-document-features-0.2)
         ("rust-clap" ,rust-clap-4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-re-ws-comms-0.12
  (package
    (name "rust-re-ws-comms")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "re_ws_comms" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1mnz3zh5a7y7ni1ln7m4cqf9lbvn83lv3n4labfhxq6xxpa574k7"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-thiserror" ,rust-thiserror-1)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-memory" ,rust-re-memory-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-format" ,rust-re-format-0.12)
         ("rust-ewebsock" ,rust-ewebsock-0.4)
         ("rust-document-features"
          ,rust-document-features-0.2)
         ("rust-bincode" ,rust-bincode-1)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-redox-syscall-0.3
  (package
    (name "rust-redox-syscall")
    (version "0.3.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "redox_syscall" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0acgiy2lc1m2vr8cr33l5s7k9wzby8dybyab1a9p753hcbr68xjn"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-redox-syscall-0.4
  (package
    (name "rust-redox-syscall")
    (version "0.4.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "redox_syscall" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1aiifyz5dnybfvkk4cdab9p2kmphag1yad6iknc7aszlxxldf8j7"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-redox-syscall-0.5
  (package
    (name "rust-redox-syscall")
    (version "0.5.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "redox_syscall" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0zja6y3av9z50gg1hh0vsc053941wng21r43whhk8mfb9n4m5426"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-redox-users-0.4
  (package
    (name "rust-redox-users")
    (version "0.4.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "redox_users" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1498qyfyc2k3ih5aaffddvbhzi36na8iqg54hcm4pnpfa6b3sa5x"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-thiserror" ,rust-thiserror-1)
         ("rust-libredox" ,rust-libredox-0.1)
         ("rust-getrandom" ,rust-getrandom-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-regex-1
  (package
    (name "rust-regex")
    (version "1.10.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "regex" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0k5sb0h2mkwf51ab0gvv3x38jp1q7wgxf63abfbhi0wwvvgxn5y1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-regex-syntax" ,rust-regex-syntax-0.8)
         ("rust-regex-automata" ,rust-regex-automata-0.4)
         ("rust-memchr" ,rust-memchr-2)
         ("rust-aho-corasick" ,rust-aho-corasick-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-regex-automata-0.1
  (package
    (name "rust-regex-automata")
    (version "0.1.10")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "regex-automata" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ci1hvbzhrfby5fdpf4ganhf7kla58acad9i1ff1p34dzdrhs8vc"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-regex-automata-0.4
  (package
    (name "rust-regex-automata")
    (version "0.4.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "regex-automata" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1spaq7y4im7s56d1gxa2hi4hzf6dwswb1bv8xyavzya7k25kpf46"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-regex-syntax" ,rust-regex-syntax-0.8)
         ("rust-memchr" ,rust-memchr-2)
         ("rust-aho-corasick" ,rust-aho-corasick-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-regex-lite-0.1
  (package
    (name "rust-regex-lite")
    (version "0.1.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "regex-lite" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "13ndx7ibckvlasyzylqpmwlbp4kahrrdl3ph2sybsdviyar63dih"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-regex-syntax-0.8
  (package
    (name "rust-regex-syntax")
    (version "0.8.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "regex-syntax" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0mhzkm1pkqg6y53xv056qciazlg47pq0czqs94cn302ckvi49bdd"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-renderdoc-sys-1
  (package
    (name "rust-renderdoc-sys")
    (version "1.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "renderdoc-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0cj8zjs7k0gvchcx3jhpg8r9bbqy8b1hsgbz0flcq2ydn12hmcqr"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rerun-0.12
  (package
    (name "rust-rerun")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rerun" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1prc3glgsrf5idgk1r4f2lvhgimfk9jjbgxipyfnn1qifi05grcc"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-tokio" ,rust-tokio-1)
         ("rust-re-ws-comms" ,rust-re-ws-comms-0.12)
         ("rust-re-web-viewer-server"
          ,rust-re-web-viewer-server-0.12)
         ("rust-re-viewer" ,rust-re-viewer-0.12)
         ("rust-re-types" ,rust-re-types-0.12)
         ("rust-re-tracing" ,rust-re-tracing-0.12)
         ("rust-re-smart-channel"
          ,rust-re-smart-channel-0.12)
         ("rust-re-sdk-comms" ,rust-re-sdk-comms-0.12)
         ("rust-re-sdk" ,rust-re-sdk-0.12)
         ("rust-re-memory" ,rust-re-memory-0.12)
         ("rust-re-log-types" ,rust-re-log-types-0.12)
         ("rust-re-log-encoding"
          ,rust-re-log-encoding-0.12)
         ("rust-re-log" ,rust-re-log-0.12)
         ("rust-re-format" ,rust-re-format-0.12)
         ("rust-re-entity-db" ,rust-re-entity-db-0.12)
         ("rust-re-data-source" ,rust-re-data-source-0.12)
         ("rust-re-crash-handler"
          ,rust-re-crash-handler-0.12)
         ("rust-re-build-tools" ,rust-re-build-tools-0.12)
         ("rust-re-build-info" ,rust-re-build-info-0.12)
         ("rust-re-analytics" ,rust-re-analytics-0.12)
         ("rust-rayon" ,rust-rayon-1)
         ("rust-puffin" ,rust-puffin-0.18)
         ("rust-log" ,rust-log-0.4)
         ("rust-itertools" ,rust-itertools-0.12)
         ("rust-env-logger" ,rust-env-logger-0.10)
         ("rust-document-features"
          ,rust-document-features-0.2)
         ("rust-clap" ,rust-clap-4)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rfd-0.12
  (package
    (name "rust-rfd")
    (version "0.12.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rfd" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1hmcmq8nwlagm5bshmrii9s4m8caqrn7yq3l4qap513fvxbpp7iw"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.48)
         ("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-wasm-bindgen-futures"
          ,rust-wasm-bindgen-futures-0.4)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-urlencoding" ,rust-urlencoding-2)
         ("rust-raw-window-handle"
          ,rust-raw-window-handle-0.5)
         ("rust-pollster" ,rust-pollster-0.3)
         ("rust-objc-id" ,rust-objc-id-0.1)
         ("rust-objc-foundation"
          ,rust-objc-foundation-0.1)
         ("rust-objc" ,rust-objc-0.2)
         ("rust-log" ,rust-log-0.4)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-futures-util" ,rust-futures-util-0.3)
         ("rust-dispatch" ,rust-dispatch-0.2)
         ("rust-block" ,rust-block-0.1)
         ("rust-async-io" ,rust-async-io-1)
         ("rust-ashpd" ,rust-ashpd-0.6))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ring-0.17
  (package
    (name "rust-ring")
    (version "0.17.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ring" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "03fwlb1ssrmfxdckvqv033pfmk01rhx9ynwi7r186dcfcp5s8zy1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52)
         ("rust-untrusted" ,rust-untrusted-0.9)
         ("rust-spin" ,rust-spin-0.9)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-getrandom" ,rust-getrandom-0.2)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-cc" ,rust-cc-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rle-decode-fast-1
  (package
    (name "rust-rle-decode-fast")
    (version "1.0.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rle-decode-fast" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "08kljzl29rpm12fiz0qj5pask49aiswdvcjigdcq73s224rgd0im"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rmp-0.8
  (package
    (name "rust-rmp")
    (version "0.8.14")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rmp" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1i1l6dhv7vws5vp0ikakj44fk597xi59g3j6ng1q55x3dz0xg3i2"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-paste" ,rust-paste-1)
         ("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-byteorder" ,rust-byteorder-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rmp-serde-1
  (package
    (name "rust-rmp-serde")
    (version "1.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rmp-serde" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1nylmh7w2vpa1bwrnx1jfp2l4yz6i5qrmpic5zll166gfyj9kraj"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-rmp" ,rust-rmp-0.8)
         ("rust-byteorder" ,rust-byteorder-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ron-0.8
  (package
    (name "rust-ron")
    (version "0.8.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ron" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "154w53s895yxdfg7rn87c6f6x4yncc535x1x31zpcj7p0pzpw7xr"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde-derive" ,rust-serde-derive-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-bitflags" ,rust-bitflags-2)
         ("rust-base64" ,rust-base64-0.21))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rusqlite-0.29
  (package
    (name "rust-rusqlite")
    (version "0.29.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rusqlite" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1wj12rmwa8g0bfhsk307fl84k0xcw8ji872xx3k447apdl1rv6sl"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-smallvec" ,rust-smallvec-1)
         ("rust-libsqlite3-sys" ,rust-libsqlite3-sys-0.26)
         ("rust-hashlink" ,rust-hashlink-0.8)
         ("rust-fallible-streaming-iterator"
          ,rust-fallible-streaming-iterator-0.1)
         ("rust-fallible-iterator"
          ,rust-fallible-iterator-0.2)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rust-format-0.3
  (package
    (name "rust-rust-format")
    (version "0.3.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rust-format" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "09qnng2g7pk4lhw857q7hak2rl99x3bh3v0fi25f7x9vdh5w1rv0"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rustc-demangle-0.1
  (package
    (name "rust-rustc-demangle")
    (version "0.1.24")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rustc-demangle" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "07zysaafgrkzy2rjgwqdj2a8qdpsm6zv6f5pgpk9x0lm40z9b6vi"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rustc-hash-1
  (package
    (name "rust-rustc-hash")
    (version "1.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rustc-hash" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1qkc5khrmv5pqi5l5ca9p5nl5hs742cagrndhbrlk3dhlrx3zm08"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rustc-version-0.4
  (package
    (name "rust-rustc-version")
    (version "0.4.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rustc_version" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0rpk9rcdk405xhbmgclsh4pai0svn49x35aggl4nhbkd4a2zb85z"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-semver" ,rust-semver-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rustix-0.37
  (package
    (name "rust-rustix")
    (version "0.37.27")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rustix" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1lidfswa8wbg358yrrkhfvsw0hzlvl540g4lwqszw09sg8vcma7y"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.48)
         ("rust-linux-raw-sys" ,rust-linux-raw-sys-0.3)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-io-lifetimes" ,rust-io-lifetimes-1)
         ("rust-errno" ,rust-errno-0.3)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rustix-0.38
  (package
    (name "rust-rustix")
    (version "0.38.34")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rustix" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "03vkqa2ism7q56rkifyy8mns0wwqrk70f4i4fd53r97p8b05xp3h"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52)
         ("rust-linux-raw-sys" ,rust-linux-raw-sys-0.4)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-errno" ,rust-errno-0.3)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rustls-0.22
  (package
    (name "rust-rustls")
    (version "0.22.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rustls" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0cl4q6w0x1cl5ldjsgbbiiqhkz6qg5vxl5dkn9wwsyxc44vzfkmz"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zeroize" ,rust-zeroize-1)
         ("rust-subtle" ,rust-subtle-2)
         ("rust-rustls-webpki" ,rust-rustls-webpki-0.102)
         ("rust-rustls-pki-types"
          ,rust-rustls-pki-types-1)
         ("rust-ring" ,rust-ring-0.17)
         ("rust-log" ,rust-log-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rustls-pki-types-1
  (package
    (name "rust-rustls-pki-types")
    (version "1.7.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rustls-pki-types" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0banlc9xzwqrx8n0h4bd0igmq3z5hc72rn941lf22cp3gkkraqlp"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rustls-webpki-0.102
  (package
    (name "rust-rustls-webpki")
    (version "0.102.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rustls-webpki" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0gmk2abk7y2cdppqlaqmnhcv690p19af9n66sjvw84z9j9z8yi7z"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-untrusted" ,rust-untrusted-0.9)
         ("rust-rustls-pki-types"
          ,rust-rustls-pki-types-1)
         ("rust-ring" ,rust-ring-0.17))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-rustversion-1
  (package
    (name "rust-rustversion")
    (version "1.0.17")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rustversion" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1mm3fckyvb0l2209in1n2k05sws5d9mpkszbnwhq3pkq8apjhpcm"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ryu-1
  (package
    (name "rust-ryu")
    (version "1.0.18")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ryu" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "17xx2s8j1lln7iackzd9p0sv546vjq71i779gphjq923vjh5pjzk"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-sage-core-0.14-b
  (package
    (name "rust-sage-core")
    (version "0.14.7")
    (build-system cargo-build-system)
    (source
     (origin
       (method git-fetch )
       (uri (git-reference
             (url "https://github.com/lazear/sage.git")
             (commit "9e870429889b341c4773df32b65e553283301a93")))
       (modules '((guix build utils)))
       (snippet
	
	 '(begin (substitute* "Cargo.toml"
                  (("\"crates/sage-cli\",")  "") 
		  (("\"crates/sage-cloudpath\",") ""))
		(delete-file-recursively "crates/sage-cli")
		(delete-file-recursively "crates/sage-cloudpath")
		))
	;; `(begin
	;;    (rename-file "crates/sage/Cargo.toml" "Cargo.toml")
	;;    (rename-file "crates/sage/src" "src")
	;;    (delete-file-recursively "tests")
	;;    (rename-file "crates/sage/tests" "tests")
	;;    (delete-file-recursively "crates")
	;; 	  )))

       (file-name (git-file-name name version))
       (sha256
        (base32
         "063ch1yhv0xz3j5z58hdwlm074q48676y7mqb1gqgbrv6wqxh7pm"))))
    (arguments
      `(#:skip-build?
        #f
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-regex" ,rust-regex-1)
         ("rust-rayon" ,rust-rayon-1)
         ("rust-log" ,rust-log-0.4)
         ("rust-itertools" ,rust-itertools-0.10)
         ("rust-fnv" ,rust-fnv-1)
         ("rust-dashmap" ,rust-dashmap-5))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define-public rust-sage-core-0.14
  (package
    (name "rust-sage-core")
    (version "0.14.7")
    (build-system cargo-build-system)
    (source
     (origin
       ;;(or git-fetch )
       (method (git-fetch-and-targz-factory "crates/sage" (string-append "sage-core" "-" version) (string-append name ".tar.gz")))
       (uri (git-reference
             (url "https://github.com/lazear/sage.git")
             (commit "9e870429889b341c4773df32b65e553283301a93")))
       #;(file-name
        (string-append name "-" version ".tar.gz"))
  

	;; `(begin
	;;    (rename-file "crates/sage/Cargo.toml" "Cargo.toml")
	;;    (rename-file "crates/sage/src" "src")
	;;    (delete-file-recursively "tests")
	;;    (rename-file "crates/sage/tests" "tests")
	;;    (delete-file-recursively "crates")
	;; 	  )))

       (sha256
        (base32
	 "063ch1yhv0xz3j5z58hdwlm074q48676y7mqb1gqgbrv6wqxh7pm"))))
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-regex" ,rust-regex-1)
         ("rust-rayon" ,rust-rayon-1)
         ("rust-log" ,rust-log-0.4)
         ("rust-itertools" ,rust-itertools-0.10)
         ("rust-fnv" ,rust-fnv-1)
         ("rust-dashmap" ,rust-dashmap-5))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-same-file-1
  (package
    (name "rust-same-file")
    (version "1.0.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "same-file" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "00h5j1w87dmhnvbv9l8bic3y7xxsnjmssvifw2ayvgx9mb1ivz4k"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi-util" ,rust-winapi-util-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-scoped-tls-1
  (package
    (name "rust-scoped-tls")
    (version "1.0.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "scoped-tls" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "15524h04mafihcvfpgxd8f4bgc3k95aclz8grjkg9a0rxcvn9kz1"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-scopeguard-1
  (package
    (name "rust-scopeguard")
    (version "1.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "scopeguard" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0jcz9sd47zlsgcnm1hdw0664krxwb5gczlif4qngj2aif8vky54l"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-semver-1
  (package
    (name "rust-semver")
    (version "1.0.23")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "semver" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "12wqpxfflclbq4dv8sa6gchdh92ahhwn4ci1ls22wlby3h57wsb1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-seq-macro-0.3
  (package
    (name "rust-seq-macro")
    (version "0.3.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "seq-macro" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1d50kbaslrrd0374ivx15jg57f03y5xzil1wd2ajlvajzlkbzw53"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-serde-1
  (package
    (name "rust-serde")
    (version "1.0.202")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "serde" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "15d3if1151db1z89qibk0f8bpy64d93kmxypyrgvmchisjh62sr2"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde-derive" ,rust-serde-derive-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-serde-bytes-0.11
  (package
    (name "rust-serde-bytes")
    (version "0.11.14")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "serde_bytes" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0d0pb7wsq2nszxvg2dmzbj9wsvrzchbq2m4742csnhzx2g1rg14b"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-serde-derive-1
  (package
    (name "rust-serde-derive")
    (version "1.0.202")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "serde_derive" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0f28ghhyilpfn8bggs9vpm9z2015ld0fswnr9h4nkzxw0j08aj30"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-serde-json-1
  (package
    (name "rust-serde-json")
    (version "1.0.117")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "serde_json" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1hxziifjlc0kn1cci9d4crmjc7qwnfi20lxwyj9lzca2c7m84la5"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-ryu" ,rust-ryu-1)
         ("rust-itoa" ,rust-itoa-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-serde-repr-0.1
  (package
    (name "rust-serde-repr")
    (version "0.1.19")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "serde_repr" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1sb4cplc33z86pzlx38234xr141wr3cmviqgssiadisgl8dlar3c"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-serde-spanned-0.6
  (package
    (name "rust-serde-spanned")
    (version "0.6.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "serde_spanned" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1839b6m5p9ijjmcwamiya2r612ks2vg6w2pp95yg76lr3zh79rkr"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-sha1-0.10
  (package
    (name "rust-sha1")
    (version "0.10.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "sha1" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1fnnxlfg08xhkmwf2ahv634as30l1i3xhlhkvxflmasi5nd85gz3"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-digest" ,rust-digest-0.10)
         ("rust-cpufeatures" ,rust-cpufeatures-0.2)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-sha2-0.10
  (package
    (name "rust-sha2")
    (version "0.10.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "sha2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1j1x78zk9il95w9iv46dh9wm73r6xrgj32y6lzzw7bxws9dbfgbr"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-digest" ,rust-digest-0.10)
         ("rust-cpufeatures" ,rust-cpufeatures-0.2)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-signal-hook-registry-1
  (package
    (name "rust-signal-hook-registry")
    (version "1.4.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "signal-hook-registry" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1cb5akgq8ajnd5spyn587srvs4n26ryq0p78nswffwhv46sf1sd9"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-simd-adler32-0.3
  (package
    (name "rust-simd-adler32")
    (version "0.3.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "simd-adler32" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1zkq40c3iajcnr5936gjp9jjh1lpzhy44p3dq3fiw75iwr1w2vfn"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-simdutf8-0.1
  (package
    (name "rust-simdutf8")
    (version "0.1.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "simdutf8" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0fi6zvnldaw7g726wnm9vvpv4s89s5jsk7fgp3rg2l99amw64zzj"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-similar-2
  (package
    (name "rust-similar")
    (version "2.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "similar" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0h361jw5wdfp5mic9d2mljmx8y7i3j9py9kgnalmvl7i2c9wjhps"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-unicode-segmentation"
          ,rust-unicode-segmentation-1)
         ("rust-bstr" ,rust-bstr-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-similar-asserts-1
  (package
    (name "rust-similar-asserts")
    (version "1.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "similar-asserts" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "03zwg4vy2c258v8sa13snfpz22akcqdxa49l467s3z0vgn1bnhg0"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-similar" ,rust-similar-2)
         ("rust-console" ,rust-console-0.15))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-skeptic-0.13
  (package
    (name "rust-skeptic")
    (version "0.13.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "skeptic" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1a205720pnss0alxvbx0fcn3883cg3fbz5y1047hmjbnaq0kplhn"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-walkdir" ,rust-walkdir-2)
         ("rust-tempfile" ,rust-tempfile-3)
         ("rust-pulldown-cmark" ,rust-pulldown-cmark-0.9)
         ("rust-glob" ,rust-glob-0.3)
         ("rust-error-chain" ,rust-error-chain-0.12)
         ("rust-cargo-metadata" ,rust-cargo-metadata-0.14)
         ("rust-bytecount" ,rust-bytecount-0.6))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-slab-0.4
  (package
    (name "rust-slab")
    (version "0.4.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "slab" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0rxvsgir0qw5lkycrqgb1cxsvxzjv9bmx73bk5y42svnzfba94lg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-autocfg" ,rust-autocfg-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-slotmap-1
  (package
    (name "rust-slotmap")
    (version "1.0.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "slotmap" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0amqb2fn9lcy1ri0risblkcp88dl0rnfmynw7lx0nqwza77lmzyv"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-version-check" ,rust-version-check-0.9)
         ("rust-serde" ,rust-serde-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-smallvec-1
  (package
    (name "rust-smallvec")
    (version "1.13.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "smallvec" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0rsw5samawl3wsw6glrsb127rx6sh89a8wyikicw6dkdcjd1lpiw"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-smithay-client-toolkit-0.16
  (package
    (name "rust-smithay-client-toolkit")
    (version "0.16.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "smithay-client-toolkit" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1fbfr05h4bcwkkymxwdkhh59pqwgx234pv23pxjbwb4g1gijf147"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wayland-protocols"
          ,rust-wayland-protocols-0.29)
         ("rust-wayland-cursor" ,rust-wayland-cursor-0.29)
         ("rust-wayland-client" ,rust-wayland-client-0.29)
         ("rust-pkg-config" ,rust-pkg-config-0.3)
         ("rust-nix" ,rust-nix-0.24)
         ("rust-memmap2" ,rust-memmap2-0.5)
         ("rust-log" ,rust-log-0.4)
         ("rust-lazy-static" ,rust-lazy-static-1)
         ("rust-dlib" ,rust-dlib-0.5)
         ("rust-calloop" ,rust-calloop-0.10)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-smithay-clipboard-0.6
  (package
    (name "rust-smithay-clipboard")
    (version "0.6.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "smithay-clipboard" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1s5hyhbmnk75i0sm14wy4dy7c576a4dyi1chfwdhpbhz1a3mqd0a"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wayland-client" ,rust-wayland-client-0.29)
         ("rust-smithay-client-toolkit"
          ,rust-smithay-client-toolkit-0.16))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-snap-1
  (package
    (name "rust-snap")
    (version "1.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "snap" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0fxw80m831l76a5zxcwmz2aq7mcwc1pp345pnljl4cv1kbxnfsqv"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-socket2-0.4
  (package
    (name "rust-socket2")
    (version "0.4.10")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "socket2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "03ack54dxhgfifzsj14k7qa3r5c9wqy3v6mqhlim99cc03y1cycz"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi" ,rust-winapi-0.3)
         ("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-socket2-0.5
  (package
    (name "rust-socket2")
    (version "0.5.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "socket2" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "070r941wbq76xpy039an4pyiy3rfj7mp7pvibf1rcri9njq5wc6f"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52)
         ("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-spin-0.9
  (package
    (name "rust-spin")
    (version "0.9.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "spin" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0rvam5r0p3a6qhc18scqpvpgb3ckzyqxpgdfyjnghh8ja7byi039"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-lock-api" ,rust-lock-api-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-spirv-0.2
  (package
    (name "rust-spirv")
    (version "0.2.0+1.5.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "spirv" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0c7qjinqpwcfxk00qx0j46z7i31lnzg2qnnar3gz3crxzqwglsr4"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-num-traits" ,rust-num-traits-0.2)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-stable-deref-trait-1
  (package
    (name "rust-stable-deref-trait")
    (version "1.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "stable_deref_trait" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1lxjr8q2n534b2lhkxd6l6wcddzjvnksi58zv11f9y0jjmr15wd8"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-static-assertions-1
  (package
    (name "rust-static-assertions")
    (version "1.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "static_assertions" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0gsl6xmw10gvn3zs1rv99laj5ig7ylffnh71f9l34js4nr4r7sx2"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-strsim-0.11
  (package
    (name "rust-strsim")
    (version "0.11.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "strsim" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0kzvqlw8hxqb7y598w1s0hxlnmi84sg5vsipp3yg5na5d1rvba3x"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-strum-0.24
  (package
    (name "rust-strum")
    (version "0.24.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "strum" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0gz6cjhlps5idwasznklxdh2zsas6mxf99vr0n27j876q12n0gh6"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-strum-macros" ,rust-strum-macros-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-strum-0.25
  (package
    (name "rust-strum")
    (version "0.25.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "strum" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "09g1q55ms8vax1z0mxlbva3vm8n2r1179kfvbccnkjcidzm58399"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-strum-macros-0.24
  (package
    (name "rust-strum-macros")
    (version "0.24.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "strum_macros" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0naxz2y38kwq5wgirmia64vvf6qhwy8j367rw966n62gsbh5nf0y"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-1)
         ("rust-rustversion" ,rust-rustversion-1)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1)
         ("rust-heck" ,rust-heck-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-strum-macros-0.25
  (package
    (name "rust-strum-macros")
    (version "0.25.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "strum_macros" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "184y62g474zqb2f7n16x3ghvlyjbh50viw32p9w9l5lwmjlizp13"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-rustversion" ,rust-rustversion-1)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1)
         ("rust-heck" ,rust-heck-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-sublime-fuzzy-0.7
  (package
    (name "rust-sublime-fuzzy")
    (version "0.7.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "sublime_fuzzy" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "002lrl3qwfdzi087agqh9z4smmd391q6sn3y81sb62kw7w38cygs"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-subtle-2
  (package
    (name "rust-subtle")
    (version "2.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "subtle" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1g2yjs7gffgmdvkkq0wrrh0pxds3q0dv6dhkw9cdpbib656xdkc1"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-syn-1
  (package
    (name "rust-syn")
    (version "1.0.109")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "syn" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ds2if4600bd59wsv7jjgfkayfzy3hnazs394kz6zdkmna8l3dkj"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-unicode-ident" ,rust-unicode-ident-1)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-syn-2
  (package
    (name "rust-syn")
    (version "2.0.66")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "syn" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1xfgrprsbz8j31kabvfinb4fyhajlk2q7lxa18fb006yl90kyby4"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-unicode-ident" ,rust-unicode-ident-1)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-sysinfo-0.30
  (package
    (name "rust-sysinfo")
    (version "0.30.12")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "sysinfo" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1bhmz8gpjrlb69bf214j0hhs8qlnimqsbyq8cbs2lsryyl0glbvk"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows" ,rust-windows-0.52)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-ntapi" ,rust-ntapi-0.4)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-core-foundation-sys"
          ,rust-core-foundation-sys-0.8)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-tempfile-3
  (package
    (name "rust-tempfile")
    (version "3.10.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "tempfile" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1wdzz35ri168jn9al4s1g2rnsrr5ci91khgarc2rvpb3nappzdw5"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52)
         ("rust-rustix" ,rust-rustix-0.38)
         ("rust-fastrand" ,rust-fastrand-2)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-termcolor-1
  (package
    (name "rust-termcolor")
    (version "1.4.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "termcolor" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0mappjh3fj3p2nmrg4y7qv94rchwi9mzmgmfflr8p2awdj7lyy86"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi-util" ,rust-winapi-util-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-thiserror-1
  (package
    (name "rust-thiserror")
    (version "1.0.61")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "thiserror" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "028prh962l16cmjivwb1g9xalbpqip0305zhq006mg74dc6whin5"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-thiserror-impl" ,rust-thiserror-impl-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-thiserror-impl-1
  (package
    (name "rust-thiserror-impl")
    (version "1.0.61")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "thiserror-impl" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0cvm37hp0kbcyk1xac1z0chpbd9pbn2g456iyid6sah0a113ihs6"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-thrift-0.17
  (package
    (name "rust-thrift")
    (version "0.17.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "thrift" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "02cydaqqlp25ri19y3ixi77a7nd85fwvbfn4fp0qpakzzj2vqm3y"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-ordered-float" ,rust-ordered-float-2)
         ("rust-integer-encoding"
          ,rust-integer-encoding-3)
         ("rust-byteorder" ,rust-byteorder-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-tiff-0.9
  (package
    (name "rust-tiff")
    (version "0.9.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "tiff" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ghyxlz566dzc3scvgmzys11dhq2ri77kb8sznjakijlxby104xs"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-weezl" ,rust-weezl-0.1)
         ("rust-jpeg-decoder" ,rust-jpeg-decoder-0.3)
         ("rust-flate2" ,rust-flate2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-time-0.3
  (package
    (name "rust-time")
    (version "0.3.36")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "time" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "11g8hdpahgrf1wwl2rpsg5nxq3aj7ri6xr672v4qcij6cgjqizax"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-time-macros" ,rust-time-macros-0.2)
         ("rust-time-core" ,rust-time-core-0.1)
         ("rust-serde" ,rust-serde-1)
         ("rust-powerfmt" ,rust-powerfmt-0.2)
         ("rust-num-threads" ,rust-num-threads-0.1)
         ("rust-num-conv" ,rust-num-conv-0.1)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-itoa" ,rust-itoa-1)
         ("rust-deranged" ,rust-deranged-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-time-core-0.1
  (package
    (name "rust-time-core")
    (version "0.1.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "time-core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1wx3qizcihw6z151hywfzzyd1y5dl804ydyxci6qm07vbakpr4pg"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-time-macros-0.2
  (package
    (name "rust-time-macros")
    (version "0.2.18")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "time-macros" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1kqwxvfh2jkpg38fy673d6danh1bhcmmbsmffww3mphgail2l99z"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-time-core" ,rust-time-core-0.1)
         ("rust-num-conv" ,rust-num-conv-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-timsrust-0.2
  (package
    (name "rust-timsrust")
    (version "0.2.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "timsrust" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "02r98h59a1ycrx0m61ghpl101jpm1a5m4k2nkzbv5awzajd700ck"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zstd" ,rust-zstd-0.12)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-rusqlite" ,rust-rusqlite-0.29)
         ("rust-rayon" ,rust-rayon-1)
         ("rust-parquet" ,rust-parquet-42)
         ("rust-memmap2" ,rust-memmap2-0.9)
         ("rust-linreg" ,rust-linreg-0.2)
         ("rust-byteorder" ,rust-byteorder-1)
         ("rust-bytemuck" ,rust-bytemuck-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-tiny-keccak-2
  (package
    (name "rust-tiny-keccak")
    (version "2.0.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "tiny-keccak" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0dq2x0hjffmixgyf6xv9wgsbcxkd65ld0wrfqmagji8a829kg79c"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-crunchy" ,rust-crunchy-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-tinyvec-1
  (package
    (name "rust-tinyvec")
    (version "1.6.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "tinyvec" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0l6bl2h62a5m44jdnpn7lmj14rd44via8180i7121fvm73mmrk47"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-tinyvec-macros" ,rust-tinyvec-macros-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-tinyvec-macros-0.1
  (package
    (name "rust-tinyvec-macros")
    (version "0.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "tinyvec_macros" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "081gag86208sc3y6sdkshgw3vysm5d34p431dzw0bshz66ncng0z"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-tobj-4
  (package
    (name "rust-tobj")
    (version "4.0.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "tobj" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1s3jhcfyid07simdg468p8haizv5cj5sa48cdidwdr19byh4pgf3"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-ahash" ,rust-ahash-0.8))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-tokio-1
  (package
    (name "rust-tokio")
    (version "1.37.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "tokio" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "11v7qhvpwsf976frqgrjl1jy308bdkxq195gb38cypx7xkzypnqs"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.48)
         ("rust-tokio-macros" ,rust-tokio-macros-2)
         ("rust-socket2" ,rust-socket2-0.5)
         ("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-num-cpus" ,rust-num-cpus-1)
         ("rust-mio" ,rust-mio-0.8)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-bytes" ,rust-bytes-1)
         ("rust-backtrace" ,rust-backtrace-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-tokio-macros-2
  (package
    (name "rust-tokio-macros")
    (version "2.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "tokio-macros" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0fwjy4vdx1h9pi4g2nml72wi0fr27b5m954p13ji9anyy8l1x2jv"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-tokio-util-0.7
  (package
    (name "rust-tokio-util")
    (version "0.7.11")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "tokio-util" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1qcz30db6m8lxkl61b3nic4bim1symi636nhbb3rmi3i6xxv9xlw"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-tokio" ,rust-tokio-1)
         ("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-futures-sink" ,rust-futures-sink-0.3)
         ("rust-futures-core" ,rust-futures-core-0.3)
         ("rust-bytes" ,rust-bytes-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-toml-0.8
  (package
    (name "rust-toml")
    (version "0.8.13")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "toml" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1flbvj1c72avfslifz0160n5vxkyw5krrqhshm671janqj63zr54"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-toml-edit" ,rust-toml-edit-0.22)
         ("rust-toml-datetime" ,rust-toml-datetime-0.6)
         ("rust-serde-spanned" ,rust-serde-spanned-0.6)
         ("rust-serde" ,rust-serde-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-toml-datetime-0.6
  (package
    (name "rust-toml-datetime")
    (version "0.6.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "toml_datetime" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1grcrr3gh7id3cy3j700kczwwfbn04p5ncrrj369prjaj9bgvbab"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-toml-edit-0.19
  (package
    (name "rust-toml-edit")
    (version "0.19.15")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "toml_edit" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "08bl7rp5g6jwmfpad9s8jpw8wjrciadpnbaswgywpr9hv9qbfnqv"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winnow" ,rust-winnow-0.5)
         ("rust-toml-datetime" ,rust-toml-datetime-0.6)
         ("rust-indexmap" ,rust-indexmap-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-toml-edit-0.22
  (package
    (name "rust-toml-edit")
    (version "0.22.13")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "toml_edit" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0v5rkld3cl628dygbngr1gk1cxm4pxmawclpshv0ihp8a1c7h9y1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winnow" ,rust-winnow-0.6)
         ("rust-toml-datetime" ,rust-toml-datetime-0.6)
         ("rust-serde-spanned" ,rust-serde-spanned-0.6)
         ("rust-serde" ,rust-serde-1)
         ("rust-indexmap" ,rust-indexmap-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-tower-service-0.3
  (package
    (name "rust-tower-service")
    (version "0.3.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "tower-service" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0lmfzmmvid2yp2l36mbavhmqgsvzqf7r2wiwz73ml4xmwaf1rg5n"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-tracing-0.1
  (package
    (name "rust-tracing")
    (version "0.1.40")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "tracing" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1vv48dac9zgj9650pg2b4d0j3w6f3x9gbggf43scq5hrlysklln3"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-tracing-core" ,rust-tracing-core-0.1)
         ("rust-tracing-attributes"
          ,rust-tracing-attributes-0.1)
         ("rust-pin-project-lite"
          ,rust-pin-project-lite-0.2)
         ("rust-log" ,rust-log-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-tracing-attributes-0.1
  (package
    (name "rust-tracing-attributes")
    (version "0.1.27")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "tracing-attributes" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1rvb5dn9z6d0xdj14r403z0af0bbaqhg02hq4jc97g5wds6lqw1l"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-tracing-core-0.1
  (package
    (name "rust-tracing-core")
    (version "0.1.32")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "tracing-core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0m5aglin3cdwxpvbg6kz0r9r0k31j48n0kcfwsp6l49z26k3svf0"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-once-cell" ,rust-once-cell-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-try-lock-0.2
  (package
    (name "rust-try-lock")
    (version "0.2.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "try-lock" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0jqijrrvm1pyq34zn1jmy2vihd4jcrjlvsh4alkjahhssjnsn8g4"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ttf-parser-0.21
  (package
    (name "rust-ttf-parser")
    (version "0.21.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ttf-parser" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1y0wsfgri7yi41cn57g4fzqm30x1v5nlrci6j5mqcxwpys1isn9c"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-tungstenite-0.21
  (package
    (name "rust-tungstenite")
    (version "0.21.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "tungstenite" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1qaphb5kgwgid19p64grhv2b9kxy7f1059yy92l9kwrlx90sdwcy"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-utf-8" ,rust-utf-8-0.7)
         ("rust-url" ,rust-url-2)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-sha1" ,rust-sha1-0.10)
         ("rust-rand" ,rust-rand-0.8)
         ("rust-log" ,rust-log-0.4)
         ("rust-httparse" ,rust-httparse-1)
         ("rust-http" ,rust-http-1)
         ("rust-data-encoding" ,rust-data-encoding-2)
         ("rust-bytes" ,rust-bytes-1)
         ("rust-byteorder" ,rust-byteorder-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-twox-hash-1
  (package
    (name "rust-twox-hash")
    (version "1.6.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "twox-hash" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0xgn72j36a270l5ls1jk88n7bmq2dhlfkbhdh5554hbagjsydzlp"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-type-map-0.5
  (package
    (name "rust-type-map")
    (version "0.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "type-map" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "17qaga12nkankr7hi2mv43f4lnc78hg480kz6j9zmy4g0h28ddny"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-rustc-hash" ,rust-rustc-hash-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-typed-builder-0.16
  (package
    (name "rust-typed-builder")
    (version "0.16.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "typed-builder" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "05ny1brm9ff3hxrps3n328w28myk4lz0h24jhxx64dhyjhbmq21l"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-typed-builder-macro"
          ,rust-typed-builder-macro-0.16))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-typed-builder-macro-0.16
  (package
    (name "rust-typed-builder-macro")
    (version "0.16.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "typed-builder-macro" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0vp94vzcnrqlz93swkai13w9dmklpdh2c2800zpjnvi0735s8g7h"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-typenum-1
  (package
    (name "rust-typenum")
    (version "1.17.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "typenum" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "09dqxv69m9lj9zvv6xw5vxaqx15ps0vxyy5myg33i0kbqvq0pzs2"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-uds-windows-1
  (package
    (name "rust-uds-windows")
    (version "1.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "uds_windows" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1fb4y65pw0rsp0gyfyinjazlzxz1f6zv7j4zmb20l5pxwv1ypnl9"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi" ,rust-winapi-0.3)
         ("rust-tempfile" ,rust-tempfile-3)
         ("rust-memoffset" ,rust-memoffset-0.9))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-unicase-2
  (package
    (name "rust-unicase")
    (version "2.7.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "unicase" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "12gd74j79f94k4clxpf06l99wiv4p30wjr0qm04ihqk9zgdd9lpp"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-version-check" ,rust-version-check-0.9))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-unicode-bidi-0.3
  (package
    (name "rust-unicode-bidi")
    (version "0.3.15")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "unicode-bidi" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0xcdxm7h0ydyprwpcbh436rbs6s6lph7f3gr527lzgv6lw053y88"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-unicode-ident-1
  (package
    (name "rust-unicode-ident")
    (version "1.0.12")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "unicode-ident" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0jzf1znfpb2gx8nr8mvmyqs1crnv79l57nxnbiszc7xf7ynbjm1k"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-unicode-normalization-0.1
  (package
    (name "rust-unicode-normalization")
    (version "0.1.23")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "unicode-normalization" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1x81a50h2zxigj74b9bqjsirxxbyhmis54kg600xj213vf31cvd5"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-tinyvec" ,rust-tinyvec-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-unicode-segmentation-1
  (package
    (name "rust-unicode-segmentation")
    (version "1.11.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "unicode-segmentation" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "00kjpwp1g8fqm45drmwivlacn3y9jx73bvs09n6s3x73nqi7vj6l"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-unicode-width-0.1
  (package
    (name "rust-unicode-width")
    (version "0.1.12")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "unicode-width" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1mk6mybsmi5py8hf8zy9vbgs4rw4gkdqdq3gzywd9kwf2prybxb8"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-unicode-xid-0.2
  (package
    (name "rust-unicode-xid")
    (version "0.2.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "unicode-xid" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "131dfzf7d8fsr1ivch34x42c2d1ik5ig3g78brxncnn0r1sdyqpr"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-unindent-0.1
  (package
    (name "rust-unindent")
    (version "0.1.11")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "unindent" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "171may3v15wzc10z64i8sahdz49d031v7424mjsifa205ml6sxp1"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-untrusted-0.9
  (package
    (name "rust-untrusted")
    (version "0.9.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "untrusted" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ha7ib98vkc538x0z60gfn0fc5whqdd85mb87dvisdcaifi6vjwf"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-ureq-2
  (package
    (name "rust-ureq")
    (version "2.9.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "ureq" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1kcmac881h6f1v9l5wqphh8kr7kr234ff243l8wf8mhb7hg866ni"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-webpki-roots" ,rust-webpki-roots-0.26)
         ("rust-url" ,rust-url-2)
         ("rust-rustls-webpki" ,rust-rustls-webpki-0.102)
         ("rust-rustls-pki-types"
          ,rust-rustls-pki-types-1)
         ("rust-rustls" ,rust-rustls-0.22)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-log" ,rust-log-0.4)
         ("rust-flate2" ,rust-flate2-1)
         ("rust-base64" ,rust-base64-0.22))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-url-2
  (package
    (name "rust-url")
    (version "2.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "url" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0cs65961miawncdg2z20171w0vqrmraswv2ihdpd8lxp7cp31rii"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-serde" ,rust-serde-1)
         ("rust-percent-encoding"
          ,rust-percent-encoding-2)
         ("rust-idna" ,rust-idna-0.5)
         ("rust-form-urlencoded" ,rust-form-urlencoded-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-urlencoding-2
  (package
    (name "rust-urlencoding")
    (version "2.1.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "urlencoding" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1nj99jp37k47n0hvaz5fvz7z6jd0sb4ppvfy3nphr1zbnyixpy6s"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-utf-8-0.7
  (package
    (name "rust-utf-8")
    (version "0.7.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "utf-8" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1a9ns3fvgird0snjkd3wbdhwd3zdpc2h5gpyybrfr6ra5pkqxk09"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-utf8parse-0.2
  (package
    (name "rust-utf8parse")
    (version "0.2.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "utf8parse" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "02ip1a0az0qmc2786vxk2nqwsgcwf17d3a38fkf0q7hrmwh9c6vi"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-uuid-1
  (package
    (name "rust-uuid")
    (version "1.8.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "uuid" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1h7wks153j08xmdk06wnza3is8pn6j37hihd3kfv95xsxrzwz0x1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-serde" ,rust-serde-1)
         ("rust-getrandom" ,rust-getrandom-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-vcpkg-0.2
  (package
    (name "rust-vcpkg")
    (version "0.2.15")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "vcpkg" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "09i4nf5y8lig6xgj3f7fyrvzd3nlaw4znrihw8psidvv5yk4xkdc"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-vec1-1
  (package
    (name "rust-vec1")
    (version "1.12.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "vec1" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0dk9qlly3n6b5g71p9rxnnfyx7v1d31364x8wbabz2f1zz7hvdpz"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-vec-map-0.8
  (package
    (name "rust-vec-map")
    (version "0.8.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "vec_map" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1481w9g1dw9rxp3l6snkdqihzyrd2f8vispzqmwjwsdyhw8xzggi"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-version-check-0.9
  (package
    (name "rust-version-check")
    (version "0.9.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "version_check" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0gs8grwdlgh0xq660d7wr80x14vxbizmd8dbp29p2pdncx8lp1s9"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-waker-fn-1
  (package
    (name "rust-waker-fn")
    (version "1.2.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "waker-fn" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1dvk0qsv88kiq22x8w0qz0k9nyrxxm5a9a9czdwdvvhcvjh12wii"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-walkdir-2
  (package
    (name "rust-walkdir")
    (version "2.5.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "walkdir" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0jsy7a710qv8gld5957ybrnc07gavppp963gs32xk4ag8130jy99"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi-util" ,rust-winapi-util-0.1)
         ("rust-same-file" ,rust-same-file-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-walrus-0.20
  (package
    (name "rust-walrus")
    (version "0.20.3")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "walrus" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1dxdn2d45r4qdpi1av92clq8rd6igkrd4h7n94j0lh64s2f540rc"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasmparser" ,rust-wasmparser-0.80)
         ("rust-wasm-encoder" ,rust-wasm-encoder-0.29)
         ("rust-walrus-macro" ,rust-walrus-macro-0.19)
         ("rust-log" ,rust-log-0.4)
         ("rust-leb128" ,rust-leb128-0.2)
         ("rust-id-arena" ,rust-id-arena-2)
         ("rust-gimli" ,rust-gimli-0.26)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-walrus-macro-0.19
  (package
    (name "rust-walrus-macro")
    (version "0.19.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "walrus-macro" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ms0rk841019hxglzqhlppjkfnhmaszda2qb2ih7vrvi5k95nvha"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-1)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1)
         ("rust-heck" ,rust-heck-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-want-0.3
  (package
    (name "rust-want")
    (version "0.3.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "want" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "03hbfrnvqqdchb5kgxyavb9jabwza0dmh2vw5kg0dq8rxl57d9xz"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-try-lock" ,rust-try-lock-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasi-0.11
  (package
    (name "rust-wasi")
    (version "0.11.0+wasi-snapshot-preview1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wasi" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "08z4hxwkpdpalxjps1ai9y7ihin26y9f476i53dv98v45gkqg3cw"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasm-bindgen-0.2
  (package
    (name "rust-wasm-bindgen")
    (version "0.2.92")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wasm-bindgen" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1a4mcw13nsk3fr8fxjzf9kk1wj88xkfsmnm0pjraw01ryqfm7qjb"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen-macro"
          ,rust-wasm-bindgen-macro-0.2)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasm-bindgen-backend-0.2
  (package
    (name "rust-wasm-bindgen-backend")
    (version "0.2.92")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wasm-bindgen-backend" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1nj7wxbi49f0rw9d44rjzms26xlw6r76b2mrggx8jfbdjrxphkb1"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen-shared"
          ,rust-wasm-bindgen-shared-0.2)
         ("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-log" ,rust-log-0.4)
         ("rust-bumpalo" ,rust-bumpalo-3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasm-bindgen-cli-support-0.2
  (package
    (name "rust-wasm-bindgen-cli-support")
    (version "0.2.92")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wasm-bindgen-cli-support" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0zw1h0yil1p069h7q8pzra3qbakd42d974s4x72qfv5fq6l1v0na"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen-wasm-interpreter"
          ,rust-wasm-bindgen-wasm-interpreter-0.2)
         ("rust-wasm-bindgen-wasm-conventions"
          ,rust-wasm-bindgen-wasm-conventions-0.2)
         ("rust-wasm-bindgen-threads-xform"
          ,rust-wasm-bindgen-threads-xform-0.2)
         ("rust-wasm-bindgen-shared"
          ,rust-wasm-bindgen-shared-0.2)
         ("rust-wasm-bindgen-multi-value-xform"
          ,rust-wasm-bindgen-multi-value-xform-0.2)
         ("rust-wasm-bindgen-externref-xform"
          ,rust-wasm-bindgen-externref-xform-0.2)
         ("rust-walrus" ,rust-walrus-0.20)
         ("rust-unicode-ident" ,rust-unicode-ident-1)
         ("rust-tempfile" ,rust-tempfile-3)
         ("rust-serde-json" ,rust-serde-json-1)
         ("rust-rustc-demangle" ,rust-rustc-demangle-0.1)
         ("rust-log" ,rust-log-0.4)
         ("rust-base64" ,rust-base64-0.21)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasm-bindgen-externref-xform-0.2
  (package
    (name "rust-wasm-bindgen-externref-xform")
    (version "0.2.92")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri
               "wasm-bindgen-externref-xform"
               version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "09d73pq9wkh3kbb52y8c1k2d9zphs3iqvgvz2m9hv8rmddr8498h"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-walrus" ,rust-walrus-0.20)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasm-bindgen-futures-0.4
  (package
    (name "rust-wasm-bindgen-futures")
    (version "0.4.42")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wasm-bindgen-futures" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1h322zjvpjllcpj7dahfxjsv6inkr6y0baw7nkdwivr1c4v19g3n"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasm-bindgen-macro-0.2
  (package
    (name "rust-wasm-bindgen-macro")
    (version "0.2.92")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wasm-bindgen-macro" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "09npa1srjjabd6nfph5yc03jb26sycjlxhy0c2a1pdrpx4yq5y51"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen-macro-support"
          ,rust-wasm-bindgen-macro-support-0.2)
         ("rust-quote" ,rust-quote-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasm-bindgen-macro-support-0.2
  (package
    (name "rust-wasm-bindgen-macro-support")
    (version "0.2.92")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wasm-bindgen-macro-support" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1dqv2xs8zcyw4kjgzj84bknp2h76phmsb3n7j6hn396h4ssifkz9"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen-shared"
          ,rust-wasm-bindgen-shared-0.2)
         ("rust-wasm-bindgen-backend"
          ,rust-wasm-bindgen-backend-0.2)
         ("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasm-bindgen-multi-value-xform-0.2
  (package
    (name "rust-wasm-bindgen-multi-value-xform")
    (version "0.2.92")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri
               "wasm-bindgen-multi-value-xform"
               version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "191j5yaya8j80ch81hhrjyy8sal89pq9ix7g1iw3slj3kxwy961l"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-walrus" ,rust-walrus-0.20)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasm-bindgen-shared-0.2
  (package
    (name "rust-wasm-bindgen-shared")
    (version "0.2.92")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wasm-bindgen-shared" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "15kyavsrna2cvy30kg03va257fraf9x00ny554vxngvpyaa0q6dg"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasm-bindgen-threads-xform-0.2
  (package
    (name "rust-wasm-bindgen-threads-xform")
    (version "0.2.92")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wasm-bindgen-threads-xform" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1naxkckfjnysiy64zy4c5d7jc524wndx5acraajhjzbzkcsxsnid"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen-wasm-conventions"
          ,rust-wasm-bindgen-wasm-conventions-0.2)
         ("rust-walrus" ,rust-walrus-0.20)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasm-bindgen-wasm-conventions-0.2
  (package
    (name "rust-wasm-bindgen-wasm-conventions")
    (version "0.2.92")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri
               "wasm-bindgen-wasm-conventions"
               version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0xdmsfdypj45v8k8gvw9n1y4gswb5rgkmnv0h9v7c3l1gdhf614c"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-walrus" ,rust-walrus-0.20)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasm-bindgen-wasm-interpreter-0.2
  (package
    (name "rust-wasm-bindgen-wasm-interpreter")
    (version "0.2.92")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri
               "wasm-bindgen-wasm-interpreter"
               version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0flvx2m0dxdlyrng8qllx02dwsbsp572ahynnhza6hw27icndacy"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen-wasm-conventions"
          ,rust-wasm-bindgen-wasm-conventions-0.2)
         ("rust-walrus" ,rust-walrus-0.20)
         ("rust-log" ,rust-log-0.4)
         ("rust-anyhow" ,rust-anyhow-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasm-encoder-0.29
  (package
    (name "rust-wasm-encoder")
    (version "0.29.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wasm-encoder" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1098j622k5mgcjqfdgdr3j3pqdxq81jk3gir59hz7szajayivi0q"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-leb128" ,rust-leb128-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasm-streams-0.3
  (package
    (name "rust-wasm-streams")
    (version "0.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wasm-streams" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1iqa4kmhbsjj8k4q15i1x0x4p3xda0dhbg7zw51mydr4g129sq5l"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-wasm-bindgen-futures"
          ,rust-wasm-bindgen-futures-0.4)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-futures-util" ,rust-futures-util-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wasmparser-0.80
  (package
    (name "rust-wasmparser")
    (version "0.80.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wasmparser" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0ssa6d22qyc4d7kwhj54hsay142fh392ipjcyazs3496hgi6g4a4"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wayland-client-0.29
  (package
    (name "rust-wayland-client")
    (version "0.29.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wayland-client" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "05b7qikqj22rjy17kqw5ar7j2chpy18dr0gqapvwjfd00n60cfrz"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wayland-sys" ,rust-wayland-sys-0.29)
         ("rust-wayland-scanner"
          ,rust-wayland-scanner-0.29)
         ("rust-wayland-commons"
          ,rust-wayland-commons-0.29)
         ("rust-scoped-tls" ,rust-scoped-tls-1)
         ("rust-nix" ,rust-nix-0.24)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-downcast-rs" ,rust-downcast-rs-1)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wayland-commons-0.29
  (package
    (name "rust-wayland-commons")
    (version "0.29.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wayland-commons" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "00m90bnxqy0d6lzqlyazc1jh18jgbjwigmyr0rk3m8w4slsg34c6"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wayland-sys" ,rust-wayland-sys-0.29)
         ("rust-smallvec" ,rust-smallvec-1)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-nix" ,rust-nix-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wayland-cursor-0.29
  (package
    (name "rust-wayland-cursor")
    (version "0.29.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wayland-cursor" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0qbn6wqmjibkx3lb3ggbp07iabzgx2zhrm0wxxxjbmhkdyvccrb8"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-xcursor" ,rust-xcursor-0.3)
         ("rust-wayland-client" ,rust-wayland-client-0.29)
         ("rust-nix" ,rust-nix-0.24))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wayland-protocols-0.29
  (package
    (name "rust-wayland-protocols")
    (version "0.29.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wayland-protocols" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ihbjyd0w460gd7w22g9qabbwd4v8x74f8vsh7p25csljcgn4l5r"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wayland-scanner"
          ,rust-wayland-scanner-0.29)
         ("rust-wayland-commons"
          ,rust-wayland-commons-0.29)
         ("rust-wayland-client" ,rust-wayland-client-0.29)
         ("rust-bitflags" ,rust-bitflags-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wayland-scanner-0.29
  (package
    (name "rust-wayland-scanner")
    (version "0.29.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wayland-scanner" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0lxx3i2kxnmsk421qx87lqqc9kd2y1ksjxcyg0pqbar2zbc06hwg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-xml-rs" ,rust-xml-rs-0.8)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wayland-sys-0.29
  (package
    (name "rust-wayland-sys")
    (version "0.29.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wayland-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1m79qqmr1hx7jlyrvnrxjma5s6dk5js9fjsr4nx7vv1r7hdcw4my"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pkg-config" ,rust-pkg-config-0.3)
         ("rust-lazy-static" ,rust-lazy-static-1)
         ("rust-dlib" ,rust-dlib-0.5))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-web-sys-0.3
  (package
    (name "rust-web-sys")
    (version "0.3.64")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "web-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "16r4fww3l99kxhb66hka3kxkmhhgzhnqkzdf0ay6l2i2ikpwp1cv"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-js-sys" ,rust-js-sys-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-web-time-0.2
  (package
    (name "rust-web-time")
    (version "0.2.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "web-time" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1q6gk0nkwbfz30g1pz8g52mq00zjx7m5im36k3474aw73jdh8c5a"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-js-sys" ,rust-js-sys-0.3))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-webbrowser-0.8
  (package
    (name "rust-webbrowser")
    (version "0.8.15")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "webbrowser" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "12zw844al9kf32p5llv6dbqzaky9fa3ng497i3sk8mj0m5sswryv"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-url" ,rust-url-2)
         ("rust-raw-window-handle"
          ,rust-raw-window-handle-0.5)
         ("rust-objc" ,rust-objc-0.2)
         ("rust-ndk-context" ,rust-ndk-context-0.1)
         ("rust-log" ,rust-log-0.4)
         ("rust-jni" ,rust-jni-0.21)
         ("rust-home" ,rust-home-0.5)
         ("rust-core-foundation"
          ,rust-core-foundation-0.9))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-webpki-roots-0.26
  (package
    (name "rust-webpki-roots")
    (version "0.26.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "webpki-roots" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "029006qfs61q75gl60aap25m0gdqmvd1pcpljid9b0q44yp39pmk"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-rustls-pki-types"
          ,rust-rustls-pki-types-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-weezl-0.1
  (package
    (name "rust-weezl")
    (version "0.1.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "weezl" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "10lhndjgs6y5djpg3b420xngcr6jkmv70q8rb1qcicbily35pa2k"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wgpu-0.18
  (package
    (name "rust-wgpu")
    (version "0.18.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wgpu" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "097gjin9snc32y9x1vanw0vyzw2dpl7wpx163h3g4qgrr4kx5rrh"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wgpu-types" ,rust-wgpu-types-0.18)
         ("rust-wgpu-hal" ,rust-wgpu-hal-0.18)
         ("rust-wgpu-core" ,rust-wgpu-core-0.18)
         ("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-wasm-bindgen-futures"
          ,rust-wasm-bindgen-futures-0.4)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-smallvec" ,rust-smallvec-1)
         ("rust-raw-window-handle"
          ,rust-raw-window-handle-0.5)
         ("rust-profiling" ,rust-profiling-1)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-naga" ,rust-naga-0.14)
         ("rust-log" ,rust-log-0.4)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-flume" ,rust-flume-0.11)
         ("rust-cfg-if" ,rust-cfg-if-1)
         ("rust-arrayvec" ,rust-arrayvec-0.7))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wgpu-core-0.18
  (package
    (name "rust-wgpu-core")
    (version "0.18.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wgpu-core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "09i7653il0aaqh4xxnyb66amrxzdb2i320b0kv3q37hy5pbc34gg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-wgpu-types" ,rust-wgpu-types-0.18)
         ("rust-wgpu-hal" ,rust-wgpu-hal-0.18)
         ("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-smallvec" ,rust-smallvec-1)
         ("rust-rustc-hash" ,rust-rustc-hash-1)
         ("rust-raw-window-handle"
          ,rust-raw-window-handle-0.5)
         ("rust-profiling" ,rust-profiling-1)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-naga" ,rust-naga-0.14)
         ("rust-log" ,rust-log-0.4)
         ("rust-codespan-reporting"
          ,rust-codespan-reporting-0.11)
         ("rust-bitflags" ,rust-bitflags-2)
         ("rust-bit-vec" ,rust-bit-vec-0.6)
         ("rust-arrayvec" ,rust-arrayvec-0.7))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wgpu-hal-0.18
  (package
    (name "rust-wgpu-hal")
    (version "0.18.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wgpu-hal" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1nfdqsf8m1j069f9ri762gplgfsvwipymn9xrys6gsx35n0cqkmq"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi" ,rust-winapi-0.3)
         ("rust-wgpu-types" ,rust-wgpu-types-0.18)
         ("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-thiserror" ,rust-thiserror-1)
         ("rust-smallvec" ,rust-smallvec-1)
         ("rust-rustc-hash" ,rust-rustc-hash-1)
         ("rust-renderdoc-sys" ,rust-renderdoc-sys-1)
         ("rust-raw-window-handle"
          ,rust-raw-window-handle-0.5)
         ("rust-range-alloc" ,rust-range-alloc-0.1)
         ("rust-profiling" ,rust-profiling-1)
         ("rust-parking-lot" ,rust-parking-lot-0.12)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-objc" ,rust-objc-0.2)
         ("rust-naga" ,rust-naga-0.14)
         ("rust-metal" ,rust-metal-0.27)
         ("rust-log" ,rust-log-0.4)
         ("rust-libloading" ,rust-libloading-0.8)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-khronos-egl" ,rust-khronos-egl-6)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-hassle-rs" ,rust-hassle-rs-0.10)
         ("rust-gpu-descriptor" ,rust-gpu-descriptor-0.2)
         ("rust-gpu-allocator" ,rust-gpu-allocator-0.23)
         ("rust-gpu-alloc" ,rust-gpu-alloc-0.6)
         ("rust-glutin-wgl-sys" ,rust-glutin-wgl-sys-0.5)
         ("rust-glow" ,rust-glow-0.13)
         ("rust-d3d12" ,rust-d3d12-0.7)
         ("rust-core-graphics-types"
          ,rust-core-graphics-types-0.1)
         ("rust-block" ,rust-block-0.1)
         ("rust-bitflags" ,rust-bitflags-2)
         ("rust-bit-set" ,rust-bit-set-0.5)
         ("rust-ash" ,rust-ash-0.37)
         ("rust-arrayvec" ,rust-arrayvec-0.7)
         ("rust-android-system-properties"
          ,rust-android-system-properties-0.1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-wgpu-types-0.18
  (package
    (name "rust-wgpu-types")
    (version "0.18.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "wgpu-types" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1pdwfh3wgcy4y1njwjirdy3cw5b3k0237i8iwcgkbpphxpqdaphd"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-js-sys" ,rust-js-sys-0.3)
         ("rust-bitflags" ,rust-bitflags-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-widestring-1
  (package
    (name "rust-widestring")
    (version "1.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "widestring" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "048kxd6iykzi5la9nikpc5hvpp77hmjf1sw43sl3z2dcdrmx66bj"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-winapi-0.3
  (package
    (name "rust-winapi")
    (version "0.3.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "winapi" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "06gl025x418lchw1wxj64ycr7gha83m44cjr5sarhynd9xkrm0sw"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi-x86-64-pc-windows-gnu"
          ,rust-winapi-x86-64-pc-windows-gnu-0.4)
         ("rust-winapi-i686-pc-windows-gnu"
          ,rust-winapi-i686-pc-windows-gnu-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-winapi-i686-pc-windows-gnu-0.4
  (package
    (name "rust-winapi-i686-pc-windows-gnu")
    (version "0.4.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "winapi-i686-pc-windows-gnu" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1dmpa6mvcvzz16zg6d5vrfy4bxgg541wxrcip7cnshi06v38ffxc"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-winapi-util-0.1
  (package
    (name "rust-winapi-util")
    (version "0.1.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "winapi-util" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0svcgddd2rw06mj4r76gj655qsa1ikgz3d3gzax96fz7w62c6k2d"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-sys" ,rust-windows-sys-0.52))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-winapi-x86-64-pc-windows-gnu-0.4
  (package
    (name "rust-winapi-x86-64-pc-windows-gnu")
    (version "0.4.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri
               "winapi-x86_64-pc-windows-gnu"
               version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0gqq64czqb64kskjryj8isp62m2sgvx25yyj3kpc2myh85w24bki"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-0.48
  (package
    (name "rust-windows")
    (version "0.48.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "03vh89ilnxdxdh0n9np4ns4m10fvm93h3b0cc05ipg3qq1mqi1p6"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-targets"
          ,rust-windows-targets-0.48)
         ("rust-windows-interface"
          ,rust-windows-interface-0.48)
         ("rust-windows-implement"
          ,rust-windows-implement-0.48))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-0.51
  (package
    (name "rust-windows")
    (version "0.51.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ja500kr2pdvz9lxqmcr7zclnnwpvw28z78ypkrc4f7fqlb9j8na"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-targets"
          ,rust-windows-targets-0.48)
         ("rust-windows-core" ,rust-windows-core-0.51))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-0.52
  (package
    (name "rust-windows")
    (version "0.52.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1gnh210qjlprpd1szaq04rjm1zqgdm9j7l9absg0kawi2rwm72p4"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-targets"
          ,rust-windows-targets-0.52)
         ("rust-windows-core" ,rust-windows-core-0.52))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-core-0.51
  (package
    (name "rust-windows-core")
    (version "0.51.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows-core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0r1f57hsshsghjyc7ypp2s0i78f7b1vr93w68sdb8baxyf2czy7i"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-targets"
          ,rust-windows-targets-0.48))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-core-0.52
  (package
    (name "rust-windows-core")
    (version "0.52.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows-core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1nc3qv7sy24x0nlnb32f7alzpd6f72l4p24vl65vydbyil669ark"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-targets"
          ,rust-windows-targets-0.52))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-implement-0.48
  (package
    (name "rust-windows-implement")
    (version "0.48.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows-implement" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1764n853zd7bb0wn94i0qxfs6kdy7wrz7v9qhdn7x7hvk64fabjy"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-1)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-interface-0.48
  (package
    (name "rust-windows-interface")
    (version "0.48.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows-interface" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1iqcilw0hfyzwhk12xfmcy40r10406sgf4xmdansijlv1kr8vyz6"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-1)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-sys-0.45
  (package
    (name "rust-windows-sys")
    (version "0.45.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1l36bcqm4g89pknfp8r9rl1w4bn017q6a8qlx8viv0xjxzjkna3m"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-targets"
          ,rust-windows-targets-0.42))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-sys-0.48
  (package
    (name "rust-windows-sys")
    (version "0.48.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1aan23v5gs7gya1lc46hqn9mdh8yph3fhxmhxlw36pn6pqc28zb7"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-targets"
          ,rust-windows-targets-0.48))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-sys-0.52
  (package
    (name "rust-windows-sys")
    (version "0.52.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0gd3v4ji88490zgb6b5mq5zgbvwv7zx1ibn8v3x83rwcdbryaar8"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-targets"
          ,rust-windows-targets-0.52))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-targets-0.42
  (package
    (name "rust-windows-targets")
    (version "0.42.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows-targets" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0wfhnib2fisxlx8c507dbmh97kgij4r6kcxdi0f9nk6l1k080lcf"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-x86-64-msvc"
          ,rust-windows-x86-64-msvc-0.42)
         ("rust-windows-x86-64-gnullvm"
          ,rust-windows-x86-64-gnullvm-0.42)
         ("rust-windows-x86-64-gnu"
          ,rust-windows-x86-64-gnu-0.42)
         ("rust-windows-i686-msvc"
          ,rust-windows-i686-msvc-0.42)
         ("rust-windows-i686-gnu"
          ,rust-windows-i686-gnu-0.42)
         ("rust-windows-aarch64-msvc"
          ,rust-windows-aarch64-msvc-0.42)
         ("rust-windows-aarch64-gnullvm"
          ,rust-windows-aarch64-gnullvm-0.42))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-targets-0.48
  (package
    (name "rust-windows-targets")
    (version "0.48.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows-targets" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "034ljxqshifs1lan89xwpcy1hp0lhdh4b5n0d2z4fwjx2piacbws"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-x86-64-msvc"
          ,rust-windows-x86-64-msvc-0.48)
         ("rust-windows-x86-64-gnullvm"
          ,rust-windows-x86-64-gnullvm-0.48)
         ("rust-windows-x86-64-gnu"
          ,rust-windows-x86-64-gnu-0.48)
         ("rust-windows-i686-msvc"
          ,rust-windows-i686-msvc-0.48)
         ("rust-windows-i686-gnu"
          ,rust-windows-i686-gnu-0.48)
         ("rust-windows-aarch64-msvc"
          ,rust-windows-aarch64-msvc-0.48)
         ("rust-windows-aarch64-gnullvm"
          ,rust-windows-aarch64-gnullvm-0.48))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-targets-0.52
  (package
    (name "rust-windows-targets")
    (version "0.52.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows-targets" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1sz7jrnkygmmlj1ia8fk85wbyil450kq5qkh5qh9sh2rcnj161vg"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-windows-x86-64-msvc"
          ,rust-windows-x86-64-msvc-0.52)
         ("rust-windows-x86-64-gnullvm"
          ,rust-windows-x86-64-gnullvm-0.52)
         ("rust-windows-x86-64-gnu"
          ,rust-windows-x86-64-gnu-0.52)
         ("rust-windows-i686-msvc"
          ,rust-windows-i686-msvc-0.52)
         ("rust-windows-i686-gnullvm"
          ,rust-windows-i686-gnullvm-0.52)
         ("rust-windows-i686-gnu"
          ,rust-windows-i686-gnu-0.52)
         ("rust-windows-aarch64-msvc"
          ,rust-windows-aarch64-msvc-0.52)
         ("rust-windows-aarch64-gnullvm"
          ,rust-windows-aarch64-gnullvm-0.52))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-aarch64-gnullvm-0.42
  (package
    (name "rust-windows-aarch64-gnullvm")
    (version "0.42.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_aarch64_gnullvm" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1y4q0qmvl0lvp7syxvfykafvmwal5hrjb4fmv04bqs0bawc52yjr"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-aarch64-gnullvm-0.48
  (package
    (name "rust-windows-aarch64-gnullvm")
    (version "0.48.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_aarch64_gnullvm" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1n05v7qblg1ci3i567inc7xrkmywczxrs1z3lj3rkkxw18py6f1b"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-aarch64-gnullvm-0.52
  (package
    (name "rust-windows-aarch64-gnullvm")
    (version "0.52.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_aarch64_gnullvm" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0qrjimbj67nnyn7zqy15mzzmqg0mn5gsr2yciqjxm3cb3vbyx23h"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-aarch64-msvc-0.42
  (package
    (name "rust-windows-aarch64-msvc")
    (version "0.42.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_aarch64_msvc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0hsdikjl5sa1fva5qskpwlxzpc5q9l909fpl1w6yy1hglrj8i3p0"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-aarch64-msvc-0.48
  (package
    (name "rust-windows-aarch64-msvc")
    (version "0.48.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_aarch64_msvc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1g5l4ry968p73g6bg6jgyvy9lb8fyhcs54067yzxpcpkf44k2dfw"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-aarch64-msvc-0.52
  (package
    (name "rust-windows-aarch64-msvc")
    (version "0.52.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_aarch64_msvc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1dmga8kqlmln2ibckk6mxc9n59vdg8ziqa2zr8awcl720hazv1cr"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-i686-gnu-0.42
  (package
    (name "rust-windows-i686-gnu")
    (version "0.42.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_i686_gnu" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0kx866dfrby88lqs9v1vgmrkk1z6af9lhaghh5maj7d4imyr47f6"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-i686-gnu-0.48
  (package
    (name "rust-windows-i686-gnu")
    (version "0.48.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_i686_gnu" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0gklnglwd9ilqx7ac3cn8hbhkraqisd0n83jxzf9837nvvkiand7"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-i686-gnu-0.52
  (package
    (name "rust-windows-i686-gnu")
    (version "0.52.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_i686_gnu" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0w4np3l6qwlra9s2xpflqrs60qk1pz6ahhn91rr74lvdy4y0gfl8"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-i686-gnullvm-0.52
  (package
    (name "rust-windows-i686-gnullvm")
    (version "0.52.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_i686_gnullvm" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1s9f4gff0cixd86mw3n63rpmsm4pmr4ffndl6s7qa2h35492dx47"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-i686-msvc-0.42
  (package
    (name "rust-windows-i686-msvc")
    (version "0.42.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_i686_msvc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0q0h9m2aq1pygc199pa5jgc952qhcnf0zn688454i7v4xjv41n24"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-i686-msvc-0.48
  (package
    (name "rust-windows-i686-msvc")
    (version "0.48.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_i686_msvc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "01m4rik437dl9rdf0ndnm2syh10hizvq0dajdkv2fjqcywrw4mcg"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-i686-msvc-0.52
  (package
    (name "rust-windows-i686-msvc")
    (version "0.52.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_i686_msvc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1gw7fklxywgpnwbwg43alb4hm0qjmx72hqrlwy5nanrxs7rjng6v"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-x86-64-gnu-0.42
  (package
    (name "rust-windows-x86-64-gnu")
    (version "0.42.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_x86_64_gnu" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0dnbf2xnp3xrvy8v9mgs3var4zq9v9yh9kv79035rdgyp2w15scd"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-x86-64-gnu-0.48
  (package
    (name "rust-windows-x86-64-gnu")
    (version "0.48.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_x86_64_gnu" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "13kiqqcvz2vnyxzydjh73hwgigsdr2z1xpzx313kxll34nyhmm2k"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-x86-64-gnu-0.52
  (package
    (name "rust-windows-x86-64-gnu")
    (version "0.52.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_x86_64_gnu" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1n8p2mcf3lw6300k77a0knksssmgwb9hynl793mhkzyydgvlchjf"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-x86-64-gnullvm-0.42
  (package
    (name "rust-windows-x86-64-gnullvm")
    (version "0.42.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_x86_64_gnullvm" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "18wl9r8qbsl475j39zvawlidp1bsbinliwfymr43fibdld31pm16"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-x86-64-gnullvm-0.48
  (package
    (name "rust-windows-x86-64-gnullvm")
    (version "0.48.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_x86_64_gnullvm" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1k24810wfbgz8k48c2yknqjmiigmql6kk3knmddkv8k8g1v54yqb"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-x86-64-gnullvm-0.52
  (package
    (name "rust-windows-x86-64-gnullvm")
    (version "0.52.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_x86_64_gnullvm" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "15n56jrh4s5bz66zimavr1rmcaw6wa306myrvmbc6rydhbj9h8l5"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-x86-64-msvc-0.42
  (package
    (name "rust-windows-x86-64-msvc")
    (version "0.42.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_x86_64_msvc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1w5r0q0yzx827d10dpjza2ww0j8iajqhmb54s735hhaj66imvv4s"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-x86-64-msvc-0.48
  (package
    (name "rust-windows-x86-64-msvc")
    (version "0.48.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_x86_64_msvc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0f4mdp895kkjh9zv8dxvn4pc10xr7839lf5pa9l0193i2pkgr57d"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-windows-x86-64-msvc-0.52
  (package
    (name "rust-windows-x86-64-msvc")
    (version "0.52.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "windows_x86_64_msvc" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1w1bn24ap8dp9i85s8mlg8cim2bl2368bd6qyvm0xzqvzmdpxi5y"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-winit-0.28
  (package
    (name "rust-winit")
    (version "0.28.7")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "winit" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "152bi6lrmnasg6dnsdjqgnzyis3n90i09cja720m4krq8l5xk5lm"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-x11-dl" ,rust-x11-dl-2)
         ("rust-windows-sys" ,rust-windows-sys-0.45)
         ("rust-web-sys" ,rust-web-sys-0.3)
         ("rust-wayland-scanner"
          ,rust-wayland-scanner-0.29)
         ("rust-wayland-protocols"
          ,rust-wayland-protocols-0.29)
         ("rust-wayland-commons"
          ,rust-wayland-commons-0.29)
         ("rust-wayland-client" ,rust-wayland-client-0.29)
         ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
         ("rust-smithay-client-toolkit"
          ,rust-smithay-client-toolkit-0.16)
         ("rust-redox-syscall" ,rust-redox-syscall-0.3)
         ("rust-raw-window-handle"
          ,rust-raw-window-handle-0.5)
         ("rust-percent-encoding"
          ,rust-percent-encoding-2)
         ("rust-orbclient" ,rust-orbclient-0.3)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-objc2" ,rust-objc2-0.3)
         ("rust-ndk" ,rust-ndk-0.7)
         ("rust-mio" ,rust-mio-0.8)
         ("rust-log" ,rust-log-0.4)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-instant" ,rust-instant-0.1)
         ("rust-dispatch" ,rust-dispatch-0.2)
         ("rust-core-graphics" ,rust-core-graphics-0.22)
         ("rust-core-foundation"
          ,rust-core-foundation-0.9)
         ("rust-cfg-aliases" ,rust-cfg-aliases-0.1)
         ("rust-bitflags" ,rust-bitflags-1)
         ("rust-android-activity"
          ,rust-android-activity-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-winnow-0.5
  (package
    (name "rust-winnow")
    (version "0.5.40")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "winnow" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0xk8maai7gyxda673mmw3pj1hdizy5fpi7287vaywykkk19sk4zm"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-memchr" ,rust-memchr-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-winnow-0.6
  (package
    (name "rust-winnow")
    (version "0.6.8")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "winnow" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "13b1kxlgqglp4787nrn4p4bpz4xfxn096v437sr73056jyf2xif3"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-memchr" ,rust-memchr-2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-x11-dl-2
  (package
    (name "rust-x11-dl")
    (version "2.21.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "x11-dl" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0vsiq62xpcfm0kn9zjw5c9iycvccxl22jya8wnk18lyxzqj5jwrq"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pkg-config" ,rust-pkg-config-0.3)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-x11rb-0.13
  (package
    (name "rust-x11rb")
    (version "0.13.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "x11rb" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "04jyfm0xmc538v09pzsyr2w801yadsgvyl2p0p76hzzffg5gz4ax"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-x11rb-protocol" ,rust-x11rb-protocol-0.13)
         ("rust-rustix" ,rust-rustix-0.38)
         ("rust-gethostname" ,rust-gethostname-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-x11rb-protocol-0.13
  (package
    (name "rust-x11rb-protocol")
    (version "0.13.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "x11rb-protocol" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0gfbxf2k7kbk577j3rjhfx7hm70kmwln6da7xyc4l2za0d2pq47c"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-xcursor-0.3
  (package
    (name "rust-xcursor")
    (version "0.3.5")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "xcursor" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0499ff2gy9hfb9dvndn5zyc7gzz9lhc5fly3s3yfsiak99xws33a"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-xdg-home-1
  (package
    (name "rust-xdg-home")
    (version "1.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "xdg-home" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "13mkcfgngnc1fpdg5737hvhjkp95bc9w2ngqdjnri0ybqcjs7r91"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-winapi" ,rust-winapi-0.3)
         ("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-xml-rs-0.8
  (package
    (name "rust-xml-rs")
    (version "0.8.20")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "xml-rs" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "14s1czpj83zhgr4pizxa4j07layw9wmlqhkq0k3wz5q5ixwph6br"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-xshell-0.2
  (package
    (name "rust-xshell")
    (version "0.2.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "xshell" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0dv4igym5whcr8fws0afmhq414a1c38x7a2ln38yyfg7xa3apc3d"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-xshell-macros" ,rust-xshell-macros-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-xshell-macros-0.2
  (package
    (name "rust-xshell-macros")
    (version "0.2.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "xshell-macros" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0lnqicgd9r2mh8p9yz4yidiskip9cp3wqfg4dvqf4xpc7272whlx"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-zbus-3
  (package
    (name "rust-zbus")
    (version "3.15.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "zbus" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ri5gklhh3kl9gywym95679xs7n3sw2j3ky80jcd8siacc5ifpb7"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zvariant" ,rust-zvariant-3)
         ("rust-zbus-names" ,rust-zbus-names-2)
         ("rust-zbus-macros" ,rust-zbus-macros-3)
         ("rust-xdg-home" ,rust-xdg-home-1)
         ("rust-winapi" ,rust-winapi-0.3)
         ("rust-uds-windows" ,rust-uds-windows-1)
         ("rust-tracing" ,rust-tracing-0.1)
         ("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-sha1" ,rust-sha1-0.10)
         ("rust-serde-repr" ,rust-serde-repr-0.1)
         ("rust-serde" ,rust-serde-1)
         ("rust-rand" ,rust-rand-0.8)
         ("rust-ordered-stream" ,rust-ordered-stream-0.2)
         ("rust-once-cell" ,rust-once-cell-1)
         ("rust-nix" ,rust-nix-0.26)
         ("rust-hex" ,rust-hex-0.4)
         ("rust-futures-util" ,rust-futures-util-0.3)
         ("rust-futures-sink" ,rust-futures-sink-0.3)
         ("rust-futures-core" ,rust-futures-core-0.3)
         ("rust-event-listener" ,rust-event-listener-2)
         ("rust-enumflags2" ,rust-enumflags2-0.7)
         ("rust-derivative" ,rust-derivative-2)
         ("rust-byteorder" ,rust-byteorder-1)
         ("rust-blocking" ,rust-blocking-1)
         ("rust-async-trait" ,rust-async-trait-0.1)
         ("rust-async-task" ,rust-async-task-4)
         ("rust-async-recursion" ,rust-async-recursion-1)
         ("rust-async-process" ,rust-async-process-1)
         ("rust-async-lock" ,rust-async-lock-2)
         ("rust-async-io" ,rust-async-io-1)
         ("rust-async-fs" ,rust-async-fs-1)
         ("rust-async-executor" ,rust-async-executor-1)
         ("rust-async-broadcast"
          ,rust-async-broadcast-0.5))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-zbus-macros-3
  (package
    (name "rust-zbus-macros")
    (version "3.15.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "zbus_macros" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "19g0d7d4b8l8ycw498sz8pwkplv300j31i9hnihq0zl81xxljcbi"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zvariant-utils" ,rust-zvariant-utils-1)
         ("rust-syn" ,rust-syn-1)
         ("rust-regex" ,rust-regex-1)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1)
         ("rust-proc-macro-crate"
          ,rust-proc-macro-crate-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-zbus-names-2
  (package
    (name "rust-zbus-names")
    (version "2.6.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "zbus_names" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "13achs6jbrp4l0jy5m6nn7v89clfgb63qhldkg5ddgjh6y6p6za3"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zvariant" ,rust-zvariant-3)
         ("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-serde" ,rust-serde-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-zerocopy-0.7
  (package
    (name "rust-zerocopy")
    (version "0.7.34")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "zerocopy" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "11xhrwixm78m6ca1jdxf584wdwvpgg7q00vg21fhwl0psvyf71xf"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zerocopy-derive"
          ,rust-zerocopy-derive-0.7))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-zerocopy-derive-0.7
  (package
    (name "rust-zerocopy-derive")
    (version "0.7.34")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "zerocopy-derive" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0fqvglw01w3hp7xj9gdk1800x9j7v58s9w8ijiyiz2a7krb39s8m"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-2)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-zeroize-1
  (package
    (name "rust-zeroize")
    (version "1.7.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "zeroize" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0bfvby7k9pdp6623p98yz2irqnamcyzpn7zh20nqmdn68b0lwnsj"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-zstd-0.12
  (package
    (name "rust-zstd")
    (version "0.12.4")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "zstd" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0g654jj8z25rvzli2b1231pcp9y7n6vk44jaqwgifh9n2xg5j9qs"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zstd-safe" ,rust-zstd-safe-6))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-zstd-safe-6
  (package
    (name "rust-zstd-safe")
    (version "6.0.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "zstd-safe" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "10cm0v8sw3jz3pi0wlwx9mbb2l25lm28w638a5n5xscfnk8gz67f"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zstd-sys" ,rust-zstd-sys-2)
         ("rust-libc" ,rust-libc-0.2))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-zstd-sys-2
  (package
    (name "rust-zstd-sys")
    (version "2.0.10+zstd.1.5.6")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "zstd-sys" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1ak51pq1ni6q3qgyr58iq1pcz0vyh80f8vn8m27zrfpm9a8s8ly2"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-pkg-config" ,rust-pkg-config-0.3)
         ("rust-cc" ,rust-cc-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-zune-core-0.4
  (package
    (name "rust-zune-core")
    (version "0.4.12")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "zune-core" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0jj1ra86klzlcj9aha9als9d1dzs7pqv3azs1j3n96822wn3lhiz"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-zune-jpeg-0.4
  (package
    (name "rust-zune-jpeg")
    (version "0.4.11")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "zune-jpeg" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "0j74rzx82w9zwfqvzrg7k67l77qp3g577w33scrn3zd1l926p1pc"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zune-core" ,rust-zune-core-0.4))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-zvariant-3
  (package
    (name "rust-zvariant")
    (version "3.15.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "zvariant" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1nxj9x187jl32fd32zvq8hfn6lyq3kjadb2q7f6kb6x0igl2pvsf"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zvariant-derive" ,rust-zvariant-derive-3)
         ("rust-url" ,rust-url-2)
         ("rust-static-assertions"
          ,rust-static-assertions-1)
         ("rust-serde" ,rust-serde-1)
         ("rust-libc" ,rust-libc-0.2)
         ("rust-enumflags2" ,rust-enumflags2-0.7)
         ("rust-byteorder" ,rust-byteorder-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-zvariant-derive-3
  (package
    (name "rust-zvariant-derive")
    (version "3.15.2")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "zvariant_derive" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "1nbydrkawjwxan12vy79qsrn7gwc483mpfzqs685ybyppv04vhip"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-zvariant-utils" ,rust-zvariant-utils-1)
         ("rust-syn" ,rust-syn-1)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1)
         ("rust-proc-macro-crate"
          ,rust-proc-macro-crate-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))

(define rust-zvariant-utils-1
  (package
    (name "rust-zvariant-utils")
    (version "1.0.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "zvariant_utils" version))
        (file-name
          (string-append name "-" version ".tar.gz"))
        (sha256
          (base32
            "00625h3240rixvfhq6yhws1d4bwf3vrf74v8s69b97aq27cg0d3j"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-syn" ,rust-syn-1)
         ("rust-quote" ,rust-quote-1)
         ("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "")
    (synopsis "")
    (description "")
    (license #f)))
rust-ionmesh-0.1


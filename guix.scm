;; guix.scm --- My Emacs configuration

(use-modules (guix build-system copy)
             (guix gexp)
             (guix git)
             (guix git-download)
             ((guix licenses) #:prefix license:)
             (guix packages)
             (guix profiles)
             (guix utils)
             (srfi srfi-13)

             (gnu)
             (gnu packages)
             (gnu services))

(use-package-modules emacs
                     emacs-xyz
		     python-xyz
                     tree-sitter)

(define vcs-file?
  ;; Return true if the given file is under version control.
  (or (git-predicate (current-source-directory))
      (const #t)))

;;; Dependencies.
(define %tree-sitter-langs
  (list tree-sitter-c
        tree-sitter-cpp
	tree-sitter-elisp
        tree-sitter-python))

(define %lang-servers
  (list python-lsp-server))

(define %emacs-packages
  (append
   (list
    ;;; Emacs.
    (if (getenv "WAYLAND_DISPLAY")
        emacs-pgtk
        emacs)

    ;;; Configuration.
    ;; emacs-no-littering

    ;;; Guile & Guix hacking.
    emacs-flycheck
    emacs-flycheck-guile
    emacs-geiser
    emacs-geiser-guile
    emacs-guix
    emacs-macrostep
    emacs-macrostep-geiser
    emacs-parinfer-rust-mode

    ;;; Base
    emacs-avy
    emacs-embark
    emacs-vertico
    emacs-marginalia
    emacs-cape
    emacs-corfu
    emacs-consult
    emacs-kind-icon
    emacs-eat
    emacs-orderless
    emacs-meow

    ;;; Dev
    ;; Git.
    emacs-magit
    emacs-magit-todos
    emacs-forge
    emacs-git-modes

    ;; Markdown
    emacs-markdown-mode

    ;; TeX
    emacs-auctex
    emacs-cdlatex
    emacs-aas

    ;; Snippets.
    emacs-yasnippet

    ;;; Org-mode
    emacs-org-roam

    ;; Interface enhancements.
    ;; emacs-eldoc-box
    ;; emacs-helpful
    ;; emacs-mwim

    ;; Rainbow delimiters.
    ;; emacs-rainbow-delimiters
    )

   %tree-sitter-langs
   %lang-servers))

;;; Profile.
;;;
;;; Use actual package objects rather than package
;;; specifications.

(define my-emacs-profile
  (profile
   (name "my-emacs-profile")
   (content
    (packages->manifest %emacs-packages))))

;;; Launcher.
;;;
;;; Use the current working directory as the Emacs
;;; initialization directory.

(define my-emacs-script
  (program-file
   "my-emacs"
   (with-imported-modules '((guix build utils))
     #~(begin
         (use-modules (guix build utils))

         (apply invoke
                "guix" "shell"
                "-p" #$my-emacs-profile
                "--"
                "emacs"
                "--init-directory" "."
                (cdr (command-line)))))))

;;; Package.
;;;
;;; copy-build-system installs the four configuration
;;; components, then installs the launcher.

(define my-emacs-package
  (package
   (name "my-emacs")
   (version "0.0.0")
   (source (local-file "." "my-emacs-checkout"
                       #:recursive? #t
                       #:select? vcs-file?))
   (build-system copy-build-system)
   (arguments
    (list
     #:install-plan
     #~'(("early-init.el" "early-init.el")
         ("init.el" "init.el")
         ("modules/" "modules/")
         ("plugins/" "plugins/"))
     #:phases
     #~(modify-phases %standard-phases
					  (add-after 'install 'install-launcher
								 (lambda* (#:key outputs #:allow-other-keys)
								   (use-modules (guix build utils))
								   (let ((dest (in-vicinity #$output "bin/my-emacs")))
									 (mkdir-p (dirname dest))
									 (copy-file #$my-emacs-script dest)))))))
   ;; (make-desktop-entry-file
   ;;  (in-vicinity #$output
   ;; 			   "share/applications/emacs-guix-starter.desktop")
   ;;  #:name "Emacs Guix Starter"
   ;;  #:generic-name "Starter Emacs configuration to work with Guix"
   ;;  #:comment "Edit text"
   ;;  #:mime-type
   ;;  '("text/english"
   ;; 	"text/plain"
   ;; 	"text/x-makefile"
   ;; 	"text/x-c++hdr"
   ;; 	"text/x-c++src"
   ;; 	"text/x-chdr"
   ;; 	"text/x-csrc"
   ;; 	"text/x-java"
   ;; 	"text/x-moc"
   ;; 	"text/x-pascal"
   ;; 	"text/x-tcl"
   ;; 	"text/x-tex"
   ;; 	"application/x-shellscript"
   ;; 	"text/x-c"
   ;; 	"text/x-c++")
   ;;  #:exec dest
   ;;  #:icon "emacs"
   ;;  #:categories '("Development" "TextEditor")
   ;;  #:startup-w-m-class "Emacs")))))))
   (home-page "")
   (synopsis "My custom Emacs configuration")
   (description
    "A personal GNU Emacs configuration with
declaratively managed packages, tree-sitter grammars,
language servers, and a development launcher.")
   (license license:gpl3+)))

;;; Return the package for Guix.

my-emacs-package

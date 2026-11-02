;;; dev-config.el --- Extra config: development tools  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Usage: Append or require this file from init.el for some software
;;; development-focused packages.
;;;
;;; It is **STRONGLY** recommended that you use the base.el config if you want to
;;; use Eglot. Lots of completion things will work better.
;;;
;;; This will try to use tree-sitter modes for many languages. Please run
;;;
;;;   M-x treesit-install-language-grammar
;;;
;;; Before trying to use a treesit mode.

;;; Contents:
;;;
;;;  - Built-in config for developers
;;;  - Version Control
;;;  - Common file types
;;;  - Eglot, the built-in LSP client for Emacs
;;;  - Templating

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Built-in config for developers
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emacs
  :config
  ;; Code folding config
  ;(setopt hs-show-indicators t)         ; Show collapse indicators in margin
  ;(setopt hs-display-lines-hidden t)    ; Show number of collapsed lines

  :hook
  ;; Auto parenthesis matching
  ((prog-mode . electric-pair-mode)))

(use-package project
  :custom
  (when (>= emacs-major-version 30)
    (project-mode-line t)))         ; show project name in modeline

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Version Control
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Magit: best Git client to ever exist
(use-package magit
  :bind (("C-x g" . magit-status)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Common file types
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'flycheck-config)
(require 'lispy-config)
(require 'guile-config)
(require 'guile-config)
(when (equal system-type `gnu/linux)
  (require 'guix-config))
(require 'markdown-config)
(require 'tex-config)

;; Emacs ships with a lot of popular programming language modes. If it's not
;; built in, you're almost certain to find a mode for the language you're
;; looking for with a quick Internet search.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Tree-sitter
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package treesit
  :ensure nil ;; built-in
  :when (and (>= emacs-major-version 29)
             (treesit-available-p)
             (getenv "TREE_SITTER_GRAMMAR_PATH"))
  :init
  ;; I use Guix Home to install tree-sitter grammars for programming which, by the
  ;; nature of its functional package-management system, will install these shared
  ;; objects into a particular location within the Guix store, which is then
  ;; exposed with an environment variable.
  ;; When I am on a Guix-based system, assume I am using Guix Home and add the
  ;; store path to Emacs' understanding of the tree-sitter module load path.
  (when (onghaik/is-guix-system)
    (setq treesit-extra-load-path
          (append (split-string (getenv "TREE_SITTER_GRAMMAR_PATH") ":")
                  treesit-extra-load-path)))

  (setq major-mode-remap-alist
        '(;; (yaml-mode . yaml-ts-mode)
          ;; (conf-toml-mode . toml-ts-mode)
          ;; TODO: Add mermaid-tree-sitter to Guix and add to my home env!
          ;; (mermaid-mode . mermaid-ts-mode)
          ;; (bash-mode . bash-ts-mode)
          ;; (c-mode . c-ts-mode)
          (c++-mode . c++-ts-mode)
          ;; (c-or-c++-mode . c-or-c++-ts-mode)
          ;; (go-mode . go-ts-mode)
          ;; (js2-mode . js-ts-mode)
          ;; (typescript-mode . typescript-ts-mode)
          ;; (json-mode . json-ts-mode)
          ;; (css-mode . css-ts-mode)
          (python-mode . python-ts-mode))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Eglot, the built-in LSP client for Emacs
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Helpful resources:
;;
;;  - https://www.masteringemacs.org/article/seamlessly-merge-multiple-documentation-sources-eldoc

(use-package eglot
  :ensure nil ;; built-in
  ;; Configure hooks to automatically turn-on eglot for selected modes
  :hook
  (((python-mode) . eglot-ensure))

  :custom
  (eglot-send-changes-idle-time 0.1)
  (eglot-extend-to-xref t)              ; activate Eglot in referenced non-project files

  :config
  ;; Avoid changing line heights if your font is wonky. See
  ;; https://github.com/joaotavora/eglot/discussions/1492
  (setopt eglot-code-action-indicator "h")

  (fset #'jsonrpc--log-event #'ignore)  ; massive perf boost---don't log every event
  ;; Sometimes you need to tell Eglot where to find the language server
  ; (add-to-list 'eglot-server-programs
  ;              '(haskell-mode . ("haskell-language-server-wrapper" "--lsp")))

  ;; You can set various options for each language server. For
  ;; example, you can raise the number of completions surfaced by a
  ;; given langauge server to Emacs:
  ;; (setopt eglot-workspace-configuration
  ;; 	  '((haskell (maxCompletions . 100))
  ;; 	    (elixir  (maxCompletions . 100))))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Yasnippet
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'yasnippet-config)

(provide 'dev-config)
;;; dev-config.el ends here

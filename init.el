;;; init.el --- My init file for Emacs -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;;; Minimal init.el

;;; Contents:
;;;
;;;  - Basic settings
;;;  - Discovery aids
;;;  - Minibuffer/completion/searching settings
;;;  - Interface enhancements/defaults
;;;  - Tab-bar configuration
;;;  - Theme
;;;  - Optional extras
;;;  - Built-in customization framework

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initial phase
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Guardrail
(when (< emacs-major-version 31)
  (error "This Emacs config only works with Emacs 31 and newer; you have version %s" emacs-major-version))

;; Load the custom file if it exists.  Among other settings, this will
;; have the list `package-selected-packages', so we need to load that
;; before adding more packages.  The value of the `custom-file'
;; variable must be set appropriately, by default the value is nil.
;; This can be done here, or in the early-init.el file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (and custom-file
           (file-exists-p custom-file))
  (load custom-file nil :nomessage))

;; update the `load-path' to include the modules path
(let ((modules (expand-file-name "./modules/" user-emacs-directory)))
  (when (file-directory-p modules)
    (message "adding modules to load-path: %s" modules)
    (add-to-list 'load-path modules)))

(require 'personal-settings)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Packages phase
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Collect list of packages to install.  This phase is not needed if
;; manage the installed packages with Guix or Nix.  It is also not
;; needed if you do not need to install packages for a
;; module.

;; Add package definitions for completion packages
;; to `package-selected-packages'.
(unless (or (onghaik/is-guix-system)
	    (executable-find "guix"))
  
  (require 'base-packages)
  (require 'dev-packages)
  (require 'org-packages)
  ;; (require 'markdown-packages)
  ;; (require 'magit-packages)
  ;; (require 'navigation-packages)
  ;; (require 'completion-packages)
  ;; (require 'flycheck-packages)
  ;; (require 'yasnippet-packages)
  ;; (require 'tex-packages)

  ;; Install the packages listed in the `package-selected-packages'
  ;; list.
  (package-install-selected-packages :noconfirm))
;; (package-install-selected-packages :noconfirm)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Configuration phase
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Modules to configure Emacs.

(require 'dired-config)
;; (require 'comint-config)
;; (require 'theme-config)
;; (require 'project-config)
(require 'base-config)
(require 'dev-config)
(require 'org-config)
;; (require 'magit-config)
;; (require 'navigation-config)
;; (require 'completion-config)
;; (require 'vterm-config)
;; (require 'flycheck-config)
;; (require 'yasnippet-config)
;; (require 'tex-config)
;; (require 'lsp-config)
;; (require 'treesit-config)

;; Profile emacs startup
(defun onghaik/display-startup-time ()
  "Display the startup time after Emacs is fully initialized."
  (message "Emacs loaded in %s."
           (emacs-init-time)))
(add-hook 'emacs-startup-hook #'onghaik/display-startup-time)

;; Set default coding system (especially for Windows)
(set-default-coding-systems 'utf-8)

;; If Emacs has been idle for 15+ seconds, perform a GC run.
;; From https://akrl.sdf.org/#orgc15a10d
(run-with-idle-timer 15 t #'garbage-collect)

(provide 'init)
;;; init.el ends here

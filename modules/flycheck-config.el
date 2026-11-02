;;; flycheck-config.el --- Provides flycheck         -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Kyle

;; Keywords:

;; Spell-checking and syntax checking
(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (setopt flycheck-emacs-lisp-load-path 'inherit)
  )

(provide 'flycheck-config)

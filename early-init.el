;;; early-init.el --- Early initialization  -*- lexical-binding: t; -*-
;;; Commentary:
;;
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Basic settings for quick startup and convenience
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Startup speed and annoyance suppression
;; Increase the amount of heap memory Emacs is allowed to use before GC.
(defvar onghaik/gc-cons-threshold (* 32 1024 1024)
  "Amount of memory used before GC is run.")
(defvar onghaik/gc-cons-percentage 0.8
  "Percent memory used before GC is run.")
(defvar onghaik/message-log-max (* 16 1024)
  "Maximum number of messages to keep in *Messages* buffer.")
(setq-default gc-cons-threshold onghaik/gc-cons-threshold
              gc-cons-percentage onghaik/gc-cons-percentage
              message-log-max onghaik/message-log-max)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Silence startup message
(advice-add #'display-startup-echo-area-message :override #'ignore)

;; Setting *-resize-pixelwise to `t' lets frames/windows resize
;; smoothly at sub-character increments
(setq frame-resize-pixelwise t)
; (setq window-resize-pixelwise t)

(when (fboundp 'tool-bar-mode) ; When in a GUI, disable tool bar;
  (tool-bar-mode -1))          ; all these tools are in the menu-bar anyway

;; These settings apply to *all* frames.
(setq default-frame-alist '(
                            ;; You can turn off scroll bars by uncommenting these lines:
                            ;; (vertical-scroll-bars . nil)
                            ;; (horizontal-scroll-bars . nil)
                            (ns-appearance . dark)
                            (ns-transparent-titlebar . t)

                            ;; Use this to turn off the OS window decoration
                            ;; (undecorated-round . t)
                            ;; (internal-border-width . 3)
                            ))

;; These settings apply to the first frame created. The
;; (back|fore)ground-color settings need to live here so that a
;; theme's background color applies correctly to subsequent frames.
(setq initial-frame-alist '((fullscreen . maximized)
                            ;; Setting the face in here prevents flashes of
                            ;; color as the theme gets activated
                            (background-color . "#000000")
                            (foreground-color . "#ffffff")))

(load (expand-file-name "modules/os-detection"
						user-emacs-directory))

(unless (or (onghaik/is-guix-system)
			(executable-find "guix"))
  (load (expand-file-name "modules/package-config"
						user-emacs-directory)))


(provide 'early-init)
;;; early-init.el ends here

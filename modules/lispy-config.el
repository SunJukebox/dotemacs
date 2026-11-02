;;; lispy-config.el --- Configuration for Lisp(s)    -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Kyle

;; Author: Kyle <kyle@portandum>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; A lot of Lisps have a lot of things in common (I am looking at you
;; parentheses). Having a file with common configuration for ALL Lisps, whether
;; that be Scheme, Common Lisp, Clojure, or Emacs Lisp, will make the entire
;; sexperience that much more fluid.

;;; Code:

(use-package macrostep
  :bind
  ((:map emacs-lisp-mode-map)
   ("C-c e" . macrostep-expand)))

(use-package parinfer-rust-mode
  :config
  ;; Disable parenthesis pairing in `electric-pair-mode' when
  ;; `parinfer-rust-mode' is active.
  (setopt electric-pair-inhibit-predicate
          (lambda (char)
            (or (and (bound-and-true-p parinfer-rust-mode)
                     (memql char '(?\( ?\[ ?\{)))
                (electric-pair-default-inhibit char))))
  (setopt parinfer-rust-troublesome-modes
          (delq 'electric-pair-mode parinfer-rust-troublesome-modes))
  ;; These customizations are managed by Guix but will be overridden if using
  ;; `no-littering'.  Reset them to standard values.
  (custom-reevaluate-setting 'parinfer-rust-library-directory)
  (custom-reevaluate-setting 'parinfer-rust-library)
  :hook
  ;; XXX: Enable mode first, workaround to support `menu-find-file-existing'.
  ((emacs-lisp-mode lisp-mode scheme-mode) . parinfer-rust-mode-enable)
  ((emacs-lisp-mode lisp-mode scheme-mode) . parinfer-rust-mode)
  ;; Disable tabs to avoid breaking Parinfer's indentation-based logic
  (parinfer-rust-mode . (lambda () (setq indent-tabs-mode nil))))


(provide 'lispy-config)
;;; lispy-config.el ends here

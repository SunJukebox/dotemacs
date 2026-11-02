;;; dev-packages.el --- Packages for development     -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Kyle

;; Author: Kyle;;; dev-packages.el --- Development packages         -*- lexical-binding: t; -*- <kyle@portandum>
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

;; 

;;; Code:

;;; Eglot for Emacs before version 29
;; Add Eglot only for Emacs prior to version 29.  It is built-in since
;; Emacs 29.
(when (version< emacs-version "29")
  ;; LSP capabilities
  (add-to-list 'package-selected-packages 'eglot)

  ;; tree-sitter syntax aware packages
  (add-to-list 'package-selected-packages 'tree-sitter)
  (add-to-list 'package-selected-packages 'tree-sitter-indent)
  (add-to-list 'package-selected-packages 'tree-sitter-ispell)
  (add-to-list 'package-selected-packages 'tree-sitter-langs))

;;; Emacs 29 packages
(when (version< "29" emacs-version)
  ;; automatically handles switching to tree-sitter versions of major
  ;; modes, can install grammars, etc.
  (add-to-list 'package-selected-packages 'treesit-auto))

;;; Editorconfig
;; editorconfig is a cross-editor/ide configuration tool to control
;; indentation, spaces vs tabs, etc.  It is built-in since Emacs 30.
(when (version< emacs-version "30")
  (add-to-list 'package-selected-packages 'editorconfig))

(require 'magit-packages)
(require 'flycheck-packages)
(require 'guile-packages)
;; (require 'guix-packages)
(require 'markdown-packages)
(require 'tex-packages)

(provide 'dev-packages)
;;; dev-packages.el ends here

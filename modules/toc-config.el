;;; toc-config.el --- Configuration for toc-mode     -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Kyle O.

;; Author: Kyle O. <onghaik@pomentum>
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

(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page)
  (define-key pdf-view-mode-map (kbd "o") 'pdf-outline))

(use-package djvu)

(use-package doc-toc
  :defer t)


(provide 'toc-config)
;;; toc-config.el ends here

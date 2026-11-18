;;; toc-packages.el --- Packages for toc-mode        -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Kyle O.

;; Author: Kyle O. <onghaik@pomentum>
;; Keywords: c

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

(add-to-list 'package-selected-packages 'pdf-tools)
(add-to-list 'package-selected-packages 'djvu)
(add-to-list 'package-selected-packages 'doc-toc)

(provide 'toc-packages)
;;; toc-packages.el ends here

;;; guile-config.el --- Guile configuration          -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Kyle

;; Author: Kyle(use-package flycheck-guile <kyle@portandum>
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

;;; Code:

(use-package flycheck-guile
  :after flycheck geiser-guile)

(use-package geiser
  :custom
  (geiser-active-implementation '(guile))
  (geiser-default-implementation 'guile)
  (geiser-autodoc-identifier-format "%s → %s")
  (geiser-mode-smart-tab-p t)
  (geiser-mode-start-repl-p t)
  (geiser-repl-query-on-kill-p nil))

(use-package geiser-guile
  :after geiser
  :config
  (setopt geiser-guile-load-path
          (let* ((cmd "echo '(write %load-path)' | guix repl -q --type=machine")
                 (out (nth 1 (split-string (shell-command-to-string cmd) "\n"))))
            (read out))))

(use-package macrostep-geiser
  :after geiser
  :hook
  ((geiser-mode geiser-repl-mode) . macrostep-geiser-setup)
  :bind
  ((:map geiser-mode-map)
   ("C-c e" . macrostep-expand))
  ((:map geiser-repl-mode-map)
   ("C-c e" . macrostep-expand)))

(provide 'guile-config)
;;; guile-config.el ends here
t

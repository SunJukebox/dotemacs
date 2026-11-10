;;; org-config.el --- Configuration for org-mode     -*- lexical-binding: t; -*-

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

;; Usage: Append or require this file from init.el for some software
;; development-focused packages.
;;
;; Org-mode is a fantastically powerful package. It does a lot of things, which
;; makes it a little difficult to understand at first.
;;
;; We will configure Org-mode in phases. Work with each phase as you are
;; comfortable.
;;
;; YOU NEED TO CONFIGURE SOME VARIABLES! The most important variable is the
;; `org-directory', which tells org-mode where to look to find your agenda
;; files.

;; See "org-intro.txt" for a high-level overview.

;; Contents:
;;
;;  - Critical variables
;;  - Phase 1: editing and exporting files
;;  - Phase 2: todos, agenda generation, and task tracking
;;  - Phase 3: extensions (org-roam, etc.)


;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Critical variables
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; These variables need to be set for Org-mode's full power to be unlocked!
;;;
;;; You can read the documentation for any variable with `C-h v'. If you have
;;; Consult configured (see the `base.el' file) then it should help you find
;;; what you're looking for.

;;; Phase 1 variables

;;; Phase 2 variables

;; Agenda variables
(setq org-directory "~/Documents/org/") ; Non-absolute paths for agenda and
                                        ; capture templates will look here.

(setq org-agenda-files '("inbox.org" "work.org"))

;; Default tags
(setq org-tag-alist '(
                      ;; locale
                      (:startgroup)
                      ("home" . ?h)
                      ("work" . ?w)
                      ("school" . ?s)
                      (:endgroup)
                      (:newline)
                      ;; scale
                      (:startgroup)
                      ("one-shot" . ?o)
                      ("project" . ?j)
                      ("tiny" . ?t)
                      (:endgroup)
                      ;; misc
                      ("meta")
                      ("review")
                      ("reading")))

;; Org-refile: where should org-refile look?
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

;;; Phase 3 variables

;; Org-roam variables
(setq org-roam-directory "~/Documents/org-roam/")
(setq org-roam-index-file "~/Documents/org-roam/index.org")

;;; Optional variables

;; Advanced: Custom link types
;; This example is for linking a person's 7-character ID to their page on the
;; free genealogy website Family Search.
;; (setq org-link-abbrev-alist
;;       '(("family_search" . "https://www.familysearch.org/tree/person/details/%s")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Phase 1: editing and exporting files
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :hook ((org-mode . visual-line-mode)  ; wrap lines at word breaks
         (org-mode . flyspell-mode))    ; spell checking!

  :bind (:map global-map
              ("C-c a" . 'org-agenda)
              ("C-c l s" . org-store-link)          ; Mnemonic: link → store
              ("C-c l i" . org-insert-link-global)) ; Mnemonic: link → insert
  :config
  (require 'oc-csl)                     ; citation support
  (add-to-list 'org-export-backends 'md)

  ;; Make org-open-at-point follow file links in the same window
  (setf (cdr (assoc 'file org-link-frame-setup)) 'find-file)

  ;; Make exporting quotes better
  (setq org-export-with-smart-quotes t))
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Phase 2: todos, agenda generation, and task tracking
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Yes, you can have multiple use-package declarations. It's best if their
;; configs don't overlap. Once you've reached Phase 2, I'd recommend merging the
;; config from Phase 1. I've broken it up here for the sake of clarity.
(use-package org
  :config
  ;; Instead of just two states (TODO, DONE) we set up a few different states
  ;; that a task can be in. Run
  ;;     M-x describe-variable RET org-todo-keywords RET
  ;; for documentation on how these keywords work.
  (setq org-todo-keywords
        '((sequence "TODO(t)" "WAITING(w@/!)" "STARTED(s!)" "|" "DONE(d!)" "OBSOLETE(o@)")))

  ;; Refile configuration
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-use-outline-path 'file)

  (setq org-capture-templates
        '(("c" "Default Capture" entry (file "inbox.org")
           "* TODO %?\n%U\n%i")
          ;; Capture and keep an org-link to the thing we're currently working with
          ("r" "Capture with Reference" entry (file "inbox.org")
           "* TODO %?\n%U\n%i\n%a")
          ;; Define a section
          ("w" "Work")
          ("wm" "Work meeting" entry (file+headline "work.org" "Meetings")
           "** TODO %?\n%U\n%i\n%a")
          ("wr" "Work report" entry (file+headline "work.org" "Reports")
           "** TODO %?\n%U\n%i\n%a")))

  ;; An agenda view lets you see your TODO items filtered and
  ;; formatted in different ways. You can have multiple agenda views;
  ;; please see the org-mode documentation for more information.
  (setq org-agenda-custom-commands
        '(("n" "Agenda and All Todos"
           ((agenda)
            (todo)))
          ("w" "Work" agenda ""
           ((org-agenda-files '("work.org")))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Phase 3: extensions
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org-roam
  :defer t
  :after cl-lib
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n t" . org-roam-node-tag-read)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today)
         :map org-mode-map
         ("M-," . org-mark-ring-goto))
  :config
  (defun org-roam-tags-list ()
    "Return all tags (#+FILETAGs) stored in the database."
    (let ((rows (org-roam-db-query "SELECT DISTINCT tag FROM tags;")))
      (flatten-list rows)))

  (defun org-roam-node-tag-read (&optional initial-input filter-fn sort-fn
                                           require-match prompt)
    "Return a list of `org-roam-node' that have a matching #+FILETAG entry.

If provided, the PROMPT string is used as a custom prompt in the minibuffer."
    (interactive current-prefix-arg)
    (let* ((prompt (or prompt "File Tag: "))
           (tag (completing-read prompt (org-roam-tags-list)))
           ;; NOTE: We construct an alist because we want the user's title
           ;; selection to be used as a key to get the node's UUID.
           (nodes (mapcar (pcase-lambda (`(,title ,uuid))
                            `(,title . ,uuid))
                          (org-roam-db-query
                           [:select [title id]
                                    :from [:select [id file title properties
                                                       :from nodes] :as nodes
                                                       :join tags
                                                       :on (= nodes:id tags:node_id)]
                                    :where (= tags:tag $s1)]
                           tag)))
           (selected-node (completing-read "Node: " nodes))
           (selected-node-id (alist-get selected-node nodes 'nil 'nil #'string=)))
      (org-roam-node-open
       (org-roam-node-from-id selected-node-id))))

  (org-roam-db-autosync-mode)
  (org-roam-setup)
  (setq-local completion-ignore-case t)

  :custom
  (org-roam-v2-ack t))

;; Enable CDLatex in Org Mode
(use-package org
  :hook (org-mode . turn-on-org-cdlatex)
  :config
  ;; customize cdlatex keybindings in org
  (define-key org-cdlatex-mode-map (kbd "'") nil)
  (define-key org-cdlatex-mode-map (kbd "'") nil)
  (define-key org-cdlatex-mode-map (kbd "#") #'org-cdlatex-math-modify)
  (define-key org-cdlatex-mode-map (kbd ";") #'cdlatex-math-symbol)

  (defun my/org-inside-latex-p ()
    "Check whether point is inside an Org LaTeX fragment or environment."
    (or (and (fboundp 'org-inside-LaTeX-fragment-p)
             (org-inside-LaTeX-fragment-p
              (and (fboundp 'org-element-type)
                   (let ((elem (org-element-context)))
                     (memq (car elem) '(latex-fragment latex-environment))))))))

  ;; Handle TAB precedence specifically inside Org buffers
  (defun my/org-tab-conditional ()
    "Handle TAB precedence: Yasnippet active field -> CDLatex -> default Org cycle."
    (cond
     ;; 1. Active snippet field: let yasnippet jump/expand
     ((and (bound-and-true-p yas-minor-mode)
           (fboundp 'yas-active-snippets)
           (yas-active-snippets))
      (yas-next-field-or-maybe-expand)
      t)
     ;; 2. Inside LaTeX fragment: let cdlatex handle it
     ((and (bound-and-true-p org-cdlatex-mode)
           (fboundp 'org-inside-LaTeX-fragment-p)
           (org-inside-LaTeX-fragment-p))
      (cdlatex-tab)
      t)
     ;; 3. Fallback: let Org do its default tab action (cycle/table)
     (t nil)))

  (add-hook 'org-tab-first-hook #'my/org-tab-conditional))
 
(provide 'org-config)
;;; org-config.el ends here

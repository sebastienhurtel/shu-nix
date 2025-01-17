(setq user-full-name "Sébastien Hurtel"
      user-mail-address "sebastienhurtel@gmail.com")
(setq doom-font (font-spec :family "MesloLGS NF" :size 14))
(setq doom-theme 'doom-one)
(setq display-line-numbers-type t)

;; Org-mode related
(setq org-directory "~/Documents/shu/org/") ; default org-directory
(setq org-roam-directory "~/Documents/shu/org/notes")
(after! org
  (use-package! ox-extra
    :config
    (ox-extras-activate '(latex-header-blocks ignore-headlines)))
  (use-package! ox-latex
    :init
    :config
    (setq org-latex-pdf-process
          '("pdflatex -interaction nonstopmode -output-directory %o %f"
            "bibtex %b"
            "pdflatex -interaction nonstopmode -output-directory %o %f"
            "pdflatex -interaction nonstopmode -output-directory %o %f"))
    (setq org-latex-with-hyperref nil)
    (setq org-latex-prefer-user-labels t)
    (setq org-latex-logfiles-extensions
          (quote ("lof" "lot" "tex~" "aux" "idx" "log" "out" "toc" "nav" "snm" "vrb" "dvi" "fdb_latexmk" "blg" "brf" "fls" "entoc" "ps" "spl" "bbl" "xmpi" "run.xml" "bcf" "acn" "acr" "alg" "glg" "gls" "ist")))
    (unless (boundp 'org-latex-classes)
      (setq org-latex-classes nil)))

  (setq
   org-startup-indented t                 ; indent by default
   org-tags-column -75                    ; align tags on the 70th columns
   org-hide-leading-stars t               ; don't show leading stars
   org-cycle-separator-lines 0            ; don't show blank lines between collapsed trees
   org-src-fontify-natively t             ; fontify code blocks
   org-edit-src-content-indentation 0     ; don't indent source blocks
   org-catch-invisible-edits 'error       ; don't edit invisible text
   org-pretty-entities t                  ; use "pretty entities"
   org-export-use-babel nil               ; do not evaluate blocks when exporting
   org-export-with-toc nil                ; do not add a ToC when exporting
   org-html-postamble nil                 ; do not add a postamble when exporting
   org-html-head-include-scripts nil      ; do not add Javascript
   org-return-follows-link t              ; follow link directly with return
   org-clock-mode-line-total 'current     ; only display the current clock time in modeline
   org-log-into-drawer t                  ; better TODO tacking
   org-clock-in-switch-to-state "STRT"    ; Start a task when clocked in
   org-duration-format '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))

  (setq org-todo-keywords
        '((sequence
           "TODO(t)"  ; A task that needs doing & is ready to do
           "STRT(s!)"  ; A task that is in progress
           "WAIT(w)"  ; Something external is holding up this task
           "HOLD(h!)"  ; This task is paused/on hold because of me
           "|"
           "DONE(d@/!)"  ; Task successfully completed
           "CANCELLED(k@/!)") ; Task was cancelled, aborted or is no longer applicable
          (sequence
           "[ ](T)"   ; A task that needs doing
           "[-](S)"   ; Task is in progress
           "[?](W)"   ; Task is being held up or paused
           "|"
           "[X](D)")) ; Task was completed
        org-todo-keyword-faces
        '(("[-]"  . +org-todo-active)
          ("STRT" . +org-todo-active)
          ("[?]"  . +org-todo-onhold)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("PROJ" . +org-todo-project))))

(setq org-roam-directory "~/Documents/org/notes")
;; Git auto commit mode for org
(defvar shu:git-auto-commit-mode-for-orgmode-directories
  '("~/Documents/shu/org")
  "List of directories where git-auto-commit-mode will be enabled.")
(use-package! git-auto-commit-mode
  :hook (org-mode . shu:git-auto-commit-mode-for-orgmode)
  :config
  (defun shu:git-auto-commit-mode-for-orgmode ()
    "Enable autocommit mode only for some directories."
    (when (and buffer-file-name
               (--any? (f-ancestor-of? it buffer-file-name)
                       shu:git-auto-commit-mode-for-orgmode-directories))
      (git-auto-commit-mode 1))))

;; Add ob-ein
(org-babel-do-load-languages
 'org-babel-load-languages
 '((ein . t)))

;; mu4e
;; Path to mu4e
(add-load-path! "/usr/local/share/emacs/site-lisp/mu4e")
(set-email-account! "sebastienhurtel@gmail.com"
                    '((user-full-name         . "Sébastien Hurtel")
                      (smtpmail-smtp-user     . "sebastienhurtel@gmail.com")
                      (smtpmail-smtp-server   . "smtp.gmail.com")
                      (smtpmail-smtp-service  . 587)
                      (smtpmail-debug-info    . t)
                      (mu4e-drafts-folder     . "/shu/Drafts")
                      (mu4e-sent-folder       . "/shu/Sent")
                      (mu4e-trash-folder      . "/shu/Trash")
                      (mu4e-refile-folder     . "/shu/All")
                      (mu4e-update-interval   . 120)))
(after! mu4e
  (setq mu4e-bookmarks
         '(("flag:unread AND NOT flag:trashed AND NOT maildir:/shu/All" "Unread messages" ?u)
           ("maildir:/shu/INBOX" "Inbox" ?i)
           ("maildir:/shu/Sent" "Messages sent" ?s)
           ("maildir:/shu/Starred:" "Starred" ?f)))
  (setq mu4e-headers-fields
        '((:flags . 6)
          (:account-stripe . 2)
          (:from-or-to . 25)
          (:folder . 10)
          (:recipnum . 2)
          (:subject . 85)
          (:human-date . 8)))
  (defvar +mu4e-header--folder-colors nil)
  (appendq! mu4e-header-info-custom
            '((:folder .
               (:name "Folder" :shortname "Folder" :help "Lowest level folder" :function
                (lambda (msg)
                  (+mu4e-colorize-str
                   (replace-regexp-in-string "\\`.*/" "" (mu4e-message-field msg :maildir))
                   '+mu4e-header--folder-colors))))))
;; mu4e alert
;; Specific to gmail
(after! mu4e
  (setq mu4e-index-cleanup nil
        ;; because gmail uses labels as folders we can use lazy check since
        ;; messages don't really "move"
        mu4e-index-lazy-check t))
  ;; Don't display mail in All as unread
  (setq mu4e-alert-interesting-mail-query
        (concat
         "flag:unread"
         " AND NOT flag:trashed"
         " AND NOT maildir:"
         "/shu/All")))
;;
;; BM Bookmark
(map! (:leader
       (:desc "Toggle mark"      :nv "b m" #'bm-toggle
        :desc "Next mark"        :nv "b ." #'bm-next
        :desc "Previous mark"    :nv "b ," #'bm-previous
        :desc "Show marks"       :nv "b M" #'bm-show)))

;; undo-tree
(map! (:leader
       (:desc "undo" :nv "u"   #'undo-tree-undo
        :desc "redo" :nv "C-r" #'undo-tree-redo)))

;; LSP confiugration
(setq lsp-signature-function 'lsp-signature-posframe)

;; Treemacs configuration
(setq treemacs-width 30)
(setq doom-themes-treemacs-theme "doom-colors")

;; Modeline
(setq doom-modeline-vcs-max-length 25)
(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-github t)
(setq doom-modeline-github-interval t)

;; File templates
(set-file-template! "/script\\.py$" :trigger "__script.py" :mode 'python-mode)
(set-file-template! "/ansible\\.py$" :trigger "__ansible.py" :mode 'python-mode)

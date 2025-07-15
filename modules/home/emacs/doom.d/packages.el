;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; Junos-mode
(package! junos-mode
  :recipe (:host github :repo "vincentbernat/junos-mode"
           :files (:defaults "junos.py")))
;; org related
(package! org-mime
  :recipe (:host github :repo "org-mime/org-mime"
           :files ("*")))

(package! tree-edit
  :recipe (:host github :repo "ethan-leba/tree-edit"))

(package! bm)
(package! eldoc-box)
(package! git-auto-commit-mode)
(package! minimap)
(package! org-download)
(package! org-modern)
(package! protobuf-mode)
(package! smtpmail)
(package! svg-tag-mode)
(package! uuid)
(package! yang-mode)
(when (eq emacs-major-version 30)
  (package! eldoc :built-in t))
(package! emacs-syncthing
  :recipe (:host github :repo "KeyWeeUsr/emacs-syncthing"))
(package! flyover
  :recipe (:host github :repo "konrad1977/flyover"))

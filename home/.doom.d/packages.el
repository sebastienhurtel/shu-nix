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

(package! uuid)
(package! smtpmail)
(package! git-auto-commit-mode)
(package! bm)
(package! org-modern :pin "537e6b75e38bc0eff083c390c257098c9fc9ab49")

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
(package! git-auto-commit-mode)
(package! logstash-conf :pin "ebc4731c45709ad1e0526f4f4164020ae83cbeff")
(package! minimap)
(package! org-download :pin "19e166f0a8c539b4144cfbc614309d47a9b2a9b7")
(package! org-modern)
(package! protobuf-mode :pin "2f6e7055952eeff2fef2f29edb092c97e7949793")
(package! smtpmail)
(package! svg-tag-mode)
(package! uuid)
(package! yang-mode)
(package! eldoc-box)
(when (eq emacs-major-version 30)
  (package! eldoc :built-in t))

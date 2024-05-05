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

(package! org-download :pin "19e166f0a8c539b4144cfbc614309d47a9b2a9b7")
(package! org-modern :pin "537e6b75e38bc0eff083c390c257098c9fc9ab49")
(package! svg-tag-mode :pin "0e0ea48799d8911ed6c1ef60565a20fd5cf3dae4")
(package! smtpmail)

(package! uuid)
(package! git-auto-commit-mode)
(package! bm)
(package! logstash-conf :pin "ebc4731c45709ad1e0526f4f4164020ae83cbeff")
(package! minimap)
(package! protobuf-mode :pin "c862c1cab4d591963437774cc7d3f0a8e4bb1da1")
(package! yang-mode :pin "4b4ab4d4a79d37d6c31c6ea7cccbc425e0b1eded")

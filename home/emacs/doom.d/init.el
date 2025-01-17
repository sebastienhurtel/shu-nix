;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load in.
;; Remember to run 'doom sync' after modifying it!

;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;      documentation. There you'll find information about all of Doom's modules
;;      and what flags they support.

;; NOTE Move your cursor over a module's name (or its flags) and press 'K' (or
;;      'C-c g k' for non-vim users) to view its documentation. This works on
;;      flags as well (those symbols that start with a plus).
;;
;;      Alternatively, press 'gd' (or 'C-c g d') on a module to browse its
;;      directory (for easy access to its source code).
;;
;; NOTE Default template at https://github.com/doomemacs/doomemacs/blob/8be1ef498b81628214ab5e78739661faaf9d950f/templates/init.example.el#L24

(doom! :input

       :completion
       (corfu +orderless +icons)
       (vertico +childframe +icons)

       :ui
       doom
       doom-dashboard
       doom-quit
       (emoji +unicode)
       hl-todo
       modeline
       nav-flash
       ophints
       (popup +all +defaults)
       (treemacs +lsp)
       unicode
       vc-gutter
       vi-tilde-fringe
       window-select
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +lsp)
       multiple-cursors
       rotate-text
       snippets

       :emacs
       (dired +icons)
       electric
       ibuffer
       vc
       (undo +tree)

       :term
       vterm

       :checkers
       (syntax
        +childframe)

       :tools
       ansible
       direnv
       (docker +lsp)
       editorconfig
       ein
       (eval +overlay)
       (lookup +docsets)
       (lsp +peek)
       (magit +forge)
       pass
       pdf
       tmux
       tree-sitter

       :lang
       data
       emacs-lisp
       (go +lsp)
       (latex
       +latexmk
       +cdlatex
       +fold
       +lsp)
       (nix +tree-sitter +lsp)
       (org
        +babel
        +capture
        +dragndrop
        +export
        +jupyter
        +present
        +pretty
        +roam2)
       (python
        +pyright
        +lsp
        +tree-sitter)
       (sh +lsp +tree-sitter)

       :email

       :app
       calendar

       :config
       (default +bindings +smartparens))

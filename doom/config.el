;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
;; Place your private configuration here

;;; Key bindings
(load! "+bindings")

;;; Visual configuration
;; theme
(load-theme 'gruvbox-light-soft t)

;; font
(setq doom-font (font-spec :family "Source Code Pro" :size 14))

;; relative line numbers
(setq doom--line-number-style 'relative)

;;; Package configuration
;; magit
(setq magit-repository-directories '(("~/dev/" . 3))
      magit-rebase-arguments '("--autostash")
      magit-pull-arguments '("--rebase" "--autostash"))

;; latex
(setq +latex-viewers '(zathura))

;; ssh
(setq ssh-directory-tracking-mode t)
(shell-dirtrack-mode t)
(setq dirtrackp nil)

;; org-mode
(setq org-directory (expand-file-name "~/documents/notes/")
     org-agenda-files (list org-directory)
     org-ellipsis " ▼ "
     ;; org-bullets-list '("#")
     )

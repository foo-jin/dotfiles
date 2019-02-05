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
(setq display-line-numbers-type 'visual)

;;; Package configuration
;; magit
(after! magit
  (setq magit-repository-directories '(("~/dev/" . 3))))

;; latex
(setq +latex-viewers '(zathura))

;; ssh
(after! ssh
  (setq ssh-directory-tracking-mode t)
  (shell-dirtrack-mode t)
  (setq dirtrackp nil))

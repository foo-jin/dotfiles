;;; ~/.config/doom/+bindings.el -*- lexical-binding: t; -*-

(map! (:when (featurep! :feature evil)
        ;; evil-easymotion
        :m  "gs"    #'+evil/easymotion  ; lazy-load `evil-easymotion'
        (:after evil-easymotion
          :map evilem-map
          "SPC" #'avy-goto-char-2)))

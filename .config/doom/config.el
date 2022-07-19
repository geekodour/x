;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; user info:
(setq
 user-full-name "Hrishikesh Barman"
 user-mail-address "hrishikeshbman@gmail.com"
 )

;; looks:
(setq
 doom-font (font-spec :family "JetBrains Mono Nerd Font" :size 13)
 doom-theme 'doom-tokyo-night
 doom-themes-treemacs-theme "doom-colors"
 )

;; components:
(setq
 display-line-numbers-type 'relative
 magit-revision-show-gravatars '("^Author:     " . "^Commit:     ")
 )

;; splash screen:
(setq
 fancy-splash-image (concat doom-private-dir "splash/mario.png")
 +doom-dashboard-functions '(doom-dashboard-widget-banner doom-dashboard-widget-loaded)
 )

;; package configuration(before load):
(use-package! tree-sitter ; a minor mode that provides a buffer-local syntax tree
  :config
  (global-tree-sitter-mode)
  (require 'tree-sitter-langs)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

;; package configurations(after load):
(after! projectile
  (setq projectile-project-search-path '("~/projects/"))
  (projectile-add-known-project "~/notes/"))
(after! which-key
  (setq which-key-popup-type 'minibuffer) ;; default popup does not show full contents sometimes
  )
(after! centaur-tabs
  (setq centaur-tabs-set-bar 'under) ; see https://github.com/ema2159/centaur-tabs/issues/127
  (centaur-tabs-group-by-projectile-project)) ; see https://github.com/ema2159/centaur-tabs/issues/181


;; enabling minor modes:
;; note: probably not the best way to do this 🤔
(nyan-mode)

;; default set of variables:
(setq-default
 ;;x-stretch-cursor t ; stretch cursor to the glyph width
 evil-want-fine-undo t  ; by default while in insert all changes are one big blob. Be more granular
 auto-save-default nil ; auto save creates a lot of issues for me.
 truncate-string-ellipsis "…"  ; unicode ellispis are nicer than "..."
 )

;; loading other private config:
(load (concat doom-private-dir "org-mode-config.el"))

;; environment variables
(setenv "XDG_SESSION_TYPE" "wayland") ;; for some reason emacs does not pick this up so we set it up manually

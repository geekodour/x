;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; user info:
(setq
 user-full-name "Hrishikesh Barman"
 user-mail-address "hrishikeshbman@gmail.com"
 )

;; looks:
(setq
 doom-font (font-spec :family "JetBrains Mono Nerd Font" :size 13)
 ;; doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 13)
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
 fancy-splash-image (concat doom-user-dir "splash/mario.png")
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
  (setq projectile-project-search-path '("~/projects/" "~/open_source" "~/clientwork"))
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
 shell-file-name "/bin/bash" ; I use fish as my default shell but org-anki has issues with fish shell because of no heredoc support, for now I don't really need fish
 )

;; loading other private config:
(load (concat doom-user-dir "org-mode-config.el"))

;; autocomplete
;; see https://company-mode.github.io/manual/Getting-Started.html
(with-eval-after-load 'company
  (define-key company-mode-map (kbd "C-/") 'company-complete)
  )

;; python
(add-hook 'python-mode-hook
          (lambda ()
            (setq-local python-shell-buffer-name
                        (format "Python %s" (buffer-file-name))
                        )))
;; ;; Restart python console before evaluate buffer or region to avoid various
;; ;; uncanny conflicts, like not reloding modules even when they are changed"
;; (defun restart-python-console ()
;;   (interactive)
;;   (kill-Python "process")
;;   (sleep-for 0.05)
;;   (kill-buffer "*Python*")
;;   (elpy-shell-send-region-or-buffer))

;; Restart python console before evaluate buffer or region to avoid various
;; uncanny conflicts, like not reloding modules even when they are changed"
;; (defun my-restart-python-console ()
;;   (interactive)
;;   (if (get-buffer (format "Python %s" (buffer-file-name))  )
;;       (let ((kill-buffer-query-functions nil)) (kill-buffer (format "Python %s" (buffer-file-name)))))
;;   (elpy-shell-send-region-or-buffer))

(global-set-key (kbd "C-c C-x C-c") 'my-restart-python-console)
(global-set-key (kbd "C-S-v") #'paste-from-clipboard)

;; environment variables
(setenv "XDG_SESSION_TYPE" "wayland") ;; for some reason emacs does not pick this up so we set it up manually

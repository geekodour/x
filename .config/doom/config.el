;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Hrishikesh Barman"
      user-mail-address "hrishikeshbman@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tokyo-night)
(setq doom-themes-treemacs-theme "doom-colors")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(setq fancy-splash-image (concat doom-private-dir "splash/mario.png"))
(setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(after! projectile
  (setq projectile-project-search-path '("~/projects/")))

;; note: default which-key popup does not fully show its contents
(after! which-key
  (setq which-key-popup-type 'minibuffer))

;; disable completed items to show up in agenda views
;;(after! org-agenda
;;  (setq org-agenda-skip-scheduled-if-done t)
;;  (setq org-agenda-skip-deadline-if-done t))

;; (after! org
;;   ;; disable auto-complete in org-mode buffers
;;   (remove-hook 'org-mode-hook #'auto-fill-mode)
;;   ;; disable company too
;;   (setq company-global-modes '(not org-mode)))

(after! centaur-tabs
  (setq centaur-tabs-set-bar 'under) ; see https://github.com/ema2159/centaur-tabs/issues/127
  (centaur-tabs-group-by-projectile-project)) ; see https://github.com/ema2159/centaur-tabs/issues/181

;; notes:
;; - M-x tree-sitter-debug-mode: show the current buffer’s syntax tree in a separate buffer
;; - M-x tree-sitter-query-builder: query playground
(use-package! tree-sitter ; a minor mode that provides a buffer-local syntax tree
  :config
  (global-tree-sitter-mode)
  (require 'tree-sitter-langs)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

;; minor modes
;; note: i am not sure if this is the best way to enable minor modes on startup
(nyan-mode)

(setq-default
 x-stretch-cursor t ; stretch cursor to the glyph width
 evil-want-fine-undo t  ; by default while in insert all changes are one big blob. Be more granular
 auto-save-default t ; nobody likes to loose work, I certainly don't
 truncate-string-ellipsis "…"  ; unicode ellispis are nicer than "..."
)

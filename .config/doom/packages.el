;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; fun:
(package! nyan-mode)
;; lang:
(package! fish-mode)
;; treesitter:
(package! tree-sitter)
(package! tree-sitter-langs)
;; helpful:
(package! focus) ; dim the font color of text in surrounding paragraphs
(package! info-colors)
(package! command-log-mode)
(package! golden-ratio)
;; org-mode related:
(package! org-appear)
(package! org-transclusion)
(package! org-super-agenda)
; org-roam
(unpin! org-roam)
(package! org-roam-ui)
;;(package! org-modern) ; i tried using it, does not play very well with my setup
;;anki
;; (package! org-anki :recipe (:host github :repo "geekodour/org-anki" :branch "shell-support"))
(package! org-anki)
(package! toc-org)
(package! org-reveal) ; might not need this here
(package! ox-reveal)
;; github.com/hakimel/reveal.js/
(package! verb)
;;

;; other packages to look for later:
;; (package! org-ol-tree) ;; does not seem to be available
;;(package! org-roam-ui) ;; use after undertanding what can unpinning of org-roam can do
;;(package! org-ref) ;; also check org-cite
;;(package! org-roam-bibtex) ;; take notes on bibliography files
;;(package! org-noter) ;; taking notes on pdf
;;https://github.com/alphapapa/org-sidebar
;; org fany priorities

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)
;(package! vertico :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)

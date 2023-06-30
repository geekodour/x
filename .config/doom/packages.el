;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; fun:
(package! nyan-mode)

;; helpful:
(package! focus) ; dim the font color of text in surrounding paragraphs
(package! info-colors)
(package! command-log-mode)
(package! golden-ratio)
(package! apheleia)

;; org-mode related:
(package! org-appear)
(package! org-transclusion) ;; not using this atm
(package! org-web-tools)
(package! org-super-agenda)
(unpin! org-roam)
(package! org-roam-ui)

;; anki
(package! org-anki)
(package! toc-org)
(package! annalist)

;; org-reveal
;; (package! org-reveal) ; might not need this here
(package! ox-reveal)

;; others
(package! verb)
(package! devdocs-browser)
(package! go-dlv)
;; (package! chatgpt-shell
;;   :recipe (:host github :repo "xenodium/chatgpt-shell"))
;; (package! flymake-vale
;;   :recipe (:host github :repo "tpeacock19/flymake-vale"))
;; (package! flymake-popon
;;   :recipe (:host codeberg :repo "akib/emacs-flymake-popon"))

;; other packages to look for later:
;;(package! org-ol-tree) ;; does not seem to be available
;;(package! org-ref) ;; also check org-cite
;;(package! org-roam-bibtex) ;; take notes on bibliography files
;;(package! org-noter) ;; taking notes on pdf
;;https://github.com/alphapapa/org-sidebar

(package! anaconda-mode :disable t)
(package! nose :disable t)
(package! pipenv :disable t)
(package! pyimport :disable t)
(package! py-isort :disable t)

(setq
 doom-font (font-spec :family "JetBrains Mono NF" :size 13)
 ;; doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 13)
 doom-theme 'doom-tokyo-night
 doom-themes-treemacs-theme "doom-colors"
 )

(setq
 display-line-numbers-type 'relative
 magit-revision-show-gravatars '("^Author:     " . "^Commit:     ")
 )

(setq
 fancy-splash-image (concat doom-user-dir "splash/mario.png")
 +doom-dashboard-functions '(doom-dashboard-widget-banner doom-dashboard-widget-loaded)
 )

(setq
 user-full-name "Hrishikesh Barman"
 user-mail-address "hrishikeshbman@gmail.com"
 auth-sources '("~/.authinfo") ; we are not encrypting shit for now, token is readonly anyway
 )

(setq
 org-directory "~/notes/org/"
 org-roam-directory "~/notes/org/roam" ; expects the directory to exist
 org-agenda-files '("~/notes/org/tasks.org" "~/notes/org/meetings.org" "~/notes/org/l.org" "~/locus/o/content-org/anti_lib.org") ; it looks for files with .org extensions
 org-roam-mode-sections '(org-roam-backlinks-section org-roam-reflinks-section) ;; TODO: Maybe we don't need this
 ;; journal
 org-journal-date-prefix "#+title: "
 org-journal-time-prefix "* "
 org-journal-file-header 'cf/org-journal-date-prefix
 org-journal-date-format "%a, %d-%m-%y"
 org-journal-file-format "%d_%m_%Y.org" ; important to have the .org otherwise org-agenda does not pick the todos
 )

(setq
 deft-directory "~/notes/org"
 deft-recursive t
 deft-recursive-ignore-dir-regexp "\\(?:\\.\\|\\.\\.\\|roam\\|journal\\)"
 deft-use-filename-as-title t
 deft-strip-summary-regexp "\\(.*\\)"
 )

(setq
 poetry-tracking-strategy 'projectile
 )

(setq-default
 ;;x-stretch-cursor t ; stretch cursor to the glyph width
 evil-want-fine-undo t  ; by default while in insert all changes are one big blob. Be more granular
 auto-save-default nil ; auto save creates a lot of issues for me.
 truncate-string-ellipsis "…"  ; unicode ellispis are nicer than "..."
 shell-file-name "/bin/sh" ; org-anki has issues with fish shell because of no heredoc support, for now I don't really need fish
 )

(setenv "XDG_SESSION_TYPE" "wayland") ;; for some reason emacs does not pick this up so we set it up manually
(setenv "GPG_AGENT_INFO")

(use-package! tree-sitter
  :config
  (global-tree-sitter-mode)
  (require 'tree-sitter-langs)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package! apheleia
  :config
  ;; (apheleia-global-mode +1) ;; don't format by default/automatically
  (setf (alist-get 'python-mode apheleia-mode-alist)
        '(isort black))
  (setf (alist-get 'pg_format apheleia-formatters)
        '("pg_format" "-"))
  (setf (alist-get 'sql-mode apheleia-mode-alist)
        '(pg_format))
   )
(push '(sh-mode . shfmt) apheleia-mode-alist) ; apheleia for some reason does not already do this

(add-hook! prog-mode #'flymake-mode) ; start flymake-mode by default only for programming language
(setq
 eglot-stay-out-of nil
 )
(map!
 (:leader :desc "Enable vale" "t V" #'flymake-vale-maybe-load)) ; no way to toggle apparently

(use-package! nyan-mode
  :config
  (nyan-mode))

(use-package! flymake-popon
  :config
  (global-flymake-popon-mode))

(use-package! org-appear
  :after org
  :hook (org-mode . org-appear-mode)
  :config (setq
           org-appear-autolinks t
           org-appear-autoentities t
           org-appear-autosubmarkers t))


;; TODO: This needs to be configured properly
(use-package! org-transclusion
  :after org-roam)


(use-package! websocket
    :after org-roam) ;; Needed for org-roam-ui
(use-package! org-roam-ui
    :after org-roam
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(use-package! org-super-agenda
  :hook (org-agenda-mode . org-super-agenda-mode))

(setq eglot-prefer-plaintext t)
(setq-default eglot-workspace-configuration '((:gopls . ((gofumpt . t)))))

(add-hook 'eglot-managed-mode-hook (lambda ()(add-to-list 'company-backends '(company-capf :with company-yasnippet))))

(define-derived-mode typescriptreact-mode web-mode "TypescriptReact" "A major mode for tsx.")
;; (define-derived-mode svelte-mode web-mode "Svelte" "A major mode for sveltejs.")
(use-package! typescript-mode
  :mode (("\\.ts\\'" . typescript-mode)
         ("\\.tsx\\'" . typescriptreact-mode)))

(use-package! svelte-mode
  :mode (("\\.svelte\\'" . svelte-mode))) ;; for some reason this does not work. it should work
;; :mode (("\\.svelte\\'" . typescript-mode))) ;; this works surprisingly

(use-package! eglot
  :ensure t
  :defer 3
  :hook
  ((js-mode
    typescript-mode
    typescriptreact-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs '(svelte-mode . ("svelteserver" "--stdio")))
  (add-to-list 'eglot-server-programs '(tuareg-mode . ("ocamllsp" "--stdio")))
  (cl-pushnew '((js-mode typescript-mode typescriptreact-mode) . ("typescript-language-server" "--stdio"))
              eglot-server-programs
              :test #'equal))

(after! org
  (setq
   org-tags-column 0
   org-element-use-cache nil ; emacs doesn't let me save files or exit emacs otherwise, emacs bug. follow up.
   org-auto-align-tags t
   org-hide-emphasis-markers t
   org-fold-catch-invisible-edits 'show-and-error
   org-insert-heading-respect-content t
   org-pretty-entities t
   org-ellipsis "…"
   org-image-actual-width 300
   org-complete-tags-always-offer-all-agenda-tags t
   ))

(after! org
  (custom-set-faces!
    '(org-level-1 :height 1.2 :weight extrabold :slant normal)
    '(org-level-2 :height 1.1 :weight bold :slant normal)
    '(org-level-3 :height 1.0 :weight bold :slant normal)
    '(org-document-title :height 180 :weight medium :family "Roboto")
    ))

(after! org
  (setq
   org-todo-keywords
   '(
     ;;tasks
     (sequence "TODO(t)" "INPROGRESS(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")
     ;;media
     (sequence "TOCONSUME" "CONSUMING" "|" "FINISHED" "DROPPED")
     ;;items
     (sequence "TOACQUIRE" "|" "ACQUIRED")
     ;;projects
     (sequence "SEED" "SAPLING" "GROWING" "|" "GROWN" "DIED")
     )
   ))

(after! org
  (setq org-capture-templates `(

;; tasks
;; tt: general todos
;; ts: appointments/events/meetings
;; td: self reminders
;; tw: blocked reminders
("t", "tasks")
("tt" "add todo" entry (file ,(concat org-directory "tasks.org")) "* TODO %?" :empty-lines 1)
("ts" "add todo[scheduled]" entry (file ,(concat org-directory "tasks.org")) "* TODO %? \nSCHEDULED: %^T" :empty-lines 1)
("td" "add todo[deadline]" entry (file ,(concat org-directory "tasks.org")) "* TODO %? \nDEADLINE: %^T" :empty-lines 1)
("tw" "add wait[deadline]" entry (file ,(concat org-directory "tasks.org")) "* WAITING %? \nDEADLINE: %^T" :empty-lines 1)

;; post/watch/read lists
;; lp: post list; online readings, tweets, blogs etc.
;; lm: movie list; movie, youtube videos, documentaries etc.
;; lv: video list; youtube videos, other short videos etc.
;; lr: reading list; book/paper readings etc.
("l", "lists")
("lp" "add post" entry (file+olp "~/locus/o/content-org/anti_lib.org" "Posts" "Un-categorized") "*** TOCONSUME %?" :empty-lines 1)
("lm" "add movie" entry (file+olp "~/locus/o/content-org/anti_lib.org" "Movies" "Un-categorized") "*** TOCONSUME %?" :empty-lines 1)
("lv" "add video" entry (file+olp "~/locus/o/content-org/anti_lib.org" "Videos" "Un-categorized") "*** TOCONSUME %?" :empty-lines 1)
("lr" "add book" entry (file+olp "~/locus/o/content-org/anti_lib.org" "Books" "Un-categorized") "*** TOCONSUME %?" :empty-lines 1)

;; today i x
;; inspiration: https://simonwillison.net/2021/May/2/one-year-of-tils/
;; xl: today i learned
;; xf: today i fucked up
;; TODO: Remove these, TILs and TIFUs to be fetched from Github issues, idk i kinda like the emacs interface now
("x", "todayi")
("xl" "add til" entry (file ,"~/locus/todayi/content-org/til.org") (function org-hugo-new-subtree-post-capture-template))
("xf" "add tifu" entry (file ,"~/locus/todayi/content-org/tifu.org") (function org-hugo-new-subtree-post-capture-template))

;; idea
;; il: new idea, can be anything
;; ip: some project idea
("i", "ideas")
("il" "add idea" entry (file ,(concat org-directory "ideas/ideas.org")) "* %?" :empty-lines 1)
("ip" "add project idea" entry (file "~/locus/o/assets/pages/project_ideas.org")
"* SEED %? %^g" :empty-lines 1)

;; journal
;; jj: journal entry, custom journal entry template attempts to emulate org-journal insertion.
;; jm: morning journal entry
;; jn: night journal entry
;; jh: health journal entry
("j" "journal")
("jj" "add journal entry" entry (function cf/org-journal-find-location) "* %<%H:%M> %?\n%i")
("jm" "add morning journal entry" entry (function cf/org-journal-find-location)
"* %<%H:%M> Morning Entry
** Looking Forward To \n%?" :empty-lines 1 :prepend t)
("jn" "add night journal entry" entry (function cf/org-journal-find-location)
"* %<%H:%M> Night Entry
** What do I remember from today?\n%?" :empty-lines 1)
("jh" "add health journal entry" entry (file ,(concat org-directory "health.org")) "* %T %?" :empty-lines 1))))

(after! org
  (setq
   org-agenda-current-time-string "⭠ now ─────────────────────────────────────────────────"
   org-agenda-skip-scheduled-if-done t
   org-agenda-skip-deadline-if-done t
   org-agenda-block-separator "────────────────"))


;; (after! ox-icalendar (setq org-icalendar-use-deadline '(todo-due)))
(after! org (setq org-icalendar-use-deadline '(todo-due)))

(after! org
  (setq
   org-agenda-custom-commands
   '(("t" "only today 🌞"
      (
       ;; today
       (agenda "" (
                   (org-agenda-overriding-header "\n👊 Today's Agenda")
                   (org-agenda-span 'day)
                   (org-agenda-start-day nil)
                   (org-agenda-skip-scheduled-if-done nil)
                   (org-agenda-skip-deadline-if-done nil)
                   (org-agenda-include-inactive-timestamps t)
                   (org-agenda-include-deadlines t)
                   (org-super-agenda-groups '(
                                              (:name "" :time-grid t :order 1)
                                              (:discard (:anything)))))))


      nil ("~/daily.html" "daily.txt"))

     ("d" "daily agenda 🏃"
      (
       ;; unscheduled shit
       (tags-todo "*" ( ; required filtering only happens to work with tags-todo currently
                       (org-agenda-overriding-header "🌀 Unscheduled(High Priority)")
                       (org-super-agenda-groups '(
                                                  (:name "tasks ⚒" :and (:scheduled nil :deadline nil :todo "TODO" :priority "A") :order 1)
                                                  (:name "waits ⏰" :and (:scheduled nil :deadline nil :todo "WAITING" :priority "A") :order 1)
                                                  (:name "consuption 🔖" :and (:scheduled nil :deadline nil :todo "TOCONSUME" :priority "A") :order 2)
                                                  (:name "consuming 🐄" :and (:scheduled nil :deadline nil :todo "CONSUMING" :priority "A") :order 2)
                                                  (:discard (:anything))))))


       ;; today
       (agenda "" (
                   (org-agenda-overriding-header "\n👊 Today's Agenda")
                   (org-agenda-span 'day)
                   (org-agenda-start-day nil)
                   (org-agenda-skip-scheduled-if-done nil)
                   (org-agenda-skip-deadline-if-done nil)
                   (org-agenda-include-deadlines t)
                   (org-super-agenda-groups '(
                                              (:name "" :time-grid t :order 1)
                                              (:discard (:anything))))))


       ;; next 3 days
       (agenda "" (
                   (org-agenda-overriding-header "\n📅 Next three days")
                   (org-agenda-time-grid nil)
                   (org-agenda-show-all-dates nil)
                   (org-agenda-span 3)
                   (org-agenda-start-day "+1d")))

       ;; deadlines for next 14 days
       (agenda "" ((org-agenda-overriding-header "\n🗡 Upcoming deadlines (+14d)")
                   (org-agenda-time-grid nil)
                   (org-agenda-start-on-weekday nil)
                   (org-agenda-start-day "+4d") ;; already have a next 3 days section
                   (org-agenda-span 14)
                   (org-agenda-show-all-dates nil)
                   (org-deadline-warning-days 0)
                   (org-agenda-entry-types '(:deadline))))

       ;; dues
       (tags "*" (
                    (org-agenda-overriding-header "\n🔥 Overdue")
                    (org-super-agenda-groups '(
                                               (:name "deadlines 💀" :deadline past)
                                               (:name "schedules ♻" :scheduled past)
                                               (:discard (:anything)))))))))))

(setq org-gcal-client-id "846127778336-jvfk3olcu1ec37242neqkdepbie6k9eq.apps.googleusercontent.com"
      org-gcal-client-secret "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"
      org-gcal-auto-archive nil
      org-gcal-fetch-file-alist '(
("269715bbdb60815127d11a80b3eb406fcb6d5d13631cfd8f08d3b65ab56196b3@group.calendar.google.com" .  "~/notes/org/tasks.org")
("27c4fd043369bc02c5a058d6dcfb4a87c03551a32c4d58532ce411d6811c2293@group.calendar.google.com" .  "~/notes/org/hacking.org")
("5e1acb6fd626ef21c9ab0a5b302f4c890f24bdd9048ce22261524b3015a20824@group.calendar.google.com" .  "~/notes/org/meetings.org")))
(require 'plstore)
;; for some reason following is needed for gcal to work in emacs29
(require 'tramp) ;; temp
(require 'gnutls) ;; temp
(require 'url-gw) ;; temp
(require 'url-cache) ;; temp
(require 'nsm) ;; temp
;; see https://discourse.doomemacs.org/t/recentf-cleanup-logs-a-lot-of-error-messages/3273/5
(setq network-stream-use-client-certificates nil) ;; temp
(setq network-security-protocol-checks nil) ;; temp
(after! tramp (advice-add 'doom--recentf-file-truename-fn :override
                          (defun my-recent-truename (file &rest _args)
                            (if (or (not (file-remote-p file)) (equal "sudo" (file-remote-p file 'method)))
                                (abbreviate-file-name (file-truename (tramp-file-local-name file)))
                              file))))
(fset 'epg-wait-for-status 'ignore)
;; end of patch for emacs29 gcal

;; NOTE: the file "oauth2-auto.plist" (whatever is set for oauth2-auto-plstore)
;;   needs to exist before, so manually create it
(add-to-list 'plstore-encrypt-to "CB46502EA121F97D")

;; oauth2-auto-plstore

(after! org
  (setq
   org-download-image-dir "~/Pictures/org"
   ))
(after! org-download
  (setq-default
   org-download-image-dir "~/Pictures/org" ; buf local: -*- mode: Org; org-download-image-dir: "~/pictures/foo"; -*-
   )
  (setq
   org-download-method 'directory
   org-download-image-dir "~/Pictures/org" ; buf local: -*- mode: Org; org-download-image-dir: "~/pictures/foo"; -*-
   org-download-heading-lvl nil ; do not want this categorized by headings
   org-download-timestamp "%Y%m%d-%H%M%S_"
   )
  )

(after! org
  (add-to-list 'org-babel-tangle-lang-exts '("python" . "py"))
  (add-to-list 'org-babel-tangle-lang-exts '("rust" . "rs"))
  (add-to-list 'org-babel-tangle-lang-exts '("ocaml" . "ml"))
  (add-to-list 'org-babel-tangle-lang-exts '("go" . "go")))

(after! projectile
  (setq
   projectile-project-search-path '(("~/projects" . 3) "~/locus" ("~/infra" . 2) ("~/faafo" . 2) "~/dump")
   +workspaces-on-switch-project-behavior nil)

  (projectile-add-known-project "~/.config/") ; not a git repo but has a .projectile
  (projectile-add-known-project "~/notes/"))

(after! which-key
  (setq which-key-popup-type 'minibuffer)) ;; default popup does not show full contents sometimes

(after! org-fancy-priorities
  (setq org-fancy-priorities-list '("🌕" "🌗" "🌙" "☕")))

(after! ellama
  (setq ellama-user-nick "🐥")
  (setq ellama-assistant-nick "🦉")
  (setq ellama-provider
		  (make-llm-ollama
		   :chat-model "zephyr:7b" :embedding-model "zephyr:7b")))
		   ;; :chat-model "zephyr:7b-alpha-q5_K_M" :embedding-model "zephyr:7b-alpha-q5_K_M")))

                  ;; This DID NOT WORK, shall try later
		  ;; (make-llm-ollama
                  ;;  :scheme "http"
                  ;;  :host "hq"
                  ;;  :port "6969"
		  ;;  :chat-model "zephyr:7b" :embedding-model "zephyr:7b")))

(use-package! ellama
  :commands (ellama-instant))

(defun ellama-make-flash-cards ()
  "Create flash cards from active region or current buffer."
  (interactive)
  (let ((text (if (region-active-p)
      (buffer-substring-no-properties (region-beginning) (region-end))
    (buffer-substring-no-properties (point-min) (point-max)))))
    (ellama-instant (concat (format "Text:\n%s\n" text)
                         "Instructions:\n"
                         "Create anki flash cards for the above text. Break the text down into different flashcards.\n"
                         "Each flashcard should be clear, precise and consistent. Try extracting info about attributes/tendencies, similarities/differences,causes/effects, significance/implications etc and mention them in the flashcards wherever relevant."
                         "If there is a link in markdown format, you can skip it.\n\n"
                         "Format for flashcards (2 lines):\n"
                         "- First line: Front of the card (question), put an asterisk symbol and a space character infront as a prefix.\n"
                         "- Second line: Back of the card (answer), keep the answer short use bullet points. Don't forget to use bullet points.\n\n"
                         "Example:\n"
                         "* What is an apple?\n"
                         "- A fruit\n- A food that humans eat"
                         ))))

;; (after! chatgpt-shell
;;   (setq chatgpt-shell-openai-key "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"))

(add-hook 'python-mode-hook
          (lambda ()
            (setq-local python-shell-buffer-name
                        (format "Python %s" (buffer-file-name))
                        )))

(map!
 (:leader :desc "insert node immediate" "n r k" #'cf/org-roam-node-insert-immediate)
 (:leader :desc "node complete" "n r c" #'completion-at-point)
 (:leader :desc "devdocs" "d")
 (:leader :desc "Open on point" "d o" #'devdocs-browser-open)
 (:leader :desc "Open on point for doc" "d i" #'devdocs-browser-open-in)
 (:leader :desc "Show available snippets" "m y" #'yas-describe-tables))
; TODO Need binding for treemacs workspace edit

(with-eval-after-load 'company
  (define-key company-mode-map (kbd "C-/") 'company-complete)
  )

(use-package! org
  :mode ("\\.org\\'" . org-mode)
  :config
  (define-key org-mode-map (kbd "C-c C-r") verb-command-map))
  (setq verb-auto-kill-response-buffers t)

(use-package! org-web-tools
  :after org
  :demand t ; do not lazy load this
  :config
  (define-key evil-normal-state-map (kbd "SPC i l") #'org-web-tools-insert-link-on-point))

(defun cf/hugo-export-all (&optional org-files-root-dir dont-recurse)
  "Export all Org files (including nested) under ORG-FILES-ROOT-DIR.
Example usage in Emacs Lisp: (ox-hugo/export-all \"~/org\")."
  (interactive)
  (let* ((org-files-root-dir (or org-files-root-dir default-directory))
         (dont-recurse (or dont-recurse (and current-prefix-arg t)))
         (search-path (file-name-as-directory (expand-file-name org-files-root-dir)))
         (org-files (if dont-recurse
                        (directory-files search-path :full "\.org$")
                      (directory-files-recursively search-path "\.org$")))
         (num-files (length org-files))
         (cnt 1))
    (if (= 0 num-files)
        (message (format "No Org files found in %s" search-path))
      (progn
        (message (format (if dont-recurse
                             "[ox-hugo/export-all] Exporting %d files from %S .."
                           "[ox-hugo/export-all] Exporting %d files recursively from %S ..")
                         num-files search-path))
        (dolist (org-file org-files)
          (with-current-buffer (find-file-noselect org-file)
            (message (format "[ox-hugo/export-all file %d/%d] Exporting %s" cnt num-files org-file))
            (org-hugo-export-wim-to-md :all-subtrees)
            (setq cnt (1+ cnt))))
        (message "Done!")))))

(defun cf/export-static-html (file_path)
  (with-current-buffer (find-file-noselect file_path)
    (org-html-export-to-html)
    )
  (message "Done!"))

(defun cf/org-journal-find-location ()
  ;; Open today's journal, but specify a non-nil prefix argument in order to
  ;; inhibit inserting the heading; org-capture will insert the heading.
  (org-journal-new-entry t)
  ;; Position point on the journal's top-level heading so that org-capture
  ;; will add the new entry as a child entry.
  (goto-char (point-min)))

(defun cf/org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t :unnarrowed t)))))
    (apply #'org-roam-node-insert args)))

(defun cf/org-journal-date-prefix (time)
  (let* (
         (date (format-time-string (org-time-stamp-format :long :inactive) (org-current-time)))
         (year (format-time-string "%Y"))
         (month (format-time-string "%m"))
         )
    (mapconcat #'identity
               `("", (format "#+HUGO_SECTION: journal/%s/%s" year month),(concat "#+DATE: " date))
               "\n")))

(defun org-hugo-new-subtree-post-capture-template ()
  "Returns `org-capture' template string for new Hugo post. See `org-capture-templates' for more information."
  (let* (;; http://www.holgerschurig.de/en/emacs-blog-from-org-to-hugo/
         (date (format-time-string (org-time-stamp-format :long :inactive) (org-current-time)))
         (title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
         (fname (org-hugo-slug title)))
    (mapconcat #'identity
               `(
                 ,(concat "* TODO " title)
                 ":PROPERTIES:"
                 ,(concat ":EXPORT_FILE_NAME: " fname)
                 ,(concat ":EXPORT_DATE: " date) ;Enter current date and time
                 ":END:"
                 "%?\n")                ;Place the cursor here finally
               "\n")))

(defun slot/org-roam-insert-image ()
  "Select and insert an image at point."
  (interactive)
  (let* ((file-name (format "%s-%s.png"
                            (file-name-sans-extension (buffer-name))
                            (cl-random (expt 2 31))))
         (path (format "%s/%s/%s" org-roam-directory "images" file-name)))
    (let ((grim-exit (call-process "/bin/sh" nil t nil "-c" (format "grim -g \"$(slurp)\" - | swappy -f - -o %s" path))))
      (when (= grim-exit 0)
        ;; ox-hugo needs the file prefix to properly set the path for the image when exported
        (insert (format "[[file:./images/%s]]" file-name)))
      )))

(defun org-web-tools-insert-link-on-point ()
  (interactive)
  (replace-string (thing-at-point 'url t) (org-web-tools--org-link-for-url (thing-at-point 'url t))))
  ;; (replace-string (thing-at-point 'url t) (org-web-tools--org-link-for-url (thing-at-point-url-at-point))))

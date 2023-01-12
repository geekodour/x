;; following paragraph from some online forum and pritam convinced me to try out
;; org-mode:
;;
;; "My files are 'logbook', 'life', 'project-1', 'project-2', etc. At any time I
;; can hit a key and capture an idea/meeting to any of those places, and as I'm
;; taking notes I can mark anything as a todo and schedule/deadline them. In the
;; 'agenda' I can see a single overview of all my todo items, and my schedule,
;; from all my notes."

;; global variables:
(setq
 org-directory "~/notes/org/"
 org-roam-directory "~/notes/org/roam" ; expects the directory to exist
 org-agenda-files '("~/notes/org/tasks.org" "~/notes/org/l.org" "~/projects/o/content-org/anti_lib.org") ; it looks for files with .org extensions
 deft-directory "~/notes"
 deft-recursive t
 )

;; org mode settings:
(after! org
  (setq
   ;; general settings
   org-tags-column 0
   org-element-use-cache nil ; emacs doesn't let me save files or exit emacs otherwise, emacs bug. follow up.
   org-auto-align-tags t
   org-hide-emphasis-markers t
   org-fold-catch-invisible-edits 'show-and-error
   org-insert-heading-respect-content t
   org-pretty-entities t
   org-ellipsis "…"
   org-complete-tags-always-offer-all-agenda-tags t
   ; org-download
   ; TODO: this has been intentionally defined 2-3 times around the file because
   ; of how doom handles org-download. a better way would be to remove
   ; +dragndrop and install org-download separately
   org-download-image-dir "~/pictures/org"
   ;; org-agenda
   ;; TODO: learn how to evaluate lisp commands directly and to play with
   ;;       org-ql, having that will make configuring this much much easier
   org-agenda-current-time-string "⭠ now ─────────────────────────────────────────────────"
   org-agenda-skip-scheduled-if-done t
   org-agenda-skip-deadline-if-done t
   org-agenda-block-separator "────────────────"
   ;; use org-store-agenda-views to export agenda into the files
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
                   (org-agenda-include-deadlines t)
                   (org-super-agenda-groups '(
                                              (:name "" :time-grid t :order 1)
                                              (:discard (:anything))
                                              ))
                   ))
       ) nil ("~/daily.html" "daily.txt")
      )
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
                                                  (:discard (:anything))
                                                  ))
                       ))
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
                                              (:discard (:anything))
                                              ))
                   ))
       ;; next 3 days
       (agenda "" (
                   (org-agenda-overriding-header "\n📅 Next three days")
                   (org-agenda-time-grid nil)
                   (org-agenda-show-all-dates nil)
                   (org-agenda-span 3)
                   (org-agenda-start-day "+1d")
                   ))
       ;; deadlines for next 14 days
       (agenda "" ((org-agenda-overriding-header "\n🗡 Upcoming deadlines (+14d)")
                   (org-agenda-time-grid nil)
                   (org-agenda-start-on-weekday nil)
                   (org-agenda-start-day "+4d") ;; already have a next 3 days section
                   (org-agenda-span 14)
                   (org-agenda-show-all-dates nil)
                   (org-deadline-warning-days 0)
                   (org-agenda-entry-types '(:deadline))
                   ))
       ;; dues
       (alltodo "" (
                   (org-agenda-overriding-header "\n🔥 Overdue")
                   (org-super-agenda-groups '(
                                              (:name "deadlines 💀" :deadline past)
                                              (:name "schedules ♻" :scheduled past)
                                              (:discard (:anything))
                                              ))
                   ))
       ))
     )
   )
  (load-library "ox-reveal")
  ;; custom faces
  (custom-set-faces!
    '(org-level-1 :height 1.2 :weight extrabold :slant normal)
    '(org-level-2 :height 1.1 :weight bold :slant normal)
    '(org-level-3 :height 1.0 :weight bold :slant normal)
    '(org-document-title :height 180 :weight medium :family "Roboto")
    )

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
   )
  (setq org-capture-templates
        `(
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

          ;; buy/watch/read lists
          ;; lp: post list; online readings, tweets, blogs etc.
          ;; lm: movie list; movie, youtube videos, documentaries etc.
          ;; lv: video list; youtube videos, other short videos etc.
          ;; lr: reading list; book/paper readings etc.
          ("l", "lists")
          ("lp" "add post" entry (file+olp "~/projects/o/content-org/anti_lib.org" "Posts" "Un-categorized") "*** TOCONSUME %?" :empty-lines 1)
          ("lm" "add movie" entry (file+olp "~/projects/o/content-org/anti_lib.org" "Movies" "Un-categorized") "*** TOCONSUME %?" :empty-lines 1)
          ("lv" "add video" entry (file+olp "~/projects/o/content-org/anti_lib.org" "Videos" "Un-categorized") "*** TOCONSUME %?" :empty-lines 1)
          ("lr" "add book" entry (file+olp "~/projects/o/content-org/anti_lib.org" "Books" "Un-categorized") "*** TOCONSUME %?" :empty-lines 1)

          ;; today i x
          ;; inspiration: https://simonwillison.net/2021/May/2/one-year-of-tils/
          ;; xl: today i learned
          ;; xf: today i fucked up
          ;; TODO: Remove these, TILs and TIFUs to be fetched from Github issues
          ("x", "todayi")
          ("xl" "add til" entry (file ,"~/projects/todayi/content-org/til.org") (function org-hugo-new-subtree-post-capture-template))
          ("xf" "add tifu" entry (file ,"~/projects/todayi/content-org/tifu.org") (function org-hugo-new-subtree-post-capture-template))

          ;; idea
          ;; il: new idea, can be anything
          ;; ip: some project idea
          ("i", "ideas")
          ("il" "add idea" entry (file ,(concat org-directory "ideas/ideas.org")) "* %?" :empty-lines 1)
          ("ip" "add project idea" entry (file ,(concat org-directory "ideas/project_ideas.org"))
"* SEED %? %^g
** Description:
** References:" :empty-lines 1)

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
         ("jh" "add health journal entry" entry (file ,(concat org-directory "health.org")) "* %T %?" :empty-lines 1))
        )
  )

;; org-appear config:
(use-package! org-appear
  :after org
  :hook (org-mode . org-appear-mode)
  :config (setq
           org-appear-autolinks t
           org-appear-autoentities t
           org-appear-autosubmarkers t
           )
  )

;; org-roam related:
(use-package! org-transclusion
  :after org-roam
  )
(setq
 org-roam-mode-sections '(org-roam-backlinks-section org-roam-reflinks-section)
 )
(map!
 (:leader :desc "insert node immediate" "n r k" #'cf/org-roam-node-insert-immediate)
 (:leader :desc "node complete" "n r c" #'completion-at-point)
 )

;; fancy priorities:
(after! org-fancy-priorities
  (setq
   org-fancy-priorities-list '("🌕" "🌗" "🌙" "☕")
   )
  )

;; org-journal:
(setq
 org-journal-date-prefix "#+title: "
 org-journal-time-prefix "* "
 org-journal-file-header 'cf/org-journal-date-prefix
 org-journal-date-format "%a, %d-%m-%y"
 org-journal-file-format "%d_%m_%Y.org" ; important to have the .org otherwise org-agenda does not pick the todos
 )

;; org-download
(after! org-download
  (setq-default
   org-download-image-dir "~/pictures/org" ; buf local: -*- mode: Org; org-download-image-dir: "~/pictures/foo"; -*-
   )
  (setq
   org-download-method 'directory
   org-download-image-dir "~/pictures/org" ; buf local: -*- mode: Org; org-download-image-dir: "~/pictures/foo"; -*-
   org-download-heading-lvl nil ; do not want this categorized by headings
   org-download-timestamp "%Y%m%d-%H%M%S_"
   org-image-actual-width 300
   )
  )

;; custom functions
;; cf: custom function
;; copied from https://github.com/kaushalmodi/ox-hugo/discussions/585#discussioncomment-2335203=
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
;; directly copied from jparcill/emacs_config/blob/master/config.el
(defun cf/org-journal-find-location ()
  ;; Open today's journal, but specify a non-nil prefix argument in order to
  ;; inhibit inserting the heading; org-capture will insert the heading.
  (org-journal-new-entry t)
  ;; Position point on the journal's top-level heading so that org-capture
  ;; will add the new entry as a child entry.
  (goto-char (point-min)))
;; directly copied from https://systemcrafters.net/build-a-second-brain-in-emacs/5-org-roam-hacks/
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
;; directly copied from https://ox-hugo.scripter.co/doc/org-capture-setup/
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
    (let ((grim-exit (call-process "/usr/bin/fish" nil t nil "-c" (format "grim -g \"$(slurp)\" - | swappy -f - -o %s" path))))
      (when (= grim-exit 0)
        ;; ox-hugo needs the file prefix to properly set the path for the image when exported
        (insert (format "[[file:./images/%s]]" file-name)))
      )))

;; org-roam ui
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

;; minor modes
(use-package! org-super-agenda
  :hook (org-agenda-mode . org-super-agenda-mode)
)

(use-package! org
  :mode ("\\.org\\'" . org-mode)
  :config (define-key org-mode-map (kbd "C-c C-r") verb-command-map))
  (setq verb-auto-kill-response-buffers t)

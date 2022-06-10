;; see https://github.com/sunnyhasija/Academic-Doom-Emacs-Config/blob/master/config.org
;; global variables:
(setq
 org-directory "~/notes/org/"
 org-agenda-files '("~/notes/org" "~/notes/org/journal") ; it looks for files with .org extensions
 deft-directory "~/notes"
 deft-recursive t
 )

;; org mode settings:
(after! org
  ;; (remove-hook 'org-mode-hook #'auto-fill-mode) ;; not now
  ;; (setq company-global-modes '(not org-mode)) ;; not now
  (setq
   ;; general settings
   org-tags-column -80
   org-auto-align-tags t
   org-hide-emphasis-markers t
   org-catch-invisible-edits 'show-and-error
   org-insert-heading-respect-content t
   org-pretty-entities t
   org-ellipsis "…"
   org-complete-tags-always-offer-all-agenda-tags t
   ;; TODO: some tags for later
   ;; - surprise, felt real good/flow, first timer
   ;;
   ;; org-agenda
   ;; TODO: learn how to evaluate lisp commands directly and to play with
   ;;       org-ql, having that will make configuring this much much easier
   org-agenda-current-time-string "⭠ now ─────────────────────────────────────────────────"
   org-agenda-skip-scheduled-if-done t
   org-agenda-skip-deadline-if-done t
   org-agenda-block-separator "────────────────"
   org-agenda-custom-commands
   '(("d" "the ageeenda"
      (
       ;; unscheduled shit
       (tags-todo "*" ( ; required filtering only happens to work with tags-todo currently
                       (org-agenda-overriding-header "🌀 Unscheduled(High Priority)")
                       (org-super-agenda-groups '(
                                                  (:name "tasks ⚒" :and (:scheduled nil :deadline nil :todo "TODO" :priority "A") :order 1)
                                                  (:name "waits ⏰" :and (:scheduled nil :deadline nil :todo "WAITING" :priority "A") :order 1)
                                                  (:name "consuption 🔖" :and (:scheduled nil :deadline nil :todo "TOCONSUME" :priority "A") :order 2)
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
       )))
   )
  ;; custom faces
  (custom-set-faces!
    '(org-level-1 :height 1.2 :weight extrabold :slant normal)
    '(org-level-2 :height 1.1 :weight bold :slant normal)
    '(org-level-3 :height 0.8 :weight bold :slant normal)
    '(org-document-title :height 180 :weight medium :family "Roboto")
    )

  (setq
   org-todo-keywords
   '(
     (sequence "TODO(t)" "INPROGRESS(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")
     (sequence "TOCONSUME" "CONSUMING" "|" "FINISHED" "DROPPED")
     (sequence "TOACQUIRE" "|" "ACQUIRED")
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
          ("tt" "add todo" entry (file ,(concat org-directory "personal.org")) "* TODO %?" :empty-lines 1)
          ("ts" "add todo[scheduled]" entry (file ,(concat org-directory "personal.org")) "* TODO %? \nSCHEDULED: %^T" :empty-lines 1)
          ("td" "add todo[deadline]" entry (file ,(concat org-directory "personal.org")) "* TODO %? \nDEADLINE: %^T" :empty-lines 1)
          ("tw" "add wait[deadline]" entry (file ,(concat org-directory "personal.org")) "* WAITING %? \nDEADLINE: %^T" :empty-lines 1)

          ;; buy/watch/read lists
          ;; lb: blog list; online readings, tweets, blogs etc.
          ;; lm: watch list; movie, youtube videos, documentaries etc.
          ;; lr: reading list; book/paper readings etc.
          ;; lw: buying/wanting wish list; things i want to buy/gift someday, not a shopping list.
          ;; TODO: extend with links
          ("l", "lists")
          ("lb" "add bloglist item" entry (file ,(concat org-directory "blog_list.org")) "* TOCONSUME %?" :empty-lines 1)
          ("lm" "add watchlist item" entry (file ,(concat org-directory "watch_list.org")) "* TOCONSUME %?" :empty-lines 1)
          ("lr" "add reading list item" entry (file ,(concat org-directory "reading_list.org")) "* TOCONSUME %?" :empty-lines 1)
          ("lw" "add wishlist item" entry (file ,(concat org-directory "wishlist.org")) "* TOACQUIRE %?" :empty-lines 1)

          ;; today i x
          ;; xl: today i learned
          ;; xf: today i fucked up
          ("x", "todayi")
          ;; inspiration: https://simonwillison.net/2021/May/2/one-year-of-tils/
          ("xl" "add til" entry (file ,(concat org-directory "til.org")) "* %? %^g\nCREATED: %U" :empty-lines 1)
          ("xf" "add tifu" entry (file ,(concat org-directory "list.org")) "* %?\nCREATED: %U" :empty-lines 1)

          ;; idea
          ;; il: new idea
          ;; if: some feedback/suggestion about anything
          ;; ip: some project idea
          ("i", "ideas")
          ("il" "add idea" entry (file ,(concat org-directory "ideas.org")) "* %?" :empty-lines 1)
          ("if" "add feedback/suggestion" entry (file ,(concat org-directory "suggestions.org")) "* %?" :empty-lines 1)
          ("ip" "add project idea" entry (file ,(concat org-directory "projects.org")) "* %? %^g" :empty-lines 1)

          ;; journal
          ;; jj: journal entry, custom journal entry template attempts to emulate org-journal insertion.
          ;; jm: morning journal entry
          ;; jn: night journal entry
          ;; jh: health journal entry
          ("j" "journal")
          ("jj" "add journal entry" entry (function cf/org-journal-find-location) "* %<%H:%M> %?\n%i")
          ("jm" "add morning journal entry" entry (function cf/org-journal-find-location)
"* %<%H:%M> Morning Entry
** Checklist
    - [[https://youtube.com/watch?v=GADW8Nlnc1s]]
    - [ ] Put on this week's album
    - [ ] make bed meditatively and clean (5 min)
    - [ ] Workout (5 min)
    - [ ] Yesterday's journal if not done (5 min)
    - [ ] Review whole month, and agenda TODOs (5 min)
    - [ ] Refresh phone orgzly
** Looking Forward To \n%?
** Day Plan" :empty-lines 1 :prepend t)
          ;; NOTE: night journal can probably also include accomplishments
         ("jn" "add night journal entry" entry (function cf/org-journal-find-location) "* %<%H:%M> Today's Learnings: \n%?" :empty-lines 1)
         ("jh" "add health journal entry" entry (file ,(concat org-directory "my_health.org")) "* %T %?" :empty-lines 1))
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

;; org-journal:
(setq
 org-journal-date-prefix "#+title: "
 org-journal-time-prefix "* "
 org-journal-date-format "%a, %d-%m-%y"
 org-journal-file-format "%d_%m_%Y.org" ; important to have the .org otherwise org-agenda does not pick the todos
 )


;; org-super-agenda
;;

;; custom functions
;; directly copied from jparcill/emacs_config/blob/master/config.el
;; cf: custom function
(defun cf/org-journal-find-location ()
  ;; Open today's journal, but specify a non-nil prefix argument in order to
  ;; inhibit inserting the heading; org-capture will insert the heading.
  (org-journal-new-entry t)
  ;; Position point on the journal's top-level heading so that org-capture
  ;; will add the new entry as a child entry.
  (goto-char (point-min)))

;; TODO
;; - text wrapping
;; - org fany priorities

;; minor modes
(global-org-modern-mode)
(use-package! org-super-agenda
  :hook (org-agenda-mode . org-super-agenda-mode)
)

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
   ;;
   ;; org-agenda
   org-agenda-current-time-string "⭠ now ─────────────────────────────────────────────────"
   org-agenda-skip-scheduled-if-done t
   org-agenda-skip-deadline-if-done t
   org-agenda-include-deadlines t
   org-agenda-include-diary nil
   org-agenda-block-separator nil
   org-agenda-compact-blocks t
   org-agenda-start-with-log-mode nil
   org-agenda-start-day nil
   org-super-agenda-groups
      '(
        (:name "Important tasks without a date" :date nil :priority "A")
        ;;(:name "Next Items" :tag ("tag1"))
        ;;(:name "Important" :priority "A")
        ;;(:priority<= "B" :scheduled future :order 1)
        )
   ;;org-agenda-tags-column 0
   ;;org-agenda-block-separator ?─
   ;;org-agenda-time-grid '((daily today require-timed) (800 1000 1200 1400 1600 1800 2000) " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
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
          ;; lw: buying/wanting wish list; things i want to buy/gift someday.
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


;; (let ((org-super-agenda-groups
;;        '(;; Each group has an implicit boolean OR operator between its selectors.
;;          (:name "Today"  ; Optionally specify section name
;;                 :time-grid t  ; Items that appear on the time grid
;;                 :todo "TODO")  ; Items that have this TODO keyword
;;          (:name "Important"
;;                 ;; Single arguments given alone
;;                 :tag "tag2"
;;                 :priority "C")
;;          ;; Set order of multiple groups at once
;;          (:order-multi (2 (:name "Shopping in town"
;;                                  ;; Boolean AND group matches items that match all subgroups
;;                                  :and (:tag "shopping" :tag "@town"))
;;                           (:name "Food-related"
;;                                  ;; Multiple args given in list with implicit OR
;;                                  :tag ("food" "dinner"))
;;                           (:name "Personal"
;;                                  :habit t
;;                                  :tag "personal")
;;                           (:name "Space-related (non-moon-or-planet-related)"
;;                                  ;; Regexps match case-insensitively on the entire entry
;;                                  :and (:regexp ("space" "NASA")
;;                                                ;; Boolean NOT also has implicit OR between selectors
;;                                                :not (:regexp "moon" :tag "planet")))))
;;          ;; Groups supply their own section names when none are given
;;          (:todo "WAITING" :order 8)  ; Set order of this section
;;          (:todo ("SOMEDAY" "TO-READ" "CHECK" "TO-WATCH" "WATCHING")
;;                 ;; Show this group at the end of the agenda (since it has the
;;                 ;; highest number). If you specified this group last, items
;;                 ;; with these todo keywords that e.g. have priority A would be
;;                 ;; displayed in that group instead, because items are grouped
;;                 ;; out in the order the groups are listed.
;;                 :order 9)
;;          (:priority<= "B"
;;                       ;; Show this section after "Today" and "Important", because
;;                       ;; their order is unspecified, defaulting to 0. Sections
;;                       ;; are displayed lowest-number-first.
;;                       :order 1)
;;          ;; After the last group, the agenda will display items that didn't
;;          ;; match any of these groups, with the default order position of 99
;;          )))
;;   (org-agenda nil "a"))

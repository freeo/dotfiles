;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Man must shape his tools lest they shape him.
;; — Arthur Miller

;; Remember, you do not need to run 'doom sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "freeo"
      user-mail-address "hifreeo@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;;
;; (setq doom-font (font-spec :family "Cousine Nerd Font Mono" :size

(after! so-long
  (setq so-long-threshold 10000))

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      truncate-string-ellipsis "…"                ; Unicode ellispis are nicer than "...", and also save /precious/ space
      password-cache-expiry nil                   ; I can trust my computers ... can't I?
      ;; scroll-preserve-screen-position 'always     ; Don't have `point' jump around
      scroll-margin 3)                            ; It's nice to maintain a little margin

(display-time-mode 1)                             ; Enable time in the mode-line

(global-subword-mode 1)                           ; Iterate through CamelCase words


;; OLD1
;; (use-package! mixed-pitch
;;   :hook
;;   ;; If you want it in all text modes:
;;   (text-mode . mixed-pitch-mode)
;;   ;; :config
;;   ;; (add-to-list 'mixed-pitch-fixed-pitch-faces 'whitespace-indentation)
;;   ;; (add-to-list 'mixed-pitch-fixed-pitch-faces 'whitespace-space)
;;   ;; (add-to-list 'mixed-pitch-fixed-pitch-faces 'whitespace-newline)
;;   ;; (add-to-list 'mixed-pitch-fixed-pitch-faces 'whitespace-tab)
;;   ;; (add-to-list 'mixed-pitch-fixed-pitch-faces 'whitespace-big-indent)
;;   ;; (add-to-list 'mixed-pitch-fixed-pitch-faces 'highlight-indent-guides-even-face)
;;   ;; (add-to-list 'mixed-pitch-fixed-pitch-faces 'highlight-indent-guides-odd-face)
;;   )

;; OLD2
;; (use-package! mixed-pitch
;;   :hook
;;   (text-mode . (lambda ()
;;                  ;; (unless (string-match-p "\\.log$" (buffer-file-name))
;;                  (unless (string-match-p "\\.\\(log\\|txt\\)$" (buffer-file-name))
;;                    (mixed-pitch-mode 1)))))


;; XXX observe: required this. OLD2 resulted in an error when executing a bash src block in org/babel with "ls" output (and more)
(use-package! mixed-pitch
  :hook
  (text-mode . (lambda ()
                 (when (and (buffer-file-name)
                            (not (string-match-p "\\.\\(log\\|txt\\)$" (buffer-file-name))))
                   (mixed-pitch-mode 1)))))
;; :config
;; (add-to-list 'mixed-pitch-fixed-pitch-faces 'org-block)
;; (add-to-list 'mixed-pitch-fixed-pitch-faces 'org-table)
;; (add-to-list 'mixed-pitch-fixed-pitch-faces 'org-code)
;; (add-to-list 'mixed-pitch-fixed-pitch-faces 'org-verb))

;; (set-face-attribute 'default nil :family "Iosevka")
;; (set-face-attribute 'variable-pitch nil :family "Iosevka Aile")




(setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 17 )
      ;; (setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 16 )
      ;; (setq doom-font (font-spec :family "FuraCode Nerd Font Mono" :size 16 :style "Regular" )
      ;; (setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 16 :weight 'medium )
      doom-variable-pitch-font (font-spec :family "Lexend" :size 17 :weight 'light )
      ;; doom-variable-pitch-font (font-spec :family "Noto Sans" :size 16 :weight 'light )
                                        ; doom-variable-pitch-font (font-spec :family "ReadexPro" :size 16 :weight 'light )
                                        ; doom-variable-pitch-font (font-spec :family "Noto Serif CJK SC" :size 16 )
                                        ; doom-variable-pitch-font (font-spec :family "Liberation Serif" :size 16 )
      doom-symbol-font (font-spec :family "Noto Color Emoji" :size 17)
      doom-emoji-font (font-spec :family "Noto Color Emoji" :size 17)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 20 :weight 'bold))
;; Noto Serif CJK SC Semibold :weight 'light
;; mixed-pitch-face (font-spec :family "Lexend" :size 16 :weight 'light )
;; doom-unicode-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 16)

                                        ; (use-package font-lock
                                        ;   :defer t
                                        ;   :custom-face
                                        ;   (font-lock-comment-face ((t (:inherit font-lock-comment-face :italic nil))))
                                        ;   ;; (font-lock-doc-face ((t (:inherit font-lock-doc-face :italic t))))
                                        ;   ;; (font-lock-string-face ((t (:inherit font-lock-string-face :italic t))))
                                        ;   )

;; (push "/home/freeo/.config/doom/theme-source/" custom-theme-load-path )

(set-fontset-font t 'unicode "Symbols Nerd Font Mono" nil 'append)


(setq use-default-font-for-symbols nil)

(setq-default tab-width 2)

;; (add-to-list 'mixed-pitch-fixed-pitch-faces 'whitespace)

;; init.el: indent-guides
;; (use-package indent-bars
;;   :config
;;   (require 'indent-bars-ts) 		; not needed with straight
;;   :custom
;;   ;; (indent-bars-color '(highlight :face-bg t :blend 0.5))
;;   (setq
;;    indent-bars-no-stipple-char "┃"
;;    indent-bars-pattern "."
;;    indent-bars-width-frac 0.5
;;    indent-bars-pad-frac 0.25
;;    indent-bars-color-by-depth nil
;;    indent-bars-highlight-current-depth '(:face default :blend 0.4))
;;   (indent-bars-no-descend-lists t) ; no extra bars in continued func arg lists

;;   (indent-bars-prefer-character "┃")
;;   (indent-bars-treesit-support t)
;;   (indent-bars-treesit-ignore-blank-lines-types '("module"))
;;   ;; Add other languages as needed
;;   (indent-bars-treesit-scope '((python function_definition class_definition for_statement
;; 	                        if_statement with_statement while_statement)))
;;   ;; Note: wrap may not be needed if no-descend-list is enough
;;   ;;(indent-bars-treesit-wrap '((python argument_list parameters ; for python, as an example
;;   ;;				      list list_comprehension
;;   ;;				      dictionary dictionary_comprehension
;;   ;;				      parenthesized_expression subscript)))
;;   :hook ((org-mode go-mode emacs-lisp python-base-mode yaml-mode) . indent-bars-mode)

;;   )



;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.
(setq doom-theme 'kalisi-light) ;; XXX
;; (setq doom-theme 'doom-gruvbox-light)
;; (setq doom-theme 'doom-opera-light)
;; (setq doom-theme 'doom-solarized-light) ;; underscorce in markdown cmds sometimes UNREADABLE
;; (setq doom-theme 'doom-one-light)
;; (setq doom-theme 'flatui) ;; modeline and tabline are too dominant

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type 'relative)
(setq display-line-numbers-type nil)
;; (setq global-display-line-numbers-mode nil)

;; Prevents some cases of Emacs flickering
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; disable quitting prompt y/n
(setq confirm-kill-emacs nil)

;; yasnippet
(yas-global-mode 1)




(defun global-hot-bookmark (workspace filename)
  ;; (message workspace filename)
  ;; (with-current-buffer (window-buffer)
  (+workspace/switch-to workspace)
  (run-with-timer 0 nil (lambda (filename)
                          (if (string= buffer-file-name (expand-file-name filename)) ()
                            ;; (message "not equal")
                            ;; (if (string= (frame-parameter nil 'name) == " *Minibuf-1* - Doom Emacs"))
                            (if (string= buffer-file-name nil)
                                (find-file filename)
                              (find-file-other-window filename)
                              )
                            ;; (find-file filename)
                            )
                          ) filename
                            )
  )




(map! :leader

      :desc "kill buffer" "k" #'kill-current-buffer
      :desc "zoxide travel" "z" #'zoxide-travel
      :desc "2nd Brain" "0" (cmd! (projectile-switch-project-by-name "/home/freeo/Dropbox/org-roam"))
      :desc "recently used files" "`" #'helm-recentf

      (:prefix-map ("f" . "")
       :desc "file open 2nd Brain" "f" #'vterm
       )

      (:prefix-map ("o" . "open")
       :desc "vterm at path of current file" "t" #'vterm
       :desc "vterm here current frame" "o" #'+vterm/here
       :desc "vterm toggle" "T" #'+vterm/toggle
       )
      (:prefix-map ("TAB" . "workspace")
       :desc "kill workspace, consistent binding" "k" #'+workspace/kill
       :desc "left workspace, consistent binding" "h" #'+workspace/switch-left
       :desc "right workspace, consistent binding" "l" #'+workspace/switch-right
       ;; :desc "kill workspace, consistent binding" "l" #'+workspace/load ;; default for "l"
       )
      (:prefix-map ("s" . "search")
       ;; :desc "search bmwcode" "s" (cmd! (projectile-switch-project-by-name "/home/freeo/bmwcode/"))
       :desc "search 2nd Brain" "0" (cmd! (setq projectile-switch-project-action #'+default/search-project)
                                          ;; (projectile-switch-project-by-name "/home/freeo/pcloud/org-roam")
                                          (projectile-switch-project-by-name "/home/freeo/Dropbox/org-roam")
                                          (setq projectile-switch-project-action #'projectile-find-file)
                                          )
       :desc "search current PWD" "c" #'helm-rg
       )

      (:prefix-map ("b" . "buffer")
       :desc "Harpoon add file" "h" 'harpoon-add-file
       )

      (:prefix-map ("t" . "toggles")
       ;; :desc "insert date header" "t" #'insert-current-date
       :desc "Line Numbers" "l" 'doom/toggle-line-numbers
       :desc "Org Heading" "t" 'org-toggle-heading
       :desc "Org Sidebar Tree" "r" 'org-sidebar-tree-toggle
       :desc "wrap mode" "w" '+word-wrap-mode
       )

      (:prefix-map ("r" . "Alrrrrighty Then!")
       :desc "refactor anzu" "r" 'anzu-replace-at-cursor-thing
       :desc "hot:wb_ck.org"       "`" (cmd! (global-hot-bookmark "cloudkoloss" "~/pcloud/cloudkoloss/chat"))
       :desc "hot:wb_ck.org"       "1" (cmd! (global-hot-bookmark "cloudkoloss" "~/pcloud/cloudkoloss/wb_ck.org"))
       :desc "hot:todo.org"        "2" (cmd! (global-hot-bookmark "cloudkoloss" "~/pcloud/cloudkoloss/agenda.org"))
       ;; :desc "hot:website.org"       "2" (cmd! (global-hot-bookmark "cloudkoloss" "~/pcloud/cloudkoloss/website.org"))
       ;; :desc "hot:todo.org"        "2" (cmd! (global-hot-bookmark "foam-workbench" "~/pcloud/org-roam/todo.org"))
       :desc "hot:doom config.el"  "3" (cmd! (global-hot-bookmark "dotfiles" "~/dotfiles/config/doom/config.el"))
       :desc "hot:.zshrc"          "4" (cmd! (global-hot-bookmark "dotfiles" "~/dotfiles/zshrc"))
       :desc "hot:awesome.rc"      "5" (cmd! (global-hot-bookmark "dotfiles" "~/dotfiles/config/awesome/rc.lua"))
       :desc "hot:kalisi.el"       "6" (cmd! (global-hot-bookmark "dotfiles" "~/dotfiles/config/doom/themes/kalisi-light-theme.el"))
       :desc "reload kalisi"       "k" (cmd! (kalisi-reload))
       :desc "reload kalisi"       "g" (cmd! (my-centaur-tabs-list-groups))
       )

      (:prefix-map ("p" . "project")
       ;; :desc "search bmwcode" "s" (cmd! (projectile-switch-project-by-name "/home/freeo/bmwcode/"))
       ;; :desc "2nd Brain" "0" (cmd! (projectile-switch-project-by-name "/home/freeo/pcloud/org-roam"))
       :desc "2nd Brain" "0" (cmd! (projectile-switch-project-by-name "/home/freeo/Dropbox/org-roam"))
       )


      (:prefix-map ("i" . "insert")
       ;; :desc "search bmwcode" "s" (cmd! (projectile-switch-project-by-name "/home/freeo/bmwcode/"))
       :desc "Killring" "y" (cmd! (helm-show-kill-ring))
       )

      )


;; And the vanilla commands
(map! :leader
      (:prefix-map ("j" . "harpoon")
                   "c" 'harpoon-clear
                   "f" 'harpoon-toggle-file
                   )
      "1" 'harpoon-go-to-1
      "2" 'harpoon-go-to-2
      "3" 'harpoon-go-to-3
      "4" 'harpoon-go-to-4
      "5" 'harpoon-go-to-5
      "6" 'harpoon-go-to-6
      "7" 'harpoon-go-to-7
      "8" 'harpoon-go-to-8
      "9" 'harpoon-go-to-9
      )


;; main keybindings
;; (map! :n "C-t"   #'evilnc-comment-operator)
(map! :n "C-t"   #'comment-line
      :n "C-/"   #'swiper-helm
      :n "-"   #'dired-jump
      :n "C-h" #'evil-window-left
      :n "C-j" #'evil-window-down
      :n "C-k" #'evil-window-up
      :n "C-l" #'evil-window-right
      :n "C-e" (cmd! (evil-scroll-line-down 3))
      :n "C-y" (cmd! (evil-scroll-line-up 3))
      :n "C-m" #'electric-newline-and-maybe-indent
      :n "<f1>" #'centaur-tabs-backward
      :n "<f2>" #'centaur-tabs-forward
      :n "<C-f1>" #'centaur-tabs-backward-group
      :n "<C-f2>" #'centaur-tabs-forward-group
      ;; :n "C-<" #'centaur-tabs-move-current-tab-to-left
      ;; :n "C->" #'centaur-tabs-move-current-tab-to-right
      :n "<f3>" #'+workspace/switch-left
      :n "<f4>" #'+workspace/switch-right
      ;; :n "<f3>" #'evil-prev-buffer
      ;; :n "<f4>" #'evil-next-buffer
      ;; :n "C-S-h" #'+workspace/switch-left
      ;; :n "C-S-l" #'+workspace/switch-right
      :n "C-S-t" #'+workspace/new
      :n "C-w C-q" #'evil-quit
      :n "C-;" #'helm-M-x  ;; previous mapping: embark-act
      :n "RET"   nil  ;; unbind electric-indent-mode
      :n "C-s"   #'avy-goto-char-2
      :n "C-f"   #'avy-goto-char-timer
      ;; :n "C-S-<return>"   #'new-vterm-s-split
      :n "C-S-<return>"    #'vterm
      :n "C-SPC" #'harpoon-quick-menu-hydra
      :n "C-q" #'evil-visual-block
      :n "g q" #'+format:region     ;; swap gQ with gq
      :n "g Q" #'evil-fill-and-move
      :n "g j" #'evil-next-visual-line
      :n "g k" #'evil-previous-visual-line
      :n "C-<" (cmd! (evil-window-decrease-width 10))
      :n "C->" (cmd! (evil-window-increase-width 10))
      :n "C-+" (cmd! (evil-window-increase-height 3))
      :n "C-_" (cmd! (evil-window-decrease-height 3))
      )

;; (global-set-key (kbd "M-'") (lambda () (interactive) (insert "ä")))
;; (global-set-key (kbd "M-[") (lambda () (interactive) (insert "ü")))
;; (global-set-key (kbd "M-;") (lambda () (interactive) (insert "ö")))

(map! :map markdown-mode-map
      :i "M--" (lambda () (interactive) (insert "ß")))

(map! :map evil-markdown-mode-map
      :i "M--" (lambda () (interactive) (insert "ß")))


(with-eval-after-load 'evil
  (define-key evil-insert-state-map (kbd "M--") (lambda () (interactive) (insert "ß")))
  (define-key evil-insert-state-map (kbd "M-;") (lambda () (interactive) (insert "ö")))
  (define-key evil-insert-state-map (kbd "M-:") (lambda () (interactive) (insert "Ö")))
  (define-key evil-insert-state-map (kbd "M-'") (lambda () (interactive) (insert "ä")))
  (define-key evil-insert-state-map (kbd "M-\"") (lambda () (interactive) (insert "Ä")))
  (define-key evil-insert-state-map (kbd "M-\\") (lambda () (interactive) (insert "ü")))
  (define-key evil-insert-state-map (kbd "M-[") (lambda () (interactive) (insert "ü")))
  (define-key evil-insert-state-map (kbd "M-|") (lambda () (interactive) (insert "Ü"))))



(if (eq system-type 'darwin)
    (map! :map markdown-mode-map
          :i "s--" (lambda () (interactive) (insert "ß")))
  (map! :map evil-markdown-mode-map
        :i "s--" (lambda () (interactive) (insert "ß")))

  (with-eval-after-load 'evil
    (define-key evil-insert-state-map (kbd "s--") (lambda () (interactive) (insert "ß")))
    (define-key evil-insert-state-map (kbd "s-;") (lambda () (interactive) (insert "ö")))
    (define-key evil-insert-state-map (kbd "s-:") (lambda () (interactive) (insert "Ö")))
    (define-key evil-insert-state-map (kbd "s-'") (lambda () (interactive) (insert "ä")))
    (define-key evil-insert-state-map (kbd "s-\"") (lambda () (interactive) (insert "Ä")))
    (define-key evil-insert-state-map (kbd "s-\\") (lambda () (interactive) (insert "ü")))
    (define-key evil-insert-state-map (kbd "s-[") (lambda () (interactive) (insert "ü")))
    (define-key evil-insert-state-map (kbd "s-{") (lambda () (interactive) (insert "Ü"))))
  nil)

;; Add ":" to end a sentence for jumping with literal "(" and ")" keys
(setq sentence-end-base "[.?!:…‽][]\"'”’)}»›]*")

(define-key
 evil-insert-state-map (kbd "M-d") 'evil-multiedit-toggle-marker-here)

(define-key! ranger-mode-map "C-h" 'evil-window-left)
(define-key! ranger-mode-map "C-j" 'evil-window-down)
(define-key! ranger-mode-map "C-k" 'evil-window-up)
(define-key! ranger-mode-map "C-l" 'evil-window-right)

(setq ranger-show-hidden t)
(setq ranger-hide-cursor t)

;; (define-key! image-mode-map "-" 'dired-jump)

(map! :map image-mode-map
      :n "-" #'dired-jump
      :n "C-=" #'image-increase-size
      :n "C--" #'image-decrease-size)


;; evil-markdown-mode-map <insert-state> M--
;; markdown-mode-map <emacs-state> M-SPC m i -
;; markdown-mode-map <insert-state> M-SPC m i -
;; markdown-mode-map <motion-state> SPC m i -
;; markdown-mode-map <normal-state> SPC m i -
;; markdown-mode-map <visual-state> SPC m i -

;; https://oremacs.com/2017/03/18/dired-ediff/
(defun ora-ediff-files ()
  (interactive)
  (let ((files (dired-get-marked-files))
        (wnd (current-window-configuration)))
    (if (<= (length files) 2)
        (let ((file1 (car files))
              (file2 (if (cdr files)
                         (cadr files)
                       (read-file-name
                        "file: "
                        (dired-dwim-target-directory)))))
          (if (file-newer-than-file-p file1 file2)
              (ediff-files file2 file1)
            (ediff-files file1 file2))
          (add-hook 'ediff-after-quit-hook-internal
                    (lambda ()
                      (setq ediff-after-quit-hook-internal nil)
                      (set-window-configuration wnd))))
      (error "no more than 2 files should be marked"))))

(map! :map ranger-normal-mode-map
      "e" #'ora-ediff-files)

;; drag and drop in dired, only supported in X
(setq dired-mouse-drag-files t)

;; ranger-emacs-mode-map C-SPC
;; ranger-normal-mode-map t


;; image--repeat-map -
;; image-map i -
;; image-mode-map <normal-state> -

;; TODO create github doom issue: fix update of buffer-file-name in +workspace/switch
;;
;; (defun global-hot-bookmark (workspace filename)
;;   (+workspace/switch-to workspace)
;;   ;; (message buffer-file-name (car (+workspace-buffer-list)))
;;   (message "%s %s" (car (+workspace-buffer-list)) (cdr (+workspace-buffer-list)))
;;   ;; (message "%s" (format "%s" +workspace-buffer-list))
;;   )

;; (with-current-buffer
;; (message buffer-file-name (window-buffer))
;; (message buffer-file-name)
;; (message buffer-file-name (car (+workspace-buffer-list)))
;; (message current-buffer)


;; helm-projectile-switch-project
;; projectile-switch-project-by-name

;; NOTE: Open...
;; https://github.com/doomemacs/doomemacs/issues/8288
;; (defun projectile-known-projects ()
;;   "Initialize the known projects.

;; This might potentially clean up redundant projects and discover new ones if
;; `projectile-auto-cleanup-known-projects' or `projectile-auto-discover' are
;; enabled."
;;   ;; load the known projects
;;   (unless projectile-known-projects
;;     (projectile-load-known-projects))
;;   ;; (when projectile-auto-cleanup-known-projects
;;   ;; (projectile--cleanup-known-projects))
;;   ;; (when (and projectile-auto-discover projectile-project-search-path)
;;   ;; (when projectile-project-search-path
;;   ;; (projectile-discover-projects-in-search-path))
;;   ;; return the list of known projects
;;   projectile-known-projects)

;; (setq foreground vterm-color-red)

;; evilnc-comment-operator (start end type))
;; (map! :C-t)
;; (+workspace/new &optional NAME CLONE-P)
;; (define-key! evil-normal-state-map (kbd "C-t" 'evilnc-comment-operator))

;; (defvar ranger-normal-mode-map
;; (ranger-pop-eshell &optional ARG)
;; ranger-normal-mode-map S

(global-set-key (kbd "C-S-h") #'+workspace/switch-left)
(global-set-key (kbd "C-S-l") #'+workspace/switch-right)

;; map specifically for org-mode. Tested other maps (org-mode-map) and
;; conditions (after! :after) but I didn't realize until later, that
;; evil-org-mode-map exists
;; months later: fuckin finally... after evil-org did it!
(map! :map evil-org-mode-map
      :after evil-org
      :n "C-S-h" #'+workspace/switch-left
      :n "C-S-l" #'+workspace/switch-right
      ;; :n "C-S-<return>"   #'new-vterm-s-split
      :n "C-S-<return>"   #'vterm
      )

;; XXX delete soon
;; previous map alone doesn't override the default mapping unfortunately.
;; (map! :map org-mode-map
;;       "C-S-<return>"   #'new-vterm-s-split
;;       )

;; (defun my/org-keybindings ()
;;   (map! :map evil-org-mode-map
;;         :n "C-S-h" #'+workspace/switch-left
;;         :n "C-S-l" #'+workspace/switch-right
;;         :n "C-S-<return>"   #'new-vterm-s-split
;;         )
;;   )
;; (add-hook! org :append #'my/org-keybindings)


;; (org-shiftleft &optional ARG)
;; evil-org-mode-map <insert-state> C-S-h
;; evil-org-mode-map <normal-state> C-S-h
;; org-mode-map S-<left>

;; evil-org-mode-map <insert-state> C-S-<return>
;; evil-org-mode-map <normal-state> C-S-<return>
;; org-mode-map C-S-<return>
;; org-mode-map C-S-RET

;; not working
;; (map! (:after evil-window-map
;; (map! evil-window-map
;;       :n "C-a"   #'kill-current-buffer
;;       :n "C-q"   #'evil-quit
;;       )

;; SPC SPC ;; +ivy/projectile-find-file
;; SPC /   ;; +default/search-project
;; SPC b k ;; (kill-current-buffer)
;; SPC b b ;; (+vertico/switch-workspace-buffer)
;; SPC f f ;; (+ivy/projectile-find-file)

;; free up s/S in normal mode. Remapping alone isn't enough.
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

(evil-define-command my-evil-insert-char (count char)
  (interactive "<c><C>")
  (setq count (or count 1))
  (insert (make-string count char)))

(evil-define-command my-evil-append-char (count char)
  (interactive "<c><C>")
  (setq count (or count 1))
  (when (not (eolp))
    (forward-char))
  (insert (make-string count char)))

(with-eval-after-load 'evil-maps
  (define-key evil-normal-state-map (kbd "s") 'my-evil-insert-char)
  (define-key evil-normal-state-map (kbd "S") 'my-evil-append-char))



;; HELM
;; SPC h p ;; +default/search-project BUT helm still works! doesn't really make sense...
;;
;; (setq helm-display-function #'helm-display-buffer-in-own-frame)
(helm-mode 1)
(setq completion-styles '(flex))
;; (setq helm-mode-fuzzy-match t)
(setq helm-candidate-number-limit 100)
(setq helm-grep-ag-command "rg --hidden --no-ignore --color=always --colors 'match:fg:black' --colors 'match:bg:yellow' --smart-case --no-heading --line-number %s %s %s")
(setq helm-grep-ag-pipe-cmd-switches '("--colors 'match:fg:black'" "--colors 'match:bg:yellow'"))

;; Find all references Functions used by +helm/project-search
;; (+helm-file-search
;; (setq helm-projectile-grep-command "grep -a -r %e -n%cH -e %p %f .")

;; (setq helm-recentf-fuzzy-match t)
(setq helm-completion-style '(emacs))
;; found on reddit, out of date:
;; (setq helm-buffers-fuzzy-matching t
;;     helm-recentf-fuzzy-match t
;;     helm-mini-fuzzy-match t
;;     helm-M-x-fuzzy-match t
;;     helm-etags-fuzzy-match t
;;
helm-ff-fuzzy-matching t
;;     helm-imenu-fuzzy-match t
;;     helm-locate-fuzzy-match t
;;     helm-apropos-fuzzy-match t
;;     helm-session-fuzzy-match t
;;     helm-locate-library-fuzzy-match t
;;     helm-file-cache-fuzzy-match t
;;     )
;;
;; helm-buffers-fuzzy-matching
;; helm-recentf-fuzzy-match to t.
;; helm-buffers-fuzzy-matching to t.
;; helm-locate-fuzzy-match to t.
;; helm-M-x-fuzzy-match to t.
;; helm-semantic-fuzzy-match to t.
;; helm-imenu-fuzzy-match to t.
;; helm-apropos-fuzzy-match to t.
;; helm-lisp-fuzzy-completion to t.
;; helm-session-fuzzy-match to t.
;; helm-etags-fuzzy-match to t.


(setq helm-apropos-fuzzy-match t
      helm-bookmark-show-location t
      helm-buffers-fuzzy-matching t
      helm-ff-fuzzy-matching t
      helm-file-cache-fuzzy-match t
      helm-flx-for-helm-locate t
      helm-imenu-fuzzy-match t
      helm-lisp-fuzzy-completion t
      helm-locate-fuzzy-match t
      helm-projectile-fuzzy-match t
      helm-recentf-fuzzy-match t
      helm-semantic-fuzzy-match t)


(setq evil-insert-state-cursor '(bar "#ff0000")
      evil-visual-state-cursor '(box "#0033aa")
      evil-normal-state-cursor '(box "#ff0000"))

;; (use-package vterm
;;   :config
;;   (advice-add #'vterm--redraw :after (lambda (&rest args) (evil-refresh-cursor evil-state)))
;;   )


(defun vterm-dont-ask-on-kill ()
  (make-local-variable 'kill-buffer-query-functions)
  (setq kill-buffer-query-functions nil))

(use-package vterm
  :ensure t
  :init
  :config
  ;; (advice-add #'vterm--redraw :after (lambda (&rest args) (evil-refresh-cursor evil-state)))
  (add-hook 'vterm-exit-functions
            (lambda (_ _)
              (let* ((buffer (current-buffer))
                     (window (get-buffer-window buffer)))
                (when (not (one-window-p))
                  (delete-window window))
                (kill-buffer buffer))))
  (add-hook 'vterm-mode-hook 'vterm-dont-ask-on-kill)
  )

(setq vterm-min-window-width 120)

;; (setq vterm-kill-buffer-on-exit t)

;; enable word-wrap (almost) everywhere
;; MUST be after use-package vterm! Otherwise this will cause a memory leak on startup (if vterm-module isn't
;; compiled yet) and therefore crash emx.
(+global-word-wrap-mode +1)
(setq +word-wrap-extra-indent 2)


;; (auto-save-visited-mode 1)
;; evil-normal-state-map C-t

;; How can I be so fuckin stupid
;; I need cases for actual files on disk.
;; Must avoid all special buffers:
;; vterm, SPC h r r
;; (add-hook 'evil-insert-state-exit-hook
;;           (lambda ()
;;             (call-interactively #'save-buffer)))
;;
;; Try doing it for individual modes
(defun cmd-mode-autosave-hook ()
  (add-hook 'evil-insert-state-exit-hook
            (lambda ()
              (unless (derived-mode-p 'vterm-mode)
                (call-interactively #'save-buffer)))))

(add-hook 'web-mode-hook #'cmd-mode-autosave-hook)
(add-hook 'org-mode-hook #'cmd-mode-autosave-hook)
;; (add-hook 'text-mode-hook #'org-mode)
;; (advice-add 'magit-status :before #'save-buffer)


(use-package! super-save
  :ensure t
  :config
  (super-save-mode +1))


(after! org
  (super-save-mode +1)
  ;; (setq org-image-actual-width 600) ;; BREAK: GLOBAL! Unfortunately this breaks ATTR width
  )

;; this triggers ws-butler too often (removes trailing whitespace at cursor while typing)
;; (setq super-save-auto-save-when-idle t)

(add-to-list 'super-save-triggers 'evil-window-next)
(add-to-list 'super-save-triggers 'evil-window-prev)

;; (setq super-save-auto-save-when-idle t)
;; (setq auto-save-default nil)
;; (setq auto-save-default t) ; since super-save doesnt work in org mode

(add-hook! 'focus-out-hook (save-some-buffers t))

;; automatically save buffers associated with files on buffer switch
;; and on windows switch
(defadvice switch-to-buffer (before save-buffer-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice other-window (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-up (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-down (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-left (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-right (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
;; xxx switching workspaces
;; '+workspace/switch-left
;; '+workspace/switch-right
;; both use
;; +workspace/cycle


(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(wb_bmw%d/%d) ")

(setq ivy-re-builders-alist
      '((t . ivy--regex-fuzzy)))


;; add _ to word characters, like vim
;; https://docs.doomemacs.org/latest/faq/#include-underscores-word-motions,code-1
(modify-syntax-entry ?_ "w")

(require 'powerline)
(powerline-center-evil-theme)
;; (require 'powerline-evil)
;; (require 'airline-themes)
;; (load-theme 'airline-kalisi)

;; (powerline-default-theme)

;; (require 'doom-modeline)

;; (doom-modeline-def-segment evil-state
;;   "The current evil state.  Requires `evil-mode' to be enabled."
;;   (when (bound-and-true-p evil-local-mode)
;;     (s-trim-right (evil-state-property evil-state :tag t))))

;; (doom-modeline-def-modeline main
;;                             (workspace-number window-number bar evil-state matches " " buffer-info buffer-position  " " selection-info)
;;                             (buffer-encoding major-mode vcs flycheck global))

;; (doom-modeline-def-modeline special
;;                             (window-number bar evil-state matches " " buffer-info-simple buffer-position " " selection-info)
;;                             (buffer-encoding major-mode flycheck global))

(after! projectile
  ;; alien doesn't work right now: unwanted: .gitignore'd files are unreachable using projectile-find-file
  (setq projectile-indexing-method 'alien)
  ;; (setq projectile-indexing-method 'hybrid)
  (setq projectile-enable-caching nil)
  ;; git ls-files filters out more than the .gitignore and therefore seems unreliable. More hits is fine for me
  ;; 2024-08-14: this worked until i upgraded doom. Now projectile complains about malformed .project file through fd:
  ;; [fd error]: Malformed pattern in custom ignore file. .project: No such file or directory (os error 2).
  ;; Temporarily shutting this off until this is fixed
  ;; (setq projectile-git-command "fd --type f --print0 -H -I -E '.git'")

  ;; (setq projectile-generic-command "fd --type f --print0 -H -I")
  )

;; export GOPATH="/home/freeo/go"


;; LSP
(use-package lsp-mode
  :ensure t
  ;; :custom
  ;; (lsp-diagnostics-provider :none)
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t)
  (setq lsp-diagnostics-flycheck-default-level "warning")
  )

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(custom-set-faces
 '(flycheck-warning ((t (:underline (:style wave :color "#808080"))))))


(setq fancy-splash-image
      ;; (expand-file-name "cloudkoloss-v2-black-300.png" doom-private-dir))
      (expand-file-name "CK Logo Crystal Gradient 300.png" doom-user-dir))

;; freeo_clean.png
;;
;; (setq fancy-startup-text "\nMan must shape his tools lest they shape him.\n~Arthur Miller")
;; (add-to-list '+doom-dashboard-functions '(lambda () "\nMan must shape his tools lest they shape him.\n~Arthur Miller"))

;; (defun miller ()
;;     return "\nMan must shape his tools lest they shape him.\n~Arthur Miller")

;; (setq '+doom-dashboard-functions
;;       (
;;        doom-dashboard-widget-banner
;;        miller
;;        doom-dashboard-widget-shortmenu
;;        doom-dashboard-widget-loaded
;;        ))


;; Go LSP
(require 'lsp-mode)
(add-hook 'go-mode-hook #'lsp-deferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Company mode
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)


;; Start LSP Mode and YASnippet mode
;; (add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'go-mode-hook #'yas-minor-mode)

(setq lsp-go-use-gofumpt t)

;; '((tab-mark 9 [9474 9] [92 9]))))
;; (after! whitespace
;;   (setq whitespace-style '(face tabs tab-mark spaces space-mark))
;;   ;; (setq whitespace-display-mappings
;;   ;;       '((tab-mark 9 [?\u00BB 9] [92 9])))
;;   )
;; (tab-mark     ?\t    [?» ?\t] [?\\ ?\t])	; tab - right guillemet
;;

(custom-set-faces!
  '(whitespace-tab :background "#f0a0a0" :foreground "#505050" ))


;; ("^\t*\\(\t\\)" 0 'whitespace-tab append)
;;
(defun highlight-non-indentation-tabs-go ()
  (interactive)
  (font-lock-add-keywords
   nil
   '(
     ;; best, but still bad.
     ("^\t*.*?\\(\t\\)" 1 'whitespace-tab append)

     ;; ("^\w\|[[:punct:]]\\(\t\\)" 1 'whitespace-tab nil)
     ;; ("^\t*[^\n\t]*\\(\t\\)" 1 'whitespace-tab nil)
     ;; ("^\t*?\w*?\\(\t*\\)" 1 'whitespace-tab nil)
     ;; ("\\(\\w\\)\\(\t\\)" 0 'whitespace-tab append)
     ;; ("^\t*\\(\w\\)" 0 'whitespace-tab append)
     )))
;; XXX off for now... just use manual search for \t
;; (add-hook 'go-mode-hook #'highlight-non-indentation-tabs-go)

;; (defun highlight-non-indentation-tabs ()
;;   (font-lock-add-keywords
;;    nil
;;    '(("^\t*\\(\t\\)" 1 'whitespace-tab append)
;;      ("[^\n\t]\\(\t\\)" 1 'whitespace-tab append))))
;; (add-hook 'go-mode-hook #'highlight-non-indentation-tabs-go)

;; Global Mode works, but overrides highlight-indent-guides
;; use this only when necessary!
;; (use-package! whitespace
;;   :config
;;   (setq whitespace-style '(face trailing tabs tab-mark trailing newline newline-mark))
;;   (setq whitespace-display-mappings
;;         '((tab-mark ?\t [?» ?\t] [?\\ ?\t])  ; Display tabs as » followed by a tab space
;;           ))
;;   (global-whitespace-mode +1))

(defun my-setup-dap-node ()
  "Require dap-node feature and run dap-node-setup if VSCode module isn't already installed"
  (require 'dap-node)
  (unless (file-exists-p dap-node-debug-path) (dap-node-setup)))

;; (add-hook 'typescript-mode-hook 'my-setup-dap-node)
;; (add-hook 'javascript-mode-hook 'my-setup-dap-node)

;; (use-package dap-mode
;;   ;; Uncomment the config below if you want all UI panes to be hidden by default!
;;   ;; :custom
;;   ;; (lsp-enable-dap-auto-configure nil)
;;   ;; :config
;;   ;; (dap-ui-mode 1)

;;   :config
;;   ;; Set up Node debugging
;;   (require 'dap-node)
;;   (dap-node-setup) ;; Automatically installs Node debug adapter if needed
;;   ;; (dap-chrome-setup) ;; Automatically installs Node debug adapter if needed
;;   )

;; Go DAP (Debugger)
;; (dap-mode 1)
;; (require 'dap-chrome)
;; (require 'dap-firefox)
;; (require 'dap-node)

;; (dap-go-setup)
;; (require 'dap-go)
(require 'dap-dlv-go)
;;
;; (after! flycheck
;;   (setq-default flycheck-disabled-checkers '(go-gofmt go-golint))
;;   (flycheck-add-next-checker 'go-build '(warning . golangci-lint))
;;   (flycheck-add-next-checker 'go-test '(warning . golangci-lint)))

;; (dap-register-debug-template
;;  "Go Debug"
;;  (list :type "go"
;;        :request "launch"
;;        :name "Debug Go Program"
;;        :mode "auto"
;;        :program "${workspaceFolder}/main.go"
;;        :args []
;;        :env nil
;;        :envFile nil))

(map! :map dap-mode-map
      :leader
      :prefix ("d" . "dap")
      ;; basics
      :desc "dap next"          "n" #'dap-next
      :desc "dap step in"       "i" #'dap-step-in
      :desc "dap step out"      "o" #'dap-step-out
      :desc "dap continue"      "c" #'dap-continue
      :desc "dap hydra"         "h" #'dap-hydra
      :desc "dap debug restart" "r" #'dap-debug-restart
      :desc "dap debug"         "s" #'dap-debug

      ;; debug
      :prefix ("dd" . "Debug")
      :desc "dap debug recent"  "r" #'dap-debug-recent
      :desc "dap debug last"    "l" #'dap-debug-last

      ;; eval
      :prefix ("de" . "Eval")
      :desc "eval"                "e" #'dap-eval
      :desc "eval region"         "r" #'dap-eval-region
      :desc "eval thing at point" "s" #'dap-eval-thing-at-point
      :desc "add expression"      "a" #'dap-ui-expressions-add
      :desc "remove expression"   "d" #'dap-ui-expressions-remove

      :prefix ("db" . "Breakpoint")
      :desc "dap breakpoint toggle"      "b" #'dap-breakpoint-toggle
      :desc "dap breakpoint condition"   "c" #'dap-breakpoint-condition
      :desc "dap breakpoint hit count"   "h" #'dap-breakpoint-hit-condition
      :desc "dap breakpoint log message" "l" #'dap-breakpoint-log-message)


(use-package! flycheck-golangci-lint
  :after flycheck)
;; :config
;; (setq flycheck-golangci-lint-config "~/.golangci.yml")) ; Path to your golangci-lint config

(after! flycheck
  (setq-default flycheck-disabled-checkers '(go-gofmt go-golint))
  (flycheck-add-next-checker 'go-build '(warning . golangci-lint) t)
  (flycheck-add-next-checker 'go-test '(warning . golangci-lint)) t)

;; Promising! Improve.
(with-eval-after-load 'go-mode
  (defun go-gotestfmt ()
    (interactive)
    (compile (concat "cd " default-directory "; grc gotestsum --format-icons=hivis --format=testdox"))
    ;; (defun go-gotestfmt (args)
    ;; (let ((cmd (concat "go test -test.v -json " args " | grc gotestfmt")))
    ;; (setq +go-test-last (concat "cd " default-directory ";" cmd))
    ;; (+go--spawn cmd)))
    ))

;;; jsonnet-language-server -- Summary
;; Development lsp registration for Emacs lsp-mode.
;;; Commentary:
;;; Code:
(require 'jsonnet-mode)
(require 'lsp-mode)

(defcustom lsp-jsonnet-executable "jsonnet-language-server"
  "Command to start the Jsonnet language server."
  :group 'lsp-jsonnet
  :risky t
  :type 'file)

;; Configure lsp-mode language identifiers.
;; If you use jsonnet-mode, you only need the first configuration.
;; If not, you probably need both the file regexps.
(add-to-list 'lsp-language-id-configuration '(jsonnet-mode . "jsonnet"))

;; Register jsonnet-language-server with the LSP client.
(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection (lambda () lsp-jsonnet-executable))
  :activation-fn (lsp-activate-on "jsonnet")
  :server-id 'jsonnet))

;; Start the language server whenever jsonnet-mode is used.
(add-hook 'jsonnet-mode-hook #'lsp-deferred)

(provide 'jsonnet-language-server)
;;; jsonnet-language-server.el ends here


(use-package k8s-mode
  ;; :ensure t
  :hook (k8s-mode . yas-minor-mode))

;; Set indent offset
(setq k8s-indent-offset nil)
;; The site docs URL
(setq k8s-site-docs-url "https://kubernetes.io/docs/reference/kubernetes-api/")
;; The defautl API version
(setq k8s-site-docs-version "v1.3")
;; The browser funtion to browse the docs site. Default is `browse-url-browser-function`
;; (setq k8s-search-documentation-browser-function nil)
                                        ; Should be a X11 browser
(setq k8s-search-documentation-browser-function (quote browse-url-firefox))


                                        ; Lua LSP
                                        ;
;; (add-hook 'lua-mode-hook #'lsp) ; old
(add-hook 'lua-local-vars-hook #'lsp!) ; from newest doom docshares

;; moved to yasnippets (in org-mode folder)
;; (defun insert-current-date () (interactive)
;;        (setq today (shell-command-to-string "echo -n $(date '+%m%d %A')"))
;;        (insert (format "* %-15s *** *** *** *** *** ***" today)))

;; (format "%-8s #############" "Wednesday")

                                        ; magit ediff default instead of underneath diff
;; (setq magit-ediff-dwim-show-on-hunks t)

;; https://www.dschapman.com/notes/33f4867d-dbe9-4c4d-8b0a-d28ad6376128


;; (centaur-tabs-enable-buffer-reordering)
;; (setq centaur-tabs-adjust-buffer-order t)
;; (setq centaur-tabs-adjust-buffer-order 'right)
(setq centaur-tabs-height 20)
;; (setq centaur-tabs-style "chamfer")
;; (setq centaur-tabs-style "rounded")
(setq centaur-tabs-style "bar")
;; (setq centaur-tabs-set-bar 'over)
;; (setq x-underline-at-descent-line t) ;; recommended fix for non-spacemacs
(setq centaur-tabs-set-close-button nil)
(setq centaur-tabs-show-new-tab-button nil)
;; centaur-tabs-active-bar-face



;; DONE: chat and wb_ck.org not switchable via F1/F2
;; continue testing
(after! centaur-tabs
  (centaur-tabs-mode t)
  (setq centaur-tabs-set-bar 'over
        centaur-tabs-set-icons t
        centaur-tabs-gray-out-icons 'buffer
        centaur-tabs-height 24
        centaur-tabs-set-modified-marker t
        centaur-tabs-modified-marker "●" ;; nice!
        ;; centaur-tabs-buffer-groups-function #'centaur-tabs-projectile-buffer-groups)
        )

  (defun centaur-tabs-buffer-groups ()
    "`centaur-tabs-buffer-groups' control buffers' group rules.

Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
All buffer name start with * will group to \"Emacs\".
Other buffer group by `centaur-tabs-get-group-name' with project name."
    (list
     (cond
      ((or (string-equal "*" (substring (buffer-name) 0 1))
           (memq major-mode '(magit-process-mode
                              magit-status-mode
                              magit-diff-mode
                              magit-log-mode
                              magit-file-mode
                              magit-blob-mode
                              magit-blame-mode
                              )))
       "Emacs")
      ;; ((derived-mode-p 'prog-mode)
      ;;  "Editing")
      ((derived-mode-p 'dired-mode)
       "Dired")
      ((memq major-mode '(helpful-mode
                          help-mode))
       "Help")
      ;; ((memq major-mode '(org-mode
      ;;                     org-agenda-clockreport-mode
      ;;                     org-src-mode
      ;;                     org-agenda-mode
      ;;                     org-beamer-mode
      ;;                     org-indent-mode
      ;;                     org-bullets-mode
      ;;                     org-cdlatex-mode
      ;;                     org-agenda-log-mode
      ;;                     diary-mode))
      ;;  "OrgMode")
      (t
       (centaur-tabs-get-group-name (current-buffer))))))

  )

(defun my-centaur-tabs-list-groups ()
  "List and switch to centaur-tabs buffer groups using completing-read."
  (interactive)
  (let* ((groups (centaur-tabs-get-groups))
         (selected-group (completing-read "Select group: " groups nil t)))
    (centaur-tabs-switch-group selected-group)))


(setq avy-all-windows t)


(defun new-vterm-s-split ()
  "Opens a vterm instance in a horizontal split"
  (interactive)
  (evil-window-split) (evil-window-down 1) (+vterm/here nil))

;; (use-package impatient-showdown
;; :hook (markdown-mode . impatient-showdown-mode))

(defcustom impatient-showdown-markdown-background-color "#fafafa"
  "For display markdown background color."
  :type 'string
  :group 'impatient-showdown)

;; (custom-set-variables
;;  '(livedown-autostart nil) ; automatically open preview when opening markdown files
;;  '(livedown-open t)        ; automatically open the browser window
;;  '(livedown-port 2001)     ; port for livedown server
;;  '(livedown-browser nil))  ; browser to use

(setq tramp-terminal-type "tramp")

(defun sshx-freeo-mba ()
  (interactive)
  (find-file "/sshx:freeo@freeo-mba:/Users/freeo/"))

(defun sshx-freeo-pop-os ()
  (interactive)
  (find-file "/sshx:freeo@pop-os.local:/home/freeo/"))

(defun kalisi-reload ()
  (interactive)
  (load-theme 'kalisi-light))

(use-package! kubernetes
  :commands (kubernetes-overview)
  :config
  (setq kubernetes-poll-frequency 3600
        kubernetes-redraw-frequency 3600))

(use-package! kubernetes-evil
  :after kubernetes)


;; (use-package typescript-mode
;;   :mode "\\.ts\\'"
;;   :hook (typescript-mode . lsp-deferred)
;;   :config
;;   (require 'dap-node)
;;   (dap-node-setup))

(use-package typescript-mode
  :defer t
  :hook (typescript-mode . (lambda () (setq-local fill-column 120)))
  ;; (typescript-ts-mode)))
  :custom
  (lsp-clients-typescript-server-args '("--stdio"))
  :config
  (setq typescript-indent-level 2)
  ;; (add-to-list 'auto-mode-alist '("\.ts\'" . typescript-mode))
  )

;; increase width, so that breakpoints are clearly visible/clickable
(after! git-gutter-fringe
  (fringe-mode '12))
;; for the future: entrypoint for increasing git fringe bitmaps:
;; https://github.com/hlissner/doom-emacs/issues/2246

;; In case I run into issues mentioned in this cfg snippet, here's the root url.
;; Not using this cfg as is, because it throws errors
;; https://github.dev/shouya/emacs.d
;;
;; (use-package apheleia
;;   :ensure t
;;   :config
;;   ;; (add-to-list 'apheleia-formatters '(prettier . (npx "prettier" "--stdin-filepath" filepath "--use-tabs false" "--tab-width 8" )))

;;   ;; (prettier "prettier" "--stdin-filepath" filepath "--use-tabs" "false" "--tab-width" "8")
;;   ;; (prettier-css npx "prettier" "--stdin-filepath" filepath "--parser=css")

;;   ;; (prettier npx "/home/freeo/pcloud/cksk/node_modules/.bin/prettier" "--stdin-filepath" filepath)
;;   ;; "--use-tabs" "false" "--tab-width" "8"

;;   ;; (setf (alist-get 'ocamlformat apheleia-formatters)
;;   ;;       '("opam" "exec" "--" "ocamlformat" "--impl" "-"))
;;   ;; (setf (alist-get 'prettier apheleia-formatters)
;;   ;;       '(npx "/home/freeo/pcloud/cksk/node_modules/.bin/prettier" "--stdin-filepath" filepath ))

;;   ;; sometimes apheleia erase the whole buffer, which is pretty annoying.
;;   ;; fix it by detecting this scenario and simply doing no-op
;;   (defun shou/fix-apheleia-accidental-deletion
;;       (orig-fn old-buffer new-buffer callback)
;;     (if (and (=  0 (buffer-size new-buffer))
;;              (/= 0 (buffer-size old-buffer)))
;;         ;; do not override anything
;;         nil
;;       (funcall orig-fn old-buffer new-buffer callback)))

;;   (advice-add 'apheleia--create-rcs-patch :around #'shou/fix-apheleia-accidental-deletion)

;;   ;; used in hooks to turn off apheleia mode for some modes
;;   (defun shou/disable-apheleia-mode nil (apheleia-mode -1))

;;   (apheleia-global-mode 1)
;;   )
;;
;;

(use-package apheleia
  :config

  ;; good example how to replace values in an alist - this seems to be a common config pattern
  (setf (alist-get 'prettier apheleia-formatters)
        ;; '(npx "prettier" "--use-tabs" "true" "--write" filepath ))
        '(npx "prettier" "--use-tabs" "true" "--stdin-filepath" filepath ))

  (setf (alist-get 'markdown-mode apheleia-mode-alist)
        'prettier-markdown)

  ;; used in hooks to turn off apheleia mode for some modes
  (defun shou/disable-apheleia-mode nil (apheleia-mode -1))

  (apheleia-global-mode 1)
  )

;; (setf (alist-get 'prettier apheleia-formatters)
;; '("prettier" "--stdin-filepath" "--stdin-filepath" "--use-tabs false" "--tab-width 8"))

;; Autoformatting async after save
;; https://github.com/radian-software/apheleia
;; (apheleia-global-mode +1)



;; (prettier-html npx "prettier" "--stdin-filepath" filepath "--parser=html")
;; (prettier . (npx "prettier" "--stdin-filepath" filepath))

(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
;; careful: enforces 4 spaces! bites itself a little with my default: tab-width 2
(add-hook 'json-mode-hook #'aggressive-indent-mode)

(add-hook 'yas-minor-mode-hook
          (lambda()
            (yas-activate-extra-mode 'fundamental-mode)))

;; https://github.com/mikefarah/yq
;; arch: go-yq NOT yq!
;; NOT https://github.com/kislyuk/yq
(defun json2yaml ()
  (interactive)
  (shell-command
   (concat "yq -P -i " buffer-file-name)))

(defun yaml2json ()
  (interactive)
  (shell-command
   (concat "yq -o=json -i " buffer-file-name)))

(defun yaml2json-region (start end)
  "Convert selected YAML region to JSON using yq."
  (interactive "r")
  (let ((temp-file (make-temp-file "yaml2json-")))
    (write-region start end temp-file)
    (shell-command-on-region
     start end
     (format "yq -o=json %s" temp-file)
     t t "*yaml2json-error*" t)
    (delete-file temp-file)))

(defun json2yaml-region (start end)
  "Convert selected JSON region to YAML using yq."
  (interactive "r")
  (let ((temp-file (make-temp-file "yaml2json-")))
    (write-region start end temp-file)
    (shell-command-on-region
     start end
     (format "yq -p json -o yaml %s" temp-file)
     t t "*yaml2json-error*" t)
    (delete-file temp-file)))

;; (setq lsp-headerline-breadcrumb-mode t)
;; (setq lsp-headerline-breadcrumb-segments '(project file symbols))

(after! lsp-mode
  (setq lsp-headerline-breadcrumb-enable t)
  (setq lsp-headerline-breadcrumb-segments '(project file symbols))
  (setq lsp-headerline-breadcrumb-icons-enable t))

;; Enable LSP for YAML files
(after! lsp-yaml
  (add-hook 'yaml-mode-hook #'lsp!))



;; https://github.com/TommyX12/company-tabnine
(use-package company-tabnine :ensure t)
(add-to-list 'company-backends #'company-tabnine)
;; Trigger completion immediately.
(setq company-idle-delay 0)
;; Number the candidates (use M-1, M-2 etc to select completions).
(setq company-show-numbers t)

(setq company-global-modes '(not org-mode))

(global-org-modern-mode)
;; officailly recommended font, used for bullet points, checkboxes etc.
;; Fixes org bullets issue: displaying utf placeholder
;; must be set after org-modern-mode
(set-face-attribute 'org-modern-symbol nil :family "Iosevka")
;; (set-face-attribute 'org-quote nil :family "Lexend" :weight 'light :slant 'oblique :foreground "#08298c" :background "#e0e0e0")


(setq org-hide-emphasis-markers t)

;; UPDATE: breaking change in doom
;; https://github.com/doomemacs/doomemacs/commit/0d9e188b26ca1d01a57598e37171e5333272cad7
;; (add-hook 'org-mode-hook 'highlight-indent-guides-mode) ;; somehow this doesn't exist anymore?!
;; until emacs 30, I install the package manually in packages.el instead of init.el 'indent-guides', which now uses 'indent-bars' by default
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'fill)
(setq highlight-indent-guides-auto-enabled nil)

;; (add-hook! 'org-mode-hook (lambda () (setq highlight-indent-guides-mode t)))
;; (setq highlight-indent-guides-method 'column) ;; quite nice, but fill is fuller
;; (setq highlight-indent-guides-method 'bitmap) ;; 3rd place
;; (setq highlight-indent-guides-method 'character) ;; default, bad influence on wrapped lines, also has gaps since it's not using full height


;; (use-package! highlight-indent-guides
;;   :hook (org-mode . highlight-indent-guides-mode)
;;   :config
;;   (setq highlight-indent-guides-auto-enabled nil)
;;   (setq highlight-indent-guides-method 'fill))


(add-hook 'org-mode-hook 'org-appear-mode)
(setq org-appear-autolinks t)
(setq org-appear-autolinks t)
(setq org-appear-autoentities t)


;; disable auto completion (company) in org-mode
(setq company-global-modes '(not org-mode))



(defface org-bold
  '((t :weight medium
     ))
  "Face for org-mode bold."
  :group 'org-faces )

(defface org-highlight-1
  '((t
     :foreground "#8700af"
     ))
  "Face for org-mode bold."
  :group 'org-faces )


(defface org-highlight-2
  '((t
     :foreground "#66b600"
     ))
  "Face for org-mode bold."
  :group 'org-faces )

(setq org-emphasis-alist
      '(("*" org-bold)
        ("/" italic)
        ("_" underline)
        ("=" org-verbatim verbatim)
        ("~" org-code verbatim)
        ("&" org-highlight-1)
        ("$" org-highlight-2)
        ("+" (:strike-through t))))

;; This is an internal variable and actually shouldn't be used:
;; org-font-lock-extra-keywords
;; But especially for :tag: this is required, because the regular approach of font-lock-add-keywords doesn't work here. Probably because of the other regex overlays. Didn't investigate.
;; Also required for the invisible chars
;; bug: if I keep just the :tag: line, this kills :emoji:. If all 3 lines are active: it's just fine!

(defun org-add-my-extra-fonts ()
  "Add alert and overdue fonts."
  (add-to-list 'org-font-lock-extra-keywords '("\\(\\$\\)\\([^\n\r\t]+\\)\\(\\$\\)" (1 '(face org-highlight-1 invisible t)) (2 'org-highlight-1 t) (3 '(face org-highlight-1 invisible t))) t)
  (add-to-list 'org-font-lock-extra-keywords '("\\(&\\)\\([^\n\r\t]+\\)\\(&\\)" (1 '(face org-highlight-2 invisible t)) (2 'org-highlight-2 t) (3 '(face org-highlight-2 invisible t))) t)
  (add-to-list 'org-font-lock-extra-keywords '("[[:blank:]]\\(:\\)\\([^\n\r\t]+\\)\\(:\\)" (1 '(face org-highlight-2 invisible t)) (2 'org-modern-tag t) (3 '(face org-highlight-2 invisible t))) t)
  )

(add-hook 'org-font-lock-set-keywords-hook #'org-add-my-extra-fonts)

(font-lock-add-keywords 'org-mode
                        '(("\\(\\[[^\n\r\t]+?\\]\\)" 1 font-lock-comment-face prepend)) 'append)
(font-lock-add-keywords 'org-mode
                        '(("\\([[:blank:]]#[[:blank:]].+$\\)" 1 font-lock-comment-face prepend)) 'append)

;; magit diff
(add-hook 'magit-mode-hook (lambda () (magit-delta-mode +1)))

;; magit character wise diff on all visible hunks, careful: performance impact
;; WIP: ugly but works, requires better highlighting groups
;; (after! magit
;; (setq magit-diff-refine-hunk 'all))

;; tested: not invisible: %
;; (font-lock-add-keywords 'org-mode
;; '("\\(%\\)\\([^\n\r\t]+\\)\\(%\\)" (1 '(face org-highlight-2 invisible t)) (2 'org-highlight-2 t) (3 '(face org-highlight-2 invisible t))) t)
;; (add-to-list 'org-font-lock-extra-keywords '("\\(\\$\\)\\([^\n\r\t]+\\)\\(\\$\\)" (1 '(face org-highlight-1 invisible t)) (2 'org-highlight-1 t) (3 '(face org-highlight-1 invisible t))) t)




;; auto-dark: takes care of dbus messages. No further config necessary!
;; XXX: auto-dark issue: On startup emacs only renders updates when entering the command line mode, e.g. ":". Otherwise it's doesn't render, only a white screen. It keeps asking, if kalisi-....el should be loaded, so there's an obvious problem.
;; required to fix the issue, but has a security concern
;; known issue https://github.com/LionyxML/auto-dark-emacs/issues/64 OPEN
(after! doom-ui
  :config
  (setq custom-safe-themes t) ; temporary workaround
  (setq! auto-dark-themes '((doom-ayu-mirage) (kalisi-light)))
  (auto-dark-mode))


;; dbus code was archived to old-code.el in this file

                                        ; this macro was copied from here: https://stackoverflow.com/a/22418983/4921402
(defmacro define-and-bind-quoted-text-object (name key start-regex end-regex)
  (let ((inner-name (make-symbol (concat "evil-inner-" name)))
        (outer-name (make-symbol (concat "evil-a-" name))))
    `(progn
       (evil-define-text-object ,inner-name (count &optional beg end type)
         (evil-select-paren ,start-regex ,end-regex beg end type count nil))
       (evil-define-text-object ,outer-name (count &optional beg end type)
         (evil-select-paren ,start-regex ,end-regex beg end type count t))
       (define-key evil-inner-text-objects-map ,key #',inner-name)
       (define-key evil-outer-text-objects-map ,key #',outer-name))))

(define-and-bind-quoted-text-object "pipe" "|" "|" "|")
(define-and-bind-quoted-text-object "slash" "/" "/" "/")
(define-and-bind-quoted-text-object "asterisk" "*" "*" "*")
(define-and-bind-quoted-text-object "dollar" "$" "\\$" "\\$") ;; sometimes your have to escape the regex

;; (defun org-sidebar-evil-bindings ()
;;   (define-key! evil-normal-state-local-map
;;     "RET" #'org-sidebar-tree-jump
;;     "<return>" #'org-sidebar-tree-jump))
;; (add-hook 'org-sidebar-window-after-display-hook #'org-sidebar-evil-bindings)

(after! org-sidebar
  (evil-set-initial-state 'org-sidebar-mode 'emacs))

(setq org-sidebar-tree-jump-fn 'org-sidebar-tree-jump-source)

(setq ispell-dictionary "de_DE")

(after! org
  (setq org-agenda-files
        '("~/pcloud/cloudkoloss/agenda.org"))

  (setq org-todo-keywords
        '((sequence "TODO(t)" "BLOCKED(b)" "PROJ(p)" "LOOP(l)" "START(s)" "WIP(w)" "HOLD(h)" "|" "DONE(d)" "KILL(k)" "WONTDO(W)" "DECIDE(D)")
          (sequence "[ ](T)" "[-](S)" "[?](q)" "|" "[X](X)")
          (sequence "REALIZATION(r)" "IDEA(i)")
          (sequence "|" "OKAY(o)" "YES(y)" "NO(n)")))

  (setq org-modern-todo-faces
        '(("PROJ" . (:background "blue" :foreground "white" :weight bold))
          ;; ("TODO" . (:background "black" :foreground "white" :weight bold))
          ("WIP" . (:background "orange" :foreground "white" :weight bold))
          ("WONTDO" . (:background "gray" :foreground "white" :weight bold))
          ("BLOCKED" . (:background "red" :foreground "black" :weight bold))))
  (set-face-attribute 'org-quote nil :family "Lexend" :weight 'light :inherit 'org-block :foreground "#08298c" :background "#eeeeee")
  )
;; ("CANCELLED" . (:background "gray" :foreground "white" :weight bold))


(setq org-highest-priority ?A
      org-default-priority ?B
      org-lowest-priority ?E)

;; (use-package org-fancy-priorities
;;   :ensure t
;;   :hook
;;   (org-mode . org-fancy-priorities-mode)
;;   :config
;;   (setq org-priority-faces
;;         '((?A :background "#ffffff" :weight bold)
;;           (?B :background "#ffffff" :weight bold)
;;           (?C :background "#ffffff" :weight bold)
;;           (?D :background "#ffffff" :weight bold)
;;           (?E :background "#ffffff" :weight bold)))
;;   (setq org-fancy-priorities-list '((?A . "🚨️")
;;                                     (?B . "🟥️️")
;;                                     (?C . "⚠️")
;;                                     (?D . "☕")
;;                                     (?E . "💤"))))
;;

(setq org-modern-priority '((?A . "🚨️")
                            (?B . "🟥️️")
                            (?C . "⚠️")
                            (?D . "☕")
                            (?E . "💤")))


;; (set-file-template! "\\.svx$" :trigger "__" :mode 'web-mode)

(require 'web-mode)
;; (add-to-list 'auto-mode-alist '("\\.svx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.svx\\'" . markdown-mode))
(add-to-list 'lsp-language-id-configuration '("\\.svx$" . "markdown"))

(add-hook 'web-mode-hook #'lsp-deferred)

;; svelte support
(add-to-list 'auto-mode-alist '("\\.svelte\\'" . web-mode))
(setq web-mode-engines-alist
      '(("svelte" . "\\.svelte\\'")))

;; inspect if running with with M-x lsp-describe-session
(use-package! lsp-tailwindcss
  :init
  ;; enable add-on mode, so that multiple LSP servers can be started (svelte+tailwind)
  (setq lsp-tailwindcss-add-on-mode t))


;; LSP Workaround: Bug in Emacs 28 (fixed in 29)
;; https://github.com/emacs-lsp/lsp-mode/issues/2681
;;
;; https://github.com/typescript-language-server/typescript-language-server/issues/559#issuecomment-1259470791
;; same definition as mentioned earlier
(advice-add 'json-parse-string :around
            (lambda (orig string &rest rest)
              (apply orig (s-replace "\\u0000" "" string)
                     rest)))

;; minor changes: saves excursion and uses search-forward instead of re-search-forward
(advice-add 'json-parse-buffer :around
            (lambda (oldfn &rest args)
	      (save-excursion
                (while (search-forward "\\u0000" nil t)
                  (replace-match "" nil t)))
	      (apply oldfn args)))

(require 'org-download)
;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

(defun dired-do-rename-suggest (&optional arg)
  "Rename current file or all marked files, suggesting the current name.
Places the cursor on the dot before the file extension in the minibuffer."
  (interactive "P")
  (let* ((files (dired-get-marked-files nil arg))
         (len (length files))
         (file (car files))
         (name (file-name-nondirectory file))
         (dir (file-name-directory file))
         (ext-pos (or (string-match-p "\\.[^.]*\\'" name) (length name))))
    (if (> len 1)
        (dired-do-rename arg)
      (let* ((initial-input (cons name (max 0 (1+ ext-pos))))
             (new-name (read-string "Rename to: " initial-input)))
        (dired-rename-file file (expand-file-name new-name dir) nil)
        (revert-buffer)
        (dired-goto-file (expand-file-name new-name dir))))))

(after! dired
  (evil-define-key '(normal visual) dired-mode-map
    "R" 'dired-do-rename-suggest))


;; YOU DON'T NEED NONE OF THIS CODE FOR SIMPLE INSTALL
;; IT IS AN EXAMPLE OF CUSTOMIZATION.
;; (use-package ellama
;;   :init
;;   ;; setup key bindings
;;   (setopt ellama-keymap-prefix "C-'")
;;   ;; language you want ellama to translate to
;;   ;; (setopt ellama-language "German")
;;   ;; could be llm-openai for example
;;   (require 'llm-ollama)
;;   (setopt ellama-provider
;; 	  (make-llm-ollama
;; 	   ;; this model should be pulled to use it
;; 	   ;; value should be the same as you print in terminal during pull
;; 	   :chat-model "llama3:8b-instruct-q8_0"
;; 	   ;; :chat-model "codestral"
;; 	   ))
;;   )
;;
;; :embedding-model "nomic-embed-text"
;; :default-chat-non-standard-params '(("num_ctx" . 8192))))
;; Predefined llm providers for interactive switching.
;; You shouldn't add ollama providers here - it can be selected interactively
;; without it. It is just example.
;; (setopt ellama-providers
;;         '(("llama3" . (make-llm-ollama
;;       		 :chat-model "llama3:7b-instruct-v0.2-q6_K"
;;       		 :embedding-model "mistral:7b-instruct-v0.2-q6_K"))
;;           ("zephyr" . (make-llm-ollama
;;       		 :chat-model "zephyr:7b-beta-q6_K"
;;       		 :embedding-model "zephyr:7b-beta-q6_K"))
;;           ("mistral" . (make-llm-ollama
;;       		  :chat-model "mistral:7b-instruct-v0.2-q6_K"
;;       		  :embedding-model "mistral:7b-instruct-v0.2-q6_K"))
;;           ("codestral" . (make-llm-ollama
;;       		    :chat-model "mistral:7b-instruct-v0.2-q6_K"
;;       		    :embedding-model "mistral:7b-instruct-v0.2-q6_K"))
;;           ("dolphin" . (make-llm-ollama
;;       		  :chat-model "mistral:7b-instruct-v0.2-q6_K"
;;       		  :embedding-model "mistral:7b-instruct-v0.2-q6_K"))
;;           ("mixtral" . (make-llm-ollama
;;       		  :chat-model "mixtral:8x7b-instruct-v0.1-q3_K_M-4k"
;;       		  :embedding-model "mixtral:8x7b-instruct-v0.1-q3_K_M-4k"))))
;; Naming new sessions with llm
;; (setopt ellama-naming-provider
;;         (make-llm-ollama
;;          :chat-model "llama3:8b-instruct-q8_0"
;;          :embedding-model "nomic-embed-text"
;;          :default-chat-non-standard-params '(("stop" . ("\n")))))
;; (setopt ellama-naming-scheme 'ellama-generate-name-by-llm)
;; ;; Translation llm provider
;; (setopt ellama-translation-provider (make-llm-ollama
;;       			       :chat-model "phi3:14b-medium-128k-instruct-q6_K"
;;       			       :embedding-model "nomic-embed-text")))
;;

(use-package! gptel
  :config
  (setq
   ;; gptel-model "codestral:latest"
   gptel-model "gemma3:12b"
   gptel-backend (gptel-make-ollama "Ollama"
                   :host "localhost:11434"
                   :stream t
                   :models '("gemma3:12b")))

  )

(add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
(add-hook 'gptel-post-response-functions 'gptel-end-of-response)


;; (add-hook 'yaml-mode-hook #'mixed-pitch-mode-off)
(add-hook 'yaml-mode-hook
          (lambda ()
            (mixed-pitch-mode 0)))

(use-package docker
  :ensure t
  :bind ("C-c d" . docker)
  :config
  (setq docker-command "podman"))

(require 'string-inflection)

;; YAML-PRO
;;
;; requirements: install this fork of tree-sitter-yaml:
;;
;; z wb
;; git clone --depth 1 https://github.com/tree-sitter-grammars/tree-sitter-yaml
;; make
;; sudo make install
;;
;; this copies the *.so file (and symlinks) to this folder:
;; /usr/local/lib
;; most notably: libtree-sitter-yaml.so
(add-to-list 'treesit-extra-load-path "/usr/local/lib")

(defun go-test-function-around-cursor ()
  "Run the Go test corresponding to the function at point."
  (interactive)
  (let* ((func-name (go-get-funcname-around-cursor))
         (test-func-name (concat "Test" func-name))
         (test-file (concat (file-name-sans-extension (buffer-file-name)) "_test.go")))
    (if (and func-name (file-exists-p test-file))
        (progn
          (save-buffer)
          (with-current-buffer (find-file-noselect test-file)
            (goto-char (point-min))
            (if (re-search-forward (concat "^func[[:space:]]+" test-func-name) nil t)
                (progn
                  (message "Running test function: %s" test-func-name)
                  (go-test--run-test test-func-name))
              (message "No test function found for %s" func-name))))
      (message "No corresponding test file found or function name is nil."))))

(defun go-get-funcname-around-cursor ()
  "Get the name of the current Go function using LSP."
  (when (and (bound-and-true-p lsp-mode)
             (lsp--capability "documentSymbolProvider"))
    (let ((symbols (lsp--get-document-symbols)))
      (cl-labels ((find-symbol (symbols)
                    (seq-find (lambda (sym)
                                (let ((range (gethash "range" sym)))
                                  (and (>= (point) (lsp--position-to-point (gethash "start" range)))
                                       (<= (point) (lsp--position-to-point (gethash "end" range))))))
                              symbols)))
        (when-let ((symbol (find-symbol symbols)))
          (gethash "name" symbol))))))

(defun go-test--run-test (test-func-name)
  "Run the Go test for the given TEST-FUNC-NAME."
  (let ((default-directory (projectile-project-root)))
    (compile (format "go test ./... -run '^%s$'" test-func-name))))

(after! go-mode
  (map! :localleader
        :map go-mode-map
        "t p" #'go-test-function-around-cursor))

(url-handler-mode 1)

(use-package! sops
  :bind (("C-c C-c" . sops-save-file)
         ("C-c C-k" . sops-cancel)
         ("C-c C-d" . sops-edit-file))
  :init
  (global-sops-mode 1))

;; (setq debug-on-error t)


;; IDEA: replicate nvim behaviour with * _ and substrings. Not easy. Leave for now. I want str1_str2 to be matched with * on str2
;; (defun my/evil-asterisk ()
;;   "Search for symbol under cursor as a substring match."
;;   (interactive)
;;   (let ((symbol (thing-at-point 'symbol t)))
;;     (if symbol
;;         (progn
;;           (setq isearch-forward t)
;;           (evil-search symbol 'forward t))
;;       (user-error "No symbol under cursor"))))

;; (defun my/evil-symbol-or-word-asterisk ()
;;   "Search for the full symbol or word under cursor."
;;   (interactive)
;;   (let ((bounds (bounds-of-thing-at-point 'symbol)))
;;     (if bounds
;;         (let ((symbol (buffer-substring-no-properties (car bounds) (cdr bounds))))
;;           ;; Use exact match if there's an underscore in the symbol
;;           (if (string-match-p "_" symbol)
;;               (evil-search symbol 'forward t) ;; Exact match
;;             ;; Otherwise, search as substring
;;             (my/evil-asterisk)))
;;       (user-error "No symbol or word under cursor"))))
;;
;; Remap * and # to the new function
;; (map! :n "*" #'my/evil-symbol-or-word-asterisk
;;       :n "#" #'(lambda () (interactive) ;; For backward search
;;                  (let ((evil-search-wrap t))
;;                    (evil-ex-search-backward-symbol-or-word))))



;; (defun my/evil-search-symbol-or-word ()
;;   "Search for symbol or word under cursor, allowing substring matches."
;;   (interactive)
;;   (let* ((bounds (bounds-of-thing-at-point 'symbol))
;;          (symbol (if bounds (buffer-substring-no-properties (car bounds) (cdr bounds)) nil)))
;;     (if symbol
;;         (let ((search-term (if (string-match-p "_" symbol)
;;                                (regexp-quote symbol)  ; Exact match for words with underscore
;;                              (concat "\\<" (regexp-quote symbol)))))  ; Substring match otherwise
;;           (evil-push-search-history search-term 'forward)
;;           (evil-search search-term t t)
;;           (setq evil-ex-search-pattern (evil-ex-make-search-pattern search-term)))
;;       (user-error "No symbol under cursor"))))

;; (map! :n "*" #'my/evil-search-symbol-or-word)

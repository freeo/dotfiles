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


;; (use-package! mixed-pitch)
;;
(use-package! mixed-pitch
  :hook
  If you want it in all text modes:
  (text-mode . mixed-pitch-mode))

;; (setq doom-font (font-spec :family "GoMono Nerd Font Mono" :size 16 )
;;       doom-variable-pitch-font (font-spec :family "Lexend" :size 16)
;;       ;; doom-variable-pitch-font (font-spec :family "Ubuntu" :size 16)
;;       doom-unicode-font (font-spec :family "GoMono Nerd Font Mono" :size 16)
;;       doom-big-font (font-spec :family "GoMono Nerd Font Mono" :size 20 ))
;;       ;; ivy-posframe-font (font-spec :family "JetBrainsMono" :size 15))
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 16 )
      ;; (setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 16 )
      ;; (setq doom-font (font-spec :family "FuraCode Nerd Font Mono" :size 16 :style "Regular" )
      ;; (setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 16 :weight 'medium )
      doom-variable-pitch-font (font-spec :family "Lexend" :size 16 :weight 'light )
      ; doom-variable-pitch-font (font-spec :family "ReadexPro" :size 16 :weight 'light )
      ; doom-variable-pitch-font (font-spec :family "Noto Serif CJK SC" :size 16 )
      ; doom-variable-pitch-font (font-spec :family "Liberation Serif" :size 16 )
      ;; Noto Serif CJK SC Semibold :weight 'light
      ;; mixed-pitch-face (font-spec :family "Lexend" :size 16 :weight 'light )
      doom-unicode-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 16)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 20 :weight 'bold))
;; (setq doom-font (font-spec :family "Cousine Nerd Font Mono" :size 16 )

                                        ; (use-package font-lock
                                        ;   :defer t
                                        ;   :custom-face
                                        ;   (font-lock-comment-face ((t (:inherit font-lock-comment-face :italic nil))))
                                        ;   ;; (font-lock-doc-face ((t (:inherit font-lock-doc-face :italic t))))
                                        ;   ;; (font-lock-string-face ((t (:inherit font-lock-string-face :italic t))))
                                        ;   )

;; (push "/home/freeo/.config/doom/theme-source/" custom-theme-load-path )


(setq-default tab-width 2)


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.
(setq doom-theme 'kalisi-light)
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

      (:prefix-map ("f" . "")
       :desc "file open 2nd Brain" "f" #'vterm
       )

      (:prefix-map ("o" . "open")
       :desc "vterm at path of current file" "t" #'vterm
       :desc "vterm here current frame" "o" #'+vterm/here
       :desc "vterm toggle" "T" #'+vterm/toggle
       )
      (:prefix-map ("TAB" . "workspace")
       :desc "kill workspace, consistent binding" "k" #'+workspace/delete
       :desc "left workspace, consistent binding" "h" #'+workspace/switch-left
       :desc "right workspace, consistent binding" "l" #'+workspace/switch-right
       ;; :desc "kill workspace, consistent binding" "l" #'+workspace/load ;; default for "l"
       )
      (:prefix-map ("s" . "search")
       ;; :desc "search bmwcode" "s" (cmd! (projectile-switch-project-by-name "/home/freeo/bmwcode/"))
       :desc "search 2nd Brain" "0" (cmd! (setq projectile-switch-project-action #'+default/search-project)
                                          (projectile-switch-project-by-name "/home/freeo/pcloud/org-roam")
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
       )

      (:prefix-map ("r" . "Alrrrrighty Then!")
       :desc "refactor anzu" "r" 'anzu-replace-at-cursor-thing
       :desc "hot:wb_ck.org"       "1" (cmd! (global-hot-bookmark "cloudkoloss" "~/pcloud/cloudkoloss/wb_ck.org"))
       :desc "hot:website.org"       "2" (cmd! (global-hot-bookmark "cloudkoloss" "~/pcloud/cloudkoloss/website.org"))
       ;; :desc "hot:todo.org"        "2" (cmd! (global-hot-bookmark "foam-workbench" "~/pcloud/org-roam/todo.org"))
       :desc "hot:doom config.el"  "3" (cmd! (global-hot-bookmark "dotfiles" "~/dotfiles/config/doom/config.el"))
       :desc "hot:.zshrc"          "4" (cmd! (global-hot-bookmark "dotfiles" "~/dotfiles/zshrc"))
       :desc "hot:awesome.rc"      "5" (cmd! (global-hot-bookmark "dotfiles" "~/dotfiles/config/awesome/rc4.3-git.lua"))
       :desc "hot:kalisi.el"       "6" (cmd! (global-hot-bookmark "dotfiles" "~/dotfiles/config/doom/themes/kalisi-light-theme.el"))
       )

      (:prefix-map ("p" . "project")
       ;; :desc "search bmwcode" "s" (cmd! (projectile-switch-project-by-name "/home/freeo/bmwcode/"))
       :desc "2nd Brain" "0" (cmd! (projectile-switch-project-by-name "/home/freeo/pcloud/org-roam"))
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
      :n "C-/"   #'swiper
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
      :n "C-S-<return>"   #'new-vterm-s-split
      :n "C-SPC" #'harpoon-quick-menu-hydra
      :n "C-q" #'evil-visual-block
      :n "g q" #'+format:region     ;; swap gQ with gq
      :n "g Q" #'evil-fill-and-move
      :n "g j" #'evil-next-visual-line
      :n "g k" #'evil-previous-visual-line
      :n "C-<" (cmd! (evil-window-decrease-width 10))
      :n "C->" (cmd! (evil-window-increase-width 10))
      :n "C-+" (cmd! (evil-window-decrease-height 3))
      :n "C-_" (cmd! (evil-window-increase-height 3))
      )


(define-key
  evil-insert-state-map (kbd "M-d") 'evil-multiedit-toggle-marker-here)

(define-key! ranger-mode-map "C-h" 'evil-window-left)
(define-key! ranger-mode-map "C-j" 'evil-window-down)
(define-key! ranger-mode-map "C-k" 'evil-window-up)
(define-key! ranger-mode-map "C-l" 'evil-window-right)

(setq ranger-show-hidden t)
(setq ranger-hide-cursor t)

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
      :n "C-S-<return>"   #'new-vterm-s-split
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

(use-package vterm
  :config
  (advice-add #'vterm--redraw :after (lambda (&rest args) (evil-refresh-cursor evil-state)))
  )

(setq vterm-kill-buffer-on-exit t)

;; enable word-wrap (almost) everywhere
;; MUST be after use-package vterm! Otherwise this will cause a memory leak on startup (if vterm-module isn't
;; compiled yet) and therefore crash emx.
(+global-word-wrap-mode +1)
(setq +word-wrap-extra-indent 2)


;; (auto-save-visited-mode 1)
;; evil-normal-state-map C-t

; How can I be so fuckin stupid
; (add-hook 'evil-insert-state-exit-hook
;           (lambda ()
;             (call-interactively #'save-buffer)))

(use-package! super-save
  :ensure t
  :config
  (super-save-mode +1))


(after! org
  (super-save-mode +1))

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


(setq projectile-indexing-method 'alien)
;; git ls-files filters out more than the .gitignore and therefore seems unreliable. More hits is fine for me
;; (setq projectile-git-command "git ls-files -zco")
(setq projectile-git-command "fd --type f --print0 -H -I -E '.git'")
(setq projectile-generic-command "fd --type f --print0 -H -I")
(setq projectile-enable-caching nil)

;; export GOPATH="/home/freeo/go"


;; LSP
;; (use-package lsp-mode
;;   :commands (lsp lsp-deferred)
;;   :hook (lsp-mode . efs/lsp-mode-setup)
;;   :init
;;   (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
;;   :config
;;   (lsp-enable-which-key-integration t))

;; (use-package lsp-ui
;;   :hook (lsp-mode . lsp-ui-mode)
;;   :custom
;;   (lsp-ui-doc-position 'bottom)


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


(use-package dap-mode)

;; Go DAP (Debugger)
(dap-mode 1)
;; (dap-go-setup)
(require 'dap-go)

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
(setq centaur-tabs-style "bar")
(setq centaur-tabs-set-bar 'under)
(setq x-underline-at-descent-line t)
(setq centaur-tabs-set-close-button nil)

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


(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (require 'dap-node)
  (dap-node-setup))

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
        '(npx "prettier" "--use-tabs" "true" "--stdin-filepath" filepath ))

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

;; https://github.com/TommyX12/company-tabnine
(use-package company-tabnine :ensure t)
(add-to-list 'company-backends #'company-tabnine)
;; Trigger completion immediately.
(setq company-idle-delay 0)
;; Number the candidates (use M-1, M-2 etc to select completions).
(setq company-show-numbers t)

(setq company-global-modes '(not org-mode))

(global-org-modern-mode)

(setq org-hide-emphasis-markers t)


;; (add-hook! 'org-mode-hook (lambda () (setq highlight-indent-guides-mode t)))
(add-hook 'org-mode-hook 'highlight-indent-guides-mode)
;; (setq highlight-indent-guides-method 'column) ;; quite nice, but fill is fuller
(setq highlight-indent-guides-method 'fill)
;; (setq highlight-indent-guides-method 'bitmap) ;; 3rd place
;; (setq highlight-indent-guides-method 'character) ;; default, bad influence on wrapped lines, also has gaps since it's not using full height

(setq highlight-indent-guides-auto-enabled nil)

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
  (add-to-list 'org-font-lock-extra-keywords '("\\(%\\)\\([^\n\r\t]+\\)\\(%\\)" (1 '(face org-highlight-2 invisible t)) (2 'org-highlight-2 t) (3 '(face org-highlight-2 invisible t))) t)
  (add-to-list 'org-font-lock-extra-keywords '("[[:blank:]]\\(:\\)\\([^\n\r\t]+\\)\\(:\\)" (1 '(face org-highlight-2 invisible t)) (2 'org-modern-tag t) (3 '(face org-highlight-2 invisible t))) t)
  )

(add-hook 'org-font-lock-set-keywords-hook #'org-add-my-extra-fonts)

(font-lock-add-keywords 'org-mode
                        '(("\\(\\[[^\n\r\t]+?\\]\\)" 1 font-lock-comment-face prepend)) 'append)
(font-lock-add-keywords 'org-mode
                        '(("\\([[:blank:]]#[[:blank:]].+$\\)" 1 font-lock-comment-face prepend)) 'append)

;;magit diff
(add-hook 'magit-mode-hook (lambda () (magit-delta-mode +1)))

;; tested: not invisible: %
;; (font-lock-add-keywords 'org-mode
;; '("\\(%\\)\\([^\n\r\t]+\\)\\(%\\)" (1 '(face org-highlight-2 invisible t)) (2 'org-highlight-2 t) (3 '(face org-highlight-2 invisible t))) t)
;; (add-to-list 'org-font-lock-extra-keywords '("\\(\\$\\)\\([^\n\r\t]+\\)\\(\\$\\)" (1 '(face org-highlight-1 invisible t)) (2 'org-highlight-1 t) (3 '(face org-highlight-1 invisible t))) t)



;; (require 'auto-dark)

;; I did minor changes to this source:
;; https://www.reddit.com/r/emacs/comments/th50v7/autodark_for_emacs_is_now_available_on_melpa/
;; Only a temporary workaround until this issue is solved:
;; https://github.com/doomemacs/doomemacs/issues/6027
;; (defun gnome-dark-mode-enabled-p ()
;;   "Check if frame is dark or not."
;;   (if (executable-find "gsettings")
;;       (thread-last "gsettings get org.gnome.desktop.interface color-scheme"
;;                    shell-command-to-string
;;                    string-trim-right
;;                    (string-suffix-p "-dark'"))
;;     (eq 'dark (frame-parameter nil 'background-mode))))

;; (use-package dbus
;;   ;; :straight nil
;;   :when window-system
;;   :requires (functions local-config)
;;   :config
;;   (defun gtk-theme-changed (path _ _)
;;     "DBus handler to detect when the GTK theme has changed."
;;     (when (string-equal path "/org/gnome/desktop/interface/color-scheme")

;;       (message "old: got new value: %s" (car value))
;;       (if (gnome-dark-mode-enabled-p)
;;           (load-theme local-config-dark-theme t)
;;         (load-theme local-config-light-theme t))
;;       ))
;;   (dbus-register-signal
;;    :session
;;    "ca.desrt.dconf"
;;    "/ca/desrt/dconf/Writer/user"
;;    "ca.desrt.dconf.Writer"
;;    "Notify"
;;    #'gtk-theme-changed))

;; (use-package dbus
;;   ;; :straight nil
;;   :when window-system
;;   :requires (functions local-config)
;;   :config
;;   )

(require 'dbus)

(setq local-config-dark-theme 'doom-gruvbox)
(setq local-config-light-theme 'kalisi-light)

(defun handler (value)
  (message "current value %s" (car (car value))))

(defun signal-handler (namespace key value)
  (if (and
       ;; (string-equal namespace "org.freedesktop.appearance")
       (string-equal namespace "org.gnome.desktop.interface")
       (string-equal key "color-scheme"))
      ;; (message "got new value: %s" (car value))
      ;; (message "got new value: %s" value)
      ;; (if (= (car value) 1)
      (setq durr (car value))  ;; using a temp variable lets me reuse it as often as I like
    ;; (if (string-equal (car value) "prefer-dark")
    (if (string-equal durr "prefer-dark")
        (load-theme local-config-dark-theme t)
      (load-theme local-config-light-theme t))
    ;; (if (string-equal durr "prefer-dark") ;; 2nd access test
    ;; (message "eq dark")
    ;; (message "eq light"))
    (message "%s" durr) ;; 3rd access test
    nil))



(dbus-call-method-asynchronously
 :session
 "org.freedesktop.portal.Desktop"
 "/org/freedesktop/portal/desktop"
 "org.freedesktop.portal.Settings"
 "Read"
 #'handler
 "org.freedesktop.appearance"
 "color-scheme")

;; Requires xdg-portal-desktop which provides the DBus Interace
;; Also requires a backend, tested: xdg-portal-desktop-gtk
(dbus-register-signal
 :session
 "org.freedesktop.portal.Desktop"
 "/org/freedesktop/portal/desktop"
 "org.freedesktop.portal.Settings"
 "SettingChanged"
 #'signal-handler)


;; string "type='signal',interface='',path='/ca
;; /desrt/dconf/Writer/user',arg0path='/org/gnome/desktop/interface/'"
;; method return time=1675795353.914985 sender=org.freedesktop.DBus ->
;; destination=:1.502 serial=3 reply_serial=2


;; (dbus-introspect
;;  :system "org.gnome.desktop.interface"
;;  "/org/gnome/desktop/interface")

;; (dbus-introspect-get-all-nodes :session "org.gnome.desktop.interface" "/")

;; learn elisp: why is using "value" in the function above consuming the item like an iterator? It yields a different value on 2nd access! WHY?
;; (defun hurr (durr)
;;   (message "%s %s" (car durr) (car durr)))
;; (setq murr '("light" "dark"))
;; hurr(murr)

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

;; (set-file-template! "\\.svx$" :trigger "__" :mode 'web-mode)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.svx\\'" . web-mode))

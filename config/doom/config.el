1;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


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

;; enable word-wrap (almost) everywhere
(+global-word-wrap-mode +1)
(setq +word-wrap-extra-indent 2)

;; (use-package! mixed-pitch
;; :hook
;; If you want it in all text modes:
;; (text-mode . mixed-pitch-mode))

;; (setq doom-font (font-spec :family "GoMono Nerd Font Mono" :size 16 )
;;       doom-variable-pitch-font (font-spec :family "Lexend" :size 16)
;;       ;; doom-variable-pitch-font (font-spec :family "Noto Serif CJK SC Semibold" :size 16)
;;       ;; doom-variable-pitch-font (font-spec :family "Ubuntu" :size 16)
;;       doom-unicode-font (font-spec :family "GoMono Nerd Font Mono" :size 16)
;;       doom-big-font (font-spec :family "GoMono Nerd Font Mono" :size 20 ))
;;       ;; ivy-posframe-font (font-spec :family "JetBrainsMono" :size 15))
(setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 16 )
      ;; (setq doom-font (font-spec :family "FuraCode Nerd Font Mono" :size 16 :style "Regular" )
      ;; (setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 16 :weight 'medium )
      doom-variable-pitch-font (font-spec :family "Lexend" :size 16 :style "ExtraLight" )
      ;; mixed-pitch-face (font-spec :family "Lexend Exa" :size 16 :weight 'light )
      ;; doom-variable-pitch-font (font-spec :family "Noto Serif" :size 16 :weight 'extra-bold)
      doom-unicode-font (font-spec :family "FiraCode Nerd Font Mono" :size 16)
      doom-big-font (font-spec :family "FiraCode Nerd Font Mono" :size 20 ))
;; (setq doom-font (font-spec :family "Cousine Nerd Font Mono" :size 16 )
;;       doom-variable-pitch-font (font-spec :family "Lexend" :size 16 :style "ExtraLight" )
;;       doom-unicode-font (font-spec :family "Cousine Nerd Font Mono" :size 16)
;;       doom-big-font (font-spec :family "Cousine Nerd Font Mono" :size 20 ))



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


(map! :leader

      :desc "kill buffer" "k" #'kill-current-buffer
      :desc "zoxide travel" "z" #'zoxide-travel

      (:prefix-map ("o" . "open")
       :desc "vterm at path of current file" "t" #'vterm
       :desc "vterm here current frame" "o" #'+vterm/here
       :desc "vterm toggle" "T" #'+vterm/toggle
       )
      (:prefix-map ("TAB" . "workspace")
       :desc "kill workspace, consistent binding" "k" #'+workspace/delete
       :desc "kill workspace, consistent binding" "h" #'+workspace/switch-left
       :desc "kill workspace, consistent binding" "l" #'+workspace/switch-right
       ;; :desc "kill workspace, consistent binding" "l" #'+workspace/load ;; default for "l"
       )
      (:prefix-map ("s" . "search")
       :desc "search bmwcode" "s" (cmd! (projectile-switch-project-by-name "/home/freeo/bmwcode/"))
       :desc "search current PWD" "c" #'helm-rg
       )

      (:prefix-map ("b" . "buffer")
       :desc "Harpoon add file" "h" 'harpoon-add-file
       )

      (:prefix-map ("t" . "toggles")
       ;; :desc "insert date header" "t" #'insert-current-date
       :desc "Line Numbers" "l" 'doom/toggle-line-numbers
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

;; (defun global-hot-bookmark(workspace, filename)
;; (+workspace/switch-to workspace)
;; (find-file-other-window "~/bmw/wb_bmw.org")
;; )

;; (map! :leader "r 1" (cmd! (find-file "~/bmw/wb_bmw.org")))
(map! :leader
      :desc "wb_ck.org"
      "r 1" (cmd! (+workspace/switch-to "main")
                  (find-file-other-window "~/cloudkoloss/wb_ck.org")
                  )

      :desc "todo.org"
      "r 2" (cmd!
             (+workspace/switch-to "main")
             (find-file-other-window "~/foam-workbench/todo.org")
             )
      :desc ".zshrc"
      "r 3" (cmd!
             (+workspace/switch-to "dotfiles")
             (find-file-other-window "~/dotfiles/zshrc")
             )
      :desc "config DOOM"
      "r 4" (cmd!
             (+workspace/switch-to "dotfiles")
             (find-file-other-window "~/dotfiles/config/doom/config.el")
             )
      :desc "awesome.rc"
      "r 5" (cmd!
             (+workspace/switch-to "dotfiles")
             (find-file-other-window "~/dotfiles/config/awesome/rc4.3-git.lua")
             )

      :desc "kalisi"
      "r 6" (cmd!
             (+workspace/switch-to "dotfiles")
             (find-file-other-window "~/dotfiles/config/doom/themes/kalisi-light-theme.el")
             )
      )


;; (map! :n "C-t"   #'evilnc-comment-operator)
(map! :n "C-t"   #'comment-line
      :n "C-/"   #'swiper
      :n "-"   #'dired-jump
      :n "C-h" #'evil-window-left
      :n "C-j" #'evil-window-down
      :n "C-k" #'evil-window-up
      :n "C-l" #'evil-window-right
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
      )

;; (projectile-switch-project-by-name "/home/freeo/bmwcode/")
;; (projectile-switch-project-by-name "~/bmwcode/")

;; helm-projectile-switch-project
;; projectile-switch-project-by-name


;; (setq foreground vterm-color-red)
                                        ;

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
(map! :map evil-org-mode-map
      :n "C-S-h" #'+workspace/switch-left
      :n "C-S-l" #'+workspace/switch-right
      :n "C-S-<return>"   #'new-vterm-s-split
      )

;; previous map alone doesn't override the default mapping unfortunately.
(map! :map org-mode-map
      "C-S-<return>"   #'new-vterm-s-split
      )

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
;;
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


;; evil-normal-state-map C-t
;;
;; (auto-save-visited-mode 1)
(super-save-mode +1)
(setq super-save-auto-save-when-idle t)
(setq auto-save-default nil)
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
      (expand-file-name "freeo_clean.png" doom-private-dir))


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
(setq magit-ediff-dwim-show-on-hunks t)

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

;; Autoformatting async after save
;; https://github.com/radian-software/apheleia
(apheleia-global-mode +1)

(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
;; careful: enforces 4 spaces! bites itself a little with my default: tab-width 2
(add-hook 'json-mode-hook #'aggressive-indent-mode)

(add-hook 'yas-minor-mode-hook
          (lambda()
            (yas-activate-extra-mode 'fundamental-mode)))

(defun json2yaml ()
  (interactive)
  (shell-command
   (concat "yq -P -i " buffer-file-name)))

(defun yaml2json ()
  (interactive)
  (shell-command
   (concat "yq -o=json -i " buffer-file-name)))

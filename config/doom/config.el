;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

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


(setq doom-font (font-spec :family "GoMono Nerd Font Mono" :size 16 )
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 16)
      doom-unicode-font (font-spec :family "GoMono Nerd Font Mono" :size 16)
      doom-big-font (font-spec :family "GoMono Nerd Font Mono" :size 20 ))
      ;; ivy-posframe-font (font-spec :family "JetBrainsMono" :size 15))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox-light)
;; (setq doom-theme 'doom-solarized-light) ;; underscorce in markdown cmds sometimes UNREADABLE
;; (setq doom-theme 'doom-one-light)
;; (setq doom-theme 'flatui) ;; modeline and tabline are too dominant

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

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

(map! :leader

       :desc "kill buffer" "k" #'kill-current-buffer

        (:prefix-map ("o" . "open")
       :desc "vterm at path of current file" "t" #'vterm
       )
        (:prefix-map ("o" . "open")
       :desc "vterm here current frame" "o" #'+vterm/here
       )
        (:prefix-map ("o" . "open")
       :desc "vterm toggle" "T" #'+vterm/toggle
       )
       (:prefix-map ("TAB" . "workspace")
       :desc "kill workspace, consistent binding" "k" #'+workspace/delete
       )
        (:prefix-map ("s" . "search")
       :desc "search bmwcode" "s" (cmd! (projectile-switch-project-by-name "/home/freeo/bmwcode/"))
       )
        (:prefix-map ("s" . "search")
       :desc "search current PWD" "c" #'helm-rg)
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

;; (map! :n "C-t"   #'evilnc-comment-operator)
(map! :n "C-t"   #'comment-line
      :n "C-/"   #'swiper
      :n "-"   #'dired-jump
      :n "C-h" #'evil-window-left
      :n "C-j" #'evil-window-down
      :n "C-k" #'evil-window-up
      :n "C-l" #'evil-window-right
      :n "C-m" #'electric-newline-and-maybe-indent
      :n "<f1>" #'next-buffer
      :n "<f2>" #'previous-buffer
      :n "<f3>" #'evil-next-buffer
      :n "<f4>" #'evil-prev-buffer
      ;; :n "C-S-h" #'+workspace/switch-left
      ;; :n "C-S-l" #'+workspace/switch-right
      :n "C-S-t" #'+workspace/new
      :n "C-w C-q" #'evil-quit
      :n "C-;" #'helm-M-x  ;; previous mapping: embark-act
      )


;; (defvar ranger-normal-mode-map
;; (ranger-pop-eshell &optional ARG)
;; ranger-normal-mode-map S

(global-set-key (kbd "C-S-h") #'+workspace/switch-left)
(global-set-key (kbd "C-S-l") #'+workspace/switch-right)

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
(setq ivy-count-format "(%d/%d) ")

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
(add-hook 'go-mode-hook #'lsp-deferred)
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
  :ensure t
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


(defun durr ()
  (interactive)
  (evil-quit))

;; (setq evil-normal-state-tag (propertize "[Normal]" 'face '((:background "green" :foreground "black")))
;;       evil-emacs-state-tag    (propertize "[Emacs]" 'face '((:background "orange" :foreground "black")))
;;       evil-insert-state-tag   (propertize "[Insert]" 'face '((:background "red") :foreground "white"))
;;       evil-motion-state-tag   (propertize "[Motion]" 'face '((:background "blue") :foreground "white"))
;;       evil-visual-state-tag   (propertize "[Visual]" 'face '((:background "grey80" :foreground "black")))
;;       evil-operator-state-tag (propertize "[Operator]" 'face '((:background "purple"))))


;; ("%e"
;;  (:eval
;;   (let*
;;       ((active
;;         (powerline-selected-window-active))
;;        (mode-line-buffer-id
;;         (if active 'mode-line-buffer-id 'mode-line-buffer-id-inactive))
;;        (mode-line
;;         (if active 'mode-line 'mode-line-inactive))
;;        (face0
;;         (if active 'powerline-active0 'powerline-inactive0))
;;        (face1
;;         (if active 'powerline-active1 'powerline-inactive1))
;;        (face2
;;         (if active 'powerline-active2 'powerline-inactive2))
;;        (separator-left
;;         (intern
;;          (format "powerline-%s-%s"
;;                  (powerline-current-separator)
;;                  (car powerline-default-separator-dir))))
;;        (separator-right
;;         (intern
;;          (format "powerline-%s-%s"
;;                  (powerline-current-separator)
;;                  (cdr powerline-default-separator-dir))))
;;        (lhs
;;         (list
;;          (powerline-raw "%*" face0 'l)
;;          (when powerline-display-buffer-size
;;            (powerline-buffer-size face0 'l))
;;          (when powerline-display-mule-info
;;            (powerline-raw mode-line-mule-info face0 'l))
;;          (powerline-buffer-id
;;           `(mode-line-buffer-id ,face0)
;;           'l)
;;          (when
;;              (and
;;               (boundp 'which-func-mode)
;;               which-func-mode)
;;            (powerline-raw which-func-format face0 'l))
;;          (powerline-raw " " face0)
;;          (funcall separator-left face0 face1)
;;          (when
;;              (and
;;               (boundp 'erc-track-minor-mode)
;;               erc-track-minor-mode)
;;            (powerline-raw erc-modified-channels-object face1 'l))
;;          (powerline-major-mode face1 'l)
;;          (powerline-process face1)
;;          (powerline-minor-modes face1 'l)
;;          (powerline-narrow face1 'l)
;;          (powerline-raw " " face1)
;;          (funcall separator-left face1 face2)
;;          (powerline-vc face2 'r)
;;          (when
;;              (bound-and-true-p nyan-mode)
;;            (powerline-raw
;;             (list
;;              (nyan-create))
;;             face2 'l))))
;;        (rhs
;;         (list
;;          (powerline-raw global-mode-string face2 'r)
;;          (funcall separator-right face2 face1)
;;          (unless window-system
;;            (powerline-raw
;;             (char-to-string 57505)
;;             face1 'l))
;;          (powerline-raw "%4l" face1 'l)
;;          (powerline-raw ":" face1 'l)
;;          (powerline-raw "%3c" face1 'r)
;;          (funcall separator-right face1 face0)
;;          (powerline-raw " " face0)
;;          (powerline-raw "%6p" face0 'r)
;;          (when powerline-display-hud
;;            (powerline-hud face0 face2))
;;          (powerline-fill face0 0))))
;;     (concat
;;      (powerline-render lhs)
;;      (powerline-fill face2
;;                      (powerline-width rhs))
;;      (powerline-render rhs)))))
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PROTESILAOS fzf ivy config
;;
;; (use-package ivy
;;   ;; :ensure t
;;   :delight
;;   :config
;;   (setq ivy-count-format "(%d/%d) ")
;;   (setq ivy-height-alist '((t lambda (_caller) (/ (window-height) 4))))
;;   (setq ivy-use-virtual-buffers t)
;;   (setq ivy-wrap nil)
;;   (setq ivy-re-builders-alist
;;         '((counsel-M-x . ivy--regex-fuzzy)
;;           (ivy-switch-buffer . ivy--regex-fuzzy)
;;           (ivy-switch-buffer-other-window . ivy--regex-fuzzy)
;;           (counsel-rg . ivy--regex-or-literal)
;;           (t . ivy--regex-plus)))
;;   (setq ivy-display-style 'fancy)
;;   (setq ivy-use-selectable-prompt t)
;;   (setq ivy-fixed-height-minibuffer nil)
;;   (setq ivy-initial-inputs-alist
;;         '((counsel-M-x . "^")
;;           (ivy-switch-buffer . "^")
;;           (ivy-switch-buffer-other-window . "^")
;;           (counsel-describe-function . "^")
;;           (counsel-describe-variable . "^")
;;           (t . "")))
;;
;;   (ivy-set-occur 'counsel-fzf 'counsel-fzf-occur)
;;   (ivy-set-occur 'counsel-rg 'counsel-ag-occur)
;;   (ivy-set-occur 'ivy-switch-buffer 'ivy-switch-buffer-occur)
;;   (ivy-set-occur 'swiper 'swiper-occur)
;;   (ivy-set-occur 'swiper-isearch 'swiper-occur)
;;   (ivy-set-occur 'swiper-multi 'counsel-ag-occur)
;;   :hook ((after-init . ivy-mode)
;;          (ivy-occur-mode . hl-line-mode))
;;   :bind (("<s-up>" . ivy-push-view)
;; 		 ("<s-down>" . ivy-switch-view)
;;          ("C-S-r" . ivy-resume)
;;          :map ivy-occur-mode-map
;;          ("f" . forward-char)
;;          ("b" . backward-char)
;;          ("n" . ivy-occur-next-line)
;;          ("p" . ivy-occur-previous-line)
;;          ("<C-return>" . ivy-occur-press)))
;;
;; (use-package counsel
;;   ;; :ensure t
;;   :after ivy
;;   :config
;;   (setq counsel-yank-pop-preselect-last t)
;;   (setq counsel-yank-pop-separator "\n—————————\n")
;;   (setq counsel-rg-base-command
;;         "rg -SHn --no-heading --color never --no-follow --hidden %s")
;;   (setq counsel-find-file-occur-cmd; TODO Simplify this
;;         "ls -a | grep -i -E '%s' | tr '\\n' '\\0' | xargs -0 ls -d --group-directories-first")
;;
;;   (defun prot/counsel-fzf-rg-files (&optional input dir)
;;     "Run `fzf' in tandem with `ripgrep' to find files in the
;; present directory.  If invoked from inside a version-controlled
;; repository, then the corresponding root is used instead."
;;     (interactive)
;;     (let* ((process-environment
;;             (cons (concat "FZF_DEFAULT_COMMAND=rg -Sn --color never --files --no-follow --hidden")
;;                   process-environment))
;;            (vc (vc-root-dir)))
;;       (if dir
;;           (counsel-fzf input dir)
;;         (if (eq vc nil)
;;             (counsel-fzf input default-directory)
;;           (counsel-fzf input vc)))))
;;
;;   (defun prot/counsel-fzf-dir (arg)
;;     "Specify root directory for `counsel-fzf'."
;;     (prot/counsel-fzf-rg-files ivy-text
;;                                (read-directory-name
;;                                 (concat (car (split-string counsel-fzf-cmd))
;;                                         " in directory: "))))
;;
;;   (defun prot/counsel-rg-dir (arg)
;;     "Specify root directory for `counsel-rg'."
;;     (let ((current-prefix-arg '(4)))
;;       (counsel-rg ivy-text nil "")))
;;
;;   ;; TODO generalise for all relevant file/buffer counsel-*?
;;   (defun prot/counsel-fzf-ace-window (arg)
;;     "Use `ace-window' on `prot/counsel-fzf-rg-files' candidate."
;;     (ace-window t)
;;     (let ((default-directory (if (eq (vc-root-dir) nil)
;;                                  counsel--fzf-dir
;;                                (vc-root-dir))))
;;       (if (> (length (aw-window-list)) 1)
;;           (find-file arg)
;;         (find-file-other-window arg))
;;       (balance-windows (current-buffer))))
;;
;;   ;; Pass functions as appropriate Ivy actions (accessed via M-o)
;;   (ivy-add-actions
;;    'counsel-fzf
;;    '(("r" prot/counsel-fzf-dir "change root directory")
;;      ("g" prot/counsel-rg-dir "use ripgrep in root directory")
;;      ("f" prot/counsel-fzf-rg-files "use fzf+ripgrep in root directory")
;;      ("a" prot/counsel-fzf-ace-window "ace-window switch")))
;;
;;   (ivy-add-actions
;;    'counsel-rg
;;    '(("r" prot/counsel-rg-dir "change root directory")
;;      ("z" prot/counsel-fzf-dir "find file with fzf in root directory")))
;;
;;   (ivy-add-actions
;;    'counsel-find-file
;;    '(("g" prot/counsel-rg-dir "use ripgrep in root directory")
;;      ("z" prot/counsel-fzf-dir "find file with fzf in root directory")))
;;
;;   ;; Remove commands that only work with key bindings
;;   (put 'counsel-find-symbol 'no-counsel-M-x t)
;;   :bind (("M-x" . counsel-M-x)
;;          ("C-x C-f" . counsel-find-file)
;;          ("s-f" . counsel-find-file)
;;          ("s-F" . find-file-other-window)
;;          ("C-x b" . ivy-switch-buffer)
;;          ("s-b" . ivy-switch-buffer)
;;          ("C-x B" . counsel-switch-buffer-other-window)
;;          ("s-B" . counsel-switch-buffer-other-window)
;;          ("C-x d" . counsel-dired)
;;          ("s-d" . counsel-dired)
;;          ("s-D" . dired-other-window)
;;          ("C-x C-r" . counsel-recentf)
;;          ("s-m" . counsel-mark-ring)
;;          ("s-r" . counsel-recentf)
;;          ("s-y" . counsel-yank-pop)
;;          ("C-h f" . counsel-describe-function)
;;          ("C-h v" . counsel-describe-variable)
;;          ("M-s r" . counsel-rg)
;;          ("M-s g" . counsel-git-grep)
;;          ("M-s l" . counsel-find-library)
;;          ("M-s z" . prot/counsel-fzf-rg-files)
;;          :map ivy-minibuffer-map
;;          ("C-r" . counsel-minibuffer-history)
;;          ("s-y" . ivy-next-line)        ; Avoid 2× `counsel-yank-pop'
;;          ("C-SPC" . ivy-restrict-to-matches)))
;;
;; (use-package projectile
;;   ;; :ensure t
;;   ;; :delight '(:eval (concat " " (projectile-project-name)))
;;   :delight
;;   :config
;;   (setq projectile-project-search-path '("~/Git/Projects/"))
;;   (setq projectile-indexing-method 'alien)
;;   (setq projectile-enable-caching t)
;;   (setq projectile-completion-system 'ivy))
;;
;; (use-package counsel-projectile
;;   ;; :ensure t
;;   :config
;;   (add-to-list 'ivy-initial-inputs-alist '(counsel-projectile-switch-project . ""))
;;   :hook (after-init . counsel-projectile-mode)
;;   ;; :bind-keymap ("M-s p" . projectile-command-map)
;;   :bind (("M-s b" . counsel-projectile-switch-to-buffer)
;;          ("M-s d" . counsel-projectile-find-dir)
;;          ("M-s p" . (lambda ()
;;                       (interactive)
;;                       (counsel-projectile-switch-project 4)))))
;;
;; (use-package swiper
;;   ;; :ensure t
;;   :after ivy
;;   :config
;;   (setq swiper-action-recenter t)
;;   (setq swiper-goto-start-of-match t)
;;   (setq swiper-include-line-number-in-search t)
;;   :bind (("C-S-s" . swiper)
;;          ("M-s s" . swiper-multi)
;;          ("M-s w" . swiper-thing-at-point)
;;          :map swiper-map
;;          ("M-%" . swiper-query-replace)))
;;
;;
;;
;; -------------------------
;; not default
;;
;; (use-package ivy-rich
;;   :ensure t
;;   :config
;;   (setq ivy-rich-path-style 'abbreviate)
;;
;;   (setcdr (assq t ivy-format-functions-alist)
;;           #'ivy-format-function-line)
;;   :hook (after-init . ivy-rich-mode))
;;
;; (use-package ivy-posframe
;;   :ensure t
;;   :delight
;;   :config
;;   (setq ivy-posframe-parameters
;;         '((left-fringe . 2)
;;           (right-fringe . 2)
;;           (internal-border-width . 2)
;;           ;; (font . "Iosevka-10.75:hintstyle=hintfull")
;; ))
;;   (setq ivy-posframe-height-alist
;;         '((swiper . 15)
;;           (swiper-isearch . 15)
;;           (t . 10)))
;;   (setq ivy-posframe-display-functions-alist
;;         '((complete-symbol . ivy-posframe-display-at-point)
;;           (swiper . nil)
;;           (swiper-isearch . nil)
;;           (t . ivy-posframe-display-at-frame-center)))
;;   :hook (after-init . ivy-posframe-mode))
;;
;;
;; (use-package prescient
  ;; :ensure t
;;   :config
;;   (setq prescient-history-length 200)
;;   (setq prescient-save-file "~/.emacs.d/prescient-items")
;;   (setq prescient-filter-method '(literal regexp))
;;   (prescient-persist-mode 1))
;;
;; (use-package ivy-prescient
;;   :ensure t
;;   :after (prescient ivy)
;;   :config
;;   (setq ivy-prescient-sort-commands
;;         '(:not counsel-grep
;;                counsel-rg
;;                counsel-switch-buffer
;;                ivy-switch-buffer
;;                swiper
;;                swiper-multi))
;;   (setq ivy-prescient-retain-classic-highlighting t)
;;   (setq ivy-prescient-enable-filtering nil)
;;   (setq ivy-prescient-enable-sorting t)
;;   (ivy-prescient-mode 1))

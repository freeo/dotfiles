;;; ../../dotfiles/config/doom/archived_functions.el -*- lexical-binding: t; -*-

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

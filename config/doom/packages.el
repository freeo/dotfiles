;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
                                        ;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
                                        ;(package! another-package
                                        ;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
                                        ;(package! this-package
                                        ;  :recipe (:host github :repo "username/repo"
                                        ;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
                                        ;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
                                        ;(package! builtin-package :recipe (:nonrecursive t))
                                        ;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
                                        ;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
                                        ;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
                                        ;(unpin! pinned-package)
;; ...or multiple packages
                                        ;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
                                        ;(unpin! t)

;; (package! benchmark-init)

(package! fzf)
(package! super-save)
(package! jsonnet-mode)
;; (package! powerline)
;; (package! powerline-evil) ;; 2 years abandoned. Use powerline only if possible
;; (package! airline-themes) ;; messes with whole theme
(package! flatui-theme)
(package! dap-mode)
(package! k8s-mode)
(package! mixed-pitch) ;; buggy, :weight doesn't work so pass for now: 2022 02 15
(package! zoxide)
(package! git-link)
(package! impatient-mode)
(package! impatient-showdown)

(package! emacs-livedown
  :recipe (:host github :repo "shime/emacs-livedown"))

(package! password-store)
(package! kubernetes-evil)
(package! harpoon)

(package! autothemer)

(package! apheleia)
(package! aggressive-indent)
(package! company-tabnine)
(package! org-appear)
(package! org-modern)
(package! org-sidebar)
(package! magit-delta)
(package! auto-dark)
(package! sudo-edit)
(package! lsp-tailwindcss :recipe (:host github :repo "merrickluo/lsp-tailwindcss"))
(package! mermaid-mode)
(package! ob-mermaid) ;; org-mode: mermaid src block -> diagram directly below
(package! org-download)
(package! org-fancy-priorities)
;; (package! ellama)
(package! gptel)
(package! docker)
(package! string-inflection)
;; for a evil verb key: g~
(package! evil-string-inflection)
(package! yaml-pro)
(package! just-mode)
(package! justl :recipe (:host github :repo "psibi/justl.el"))
(package! sops)
(package! highlight-indent-guides)

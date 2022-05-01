;;; doom-kalisi-light-theme.el --- Kalisi light theme -*- lexical-binding: t; no-byte-compile: t; -*-
(require 'doom-themes)

;;; Variables
(defgroup doom-kalisi-light-theme nil
  "Options for the `doom-kalisi-light' theme."
  :group 'doom-themes)

(defcustom doom-kalisi-light-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-kalisi-light-theme
  :type 'boolean)

(defcustom doom-kalisi-light-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-kalisi-light-theme
  :type 'boolean)

(defcustom doom-kalisi-light-comment-bg doom-kalisi-light-brighter-comments
  "If non-nil, comments will have a subtle, darker background. Enhancing their
legibility."
  :group 'doom-kalisi-light-theme
  :type 'boolean)

(defcustom doom-kalisi-light-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to
determine the exact padding."
  :group 'doom-kalisi-light-theme
  :type '(or integer boolean))

;;; Theme definition
(def-doom-theme kalisi-light
  "A light theme in tribute for a queen"

;;;; Colors
  ;; name        default   256         16
  ; ((bg         '("#F5F5F9" "color-255" "black"        ))
  ((bg         '("#FAFAFA" "color-255" "black"        ))
   (bg-alt     '("#E9E9E9" "color-254" "brightblack"  ))
   (base0      '("#D0D0D0" "color-188" "black"        ))
   (base1      '("#E0E0E0" "color-188" "brightblack"  ))
   (base2      '("#C0CCD0" "color-152" "brightblack"  ))
   (base3      '("#9EA6B0" "color-103" "brightblack"  ))
   (base4      '("#585C6C" "color-60"  "brightblack"  ))
   (base5      '("#4E4E4E" "color-239" "brightblack"  ))
   (base6      '("#3A3A3A" "color-237" "white"        ))
   (base7      '("#303030" "color-236" "white"        ))
   (base8      '("#1E1E33" "color-236" "brightwhite"  ))
   (fg         '("#0F1019" "color-234" "brightwhite"  ))
   (fg-alt     '("#0D0E16" "color-233" "brightwhite"  ))

   (black      '("#000000" "color-0"   "black"        ))

   (grey       base5)
   (grey-blue  '("#70a0d0" "color-110"  "brightblack" ))

   (red        '("#D80000" "color-160" "red"          ))
   (green      '("#66b600" "color-70"  "green"        ))
   (yellow     '("#AF8700" "color-136" "yellow"       ))
   (blue       '("#1177dd" "color-25"  "blue"         ))

   (magenta    '("#AE01E2" "color-125" "magenta"      ))
   (cyan       '("#007687" "color-30"  "cyan"         ))

   (orange     '("#F47300" "color-166" "brightred"    ))
   (teal       '("#009B7C" "color-36"  "brightgreen"  ))
   (violet     '("#8700AF" "color-91"  "brightmagenta"))
   (pink       '("#FF00AA" "color-91"  "brightmagenta"))

   (bg-blue    '("#d0eeff" "color-153"   "blue"         ))
   (dark-blue  '("#274aac" "color-25"    "blue"         ))
   (bg-cyan    '("#D5FAFF" "color-195"   "cyan"         ))
   (dark-cyan  bg-cyan)

   (blue-intense      '("#0000af" "color-19"  "blue"    ))
   (blue-pale         '("#0070c0" "color-214" "blue"    ))
   (blue-pale-dark    '("#0060a0" "color-24"  "blue"    ))

   (green-pale-bright '("#C9F0C4" "color-70"  "green"   ))
   (blue-pale-bright  '("#9EA2FF" "color-24"  "blue"    ))
   (red-pale-bright   '("#FF8787" "color-160" "red"     ))


;;;; face categories -- required for all themes
   (highlight      teal)
   (vertical-bar   base0)
   (selection      bg-blue)
   (builtin        pink)
   (comments       (if doom-kalisi-light-brighter-comments pink grey-blue))
   (doc-comments   (doom-darken (if doom-kalisi-light-brighter-comments pink grey-blue) 0.25))
   (constants      blue-intense)
   (functions      blue)
   (keywords       green)
   (methods        blue)
   (operators      dark-blue)
   (type           magenta)
   (strings        blue-pale-dark)
   (variables      black)
   (numbers        blue-pale)
   (region         pink)
   (error          red)
   (warning        orange)
   (success        green)
   (vc-modified    blue-pale-bright)
   (vc-added       green-pale-bright)
   (vc-deleted     red-pale-bright)

   ;; custom categories
   (hidden bg)
   (-modeline-dark doom-kalisi-light-brighter-modeline)
   (-modeline-bright -modeline-dark)
   (-modeline-pad
    (when doom-kalisi-light-padded-modeline
      (if (integerp doom-kalisi-light-padded-modeline) doom-kalisi-light-padded-modeline 4)))

   (modeline-fg     nil)
   (modeline-fg-alt base5)

   (modeline-bg
    (if -modeline-dark
        (doom-blend blue bg 0.35)
      `(,(car base3) ,@(cdr base0))))
   (modeline-bg-l
    (if -modeline-dark
        (doom-blend blue bg-alt 0.35)
      `(,(car base2) ,@(cdr base0))))
   (modeline-bg-inactive   `(,(doom-darken (car bg-alt) 0.2) ,@(cdr base0)))
   (modeline-bg-inactive-l (doom-darken bg 0.20)))

  ;;;; Base theme face overrides
  (((font-lock-comment-face &override)
    :slant 'italic
    :background (if doom-kalisi-light-comment-bg (doom-darken bg 0.05)))
   ((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground orange)
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis
    :foreground (if -modeline-dark base8 highlight))

   ;;;; elscreen
   (elscreen-tab-other-screen-face :background bg-blue :foreground fg-alt)
   ;;;; doom-modeline
   (doom-modeline-bar :background (if -modeline-dark modeline-bg highlight))
   (doom-modeline-buffer-file :inherit 'mode-line-buffer-id :weight 'bold)
   (doom-modeline-buffer-path :inherit 'mode-line-emphasis :weight 'bold)
   (doom-modeline-buffer-project-root :foreground green :weight 'bold)
   ;;;; doom-themes
   (doom-themes-treemacs-file-face :foreground comments)
   ;;;; comments and doc
   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property             :foreground green)
   (css-selector             :foreground blue)
   ;;;; Flycheck
   (flycheck-popup-tip-face :background bg-blue :foreground fg-alt)
   (flycheck-posframe-info-face :background bg-blue :foreground fg-alt)
   (flycheck-posframe-warning-face :inherit 'warning)
   (flycheck-posframe-error-face :inherit 'error)
   ;;;; Magit
   (magit-bisect-skip :foreground fg)
   (magit-blame-date :foreground green)
   (magit-blame-header :foreground green)
   (magit-blame-heading :foreground green)
   (magit-blame-name :foreground cyan)
   (magit-blame-sha1 :foreground cyan)
   (magit-blame-subject :foreground cyan)
   (magit-blame-summary :foreground cyan)
   (magit-blame-time :foreground green)
   (magit-branch :foreground magenta :weight 'bold)
   ((magit-branch-current &override) :weight 'bold :box t)
   (magit-branch-local :foreground blue :weight 'bold)
   (magit-branch-remote :foreground orange :weight 'bold)
   (magit-cherry-equivalent :foreground magenta)
   (magit-cherry-unmatched :foreground orange)
   (magit-diff-added :foreground green :weight 'light)
   (magit-diff-added-highlight :foreground green :weight 'bold)
   (magit-diff-base :foreground fg :weight 'light)
   (magit-diff-base-highlight :foreground fg :weight 'bold)
   (magit-diff-conflict-heading :foreground fg)
   (magit-diff-context :foreground fg :weight 'light)
   (magit-diff-context-highlight :foreground fg :weight 'bold)
   (magit-diff-file-header :foreground yellow)
   (magit-diff-file-heading :foreground blue :weight 'light)
   (magit-diff-file-heading-highlight :foreground blue :weight 'bold)
   (magit-diff-file-heading-selection :foreground blue :weight 'bold :background base1)
   (magit-diff-hunk-heading :foreground yellow :weight 'light)
   (magit-diff-hunk-heading-highlight :foreground yellow :weight 'bold)
   (magit-diff-hunk-heading-selection :inherit 'selection :weight 'bold)
   (magit-diff-lines-boundary :background fg :foreground base2)
   (magit-diff-lines-heading :background fg :foreground base2)
   (magit-diff-removed :foreground red :weight 'light)
   (magit-diff-removed-highlight :foreground red :weight 'bold)
   (magit-dimmed :foreground base8)
   (magit-hash :foreground cyan)
   (magit-item-highlight :background grey)
   (magit-log-author :foreground cyan)
   (magit-log-date :foreground fg-alt)
   (magit-log-graph :foreground fg-alt)
   (magit-log-head-label-head :background cyan :foreground bg-alt :weight 'bold)
   (magit-log-head-label-local :background red :foreground bg-alt :weight 'bold)
   (magit-log-head-label-remote :background green :foreground bg-alt :weight 'bold)
   (magit-log-head-label-tags :background magenta :foreground bg-alt :weight 'bold)
   (magit-log-head-label-wip :background yellow :foreground bg-alt :weight 'bold)
   (magit-log-sha1 :foreground green)
   (magit-process-ng :foreground orange :weight 'bold)
   (magit-process-ok :foreground cyan :weight 'bold)
   (magit-reflog-amend :foreground magenta)
   (magit-reflog-checkout :foreground blue)
   (magit-reflog-cherry-pick :foreground green)
   (magit-reflog-other :foreground yellow)
   (magit-reflog-rebase :foreground magenta)
   (magit-reflog-remote :foreground yellow)
   (magit-reflog-reset :foreground red)
   (magit-section-heading :foreground red)
   (magit-section-highlight :weight 'bold)
   (magit-section-title :background bg-alt :foreground red :weight 'bold)
   (magit-section-heading-selection :foreground red :weight 'bold)
   ;;;; magithub
   (magithub-ci-no-status :foreground grey)
   (magithub-issue-number :foreground fg)
   (magithub-notification-reason :foreground fg)
   ;;;; hl-fill-column-face
   (hl-fill-column-face :background bg-alt :foreground fg-alt)
   ;;;; ivy
   (ivy-current-match :background bg-blue :distant-foreground base0 :weight 'normal)
   (ivy-posframe :background base1 :foreground fg)
   (internal-border :background base7)
   ;;;; lsp-mode and lsp-ui-mode
   (lsp-ui-peek-highlight :foreground yellow)
   (lsp-ui-sideline-symbol-info :foreground (doom-blend comments bg 0.85)
                                :background bg-alt)
   ;;;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground red)
   ((markdown-code-face &override) :background (doom-lighten base3 0.05))
   ;;;; org <built-in>
   ((org-block &override) :background bg-alt)
   ((org-block-begin-line &override) :background bg :slant 'italic)
   ((org-quote &override) :background base1)
   (org-hide :foreground hidden)
   ;;;; solaire-mode
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l)))
   ;;;; treemacs
   (treemacs-root-face :foreground strings :weight 'bold :height 1.2)
   ;;;; whitespace <built-in>
   (whitespace-indentation :inherit 'default)
   (whitespace-big-indent :inherit 'default))

  ;;;; Base theme variable overrides-
  ;; ()
  )

;;; doom-kalisi-light-theme.el ends here

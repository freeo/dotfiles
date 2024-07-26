

Dark Mode Stuff. Doesn't work anymore, but learned some thing about dbus messagin while working with all of this

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

(setq local-config-dark-theme 'doom-gruvbox)
(setq local-config-light-theme 'kalisi-light)

(when (featurep 'dbus)
  (require 'dbus)


  (defun handler (value)
    (message "current value %s" (car (car value))))

  (defun signal-handler (namespace key value)
    (if (and
         ;; (string-equal namespace "org.freedesktop.appearance")
         (string-equal namespace "org.gnome.desktop.interface")
         (string-equal key "color-scheme"))
        (message "got new value: %s" (car value)) ;; debug
      (message "got new value: %s" value) ;; debug
      ;; (if (= (car value) 1)
      (setq durr (car value))  ;; using a temp variable lets me reuse it as often as I like
      ;; (if (string-equal (car value) "prefer-dark") ;; debug
      (if (string-equal durr "prefer-dark")
          (load-theme local-config-dark-theme t)
        (load-theme local-config-light-theme t))

      (if (string-equal durr "prefer-dark") ;; 2nd access test, debug
          (message "eq dark") ;; debug
        (message "eq light")) ;; debug
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

  ;; Requires xdg-portal-desktop which provides the DBus Interface
  ;; Also requires a backend, tested: xdg-portal-desktop-gtk
  (dbus-register-signal
   :session
   "org.freedesktop.portal.Desktop"
   "/org/freedesktop/portal/desktop"
   "org.freedesktop.portal.Settings"
   "SettingChanged"
   #'signal-handler)

  )


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

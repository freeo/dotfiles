;;; ../../dotfiles/config/doom/themes/example-name.el -*- lexical-binding: t; -*-
(autothemer-deftheme example-name "Autothemer example..."

  ;; Specify the color classes used by the theme
  ((((class color) (min-colors #xFFFFFF))
    ((class color) (min-colors #xFF)))

    ;; Specify the color palette for each of the classes above.
    (example-red    "#781210" "#FF0000")
    (example-green  "#22881F" "#00D700")
    (example-blue   "#212288" "#0000FF")
    (example-purple "#812FFF" "#Af00FF")
    (example-yellow "#EFFE00" "#FFFF00")
    (example-orange "#E06500" "#FF6600")
    (example-cyan   "#22DDFF" "#00FFFF"))

    ;; specifications for Emacs faces.
    ((button (:underline t :weight 'bold :foreground yellowish))
     (error  (:foreground reddish)))

    ;; Forms after the face specifications are evaluated.
    ;; (palette vars can be used, read below for details.)
    (custom-theme-set-variables 'example-name
        `(ansi-color-names-vector [,example-red
                                   ,example-green
                                   ,example-blue
                                   ,example-purple
                                   ,example-yellow
                                   ,example-orange
                                   ,example-cyan])))

(provide-theme 'example-name)

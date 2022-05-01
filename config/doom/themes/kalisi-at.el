(require 'autothemer)

(autothemer-deftheme kalisi-at "base from yt 'System Crafters'"

 ((((class color) (min-colors #xFFFFFF))) ;; We're only concerned with graphical Emacs

  ;; Define our color palette
  (kalisi-black      "#000000")
  (kalisi-white      "#ffffff")
  (kalisi-orange     "orange1")
  (kalisi-dk-orange  "#eb6123")
  (kalisi-purple     "MediumPurple2")
  (kalisi-dk-purple  "MediumPurple4")
  (kalisi-green      "LightGreen"))

 ;; Customize faces
 ((default                   (:foreground kalisi-white :background kalisi-black))
  (cursor                    (:background kalisi-dk-orange))
  (region                    (:background kalisi-dk-purple))
  (mode-line                 (:background kalisi-dk-purple))
  (font-lock-keyword-face    (:foreground kalisi-purple))
  (font-lock-constant-face   (:foreground kalisi-green))
  (font-lock-string-face     (:foreground kalisi-orange))
  (font-lock-builtin-face    (:foreground kalisi-green))

  (org-level-1               (:foreground kalisi-orange))))

(provide-theme 'kalisi-at)

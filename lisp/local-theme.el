;;; local-theme.el --- Local theme overrides

;;; Commentary:
;; Making things personal.

;;; Code:

(require 'tao-theme)

(deftheme local "Local theme overrides")

(tao-with-color-variables
  tao-theme-yang-palette

  ;;;
  ;; Theme Colors

  (defvar theme-color-error "tomato"
    "Color used to indicate error.")
  (defvar theme-color-success "sea green"
    "Color used to indicate success.")
  (defvar theme-color-warning color-11
    "Color used to indicate warning.")

  (defvar theme-color-highlight color-14
    "Color used to highlight elements.")
  (defvar theme-color-lighter color-3
    "Color used for less visible elements.")

  ;;;
  ;; Theme Faces

  (custom-theme-set-faces
   'local
   `(default                                 ((t (:height ,+default-font-height :family ,+fixed-pitch-font :weight light))))
   `(fixed-pitch                             ((t (:family ,+fixed-pitch-font :weight light))))
   `(variable-pitch                          ((t (:family ,+variable-pitch-font))))
   `(vertical-border                         ((t (:background ,color-7 :foreground ,color-7))))
   `(mode-line                               ((t (:family ,+variable-pitch-font :background ,color-5 :foreground ,color-12 :box (:line-width 4 :color ,color-5)))))
   `(mode-line-inactive                      ((t (:family ,+variable-pitch-font :background ,color-4 :foreground ,color-9 :box (:line-width 4 :color ,color-4)))))
   `(mode-line-buffer-id                     ((t (:foreground nil :bold t))))
   `(header-line-highlight                   ((t (:inherit mode-line-highlight))))
   `(line-number                             ((t (:inherit fixed-pitch))))
   `(line-number-current-line                ((t (:inherit line-number :background ,color-5 :foreground ,theme-color-highlight :bold t))))

   `(error                                   ((t (:foreground ,theme-color-error))))
   `(success                                 ((t (:foreground ,theme-color-success))))
   `(warning                                 ((t (:foreground ,theme-color-warning :bold t))))

   `(font-lock-keyword-face                  ((t (:foreground ,color-13))))
   `(font-lock-constant-face                 ((t (:foreground ,color-13 :weight normal))))
   `(font-lock-type-face                     ((t (:foreground ,color-10))))

   ;; comint
   `(comint-highlight-prompt                 ((t (:height 1.0))))
   ;; compile
   `(compilation-error                       ((t (:foreground ,theme-color-error))))
   `(compilation-warning                     ((t (:foreground ,theme-color-warning))))
   ;; ediff
   `(ediff-current-diff-A                    ((t (:background "#FFEEF0"))))
   `(ediff-fine-diff-A                       ((t (:background "#EECCCC"))))
   `(ediff-current-diff-B                    ((t (:background "#E6FFED"))))
   `(ediff-fine-diff-B                       ((t (:background "#CCEECC"))))
   `(ediff-current-diff-C                    ((t (:background "#F1F8FF"))))
   `(ediff-fine-diff-C                       ((t (:background "#DDEEFF"))))
   `(ediff-current-diff-Ancestor             ((t (:background "#FEE6FF"))))
   `(ediff-fine-diff-Ancestor                ((t (:background "#EEDDFF"))))
   ;; hl-line-mode
   `(hl-line                                 ((t (:foreground nil))))
   ;; org-mode
   `(org-document-title                      ((t (:height 2.2 :bold nil))))
   `(org-level-1                             ((t (:height 1.6 :bold nil :italic t))))
   `(org-level-2                             ((t (:height 1.4 :bold nil :italic t))))
   `(org-level-3                             ((t (:height 1.2 :bold nil :italic t))))
   `(org-level-4                             ((t (:height 1.0 :bold nil :italic t))))
   `(org-level-5                             ((t (:height 1.0 :bold nil :italic t))))
   `(org-level-6                             ((t (:height 1.0 :bold nil :italic t))))
   `(org-level-7                             ((t (:height 1.0 :bold nil :italic t))))
   `(org-level-8                             ((t (:height 1.0 :bold nil :italic t))))
   `(org-block                               ((t (:height 1.0 :inherit fixed-pitch :weight light))))
   `(org-block-background                    ((t (:height 1.0 :inherit fixed-pitch))))
   `(org-block-begin-line                    ((t (:foreground ,color-7))))
   `(org-checkbox                            ((t (:inherit fixed-pitch))))
   `(org-code                                ((t (:inherit fixed-pitch :background ,color-5 :foreground ,color-9))))
   `(org-formula                             ((t (:inherit fixed-pitch))))
   `(org-hide                                ((t (:inherit fixed-pitch))))
   `(org-meta-line                           ((t (:inherit fixed-pitch))))
   `(org-property-value                      ((t (:inherit fixed-pitch))))
   `(org-table                               ((t (:inherit fixed-pitch))))
   `(org-verbatim                            ((t (:inherit fixed-pitch))))
   ;; whitespace
   `(whitespace-space                        ((t (:background nil :family ,+fixed-pitch-font))))
   ;; window-divider
   `(window-divider                          ((t (:inherit 'vertical-border))))
   `(window-divider-first-pixel              ((t (:inherit 'window-divider))))
   `(window-divider-last-pixel               ((t (:inherit 'window-divider))))

   ;; cargo
   `(cargo-process--standard-face            ((t (:foreground nil))))
   `(cargo-process--ok-face                  ((t (:foreground ,theme-color-success))))
   `(cargo-process--error-face               ((t (:foreground ,theme-color-error))))
   `(cargo-process--warning-face             ((t (:foreground ,theme-color-warning))))
   ;; company
   `(company-tooltip                         ((t (:family ,+variable-pitch-font))))
   `(company-tooltip-search                  ((t (:bold t))))
   `(company-tooltip-search-selection        ((t (:bold t))))
   ;; eros
   `(eros-result-overlay-face                ((t (:background ,color-5 :foreground ,color-9 :box nil))))
   ;; indent-guide
   `(indent-guide-face                       ((t (:inherit fringe))))
   ;; js2-mode
   `(js2-error                               ((t (:inherit flycheck-error))))
   `(js2-warning                             ((t (:inherit flycheck-warning))))
   ;; lsp-mode
   `(lsp-face-highlight-textual              ((t (:background nil :box (:line-width 1 :color ,theme-color-warning)))))
   `(lsp-face-highlight-read                 ((t (:background nil :box (:line-width 1 :color ,theme-color-error)))))
   `(lsp-face-highlight-write                ((t (:background nil :box (:line-width 1 :color ,theme-color-success)))))
   ;; lsp-ui
   `(lsp-ui-peek-peek                        ((t (:background nil))))
   `(lsp-ui-peek-list                        ((t (:background nil))))
   `(lsp-ui-peek-filename                    ((t (:foreground ,color-10))))
   `(lsp-ui-peek-line-number                 ((t (:foreground ,color-9))))
   `(lsp-ui-peek-highlight                   ((t (:box (:line-width 1 :color ,color-10)))))
   `(lsp-ui-peek-selection                   ((t (:background ,color-5))))
   `(lsp-ui-peek-header                      ((t (:inherit header-line))))
   `(lsp-ui-peek-footer                      ((t (:inherit header-line))))
   ;; flycheck
   `(flycheck-error                          ((t (:underline (:color ,theme-color-error)))))
   `(flycheck-warning                        ((t (:underline (:color ,theme-color-warning)))))
   `(flycheck-fringe-error                   ((t (:foreground ,theme-color-error))))
   `(flycheck-fringe-warning                 ((t (:foreground ,theme-color-warning))))
   ;; nav-flash
   `(nav-flash-face                          ((t (:background ,color-5))))
   ;; markdown
   `(markdown-header-face                    ((t (:weight normal :italic t :foreground ,color-14))))
   `(markdown-header-face-1                  ((t (:height 2.2))))
   `(markdown-header-face-2                  ((t (:height 1.6))))
   `(markdown-header-face-3                  ((t (:height 1.4 :underline nil))))
   `(markdown-header-face-4                  ((t (:height 1.2 :underline nil))))
   `(markdown-header-face-5                  ((t (:height 1.0 :underline nil))))
   `(markdown-header-face-6                  ((t (:height 1.0 :underline nil))))
   `(markdown-hr-face                        ((t (:inherit fixed-pitch :height ,+default-font-height))))
   `(markdown-pre-face                       ((t (:inherit org-verbatim :height 1.0 :background ,color-5 :foreground ,color-9))))
   `(markdown-code-face                      ((t (:inherit org-code :background ,color-5 :foreground ,color-9))))
   `(markdown-inline-code-face               ((t (:inherit fixed-pitch :background ,color-5 :foreground ,color-9))))
   `(markdown-gfm-checkbox-face              ((t (:inherit org-checkbox))))
   ;; org-tree-slide
   `(org-tree-slide-header-overlay-face      ((t (:inherit header-line :background nil))))
   ;; perspeen
   `(perspeen-selected-face                  ((t (:bold t))))
   ;; rainbow-delimiters
   `(rainbow-delimiters-unmatched-face       ((t (:foreground ,theme-color-error :bold t))))
   ;; rst
   `(rst-level-1                             ((t (:weight normal :italic t))))
   `(rst-level-2                             ((t (:weight normal :italic t))))
   `(rst-level-3                             ((t (:weight normal :italic t))))
   `(rst-level-4                             ((t (:weight normal :italic t))))
   `(rst-level-5                             ((t (:weight normal :italic t))))
   `(rst-level-6                             ((t (:weight normal :italic t))))
   `(rst-literal                             ((t (:inherit fixed-pitch))))
   ;; shm
   `(shm-current-face                        ((t (:inherit hl-line))))
   `(shm-quarantine-face                     ((t (:background "#FFEEF0"))))
   ;; smartparens
   `(sp-show-pair-match-face                 ((t (:foreground ,color-11 :bold t))))
   `(sp-show-pair-mismatch-face              ((t (:foreground ,theme-color-error :bold t))))
   ;; spray
   `(spray-base-face                         ((t (:foreground ,color-10 :family "Noto Serif" :weight normal :underline nil))))
   `(spray-accent-face                       ((t (:foreground ,theme-color-error :underline (:color ,color-10) :overline ,color-10))))
   ;; stripe-buffer
   `(stripe-highlight                        ((t (:background ,color-5))))
   ;; web-mode
   `(web-mode-current-element-highlight-face ((t (:background nil :foreground nil :bold t))))
   ;; which-key
   `(which-key-local-map-description-face    ((t (:bold t))))
   ;; quick-peek
   `(quick-peek-border-face                  ((t (:background ,color-5 :height 0.1 :box (:line-width 1 :color ,color-7)))))
   `(quick-peek-padding-face                 ((t (:height 0.1)))))

  ;;;
  ;; Theme Variables

  (custom-theme-set-variables
   'local
   `(line-spacing ,+line-spacing)
   ;; beacon
   `(beacon-color ,color-5)
   ;; coverlay
   `(coverlay:untested-line-background-color "#FFEEF0")
   `(coverlay:tested-line-background-color   "#E6FFED")
   ;; hl-todo
   `(hl-todo-keyword-faces
     `(("TODO"  . (:box (:line-width 1) :foreground ,theme-color-warning))
       ("FIXME" . (:box (:line-width 1) :foreground ,theme-color-error))
       ("NOTE"  . (:box (:line-width 1)))))
   ;; lsp-ui
   `(lsp-ui-doc-background ,color-5)
   `(lsp-ui-doc-border     ,color-4)
   ;; markdown-mode
   `(markdown-header-scaling-values
     '(2.2 1.6 1.4 1.2 1.0 1.0))
   ;; rainbow-identifiers
   `(rainbow-identifiers-cie-l*a*b*-saturation 65)
   `(rainbow-identifiers-cie-l*a*b*-lightness 45)
   ;; rst-mode
   `(rst-header-scaling-values
     '(2.2 1.6 1.4 1.2 1.0 1.0))
   ;; vc-annotate
   `(vc-annotate-color-map
     '(( 20. . ,color-2)
       ( 40. . ,color-3)
       ( 60. . ,color-3)
       ( 80. . ,color-4)
       (100. . ,color-4)
       (120. . ,color-5)
       (140. . ,color-5)
       (160. . ,color-6)
       (180. . ,color-6)
       (200. . ,color-6)
       (220. . ,color-7)
       (240. . ,color-7)
       (260. . ,color-7)
       (280. . ,color-8)
       (300. . ,color-8)
       (320. . ,color-8)
       (340. . ,color-9)
       (360. . ,color-9)))
   ;; zoom-window
   `(zoom-window-mode-line-color (face-background 'mode-line))))

;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))

(provide-theme 'local)
;;; local-theme.el ends here

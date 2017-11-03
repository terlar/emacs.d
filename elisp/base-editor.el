;;; base-editor.el --- Editor configuration

;;; Commentary:
;; Defining the behavior of things.

;;; Code:
(require 'base-vars)
(require 'base-lib)

;;;
;; Settings
(setq-default
 vc-follow-symlinks t
 ;; Save clipboard contents into kill-ring before replacing them
 save-interprogram-paste-before-kill t
 ;; Bookmarks
 bookmark-default-file (concat my-cache-dir "bookmarks")
 bookmark-save-flag t
 ;; Formatting
 delete-trailing-lines nil
 fill-column 80
 sentence-end-double-space nil
 ;; Scrolling
 hscroll-margin 1
 hscroll-step 1
 scroll-conservatively 1001
 scroll-margin 0
 scroll-preserve-screen-position t
 ;; White-space
 indent-tabs-mode nil
 require-final-newline t
 tab-always-indent t
 tab-width 4
 tabify-regexp "^\t* [ \t]+"
 whitespace-line-column fill-column
 whitespace-style
 '(face tabs tab-mark spaces space-mark trailing lines-tail)
 whitespace-display-mappings
 '((tab-mark ?\t [?› ?\t])
   (newline-mark 10 [?¬ 10])
   (space-mark 32 [183] [46]))
 ;; Give the text some space
 line-spacing 0.2
 ;; Wrapping
 truncate-lines nil
 truncate-partial-width-windows 50
 word-wrap t)

;;;
;; Built-ins

;; Revert buffers for changed files
(require 'autorevert)
(diminish 'auto-revert-mode)
(setq auto-revert-verbose nil)
(global-auto-revert-mode +1)

;; Save point across sessions
(require 'saveplace)
(setq save-place-file (concat my-cache-dir "saveplace"))
(save-place-mode +1)

;; Save history across sessions
(require 'savehist)
(setq savehist-file (concat my-cache-dir "savehist")
      savehist-save-minibuffer-history t
      ;; Save on kill only
      savehist-autosave-interval nil
      savehist-additional-variables '(search-ring regexp-search-ring))
(savehist-mode +1)

;; Keep track of recently opened files
(require 'recentf)
(setq recentf-save-file (concat my-cache-dir "recentf")
      recentf-exclude
      (list "/tmp/"           ; Temp-files
            "/dev/shm"        ; Potential secrets
            "/ssh:"           ; Files over SSH
            "/TAGS$"          ; Tag files
            "/\\.git/.*\\'"   ; Git contents
            "\\.?ido\\.last$"
            "\\.revive$"
            "^/var/folders/.+$"
            my-data-dir)
      recentf-max-menu-items 0
      recentf-max-saved-items 250
      recentf-filename-handlers '(abbreviate-file-name))
(quiet! (recentf-mode +1))

;; Undo/redo window layout changes
(require 'winner)

;; Ediff: use existing frame instead of creating a new one
(use-package ediff
  :commands (ediff-copy-diff
             ediff-get-region-contents
             ediff-setup-windows-plain)
  :preface
  (defun ediff-copy-both-to-C ()
    "Copy change from both A and B to C."
    (interactive)
    (ediff-copy-diff
     ediff-current-difference nil 'C nil
     (concat
      (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
      (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))
  :init
  (setq ediff-diff-options "-w"
        ediff-split-window-function #'split-window-horizontally
        ediff-merge-split-window-function #'split-window-horizontally
        ;; No extra frames
        ediff-window-setup-function #'ediff-setup-windows-plain)
  (add-hooks-pair 'ediff-quit 'winner-undo))

;; Smart expansion completions
(require 'hippie-exp)
(setq hippie-expand-try-functions-list
      '(;; Try to expand word "dynamically", searching the current buffer.
        try-expand-dabbrev
        ;; Try to expand word "dynamically", searching all other buffers.
        try-expand-dabbrev-all-buffers
        ;; Try to expand word "dynamically", searching the kill ring.
        try-expand-dabbrev-from-kill
        ;; Try to complete text as a file name, as many characters as unique.
        try-complete-file-name-partially
        ;; Try to complete text as a file name.
        try-complete-file-name
        ;; Try to expand word before point according to all abbrev tables.
        try-expand-all-abbrevs
        ;; Try to complete the current line to an entire line in the buffer.
        try-expand-list
        try-expand-line
        ;; Try to complete as an Emacs Lisp symbol, as many characters as unique.
        try-complete-lisp-symbol-partially
        ;; Try to complete word as an Emacs Lisp symbol.
        try-complete-lisp-symbol))

(defun my|dont-kill-scratch-buffer ()
  "Don't kill scratch buffers."
  (or (not (string= (buffer-name) "*scratch*"))
      (ignore (bury-buffer))))
(add-hook 'kill-buffer-query-functions #'my|dont-kill-scratch-buffer)

;; Make scripts executable on save
(add-hook 'after-save-hook #'executable-make-buffer-file-executable-if-script-p)

;; Automatic indentation
(electric-indent-mode +1)

;;;
;; Packages

;; Automatic indentation as you type
(use-package aggressive-indent
  :diminish aggressive-indent-mode
  :commands (aggressive-indent-mode global-aggressive-indent-mode)
  :init
  (global-aggressive-indent-mode +1)
  :config
  ;; Disabled modes
  (dolist (mode '(diff-auto-refine-mode))
    (push mode aggressive-indent-excluded-modes))

  ;; Disabled commands
  (dolist (command '(evil-undo-pop
                     ws-butler-clean-region))
    (push command aggressive-indent-protected-commands)))

;; Delete selection upon insertion or DEL
(use-package delsel :demand t
  :config (delete-selection-mode +1))

;; Handles white-space (tabs/spaces) settings externally. This way projects can
;; specify their own formatting rules.
(use-package editorconfig :demand t
  :diminish editorconfig-mode
  :mode ("\\.?editorconfig$" . editorconfig-conf-mode)
  :config (editorconfig-mode +1))

;; Ignore files
(use-package ignoramus :demand t
  :config
  ;; Ignore some additional directories
  (dolist (name '("node_modules" "vendor"))
    (push name ignoramus-file-basename-exact-names))

  (ignoramus-setup))

;; Auto-close delimiters and blocks as you type
(use-package smartparens :demand t
  :diminish smartparens-mode
  :commands (sp-pair sp-local-pair)
  :init
  (setq-default
   sp-autowrap-region nil ; Let evil-surround handle this
   sp-highlight-pair-overlay nil
   sp-cancel-autoskip-on-backward-movement nil
   sp-show-pair-delay 0
   sp-max-pair-length 3)
  :config
  (add-hooks-pair 'after-init 'smartparens-global-mode)
  (require 'smartparens-config)
  ;; Smartparens interferes with Replace mode
  (add-hooks-pair 'evil-replace-state-entry 'turn-off-smartparens-mode)
  (add-hooks-pair 'evil-replace-state-exit  'turn-on-smartparens-mode)

  ;; Auto-close more conservatively
  (sp-pair "'" nil
           :unless '(sp-point-before-word-p sp-point-after-word-p sp-point-before-same-p))
  (sp-pair "\"" nil
           :unless '(sp-point-before-word-p sp-point-after-word-p sp-point-before-same-p))
  (sp-pair "{" nil :post-handlers '(("||\n[i]" "RET") ("| " " "))
           :unless '(sp-point-before-word-p sp-point-before-same-p))
  (sp-pair "(" nil :post-handlers '(("||\n[i]" "RET") ("| " " "))
           :unless '(sp-point-before-word-p sp-point-before-same-p))
  (sp-pair "[" nil :post-handlers '(("| " " "))
           :unless '(sp-point-before-word-p sp-point-before-same-p))

  (sp-local-pair
   'css-mode "/*" "*/" :post-handlers '(("[d-3]||\n[i]" "RET") ("| " "SPC")))
  (sp-local-pair '(sh-mode markdown-mode) "`" nil
                 :unless '(sp-point-before-word-p sp-point-before-same-p))
  (sp-local-pair '(xml-mode nxml-mode php-mode)
                 "<!--" "-->"   :post-handlers '(("| " "SPC"))))

;; Treat camel-case and snake-case words as separate words
(use-package subword
  :diminish subword-mode
  :commands subword-mode)

;; Save buffers when focus is lost
(use-package super-save :demand t
  :diminish super-save-mode
  :config (super-save-mode +1))

;; Branching & persistent undo
(use-package undo-tree :demand t
  :diminish undo-tree-mode
  :commands (undo-tree-mode
             undo-tree-load-history-hook)
  :preface
  (defun my|silence-undo-tree-load (orig-fn &rest args)
    "Silence undo-tree load errors."
    (quiet! (apply orig-fn args)))
  :config
  (global-undo-tree-mode +1)
  (setq undo-tree-auto-save-history t
        undo-tree-history-directory-alist
        (list (cons "." (concat my-cache-dir "undo-tree-hist/")))
        undo-tree-visualizer-diff t
        undo-tree-visualizer-timestamps t)
  (advice-add #'undo-tree-load-history-hook :around #'my|silence-undo-tree-load))

;; Delete trailing white-space before save
(use-package ws-butler
  :diminish ws-butler-mode
  :commands ws-butler-mode
  :preface
  (defun my|trim-trailing-whitespace (props)
    "Use ws-butler mode instead of delete-trailing-whitespace."
    (if (not (equal (gethash 'trim_trailing_whitespace props) "true"))
        (ws-butler-mode -1)
      (setq write-file-functions
            (delete 'delete-trailing-whitespace write-file-functions))
      (ws-butler-mode +1)))
  :init
  (with-eval-after-load "editorconfig"
    (add-hook 'editorconfig-custom-hooks #'my|trim-trailing-whitespace)))

;;;
;; Auto-loaded Packages

;; Hint mode for links
(use-package ace-link
  :commands (ace-link-help
             ace-link-org))

;; Fast window navigation
(use-package ace-window
  :commands (ace-window
             ace-swap-window ace-delete-window
             ace-select-window ace-delete-other-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
        aw-scope 'frame
        aw-background t))

;; Jump to things
(use-package avy
  :commands (avy-goto-char-2
             avy-goto-line)
  :config
  (setq avy-all-windows nil
        avy-background t))

;; Bug references as buttons (builtin)
(use-package bug-reference
  :init
  (add-hooks-pair 'prog-mode 'bug-reference-prog-mode)
  (add-hooks-pair '(text-mode magit-log-mode)
                  'bug-reference-mode))

;; Use GitHub URL for bug reference
(use-package bug-reference-github
  :commands bug-reference-github-set-url-format
  :init
  (add-hooks-pair '(bug-reference-mode bug-reference-prog-mode)
                  'bug-reference-github-set-url-format))

;; Selection helper
(use-package expand-region
  :commands (er/expand-region
             er/contract-region
             er/mark-symbol
             er/mark-word))

;; Move point through buffer-undo-list positions
(use-package goto-last-change :commands goto-last-change)

;; Improved help commands
(use-package help-fns+
  :commands (describe-buffer
             describe-command describe-file
             describe-keymap describe-option describe-option-of-type))

(use-package imenu-anywhere
  :commands (ido-imenu-anywhere ivy-imenu-anywhere helm-imenu-anywhere))

(use-package imenu-list :commands imenu-list-minor-mode)

;; Convert between regexp syntax
(use-package pcre2el :commands rxt-quote-pcre)

;; Display colors
(use-package rainbow-mode :commands rainbow-mode)

;; Semantic navigation
(use-package smart-forward
  :commands (smart-up smart-down smart-backward smart-forward))

;; Peek definition (Display function source inline)
(use-package source-peek :ensure nil :pin manual :demand t
  :load-path "vendor/source-peek/"
  :commands source-peek)

;; Utility for opening files with sudo
(use-package sudo-edit :commands sudo-edit)

;; Writable grep buffer and apply the changes to files
(use-package wgrep
  :commands (wgrep-setup wgrep-change-to-wgrep-mode)
  :config (setq wgrep-auto-save-buffer t))

(use-package zoom-window :commands zoom-window-zoom)

(provide 'base-editor)
;;; base-editor.el ends here

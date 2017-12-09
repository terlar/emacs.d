;;; feature-evil.el --- Extensible vi layer -*- lexical-binding: t; -*-

;;; Commentary:
;; The way of the vi!

;;; Code:

(eval-when-compile
  (require 'base-package)
  (require 'base-keybinds)

  (defvar buffer-face-mode))

;; Escape hooks
(defvar my-evil-esc-hook '(t)
  "A hook run after ESC is pressed in normal mode.
E.g. invoked by `evil-force-normal-state'.
If a hook returns non-nil, all hooks after it are ignored.")

(defvar-local evil-pre-insert-state-variable-pitch-mode
  "Hold original `variable-pitch-mode'.")

;;;
;; Packages

(use-package evil
  :demand t
  :hook
  (after-change-major-mode . +evil-init-state-entry-functions)
  (evil-insert-state-entry . +evil-insert-state-entry-run-functions)
  (evil-normal-state-entry . +evil-normal-state-entry-run-functions)
  :preface
  (defun +evil-init-state-entry-functions ()
    "Initialize evil state entry functions."
    (when-let* ((plist (cdr (assq major-mode evil-state-entry-functions-mode-alist))))
      (setq-local evil-state-entry-functions plist)))

  (defun +evil-insert-state-entry-run-functions ()
    (let ((fn (plist-get evil-state-entry-functions :on-insert)))
      (when (functionp fn) (funcall fn))))

  (defun +evil-normal-state-entry-run-functions ()
    (let ((fn (plist-get evil-state-entry-functions :on-normal)))
      (when (functionp fn) (funcall fn))))
  :init
  (setq evil-mode-line-format '(before . mode-line-front-space)
        evil-want-C-u-scroll t
        evil-want-visual-char-semi-exclusive t
        evil-magic t
        evil-echo-state t
        evil-indent-convert-tabs t
        evil-ex-search-vim-style-regexp t
        evil-ex-substitute-global t
        evil-symbol-word-search t
        ;; Column range for ex commands
        evil-ex-visual-char-range t
        evil-insert-skip-empty-lines t)

  ;; evil-want-Y-yank-to-eol must be set via customize to have an effect
  (customize-set-variable 'evil-want-Y-yank-to-eol t)
  :config
  ;; Use Emacs key-map for insert state.
  (setq evil-insert-state-map (make-sparse-keymap))
  (define-key evil-insert-state-map (kbd "<escape>") 'evil-normal-state)

  ;; Default modes
  (set-evil-state '(calendar-mode
                    comint-mode
                    git-rebase-mode
                    grep-mode
                    image-mode
                    special-mode
                    tabulated-list-mode
                    term-mode
                    view-mode)
                  'emacs)
  (set-evil-state 'git-commit-mode 'insert)
  (set-evil-state '(debugger-mode
                    dired-mode
                    elisp-refs-mode
                    help-mode
                    imenu-list-major-mode
                    messages-buffer-mode
                    Man-mode
                    package-menu-mode
                    process-menu-mode
                    vc-annotate-mode
                    xref--xref-buffer-mode)
                  'motion)

  (evil-mode 1))

;; Magit integration
(use-package evil-magit
  :demand t
  :after (evil magit)
  :init
  (setq evil-magit-want-horizontal-movement t))

;; Comment/uncomment lines
(use-package evil-commentary
  :diminish evil-commentary-mode
  :commands
  (evil-commentary
   evil-commentary-yank
   evil-commentary-line))

;; Improved % matching
(use-package evil-matchit
  :commands evilmi-jump-items
  :general
  ([remap evil-jump-item] 'evilmi-jump-items))

;; Quoting/parenthesizing
(use-package evil-surround
  :commands
  (evil-surround-edit
   evil-Surround-edit
   evil-surround-region))
(use-package evil-embrace
  :demand t
  :init
  (setq evil-embrace-show-help-p nil)
  :config
  (evil-embrace-enable-evil-surround-integration))

;;;
;; Autoloads

;;;###autoload
(defun +evil-visual-indent ()
  "Visual indentation restore selection after operation."
  (interactive)
  (evil-shift-right (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

;;;###autoload
(defun +evil-visual-outdent ()
  "Visual outdentation restore selection after operation."
  (interactive)
  (evil-shift-left (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

;;;###autoload
(defun +evil-reselect-paste ()
  "Go back into visual mode and reselect the last pasted region."
  (interactive)
  (destructuring-bind (_ _ _ beg end) evil-last-paste
    (evil-visual-make-selection
     (save-excursion (goto-char beg) (point-marker))
     end)))

;;;###autoload
(defun +evil-insert-state-disable-variable-pitch-mode ()
  "Disable `variable-pitch-mode' and store original value."
  (interactive)
  (setq evil-pre-insert-state-variable-pitch-mode buffer-face-mode)
  (variable-pitch-mode 0))

;;;###autoload
(defun +evil-insert-state-restore-variable-pitch-mode ()
  "Restore `variable-pitch-mode' from original value."
  (interactive)
  (when evil-pre-insert-state-variable-pitch-mode
    (variable-pitch-mode 1)))

(provide 'feature-evil)
;;; feature-evil.el ends here
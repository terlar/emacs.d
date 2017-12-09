;;; lang-markdown.el --- Markdown -*- lexical-binding: t; -*-

;;; Commentary:
;; Markdown is a lightweight markup language with plain text formatting syntax.

;;; Code:

(eval-when-compile
  (require 'base-package)
  (require 'base-lib))

;;;
;; Packages

(use-package markdown-mode
  :mode
  "\\.markdown$"
  "\\.md$"
  "/README$"
  ("/README\\.md$" . gfm-mode)
  :hook
  (markdown-mode . auto-fill-mode)
  (markdown-mode . readable-mode)
  :preface
  (defun +markdown-mode-on-insert-state-entry ()
    (markdown-toggle-markup-hiding 0))
  (defun +markdown-mode-on-normal-state-entry ()
    (markdown-toggle-markup-hiding 1))
  :init
  (setq
   markdown-command
   "pandoc -f markdown -t html5 -s --self-contained --smart"
   markdown-enable-math t
   markdown-enable-wiki-links t
   markdown-fontify-code-blocks-natively t
   markdown-hide-markup t
   markdown-italic-underscore t
   markdown-make-gfm-checkboxes-buttons t)

  (customize-set-variable 'markdown-header-scaling t)
  :config
  (set-evil-state-entry
   '(markdown-mode gfm-mode)
   :on-insert #'+markdown-mode-on-insert-state-entry
   :on-normal #'+markdown-mode-on-normal-state-entry))

(use-package edit-indirect)

(use-package markdown-toc
  :commands
  (markdown-toc-generate-toc
   markdown-toc-refresh-toc))

(provide 'lang-markdown)
;;; lang-markdown.el ends here
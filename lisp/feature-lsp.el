;;; feature-lsp.el --- Language Server Protocol -*- lexical-binding: t; -*-

;;; Commentary:
;; Servant of languages.

;;; Code:

(eval-when-compile
  (require 'base-vars)
  (require 'base-package))

(use-package lsp-mode
  :demand t
  :hook (lsp-mode . flycheck-mode)
  :init
  (setq lsp-enable-eldoc t)
  :config
  (require 'lsp-flycheck))

(use-package company-lsp
  :requires company
  :commands company-lsp
  :init
  (setq company-lsp-async t)
  (with-eval-after-load "company"
    (push 'company-lsp company-backends)))

(provide 'feature-lsp)
;;; feature-lsp.el ends here
;;; feature-jump.el --- Jump to definition

;;; Commentary:
;; Go to the source.

;;; Code:
(require 'base-vars)

;; Recenter after certain jumps
(dolist (hook '(imenu-after-jump-hook
                evil-jumps-post-jump-hook
                counsel-grep-post-action-hook
                dumb-jump-after-jump-hook))
  (add-hook hook #'recenter))

(use-package dumb-jump
  :commands (dumb-jump-go dumb-jump-quick-look dumb-jump-back)
  :config
  (setq dumb-jump-default-project my-emacs-dir
        dumb-jump-aggressive nil
        dumb-jump-selector (cond ((eq my-completion-system 'ivy) 'ivy)
                                 ((eq my-completion-system 'helm) 'helm)
                                 (t 'popup))))

(use-package gxref
  :commands (gxref-xref-backend
             gxref-create-db
             gxref-update-db
             gxref-single-update-db
             gxref-set-project-dir)
  :init
  (setq-default xref-backend-functions '(gxref-xref-backend t)))

(provide 'feature-jump)
;;; feature-jump.el ends here
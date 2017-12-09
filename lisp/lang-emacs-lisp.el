;;; lang-emacs-lisp.el --- Emacs Lisp -*- lexical-binding: t; -*-

;;; Commentary:
;; Emacs Lisp is a dialect of the Lisp programming language used as a scripting
;; language by Emacs (a text editor family most commonly associated with GNU
;; Emacs.

;;; Code:

(eval-when-compile
  (require 'base-lib)
  (require 'base-package))

(autoload 'eir-eval-in-ielm "eval-in-repl-ielm")

(add-to-list 'auto-mode-alist '("recipes/.*$" . emacs-lisp-mode))

(set-repl-command 'emacs-lisp-mode #'elisp-repl)
(set-eval-command 'emacs-lisp-mode #'eir-eval-in-ielm)
(set-doc-fn 'emacs-lisp-mode #'helpful-at-point)
(with-eval-after-load "smart-jump"
  (smart-jump-register :modes 'emacs-lisp-mode))

(set-prettify-symbols 'emacs-lisp-mode '(("defun"    . ?ƒ)
                                         ("defmacro" . ?μ)
                                         ("defvar"   . ?ν)))

(set-evil-state 'checkdoc-output-mode 'motion)
(set-popup-buffer (rx bos "*ielm*" eos)
                  (rx bos "*Style Warnings*" eos))

;;;
;; Packages

(use-package auto-compile
  :commands auto-compile-byte-compile
  :hook
  (emacs-lisp-mode . auto-compile-on-load-mode)
  (emacs-lisp-mode . auto-compile-on-save-mode)
  :init
  (setq auto-compile-display-buffer nil
        auto-compile-use-mode-line nil)
  :config
  (defun +emacs-lisp-load-after-compile (success)
    "Reload the current emacs-lisp file after it's recompiled, if an older
version is loaded."
    (when (eq success t)
      (let ((buffer-path (file-truename buffer-file-name)))
        (when (assoc buffer-path load-history)
          (load-file buffer-path)))))
  (advice-add #'auto-compile-byte-compile :filter-return #'+emacs-lisp-load-after-compile))

(use-package highlight-quoted
  :hook (emacs-lisp-mode . highlight-quoted-mode))

;; Evaluation result overlays.
(use-package eros
  :hook (emacs-lisp-mode . eros-mode))

;; Emacs Start Up Profiler
(use-package esup
  :commands esup
  :config
  (set-evil-state 'esup-mode 'motion)
  (set-popup-buffer (rx bos "*esup*" eos)))

;;;
;; Autoloads

;;;###autoload
(defun elisp-repl ()
  "Open the Emacs Lisp REPL (`ielm')."
  (interactive)
  (open-and-switch-to-buffer #'ielm "*ielm*" t))

(provide 'lang-emacs-lisp)
;;; lang-emacs-lisp.el ends here
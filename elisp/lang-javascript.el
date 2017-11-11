;;; lang-javascript.el --- JavaScript -*- lexical-binding: t; -*-

;;; Commentary:
;; JavaScript, often abbreviated as "JS", is a high-level, dynamic, untyped,
;; object-based, multi-paradigm, and interpreted programming language.

;;; Code:

(eval-when-compile
  (require 'base-keybinds)

  (defvar flycheck-disabled-checkers)
  (defvar editorconfig-indentation-alist))

(autoload 'push-repl-command "base-lib")

;;;
;; Packages

(use-package js2-mode
  :mode
  "\\.js$"
  ("\\.json$" . js2-jsx-mode)
  :interpreter
  "node"
  "nodejs"
  :general
  (:keymaps 'js2-mode-map "M-." '(nil))
  :preface
  (defun javascript-repl ()
    "Open a JavaScript REPL."
    (interactive)
    (pop-to-buffer
     (or (get-buffer "*nodejs*")
         (progn (nodejs-repl)
                (let ((buf (get-buffer "*nodejs*")))
                  (bury-buffer buf)
                  buf)))))

  (defun coverlay-mode-enable ()
    "Turn on `coverlay-mode'."
    (coverlay-mode +1)
    (unless (bound-and-true-p coverlay--loaded-filepath)
      (coverlay-watch-file (concat
                            (locate-dominating-file (file-name-directory buffer-file-name) "coverage")
                            "coverage"
                            "/lcov.info"))))
  :init
  (add-hooks-pair 'js2-mode
                  '(flycheck-mode
                    rainbow-delimiters-mode
                    coverlay-mode-enable
                    (lambda ()
                      (run-with-idle-timer 0.2 t 'color-identifiers:refresh))))

  (with-eval-after-load "editorconfig"
    (add-to-list 'editorconfig-indentation-alist
                 '(js2-mode js2-basic-offset js-switch-indent-offset)))
  :config
  (push-repl-command 'js2-mode #'javascript-repl)

  (setq js2-highlight-external-variables nil
        js2-mode-show-parse-errors nil
        js2-skip-preprocessor-directives t
        js2-strict-trailing-comma-warning nil))

(req-package lsp-javascript-typescript
  :require lsp-mode
  :loader :el-get
  :commands lsp-javascript-typescript-enable
  :config
  (add-hooks-pair '(js2-mode rjsx-mode typescript-mode) 'lsp-javascript-typescript-enable)

  (with-eval-after-load "flycheck"
    (flycheck-add-next-checker 'lsp 'javascript-eslint 'append)))

(use-package js2-refactor
  :after js2-mode
  :general
  (:keymaps 'js2-mode-map
            "C-k" '(js2r-kill))
  :commands
  (js2-refactor-mode
   js2r-add-keybindings-with-prefix js2r-kill
   js2r-extract-function js2r-extract-method js2r-introduce-parameter
   js2r-localize-parameter js2r-expand-object js2r-contract-object
   js2r-expand-function js2r-contract-function js2r-expand-array
   js2r-contract-array js2r-wrap-buffer-in-iife js2r-inject-global-in-iife
   js2r-add-to-globals-annotation js2r-extract-var js2r-inline-var
   js2r-rename-var js2r-var-to-this js2r-arguments-to-object js2r-ternary-to-if
   js2r-split-var-declaration js2r-split-string js2r-unwrap js2r-log-this
   js2r-debug-this js2r-forward-slurp js2r-forward-barf)
  :preface
  (defun setup-js2-refactor-keybinding-prefix ()
    "Setup keybindings for js2-refactor."
    (js2r-add-keybindings-with-prefix "C-c c R"))
  :init
  (add-hooks-pair 'js2-mode
                  '(js2-refactor-mode
                    setup-js2-refactor-keybinding-prefix)))

(use-package nodejs-repl :commands nodejs-repl)

(use-package indium)

(use-package rjsx-mode
  :mode
  ("\\.jsx$"             . rjsx-mode)
  ("components/.+\\.js$" . rjsx-mode)
  :commands rjsx-mode
  :general
  (:keymaps 'rjsx-mode-map
            "<"   '(nil)
            "C-d" '(nil))
  :preface
  (autoload 'sp-point-in-string-or-comment "smartparens")
  :init
  ;; Auto-detect JSX file
  (push (cons (lambda ()
                (and buffer-file-name
                     (equal (file-name-extension buffer-file-name) "js")
                     (re-search-forward "\\(^\\s-*import React\\|\\( from \\|require(\\)[\"']react\\)"
                                        magic-mode-regexp-match-limit t)
                     (progn
                       (goto-char (match-beginning 1))
                       (not (sp-point-in-string-or-comment)))))
              'rjsx-mode)
        magic-mode-alist))

(use-package coffee-mode
  :mode "\\.coffee$"
  :defines coffee-indent-like-python-mode
  :init (setq coffee-indent-like-python-mode t))

(use-package web-beautify
  :commands
  (web-beautify-js web-beautify-html web-beautify-css)
  :general
  (:keymaps '(js2-mode-map json-mode-map) :states 'normal
            "gQ" '(web-beautify-js))
  (:keymaps 'html-mode-map :states 'normal
            "gQ" '(web-beautify-html))
  (:keymaps 'css-mode-map :states 'normal
            "gQ" '(web-beautify-css)))

;;;
;; Skewer

(use-package skewer-mode
  :commands (skewer-mode run-skewer)
  :general
  (:keymaps 'skewer-mode-map :states 'normal :prefix ","
            "sE" '(skewer-eval-last-expression)
            "se" '(skewer-eval-defun)
            "sf" '(skewer-load-buffer)))

(use-package skewer-css :ensure nil
  :commands skewer-css-mode
  :general
  (:keymaps 'skewer-css-mode-map :states 'normal :prefix ","
            "se" '(skewer-css-eval-current-declaration)
            "sr" '(skewer-css-eval-current-rule)
            "sb" '(skewer-css-eval-buffer)
            "sc" '(skewer-css-clear-all)))

(use-package skewer-html :ensure nil
  :commands skewer-html-mode
  :general
  (:keymaps 'skewer-html-mode-map :states 'normal :prefix ","
            "se" '(skewer-html-eval-tag)))

(provide 'lang-javascript)
;;; lang-javascript.el ends here

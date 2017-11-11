;;; init.el --- Main init file -*- lexical-binding: t no-byte-compile: t; -*-

;;; Commentary:
;;; The init file that loads all the components.

;;; Code:

(eval-and-compile
  (push (concat user-emacs-directory "elisp") load-path)
  (push (concat user-emacs-directory "vendor") load-path))

;;;
;; Base

;; Calls (package-initialize)
(require 'base)

;;;
;; Features

(require 'feature-evil)
(require 'feature-eval)
(require 'feature-debug)
(require 'feature-jump)
(require 'feature-lsp)
(require 'feature-preview)
(require 'feature-spellcheck)
(require 'feature-speed-reading)
(require 'feature-syntax-checker)
(require 'feature-version-control)
(require 'feature-workspaces)

;;;
;; Completion

(require 'completion-company)      ; In-buffer completion
(require 'completion-ivy)          ; General completion

;;;
;; Tools

(require 'tool-coverage)           ; Code coverage
(require 'tool-docsets)            ; Docsets
(require 'tool-dired)              ; Directories
(require 'tool-neotree)            ; Tree navigation
(require 'tool-notes)              ; Note taking
(require 'tool-rotate-text)        ; Toggle between different text

;;;
;; Language support

(require 'lang-conf)
(require 'lang-data)
(require 'lang-ebook)
(require 'lang-elixir)
(require 'lang-elm)
(require 'lang-emacs-lisp)
(require 'lang-erlang)
(require 'lang-go)
(require 'lang-haskell)
(require 'lang-java)
(require 'lang-javascript)
(require 'lang-lua)
(require 'lang-markdown)
(require 'lang-opengl)
(require 'lang-org)
(require 'lang-pkgbuild)
(require 'lang-python)
(require 'lang-raml)
(require 'lang-rest)
(require 'lang-rst)
(require 'lang-ruby)
(require 'lang-rust)
(require 'lang-scala)
(require 'lang-shell)
(require 'lang-typescript)
(require 'lang-uml)
(require 'lang-web)

;;;
;; Keybindings

(unless noninteractive
  (require 'theme)
  (require 'bindings)
  (require 'commands))

(req-package-finish)

;;; init.el ends here

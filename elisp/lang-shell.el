;;; lang-shell.el --- Shell scripting

;;; Commentary:
;; A shell script is a computer program designed to be run by the Unix shell, a
;; command-line interpreter.

;;; Code:
(require 'base-lib)

(use-package bats-mode :commands bats-mode)

(use-package fish-mode
  :commands fish-mode
  :init
  (add-hook 'fish-mode-hook
            #'(lambda ()
                (add-hook 'before-save-hook #'fish_indent-before-save))))

(use-package sh-script
  :mode ("\\.zsh$" . sh-mode)
  :commands sh-mode
  :init
  (add-hook 'sh-mode-hook
            #'(lambda ()
                (flycheck-mode +1)
                (highlight-numbers-mode +1)))
  :config
  ;; Use regular indentation for line-continuation
  (setq sh-indent-after-continuation 'always))

;; Completion for keywords, executable files in PATH and ENV variables.
(use-package company-shell
  :after company
  :preface
  (require 'company-keywords)
  :config
  (setq company-shell-delete-duplicates t)

  (push '(sh-mode "alias" "bg" "bind" "builtin" "caller" "case" "in" "esac"
                  "command" "compgen" "complete" "continue" "declare" "dirs"
                  "disown" "do" "done" "echo" "enable" "eval" "exec" "exit"
                  "export" "false" "fc" "fg" "for" "function" "getopts" "hash"
                  "help" "history" "if" "elif" "else" "fi" "jobs" "kill" "let"
                  "local" "logout" "popd" "printf" "pushd" "pwd" "read"
                  "readonly" "return" "select" "set" "shift" "shopt" "source"
                  "suspend" "test" "then" "time" "times" "trap" "true" "type"
                  "typeset" "ulimit" "umask" "unalias" "unset" "until"
                  "variables" "while") company-keywords-alist)

  (with-eval-after-load "company"
    (push-company-backends 'sh-mode '(company-keywords
                                      company-shell
                                      company-shell-env
                                      company-files
                                      company-dabbrev-code))
    (push-company-backends 'fish-mode '(company-fish-shell
                                        company-shell
                                        company-files))))

(provide 'lang-shell)
;;; lang-shell.el ends here
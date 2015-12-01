
(package-initialize)
;; load-path adds
(add-to-list 'load-path "~/.emacs.d/site-lisp/magit/lisp")
(add-to-list 'load-path "~/.emacs.d/site-lisp/markdown-mode")

(add-to-list 'package-archives
	         '("org" . "http://orgmode.org/elpa/") )
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-verbose t)

(require 'package)
(require 'magit)
(require 'use-package)


;; application specific

;;
;; helm
;; see https://github.com/emacs-helm/helm/wiki
;;
(use-package helm
  :ensure t
  :demand t
  :bind (( "<f5> <f5>" . helm-org-agenda-files-headings)
	 ( "<f5> a" . helm-apropos)
	 ( "<f5> A" . helm-apt)
	 ( "<f5> b" . helm-buffers-list)
	 ( "<f5> c" . helm-colors)
	 ( "<f5> f" . helm-find-files)
	 ( "<f5> g" . helm-do-grep)
	 ( "<f5> i" . helm-semantic-or-imenu)
	 ( "<f5> k" . helm-show-kill-ring)
	 ( "<f5> l" . helm-locate)
	 ( "<f5> m" . helm-man-woman)
	 ( "<f5> o" . helm-occur)
	 ( "<f5> r" . helm-resume)
	 ( "<f5> R" . helm-register)
	 ( "<f5> t" . helm-top)
	 ( "<f5> p" . helm-list-emacs-process)
	 ( "<f5> x" . helm-M-x)))

(use-package helm-swoop
  :ensure t
  :bind (( "<f5> s" . helm-swoop)
	 ( "<f5> S" . helm-multi-swoop)))

(use-package paradox :ensure t) 
(setq paradox-github-token "478893d7b339e9049605be85f775f55f84b476a1")
;;
;; magit
;; https://github.com/magit/magit 
;;
(global-set-key (kbd "C-x g") 'magit-status)
(with-eval-after-load 'info
  (info-initialize)
  (add-to-list 'Info-directory-list
	                      "~/.emacs.d/site-lisp/magit/Documentation/"))

;;
;; markdown
;;
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;
;; org-mode
;;
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line
(setq org-log-done 'time)

(custom-set-variables
 '(org-babel-load-languages
   (quote
    ((emacs-lisp . t)
     (css . t)
     (sh . t)))))

;; use ido mode for buffer and file selections
(use-package ido
	     :ensure t
	     :config (progn
		       (ido-mode t)
		       (setq ido-enable-flex-matching t)
		       (use-package flx-ido
				    :ensure t
				    :config
				    (flx-ido-mode 1))))

;; setup smex for flexible command matching in the mini-buffer
(use-package smex
	     :ensure t
	     :bind (("M-x" . smex)
		    ("M-X" . smex-major-mode-commands)
		    ("C-c M-x" . execute-extended-command)))

;; Customizations shall be saved and loaded to/from a
;; separate file
(setq custom-file "~/.emacs-custom.el")
(load custom-file)

(set-face-attribute 'default nil :height 190)
(set-background-color "#222244")
(set-foreground-color "#dddddd")

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

(package-install 'edit-server)
(require 'edit-server)
(edit-server-start)

(require 'package)
(require 'magit)
(require 'use-package)

;; screenshot inside org-mode buffer
(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (setq filename
        (concat
         (make-temp-name
          (concat (buffer-file-name)
                  "_"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (call-process "/usr/local/bin/import" nil nil nil filename)
  (insert (concat "[[" filename "]]"))
  (org-display-inline-images))

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

;; org-mode headings size
(custom-set-faces
  '(org-level-1 ((t (:inherit outline-1 :height 1.6))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.4))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
  '(org-level-5 ((t (:inherit outline-5 :height 0.9))))
)

;; show inline images
(defun do-org-show-all-inline-images ()
  (interactive)
  (org-display-inline-images t t))
(global-set-key (kbd "C-c C-x C v")
                'do-org-show-all-inline-images)

;; for fancy bullets
(package-install 'org-bullets)
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

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


(package-install 'vagrant-tramp)
(require 'vagrant-tramp)

;; yes or no questions to be answered by simple y/n
(fset 'yes-or-no-p 'y-or-n-p)

(package-install 'multiple-cursors)
(require 'multiple-cursors)

;; for displaying automatically inline images
(defun do-org-show-all-inline-images ()
  (interactive)
  (org-display-inline-images t t))
(global-set-key (kbd "C-c C-x C v")
                'do-org-show-all-inline-images)


;; https://github.com/auto-complete/auto-complete
(package-install 'auto-complete)
(require 'auto-complete)
(ac-config-default)

;; http://orgmode.org/worg/exporters/beamer/ox-beamer.html
(require 'ox-latex)
(add-to-list 'org-latex-classes
             '("beamer"
               "\\documentclass\[presentation\]\{beamer\}"
               ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

(defun set-exec-path-from-shell-PATH ()
  "Sets the exec-path to the same value used by the user shell"
  (let ((path-from-shell
         (replace-regexp-in-string
          "[[:space:]\n]*$" ""
          (shell-command-to-string "$SHELL -l -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

;; call function now
(set-exec-path-from-shell-PATH)

;; automatically save sessions
;; see https://www.gnu.org/software/emacs/manual/html_node/emacs/Saving-Emacs-Sessions.html for futher details
(desktop-save-mode 1)

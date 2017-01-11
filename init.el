(x-focus-frame nil)
(setq mac-command-modifier 'super)

(global-unset-key (kbd "C-z"))

;; Org mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;; Automatically close brackets/braces - I found this more annoying than helpful
;;  (electric-pair-mode 1)

;; List the package we want
(setq package-list '(ensime lua-mode dart-mode yaml-mode 
                     tide tss typescript-mode web-mode flycheck company
                     magit multiple-cursors find-file-in-repository ace-jump-mode yasnippet window-numbering expand-region neotree monokai-theme rainbow-delimiters helm markdown-mode markdown-preview-eww slime yafolding ido-grid-mode dumb-jump ag))

(autoload 'findr "findr" "Find file name." t)
(define-key global-map [(meta control S)] 'findr)

(autoload 'findr-search "findr" "Find text in files." t)
(define-key global-map [(meta control s)] 'findr-search)

(autoload 'findr-query-replace "findr" "Replace text in files." t)
(define-key global-map [(meta control r)] 'findr-query-replace)

(package-initialize) 

;; Fetch list of packages available
(unless package-archive-contents
	(package-refresh-contents))

;; install the packages that are missing, if any
(dolist (package package-list)
	(unless (package-installed-p package)
		(package-install package)))

;;------------------------------------------------------------------------------------------------------------------------------------

(require 'ensime)
;; Start ensime mode whenever we open scala mode, e.g. open a .scala file
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

(add-hook 'ensime-scala-mode-hook #'setup-ensime-mode)

(defun setup-ensime-mode ()
  (interactive)
  (ensime-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (company-mode +1)
  ;; Start ensime with Super-e
  (global-set-key (kbd "C-c C-c c") 'ensime)
  (global-set-key (kbd "C-c C-r r") 'ensime-refactor-rename)
  (global-set-key (kbd "C-c C-o i") 'ensime-refactor-organize-imports)
  (global-set-key (kbd "C-c C-i l") 'ensime-refactor-inline-local)
  (global-set-key (kbd "C-c C-t i") 'ensime-inspect-by-path)
  (global-set-key (kbd "s-R")       'ensime-inf-eval-buffer)
  (global-set-key (kbd "s-r")       'ensime-inf-eval-region)
  ;; 'ensime-mode-menu
  ;; 'ensime-inspector-mode
  ;; 'ensime-inspector-browse-doc
  ;; 'ensime-inspect-package-at-point
  ;; 'ensime-inspect-type-at-point-other-frame
  ;; 'ensime-inspect-bytecode
  ;; 'ensime-inf-mode
  ;; 'ensime-inf-eval-buffer
  ;; 'ensime-inf-eval-region
  ;; 'ensime-inf-eval-definition
  ;; 'ensime-inf-import-package-at-point
  ;; 'ensime-search-mode
  ;; 'ensime-search
  ;; 'ensime-show-doc-for-symbol-at-point
  ;; 'ensime-show-uses-of-symbol-at-point
  ;; 'ensime-type-at-point
  ;; 'ensime-typecheck-current-buffer
  ;; 'ensime-typecheck-all
  ;; 'ensime-print-type-at-point
  ;; 'ensime-backward-note
  ;; 'enaime-forward-note
  ;; 'ensime-goto-test
  ;; 'ensime-goto-impl
  ;; 'ensime-refactor-diff-organize-imports
  ;; 'ensime-refactor-diff-extract-method
  ;; 'ensime-refactor-diff-extract-method
  ;; 'ensime-refactor-diff-extract-local
  ;; 'ensime-refactor-diff-inline-local
  ;; 'ensime-refactor-diff-rename
  ;; 'ensime-refactor-diff-apply-hunks
  ;; 'ensime-search
  ;; 'ensime-search-mode
  ;; 'ensime-search-next-match
  ;; 'ensime-search-prev-match
  )

(setq ensime-sem-high-faces
        '(
           (implicitConversion nil)
           (var . (:foreground "#ff2222"))
           (val . (:foreground "#dddddd"))
           (varField . (:foreground "#ff3333"))
           (valField . (:foreground "#dddddd"))
           (functionCall . (:foreground "#dc9157"))
           (param . (:foreground "#ffffff"))
           (object . (:foreground "#D884E3"))
           (class . (:foreground "green"))
           (trait . (:foreground "#009933")) ;; "#084EA8")) 
           (operator . (:foreground "#cc7832"))
           (object . (:foreground "#6897bb" :slant italic))
           (package . (:foreground "yellow"))
           (implicitConversion . (:underline (:style wave :color "blue")))
           (implicitParams . (:underline (:style wave :color "blue")))
           (deprecated . (:strike-through "#a9b7c6"))
           (implicitParams nil)
         )
        ensime-startup-notification nil
        ensime-startup-snapshot-notification nil
  )

;;------------------------------------------------------------------------------------------------------------------------------------

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(add-hook 'typescript-mode-hook #'setup-tide-mode)
(add-hook 'js2-mode-hook #'setup-tide-mode)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "jsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;;------------------------------------------------------------------------------------------------------------------------------------

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)


;; Don't show the magit instructions every time
(setq magit-last-seen-setup-instructions "1.4.0")

(require 'multiple-cursors)
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(require 'find-file-in-repository)

(global-linum-mode 1)
(global-set-key [f7] 'kill-whole-line)
(global-set-key (kbd "M-s M-m")   'magit-status)
(global-set-key (kbd "M-s M-/")   'comment-or-uncomment-region)
(global-set-key (kbd "C-x C-M-f") 'find-file-in-repository)

(put 'dired-find-alternate-file 'disabled nil)

;;Uncomment the below to hide the menu
;;(menu-bar-mode -1)


;; Some general-purpose key bindings
(global-set-key [kp-subtract] 'undo) ; [Undo]
(global-set-key (kbd "S-z") 'undo)
(global-set-key [insert]    'overwrite-mode) ; [Ins]
(global-set-key [kp-insert] 'overwrite-mode) ; [Ins]
(global-set-key (kbd "M-g") 'goto-line) ; [Ctrl]-l]
(global-set-key (kbd "C-L") 'recenter-top-bottom)
(global-set-key [f2] 'split-window-vertically)
(global-set-key [f1] 'remove-split)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(setq ido-use-filename-at-point 'guess)
(setq ido-create-new-buffer 'always)
(setq ido-file-extensions-order '(".scala" ".org" ".txt" ".py" ".emacs" ".xml" ".el" ".ini" ".cfg" ".cnf"))

(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
 t)
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
 t)

(define-key global-map (kbd "RET") 'newline-and-indent)

(defun search-to-brace ()
  "Jump to the next open brace"
  (interactive)
  (search-forward "{"))
(define-key global-map (kbd "M-s {") 'search-to-brace)

(defun search-to-prev-brace ()
    "Jump to the previous brace"
    (interactive)
    (search-backward "{"))
(define-key global-map (kbd "M-S {") 'search-to-prev-brace)

(defun search-to-close-brace ()
  "Jump to the next close brace"
  (interactive)
  (search-forward "}"))
(define-key global-map (kbd "M-s }") 'search-to-close-brace)

(defun search-to-prev-close-brace ()
  "Jump to the previous close brace"
  (interactive)
  (search-backward "}"))
(define-key global-map (kbd "M-S }") 'search-to-prev-brace)

(defun search-to-next-def ()
  "Jump to the next def"
  (interactive)
  (search-forward "def "))
(define-key global-map (kbd "M-s d") 'search-to-next-def)

(defun search-to-prev-def ()
  "Jump to the previous def"
  (interactive)
  (search-backward "def "))
(define-key global-map (kbd "M-S d") 'search-to-prev-def)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-tab)

(define-key global-map (kbd "<backtab>") 'scala-indent:indent-with-reluctant-strategy)


;; Un-comment below lines for Monokai theme
(require 'monokai-theme)
(load-theme 'monokai t)
(setq frame-background-mode 'dark)


;; Always pick up the most recent file from the filesystem
(global-auto-revert-mode 1)

(global-set-key (kbd "s-j") 'dired-jump)

(setq server-socket-dir "~/.emacs.d/server")

;; window command shortcuts
(global-set-key (kbd "s-|") 'split-window-horizontally)
(global-set-key (kbd "C-x 9") 'split-window-horizontally)
(global-set-key (kbd "s--") 'split-window-vertically)
(global-set-key (kbd "s-+") 'remove-split)
(global-set-key (kbd "s-<up>") 'enlarge-window)
(global-set-key (kbd "s-<down>") 'shrink-window)
(global-set-key (kbd "s-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "s-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "M-k") 'kill-whole-line)

(global-set-key (kbd "s-1") 'ace-jump-line-mode)
(global-set-key (kbd "s-2") 'ace-jump-word-mode)

(global-set-key (kbd "s-f") 'find-file-in-repository)

;;;;TODO: Put temporary and backup files elsewhere
;;(setq auto-save-file-name-transforms
;;          `((".*" ,(concat user-emacs-directory "auto-save/") t))) 
;;(setq backup-directory-alist
;;      `(("." . ,(expand-file-name
;;                 (concat user-emacs-directory "backups")))))
;;(setq create-lockfiles nil)

(require 'yasnippet)
(yas-global-mode 1)
       
(require 'window-numbering)
(window-numbering-mode 1)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(defun save-all () (interactive) (save-some-buffers t))
(global-set-key (kbd "S-s") 'save-all)

(require 'neotree)
(global-set-key (kbd "s-d") 'neotree-toggle)
;;uncomment to have a neotree window open initially
(neotree)

(require 'whitespace)
(setq whitespace-line-column 120)
(setq whitespace-style '(face lines-tail))
(global-whitespace-mode +1)

(setq show-paren-delay 0)
(setq blink-matching-paren 1)
(show-paren-mode 1)

(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
      (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t) 
        (backward-char) (insert "\n"))
      (indent-region begin end))
    (message "Ah, much better!"))

(require 'rainbow-delimiters)
(add-hook 'scala-mode-hook #'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)

;; Save on focus-out
(defun save-all ()
  (interactive)
  (save-some-buffers t))
(add-hook 'focus-out-hook 'save-all)

;; Exit emacs w/o prompts
(require 'cl)
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
           (flet ((process-list ())) ad-do-it))

(add-hook 'markdown-mode-hook (lambda () (electric-indent-local-mode -1)))


;; Control and mouse-wheel-up to increase font size in buffer, down to decrease    
(global-set-key (kbd "C-+")    '(lambda () (interactive) (text-scale-increase 1)))
(global-set-key (kbd "C--")    '(lambda () (interactive) (text-scale-decrease 1)))
(global-set-key [C-wheel-up]   '(lambda () (interactive) (text-scale-increase 1)))
(global-set-key [C-wheel-down] '(lambda () (interactive) (text-scale-decrease 1)))
(global-set-key [C-mouse-4]    '(lambda () (interactive) (text-scale-increase 1)))
(global-set-key [C-mouse-5]    '(lambda () (interactive) (text-scale-decrease 1)))

;; Super wheel-up to increase font size in all buffers
(defun change-font-height (delta)
  (set-face-attribute 'default 
                      (selected-frame)
                      :height (+ (face-attribute 'default :height) delta)))

(global-set-key [M-wheel-up]   '(lambda () (interactive) (change-font-height +4)))
(global-set-key [M-wheel-down] '(lambda () (interactive) (change-font-height -4)))
(global-set-key [M-mouse-4]    '(lambda () (interactive) (change-font-height +4)))
(global-set-key [M-mouse-5]    '(lambda () (interactive) (change-font-height -4)))

(setq inferior-lisp-program "/usr/local/bin/sbcl")

;; Turn on yafolding-mode for scala files
(add-hook 'prog-mode-hook
          (lambda () (yafolding-mode)))
;; Uncomment below to start with all elements folded
;; (add-hook 'scala-mode-hook
;;          (lambda () (yafolding-mode) (yafolding-toggle-all)))


(defun jump-to-test ()
  "Jump to correspnding test file"
  (interactive)
  (find-file-other-window (format "%s%sTest.scala" (replace-regexp-in-string "app\/" "test\/" (file-name-directory buffer-file-name)) (file-name-nondirectory (file-name-sans-extension buffer-file-name)))))

(global-set-key (kbd "s-T") 'jump-to-test)

(ido-grid-mode 1)

(global-set-key (kbd "s-b") 'ido-display-buffer)

(require 'helm)
(global-set-key (kbd "M-x")     'helm-M-x)
(global-set-key (kbd "C-x C-m") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

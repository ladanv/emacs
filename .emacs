
;; packages
(require 'package)
; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
; (add-to-list 'package-archives '("tromey" . "http://tromey.com/elpa/"))
; (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(clojure-mode		      
		      nrepl
		      ac-nrepl
	              auto-complete		
		      popup
		      paredit
		      rainbow-delimiters))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

; add top level emacs.d directory to load path
(add-to-list 'load-path "~/.emacs.d")

; resizing main window
(defun maximize-frame ()
  (interactive)
  (when (eq system-type 'windows-nt)
    (w32-send-sys-command 61488)))
(add-hook 'window-setup-hook 'maximize-frame 1)

; *********************************************
; Plugins
; *********************************************

;; clojure mode
(add-to-list 'auto-mode-alist '("\\.clj$"  . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cljs$" . clojurescript-mode))
; to truncate lines in the clojure mode
(add-hook 'clojure-mode-hook (lambda () (setq truncate-lines 1)))

;; paredit
(require 'paredit)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'clojure-mode-hook    'enable-paredit-mode)
(add-hook 'nrepl-mode-hook 	'paredit-mode)

;; auto complete
(require 'auto-complete-config)
(ac-config-default)

;; ac-nrepl - auto-complete in a nrepl buffer
(require 'ac-nrepl)
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
(add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete" '(add-to-list 'ac-modes 'nrepl-mode))

;; nrepl
(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
(setq nrepl-popup-stacktraces nil)

;; evil - vim mode
; only without ELPA/el-get
(add-to-list 'load-path "~/.emacs.d/evil") 
(require 'evil)
(evil-mode 1)
; to be able to change a cursor color
(setq evil-default-cursor t) 

;; git
(add-to-list 'load-path "~/.emacs.d/magit-1.2.0") 
(require 'magit)

;; line numbers
(require 'linum)
(global-linum-mode 1)

;(require 'ibuffer)
 
; ace jump mode major function
(add-to-list 'load-path "~/.emacs.d/ace-jump-mode")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode")
(autoload
  'ace-jump-line-mode
  "ace-jump-mode"
  "Jump to the line")
(autoload
  'ace-jump-char-mode
  "ace-jump-mode"
  "Jump to the line")
; enable a more powerful jump back function from ace jump mode
;; (autoload
;;   'ace-jump-mode-pop-mark
;;   "ace-jump-mode"
;;   "Ace jump back:-)"
;;   t)
;; (eval-after-load "ace-jump-mode"
;;   '(ace-jump-mode-enable-mark-sync))
;; (define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;; get mouse away as soon as I press a key
;(mouse-avoidance-mode 'banish)

;; org mode
; for agenda to work properly
(global-font-lock-mode 1)
; add the time stump when status is DONE
(setq org-log-done 'time)
; add a note tump when status is DONE
; (setq org-log-done 'note)
; list of my org files
(setq org-agenda-files (list "~/.emacs.d/org/todo.org"
                             "~/.emacs.d/org/test.org"
                             "~/.emacs.d/org/lombardiya.org"
                             "~/.emacs.d/org/nataliya.org"
                             "~/.emacs.d/org/gals.org"))
; status settings
(setq org-todo-keywords
  '((sequence "TODO" "WORK" "TEST" "|" "DONE" "CANCELED")))
(setq org-todo-keyword-faces
  '(("TODO"     . "red") 
    ("WORK"     . "yellow") 
    ("TEST"     . "orange")
    ("DONE"     . "green") 
    ("CANCELED" . "purple")))
; clocking work time 
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;; ido-mode for switching buffers
(require 'ido)
(ido-mode 1)
; enabling fuzzy matching
(setq ido-enable-flex-matching 1)
     
;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

; *********************************************
; Editer options
; *********************************************
; setting buffer encoding in order not to have ^M at
; the end of lines
;(set-buffer-file-coding-system 'undecided-unix nil)
; change cursor type
; (setq-default cursor-type '(bar . 3))
; use spaces not tabs
(setq-default indent-tabs-mode nil)
; no backup files
;(setq make-backup-files nil)
(setq
   ; don't clobber symlinks
   backup-by-copying t      
   backup-directory-alist
   ; don't litter my fs tree
    '(("." . "~/.emacs.d/backup"))    
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   ; use versioned backups
   version-control t)       
; no splash screen
(setq inhibit-startup-message 1)     	
; no scratch message
(setq initial-scratch-message nil) 
; smart scrolling
(setq scroll-step 1 			
scroll-conservatively 100000 		
scroll-margin 5 		
scroll-preserve-screen-position 1)
; hide scroll bars
(scroll-bar-mode -1)
; hide tool bar
(tool-bar-mode -1) 			
; hide main menu 
(menu-bar-mode -1)			
; turn on highlight in all buffers
;(global-hl-line-mode 1) 		 
; don't ask 
(fset 'yes-or-no-p 'y-or-n-p) 		
; save last opened files and restore them
(desktop-save-mode 1)			
; disable visible-bell 
(setq visible-bell nil)			
; show current file name in the window name
(setq frame-title-format "emacs - %f")  
; show parentheses
(show-paren-mode 1)
; highlight all the expression
(setq show-paren-style 'expression) 

; *********************************************
; Font and color
; *********************************************

; font size
(set-face-attribute 'default nil :height 150)
; color theme
; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/emacs-color-theme-solarized")
; (load-theme 'solarized-dark t)
; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/grandshell-theme")
; (load-theme 'grandshell t)
(load-theme 'deeper-blue 1)
; changing a cursor color
; (set-cursor-color "#00ff00")  
; set emacs background colour
(set-background-color "black")

; *********************************************
; Key mapping
; *********************************************

; switching between buffers
; changing evil's 'find-file-at-point to 'ido-find-file
(define-key evil-normal-state-map "gf" 'ido-find-file)
; select/open buffer
(define-key evil-normal-state-map "gb" 'ido-switch-buffer)
; go word
(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)
(define-key evil-visual-state-map (kbd "SPC") 'ace-jump-mode)
; go line
(define-key evil-normal-state-map "gl" 'ace-jump-line-mode)
(define-key evil-visual-state-map "gl" 'ace-jump-line-mode)
; go char
(define-key evil-normal-state-map "gc" 'ace-jump-char-mode)
(define-key evil-visual-state-map "gc" 'ace-jump-char-mode)
; write file
(define-key evil-normal-state-map (kbd "<f2>") 'evil-write)
(define-key evil-insert-state-map (kbd "<f2>")  'evil-write)
(define-key evil-visual-state-map (kbd "<f2>")  'evil-write)
; eval clojure expr
(define-key nrepl-interaction-mode-map (kbd "<f3>") 'nrepl-eval-last-expression)
; eval clojure expr at point
(define-key nrepl-interaction-mode-map (kbd "<f4>") 'nrepl-eval-expression-at-point)

; switching between windows
(global-set-key (kbd "M-h")   'windmove-left)
(global-set-key (kbd "M-l")   'windmove-right)
(global-set-key (kbd "M-k")   'windmove-up)
(global-set-key (kbd "M-j")   'windmove-down)
;(define-key global-map "o"    'delete-other-windows)
; switching between buffers
(global-set-key (kbd "M-f") 'next-buffer)
(global-set-key (kbd "M-a") 'previous-buffer)

; org mode key bindings
(evil-define-key 'normal org-mode-map
  ; cycle TODO keywords
  (kbd "t") 'org-todo
  ; populate agenda menu in an org mode 
"\C-a" 'org-agenda)

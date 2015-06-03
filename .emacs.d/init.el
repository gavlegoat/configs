(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/")
             t)

; There's a bug in the current Emacs (24.3) which causes previous-line to work
; incorrectly. This is from github.com/alpaker/Fill-Column-Indicator/issues/31
(make-variable-buffer-local 'line-move-visual)
(defadvice previous-line (around avoid-jumpy-fci activate)
  (if (and (symbol-value 'fci-mode) (> (count-lines 1 (point)) 0))
      (progn (fci-mode -1) ad-do-it (fci-mode 1))
    ad-do-it))

(setq make-backup-files nil)  ; don't make the ~ files

(setq-default indent-tabs-mode nil)  ; replace tabs with spaces
(setq inhibit-startup-message t)   ; don't show the splash screen

(setq-default blink-cursor-blinks 0)  ; Don't stop blinking the cursor

; Show a line at 80 characters
(add-to-list 'load-path "/home/greg/.emacs.d/scripts")
(require 'fill-column-indicator)
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)

(global-linum-mode 1)   ; Show line numbers

(add-hook 'after-init-hook #'global-flycheck-mode)

(require 'ace-jump-mode)  ; C-c SPC is similar to easymotion in vim
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

; Show trailing whitespace
(require 'whitespace)
(global-whitespace-mode 1)
(setq whitespace-style '(face trailing lines-tail))
; Delete trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq-default fill-column 80)  ; wrap on column 80 when autofill is on

(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)

(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)  ; wrap text in LaTeX
(setq TeX-PDF-mode t)    ; compile with pdflatex
(add-hook 'LaTeX-mode-hook (lambda () (flyspell-mode 1)))  ; spell check
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

; Load Proof General
(load-file "/home/greg/.emacs.d/scripts/ProofGeneral-4.2/generic/proof-site.el")

; Load whitespace-mode
(load-file "/home/greg/.emacs.d/scripts/whitespace-mode.el")

(custom-set-variables
  '(haskell-process-suggest-remove-import-lines t)
  '(haskell-process-auto-import-loaded-modules t)
  '(haskell-process-log t))
(eval-after-load 'haskell-mode '(progn
  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
  (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
  (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
  (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
  (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)
  (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)))
(eval-after-load 'haskell-cabal '(progn
  (define-key haskell-cabal-mode-map (kbd "C-c C-z")
    'haskell-interactive-switch)
  (define-key haskell-cabal-mode-map (kbd "C-c C-k")
    'haskell-interactive-mode-clear)
  (define-key haskell-cabal-mode-map (kbd "C-c C-c")
    'haskell-process-cabal-build)
  (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(custom-enabled-themes (quote (whiteboard))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

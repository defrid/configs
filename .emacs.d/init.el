;; System-type definition
(defun system-is-linux()
    (string-equal system-type "gnu/linux"))
(defun system-is-windows()
    (string-equal system-type "windows-nt"))


;; Start Emacs as a server
(when (system-is-linux)
    (require 'server)
    (unless (server-running-p)
        (server-start))) ;; запустить Emacs как сервер, если ОС - GNU/Linux

;; MS Windows path-variable
(when (system-is-windows)
    (setq win-sbcl-exe          "C:/sbcl/sbcl.exe")
    (setq win-init-path         "C:/.emacs.d")
    (setq win-init-ct-path      "C:/.emacs.d/plugins/color-theme")
    (setq win-init-ac-path      "C:/.emacs.d/plugins/auto-complete")
    (setq win-init-slime-path   "C:/slime")
    (setq win-init-ac-dict-path "C:/.emacs.d/plugins/auto-complete/dict")
	;; Custom font for windows
	(set-face-attribute 'default nil :family "Consolas" :height 100))

;; Unix path-variable
(when (system-is-linux)
    (setq unix-sbcl-bin          "/usr/bin/sbcl")
    (setq unix-init-path         "~/.emacs.d/lisp")
    (setq unix-init-ct-path      "~/.emacs.d/plugins/color-theme")
    (setq unix-init-ac-path      "~/.emacs.d/plugins/auto-complete")
    (setq unix-init-slime-path   "/usr/share/common-lisp/source/slime/")
    (setq unix-init-ac-dict-path "~/.emacs.d/plugins/auto-complete/dict")
	;; jslint behaviour only for linux
	(setq js2-highlight-level 3)
	(add-hook 'js-mode-hook 'js2-minor-mode)
	(add-hook 'js2-mode-hook 'ac-js2-mode)
	(setq ac-js2-evaluate-calls t)

	(eval-after-load 'tern
		'(progn
		  (require 'tern-auto-complete)
		  (tern-ac-setup))))


;; Display the name of the current buffer in the title bar
(setq frame-title-format "GNU Emacs: %b")

;; Load path for plugins
(if (system-is-windows)
    (add-to-list 'load-path win-init-path)
    (add-to-list 'load-path unix-init-path))

;; Inhibit startup/splash screen
(setq inhibit-splash-screen   t)
(setq ingibit-startup-message t) ;; экран приветствия можно вызвать комбинацией C-h C-a

;; Show-paren-mode settings
(show-paren-mode t) ;; включить выделение выражений между {},[],()
(setq show-paren-style 'expression) ;; выделить цветом выражения между {},[],()

;; Electric-modes settings
(electric-pair-mode    1) ;; автозакрытие {},[],() с переводом курсора внутрь скобок
(electric-indent-mode -1) ;; отключить индентацию  electric-indent-mod'ом (default in Emacs-24.4)

;; Delete selection
(delete-selection-mode t)

;; Disable GUI components
(tooltip-mode      -1)
(menu-bar-mode     -1) ;; отключаем графическое меню
(tool-bar-mode     -1) ;; отключаем tool-bar
(blink-cursor-mode -1) ;; курсор не мигает
(setq use-dialog-box     nil) ;; никаких графических диалогов и окон - все через минибуфер
(setq redisplay-dont-pause t)  ;; лучшая отрисовка буфера
(setq ring-bell-function 'ignore) ;; отключить звуковой сигнал

;; Linum plugin
(require 'linum) ;; вызвать Linum
(line-number-mode   t) ;; показать номер строки в mode-line
(global-linum-mode  t) ;; показывать номера строк во всех буферах
(column-number-mode t) ;; показать номер столбца в mode-line
(setq linum-format " %d") ;; задаем формат нумерации строк

;; IDO plugin
(require 'ido)
(ido-mode                      t)
(icomplete-mode                t)
(ido-everywhere                t)
(setq ido-vitrual-buffers      t)
(setq ido-enable-flex-matching t)

;; Buffer Selection and ibuffer settings
(require 'bs)
(require 'ibuffer)
(defalias 'list-buffers 'ibuffer) ;; отдельный список буферов при нажатии C-x C-b
(global-set-key (kbd "<f2>") 'bs-show) ;; запуск buffer selection кнопкой F2

;; Color-theme definition <http://www.emacswiki.org/emacs/ColorTheme>
(defun color-theme-init()
    (require 'color-theme)
    (color-theme-initialize)
    (setq color-theme-is-global t)
    (color-theme-charcoal-black))
(if (system-is-windows)
    (when (file-directory-p win-init-ct-path)
        (add-to-list 'load-path win-init-ct-path)
        (color-theme-init))
    (when (file-directory-p unix-init-ct-path)
        (add-to-list 'load-path unix-init-ct-path)
        (color-theme-init)))

;; Syntax highlighting
(require 'font-lock)
(global-font-lock-mode             t) ;; включено с версии Emacs-22. На всякий...
(setq font-lock-maximum-decoration t)

;; Indent settings
(setq-default tab-width          4) ;; ширина табуляции - 4 пробельных символа
(setq-default c-basic-offset     4)
(setq-default standart-indent    4) ;; стандартная ширина отступа - 4 пробельных символа
(setq-default lisp-body-indent   4) ;; сдвигать Lisp-выражения на 4 пробельных символа
(global-set-key (kbd "RET") 'newline-and-indent) ;; при нажатии Enter перевести каретку и сделать отступ
(setq lisp-indent-function  'common-lisp-indent-function)

;; Scrolling settings
(setq scroll-step               1) ;; вверх-вниз по 1 строке
(setq scroll-margin             0) ;; сдвигать буфер верх/вниз когда курсор в 1 шагах от верхней/нижней границы
(setq scroll-conservatively 10000)

;; End of file newlines
(setq require-final-newline    t) ;; добавить новую пустую строку в конец файла при сохранении
(setq next-line-add-newlines nil) ;; не добавлять новую строку в конец при смещении
;; курсора  стрелками

;; Highlight search resaults
(setq search-highlight        t)
(setq query-replace-highlight t)

;; Easy transition between buffers: M-arrow-keys
(if (equal nil (equal major-mode 'org-mode))
    (windmove-default-keybindings 'meta))

(add-to-list 'write-file-functions 'delete-trailing-whitespace)

(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;;Restart tern-server
(defun delete-tern-process ()
  (interactive)
  (delete-process "Tern"))

(add-hook 'js-mode-hook (lambda () (tern-mode t)))
(eval-after-load 'tern
    '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))

(require 'auto-complete)
(global-auto-complete-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("1db337246ebc9c083be0d728f8d20913a0f46edc0a00277746ba411c149d7fe5" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(autoload 'svn-status "dsvn" "Run `svn status'." t)
(autoload 'svn-update "dsvn" "Run `svn update'." t)

(setq tab-width 4)
(setq tab-stop-list (number-sequence 4 200 4))

(load-theme 'ample-zen t)

;; func, allows to rename files in emacs
(defun rename-file-and-buffer ()
	"Rename the current buffer and file it is visiting."
	(interactive)
	(let ((filename (buffer-file-name)))
		(if (not (and filename (file-exists-p filename)))
			(message "Buffer is not visiting a file!")
			(let ((new-name (read-file-name "New name: " filename)))
				(cond
				  ((vc-backend filename) (vc-rename-file filename new-name))
				  (t
				   (rename-file filename new-name t)
				   (set-visited-file-name new-name t t)))))))
(global-set-key (kbd "C-c r")  'rename-file-and-buffer)


;;Set back-up and auto-save directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

(setq auto-save-file-name-transforms
	  `((".*" ,(expand-file-name
				(concat user-emacs-directory "auto-save")) t)))
;;activate Redo func
(global-set-key (kbd "C-?") 'redo)

(eval-after-load 'js2-mode
	'(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
(eval-after-load 'json-mode
	'(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))
(eval-after-load 'sgml-mode
	'(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))
(eval-after-load 'css-mode
	'(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))

(eval-after-load 'js
  '(define-key js-mode-map (kbd "C-c b") 'web-beautify-js))

;;Scroll all for mouse wheel
(defun mwheel-scroll-all-function-all (func arg)
	(if scroll-all-mode
		(save-selected-window
			(walk-windows
			 (lambda (win)
				 (select-window win)
				 (condition-case nil
					 (funcall func arg)
					 (error nil)))))
		(funcall func arg)))

(defun mwheel-scroll-all-scroll-up-all (arg)
	(mwheel-scroll-all-function-all 'scroll-up arg))

(defun mwheel-scroll-all-scroll-down-all (arg)
	(mwheel-scroll-all-function-all 'scroll-down arg))

(setq mwheel-scroll-up-function 'mwheel-scroll-all-scroll-up-all)
(setq mwheel-scroll-down-function 'mwheel-scroll-all-scroll-down-all)

(require 'highlight-symbol)
(global-set-key (kbd "C-c h") 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)

(add-to-list 'auto-mode-alist '("\\.scss$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.less$" . web-mode))

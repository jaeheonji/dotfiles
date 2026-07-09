;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Maple Mono NF" :size 15 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Maple Mono NF" :size 15))

(defun hangul-font ()
  (set-fontset-font t 'hangul (font-spec :family "Pretendard")))
(add-hook 'after-setting-font-hook #'hangul-font)

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'catppuccin)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Keep the key/function pairs in one place so the same window navigation
;; bindings can be applied to global, Evil, and terminal-specific keymaps.
(defconst my/window-navigation-bindings
  '(("M-h" . evil-window-left)
    ("M-j" . evil-window-down)
    ("M-k" . evil-window-up)
    ("M-l" . evil-window-right)))

;; Make M-h/j/k/l work as regular Emacs global bindings.
(dolist (binding my/window-navigation-bindings)
  (global-set-key (kbd (car binding)) (cdr binding)))

;; Evil has separate keymaps for each state, so bind the same keys in every
;; state where direct window navigation should work, including insert state.
(with-eval-after-load 'evil
  (dolist (map (list evil-normal-state-map
                     evil-visual-state-map
                     evil-insert-state-map
                     evil-emacs-state-map
                     evil-motion-state-map
                     evil-replace-state-map))
    (dolist (binding my/window-navigation-bindings)
      (define-key map (kbd (car binding)) (cdr binding)))))

;; Ghostel normally sends Meta key chords like M-h to the terminal process.
;; Treat M-h/j/k/l as Emacs-owned keys instead, then bind them in every ghostel
;; input keymap so window navigation works from terminal buffers as well.
(with-eval-after-load 'ghostel
  (dolist (key '("M-h" "M-j" "M-k" "M-l"))
    (add-to-list 'ghostel-keymap-exceptions key))
  ;; Rebuild the semi-char map so the updated exception list takes effect.
  (ghostel--rebuild-semi-char-keymap)
  (dolist (map (list ghostel-mode-map
                     ghostel-semi-char-mode-map
                     ghostel-char-mode-map
                     ghostel-readonly-mode-map
                     ghostel-readonly-fast-exit-mode-map
                     ghostel-line-mode-map))
    (dolist (binding my/window-navigation-bindings)
      (define-key map (kbd (car binding)) (cdr binding)))))

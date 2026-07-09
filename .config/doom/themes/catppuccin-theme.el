;;; catppuccin-theme.el --- Catppuccin Mocha with black backgrounds -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Author: jaeheonji <https://github.com/jaeheonji>
;; Source: https://github.com/catppuccin/nvim
;;
;;; Commentary:
;;
;; A Doom theme based on Catppuccin Mocha, with transparent-style surfaces
;; represented as pitch black backgrounds.
;;
;;; Code:

(require 'doom-themes)


;;
;;; Variables

(defgroup catppuccin-theme nil
  "Options for the `catppuccin' theme."
  :group 'doom-themes)

(defcustom catppuccin-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'catppuccin-theme
  :type '(choice integer boolean))


;;
;;; Theme definition

(def-doom-theme catppuccin
  "Catppuccin Mocha with black transparent-style backgrounds."
  :family 'catppuccin
  :background-mode 'dark

  ;; name        default   256       16
  ((bg         '("#000000" "black"   "black"        ))
   (bg-alt     '("#000000" "black"   "black"        ))
   (base0      '("#000000" "black"   "black"        ))
   (base1      '("#11111b" "#121212" "brightblack"  ))
   (base2      '("#181825" "#1c1c1c" "brightblack"  ))
   (base3      '("#1e1e2e" "#262626" "brightblack"  ))
   (base4      '("#313244" "#3a3a3a" "brightblack"  ))
   (base5      '("#6c7086" "#6c6c6c" "brightblack"  ))
   (base6      '("#7f849c" "#808080" "brightblack"  ))
   (base7      '("#bac2de" "#bcbcbc" "brightwhite"  ))
   (base8      '("#cdd6f4" "#d0d0d0" "white"        ))
   (fg         '("#cdd6f4" "#d0d0d0" "brightwhite"  ))
   (fg-alt     '("#a6adc8" "#a8a8a8" "white"        ))

   (rosewater  '("#f5e0dc" "#f5e0dc" "brightwhite"  ))
   (flamingo   '("#f2cdcd" "#f2cdcd" "brightwhite"  ))
   (pink       '("#f5c2e7" "#f5c2e7" "brightmagenta"))
   (mauve      '("#cba6f7" "#cba6f7" "magenta"      ))
   (red        '("#f38ba8" "#f38ba8" "red"          ))
   (maroon     '("#eba0ac" "#eba0ac" "red"          ))
   (peach      '("#fab387" "#fab387" "brightred"    ))
   (yellow     '("#f9e2af" "#f9e2af" "yellow"       ))
   (green      '("#a6e3a1" "#a6e3a1" "green"        ))
   (teal       '("#94e2d5" "#94e2d5" "brightgreen"  ))
   (sky        '("#89dceb" "#89dceb" "brightcyan"   ))
   (sapphire   '("#74c7ec" "#74c7ec" "cyan"         ))
   (blue       '("#89b4fa" "#89b4fa" "brightblue"   ))
   (lavender   '("#b4befe" "#b4befe" "brightblue"   ))

   (grey       base5)
   (orange     peach)
   (magenta    mauve)
   (violet     mauve)
   (cyan       sky)
   (dark-blue  sapphire)
   (dark-cyan  teal)

   ;; face categories -- required for all Doom themes
   (highlight      blue)
   (vertical-bar   base1)
   (selection      base4)
   (builtin        pink)
   (comments       '("#9399b2" "#9399b2" "brightblack"  ))
   (doc-comments   fg-alt)
   (constants      peach)
   (functions      blue)
   (keywords       mauve)
   (methods        blue)
   (operators      sky)
   (type           yellow)
   (strings        green)
   (variables      flamingo)
   (numbers        peach)
   (region         selection)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    peach)
   (vc-added       green)
   (vc-deleted     red)

   ;; custom categories
   (modeline-fg              fg)
   (modeline-fg-alt          fg-alt)
   (modeline-bg              bg)
   (modeline-bg-alt          bg)
   (modeline-bg-inactive     bg)
   (modeline-bg-inactive-alt bg)

   (-modeline-pad
    (when catppuccin-padded-modeline
      (if (integerp catppuccin-padded-modeline) catppuccin-padded-modeline 4))))

  ;;;; Base theme face overrides
  (((default &override) :background bg :foreground fg)
   ((fringe &override) :background bg :foreground base5)
   ((highlight &override) :background base3 :foreground fg)
   ((hl-line &override) :background base1 :extend t)
   ((region &override) :background region :foreground 'unspecified :extend t)
   ((secondary-selection &override) :background base3 :extend t)
   ((line-number &override) :background bg :foreground base4)
   ((line-number-current-line &override) :background bg :foreground lavender)
   ((vertical-border &override) :background bg :foreground vertical-bar)
   ((window-divider &override) :inherit 'vertical-border)
   ((window-divider-first-pixel &override) :inherit 'vertical-border)
   ((window-divider-last-pixel &override) :inherit 'vertical-border)

   (cursor :background rosewater)
   (escape-glyph :foreground peach)
   (minibuffer-prompt :foreground mauve :weight 'bold)
   (tooltip :background bg :foreground fg)
   (link :foreground blue :underline t)
   (lazy-highlight :background base3 :foreground lavender :weight 'bold)
   (match :background base3 :foreground green :weight 'bold)

   (font-lock-comment-face :foreground comments :slant 'italic)
   (font-lock-doc-face :inherit 'font-lock-comment-face :foreground doc-comments)
   (font-lock-function-name-face :foreground functions)
   (font-lock-keyword-face :foreground keywords :weight 'bold)
   (font-lock-string-face :foreground strings)
   (font-lock-type-face :foreground type)
   (font-lock-variable-name-face :foreground variables)
   (font-lock-property-name-face :foreground sapphire)
   (font-lock-number-face :foreground numbers)
   (font-lock-constant-face :foreground constants)
   (font-lock-builtin-face :foreground builtin)
   (font-lock-operator-face :foreground operators)
   (font-lock-punctuation-face :foreground (doom-blend operators fg 0.35))

   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-active :inherit 'mode-line)
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground lavender :weight 'bold)
   (mode-line-highlight :background base3 :foreground fg)
   (mode-line-buffer-id :foreground blue :weight 'bold)
   (header-line :inherit 'mode-line)

   (tab-line :background bg :foreground fg-alt)
   (tab-line-tab :background bg :foreground fg)
   (tab-line-tab-current :background bg :foreground lavender :weight 'bold)
   (tab-line-tab-inactive :background bg :foreground base5)
   (tab-bar :background bg :foreground fg-alt)
   (tab-bar-tab :background bg :foreground lavender :weight 'bold)
   (tab-bar-tab-inactive :background bg :foreground base5)

   ;;;; completion / popup
   (company-tooltip :background bg :foreground fg)
   (company-tooltip-common :foreground lavender :weight 'bold)
   (company-tooltip-selection :background base3 :foreground fg)
   (company-scrollbar-bg :background bg)
   (company-scrollbar-fg :background base4)
   (corfu-default :background bg :foreground fg)
   (corfu-current :background base3 :foreground fg)
   (popup-face :background bg :foreground fg)
   (popup-tip-face :background bg :foreground mauve)
   (popup-selection-face :background base3 :foreground fg)
   (ivy-current-match :background base3 :foreground fg :weight 'bold)
   (ivy-posframe :background bg :foreground fg)
   (vertico-current :background base3 :foreground fg)

   ;;;; doom-modeline
   (doom-modeline-bar :background mauve)
   (doom-modeline-buffer-file :inherit 'mode-line-buffer-id :weight 'bold)
   (doom-modeline-buffer-path :foreground blue :weight 'bold)
   (doom-modeline-buffer-project-root :foreground green :weight 'bold)

   ;;;; solaire-mode
   (solaire-default-face :inherit 'default :background bg)
   (solaire-hl-line-face :inherit 'hl-line :background base1)
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-alt)))

   ;;;; org / markdown
   ((org-block &override) :background base1 :extend t)
   ((org-block-begin-line &override) :background bg :foreground base5 :slant 'italic :extend t)
   ((org-block-end-line &override) :background bg :foreground base5 :slant 'italic :extend t)
   ((org-code &override) :foreground peach :background base1)
   ((org-verbatim &override) :foreground green :background base1)
   ((org-quote &override) :background base1 :extend t)
   ((org-table &override) :foreground sapphire)
   ((org-todo &override) :foreground red :weight 'bold)
   ((org-done &override) :foreground green :weight 'bold)
   ((org-date &override) :foreground blue)
   ((org-tag &override) :foreground base6)
   (org-ellipsis :foreground base5 :underline nil)
   (markdown-markup-face :foreground base5)
   (markdown-header-face :foreground mauve :weight 'bold)
   ((markdown-code-face &override) :background base1 :foreground fg)
   ((markdown-pre-face &override) :background base1 :foreground fg)

   ;;;; magit / diff
   (diff-added :background (doom-blend green bg 0.16) :foreground green)
   (diff-removed :background (doom-blend red bg 0.16) :foreground red)
   (diff-changed :background (doom-blend yellow bg 0.16) :foreground yellow)
   (diff-refine-added :background (doom-blend green bg 0.32) :foreground green)
   (diff-refine-removed :background (doom-blend red bg 0.32) :foreground red)
   (magit-section-heading :foreground mauve :weight 'bold)
   (magit-branch-local :foreground blue)
   (magit-branch-remote :foreground green)
   (magit-diff-context :foreground fg-alt :background bg)
   (magit-diff-context-highlight :foreground fg :background base1)
   (magit-diff-hunk-heading :foreground fg-alt :background base2)
   (magit-diff-hunk-heading-highlight :foreground fg :background base3 :weight 'bold)
   (magit-diff-added :inherit 'diff-added)
   (magit-diff-added-highlight :background (doom-blend green bg 0.22) :foreground green)
   (magit-diff-removed :inherit 'diff-removed)
   (magit-diff-removed-highlight :background (doom-blend red bg 0.22) :foreground red)

   ;;;; lsp / diagnostics
   (lsp-ui-doc-background :background bg)
   (lsp-face-highlight-read :background base3)
   (lsp-face-highlight-textual :background base3)
   (lsp-face-highlight-write :background base3)
   (flycheck-error :underline `(:style wave :color ,red))
   (flycheck-warning :underline `(:style wave :color ,yellow))
   (flycheck-info :underline `(:style wave :color ,blue))
   (flymake-error :underline `(:style wave :color ,red))
   (flymake-warning :underline `(:style wave :color ,yellow))
   (flymake-note :underline `(:style wave :color ,blue))

   ;;;; tree / misc UI
   (treemacs-directory-face :foreground blue)
   (treemacs-file-face :foreground fg)
   (treemacs-root-face :foreground mauve :weight 'bold :height 1.2)
   (treemacs-git-added-face :foreground green)
   (treemacs-git-modified-face :foreground peach)
   (treemacs-git-untracked-face :foreground sapphire)
   (which-key-key-face :foreground mauve)
   (which-key-group-description-face :foreground blue)
   (which-key-command-description-face :foreground fg)
   (which-key-local-map-description-face :foreground pink)
   (hl-todo :foreground bg :background yellow :weight 'bold)
   (whitespace-space :foreground base3)
   (whitespace-tab :foreground base3)
   (whitespace-newline :foreground base3)
   (whitespace-trailing :background red)
   (show-paren-match :background base3 :foreground rosewater :weight 'bold)
   (show-paren-mismatch :background red :foreground bg :weight 'bold)

   ;;;; terminal colors
   (term-color-black :background bg :foreground bg)
   (term-color-red :background red :foreground red)
   (term-color-green :background green :foreground green)
   (term-color-yellow :background yellow :foreground yellow)
   (term-color-blue :background blue :foreground blue)
   (term-color-magenta :background mauve :foreground mauve)
   (term-color-cyan :background sky :foreground sky)
   (term-color-white :background fg :foreground fg)
   (vterm-color-black :background bg :foreground bg)
   (vterm-color-red :background red :foreground red)
   (vterm-color-green :background green :foreground green)
   (vterm-color-yellow :background yellow :foreground yellow)
   (vterm-color-blue :background blue :foreground blue)
   (vterm-color-magenta :background mauve :foreground mauve)
   (vterm-color-cyan :background sky :foreground sky)
   (vterm-color-white :background fg :foreground fg))

  ;;;; Base theme variable overrides
  ((ansi-color-names-vector
    (vconcat (mapcar #'doom-color '(bg red green yellow blue magenta cyan fg))))
   (pdf-view-midnight-colors `(cons ,(doom-color 'fg) ,(doom-color 'bg)))
   (vc-annotate-background (doom-color 'bg))))

;;; catppuccin-theme.el ends here

# Dotfiles

Personal `zsh`, `vim`, and `tmux` configuration with a focus on fast terminal workflows, readable defaults, and lightweight custom behavior.

## Zsh

Main features:

- Large shared history (`HISTSIZE`/`SAVEHIST` = `100000`)
- Incremental + shared history across sessions
- Duplicate/whitespace history cleanup (`HIST_IGNORE_DUPS`, `HIST_IGNORE_SPACE`, `HIST_REDUCE_BLANKS`)
- `compinit` completion with menu selection
- Auto-load completions when available:
  - `kubectl`
  - `docker`
  - `kind`
- Sources local config fragments from `$DOTFILES_DIR` if present:
  - `aliases`
  - `prompt`
  - `private`
- Plugin loading (if installed in `zsh/`):
  - `zsh-autosuggestions`
  - `zsh-z`

## Vim

Main features:

- Sane editing defaults:
  - spaces instead of tabs (`expandtab`)
  - 2-space indentation (`tabstop`, `shiftwidth`, `softtabstop`)
  - smart search (`ignorecase` + `smartcase`)
  - mouse enabled
  - no wrap
  - split right / split below
- Visual whitespace support (toggle with `L`)
  - spaces/trailing spaces shown as `·`
  - hidden by default (`nolist`)
- UI customization:
  - line numbers in gray (`#555555`)
  - transparent editor background (uses terminal theme)
  - custom statusline:
    - left: full file path (`~/...`)
    - right: Git branch (cached, fast redraw-safe)
    - dark gray base + lighter gray branch segment
  - subtle split separators (`│`)
- Window and tab workflow:
  - `;v` vertical split
  - `;h` horizontal split
  - `;o` switch to next split
  - `;t` new tab
  - `;+` / `;-` resize current split width by 5
  - `Shift+Arrow` moves between panes (Normal + Insert mode)
- Search/visibility shortcuts:
  - `Ctrl+n` toggle line numbers
  - `Ctrl+l` clear search highlight
  - `;<Space>` clear search highlight
- Netrw sidebar setup:
  - `;e` opens/toggles `:Lexplore`
  - tree view, banner off, fixed-width sidebar
  - netrw sidebar statusline is blank
- Custom YAML folding (`vim/qbcmp_vim_yaml_fold.vim`)
  - indentation-based folding for YAML
  - custom fold text with IDE-style triangle (`▸`)
  - no default Vim fold filler text/padding
  - folded line keeps normal buffer colors
  - files open expanded by default; fold manually as needed
- Text helpers:
  - Visual `;r`: replace all occurrences of selected text in current buffer
  - Visual `;s`: strikethrough selected text (Unicode combining overlay)
- Cross-platform clipboard handling:
  - native clipboard on macOS/Linux when Vim has `+clipboard`
  - WSL-specific fallback mappings (`clip.exe`) when native clipboard is unavailable

## tmux

Main features:

- Dual prefixes:
  - `Ctrl-b` (default)
  - backtick `` ` ``
- Modern terminal support:
  - `default-terminal "tmux-256color"`
  - `focus-events on`
  - `set-clipboard on`
  - `allow-passthrough on`
  - `escape-time 0` (low-latency `Esc`)
- Workflow helpers:
  - `c` opens new window in current pane path
  - `!` breaks pane into a new window
  - `prefix + m` toggles mouse mode on/off
- Pane navigation:
  - `Alt+Arrow` to move between panes
- Copy mode:
  - vi keys enabled
  - `v` begins selection
  - `y` copies selection and exits copy mode
- Status bar theme:
  - custom colors
  - date/time on the right
  - customized current/non-current window labels


# nvim-prose

A Neovim configuration that behaves like a calm text editor (Word / Google
Docs) instead of a code editor. Built for writing Polish prose in Markdown.

What you get:

- Word-style navigation: arrows move by screen line, Ctrl+Arrows jump by
  word/paragraph, Shift+Arrows select, Home/End respect soft wrap.
- Zen mode on by default: narrow centered column, no line numbers, no
  gutter, minimal statusline with a live word count.
- Polish spellcheck, hard wrap at 80 columns for prose files.
- Live Markdown rendering and an F1 cheatsheet of every binding.
- `<leader>e` (Space e) saves and exports to a styled `.docx`, asking for
  font, size, and line spacing first (your last picks are remembered).

## Requirements

- Neovim **0.10 or newer** (`nvim --version` to check).
- `git` (the plugin manager clones plugins on first launch).
- `pandoc` (Markdown → `.docx` conversion).
- `python3` with `python-docx`, installed for the `python3` on your PATH —
  verify with `python3 -c "import docx"`. (With conda first on PATH, an
  `apt install python3-docx` lands in the system Python where the export
  can't see it — install into conda instead, see Troubleshooting.)
- A terminal sending standard xterm keycodes for modified arrows
  (Ghostty, kitty, WezTerm, modern VTE-based terminals all do).

## Install

```sh
git clone git@github.com:p-kocur/nvim-prose.git ~/.config/nvim-prose
sudo apt install git pandoc python3-docx
```

Ubuntu's apt Neovim is often older than 0.10 — if `nvim --version`
disagrees, install the official release tarball or
`sudo snap install nvim --classic` instead.

No build step, no daemons. The first launch (needs network once) makes
lazy.nvim install the pinned plugins from `lazy-lock.json`, and Neovim
asks to download the Polish spell files — answer `y`.

## Run it smoothly

The config lives beside any other Neovim setup under its own app name, so
launch it as `NVIM_APPNAME=nvim-prose nvim file.md` — or skip typing that
with a one-word alias. In `~/.bashrc` (bash) or `~/.zshrc` (zsh) add:

```sh
alias prose='NVIM_APPNAME=nvim-prose nvim'
```

Then reload (`source ~/.bashrc` or restart the shell) and just run:

```sh
prose myfile.md
```

from any directory.

## Everyday keys

Press F1 inside the editor for the full cheatsheet. The essentials:

| Keys | Action |
| --- | --- |
| Arrows | Move by screen line |
| Ctrl+Arrows | Jump by word (Left/Right) or paragraph (Up/Down) |
| Shift+Arrows | Select text |
| Ctrl+Shift+Arrows | Select by word / paragraph |
| Home / End (+ Shift) | Line start / end (and select to it) |
| Space e | Save, pick export options, export to `.docx` |
| F1 | Cheatsheet (`q` or `Esc` closes it) |
| `]s` / `[s`, `z=`, `zg` | Next/previous misspelling, suggestions, add word |

`:q`, `:wq`, and `:q!` all quit in one step, even with Zen mode open.

## Export

`<leader>e` asks for font (Times New Roman, Calibri, Georgia), size (11,
12, 14), and spacing (single, 1.5, double), then writes `name.docx` next
to `name.md` and notifies you with the output path. Cancelling any picker
aborts silently (the file stays saved). Last picks persist across sessions.

## Layout

```text
~/.config/nvim-prose/
├── init.lua
├── lua/core/      options, keymaps, plugins bootstrap, export, help
├── lua/plugins/   zen-mode UI, markdown rendering, word count
└── scripts/       export_docs.py (pandoc + python-docx converter)
```

Not in the repo (rebuilt automatically): installed plugins, spell files,
and export history under `~/.local/share/nvim-prose/`.

## Troubleshooting

- `Export failed (exit 2) ... python-docx not found for /path/to/python3`:
  install it into *that* interpreter, e.g.
  `/path/to/pip install python-docx`.
- `pandoc not found`: `sudo apt install pandoc`.
- `:q` needs repeating / Zen never opens: update Neovim past 0.10.
- Modified arrows print characters instead of moving: the terminal doesn't
  send xterm keycodes — switch terminal or remap in `lua/core/keymaps.lua`.

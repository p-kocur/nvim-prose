# nvim-prose — project decisions

Status: **Final** (accepted with your answer "I accept!").
Language: English for conversation and documentation; the editor itself targets Polish prose.

## Goal

A complete Neovim configuration in `~/.config/nvim-prose/` that behaves like
a text editor (Word / Google Docs, distraction-free writing), not a code editor.

## Settled decisions

- **D1 — Working location: `~/.config/nvim-prose/`.**
  The name `nvim-pisarz` is abandoned (your answer: "A - zapomnij o nazwie
  nvim-pisarz, bedziemy poslugiwac sie dalej nvim-prose").
  Decisions are recorded in this file (`PROJECT.md`) in the working directory.
- **D2 — Conversation and documentation language: English.**
  (Your answer: "A - and btw, let's switch to english. this is for polish prose,
  yes, but let's talk and keep documentation in english".)
  Spellcheck and prose remain Polish; everything around them is English.
- **D3 — `<leader>` key: Space.**
  (Your answer: "A" to Question 3.)
- **D4 — Statusline: absolute minimum (one slim line), not fully hidden.**
  (Your answer: "A" to Question 4.) Keeps a persistent home for the word count.
- **D5 — Word count: minimal Lualine with a word-count component.**
  (Your answer: "A" to Question 5.) One plugin covers both statusline and counter.
- **D6 — Zen plugin: `folke/zen-mode.nvim`, on by default at startup.**
  (Your answer: "A" to Question 6.)
- **D7 — `export_docs.py` stub: minimal executable skeleton.**
  (Your answer: "A" to Question 7.) Shebang, accepts the file path argument,
  prints "not implemented yet", exits 0. Still a stub — no real logic.
- **D8 — Help: custom floating cheatsheet on F1, zero new dependencies.**
  (Step-2 answer: "Q1 -- A".) Toggle with F1, close with q/Esc; lists
  movement, selection, actions, and spellcheck bindings.
- **D9 — Hard wrap: `textwidth=80` + wrap-while-typing for markdown/text.**
  (Step-2 answer: "Q2 -- A".) Reverses `textwidth=0` for those filetypes
  only; code and config files keep soft-wrap-only.
- **D10 — Real export: pandoc Markdown→`.docx`, same folder, same basename.**
  (Step-3 answers: "Q1 -- B" and "Q2 -- A".) Prerequisite: you install
  pandoc. The script prints the output path on success; errors go to
  stderr with a nonzero exit, and the editor shows both.
- **D11 — Export styling default: Times New Roman 12.**
  (Step-4 answer: "B".) Applied via python-docx after pandoc; prerequisite:
  you install python3-docx.
- **D12 — Export options window: font → size → spacing pickers.**
  (Step-4 answer: "Q2 A".) Native `vim.ui.select`, last picks first and
  persisted across sessions, then the export runs. Stays `.docx`-only.

## Scope contract (accepted)

Accepted with your answer "A" (no changes) to Question 2.

**Artifact boundary — in scope (Step 1):**

- `init.lua`
- `lua/core/options.lua`, `lua/core/keymaps.lua`, `lua/core/lazy.lua` (lazy.nvim bootstrap)
- `lua/plugins/ui.lua` (ZenMode, hiding UI)
- `lua/plugins/markdown.lua` (render-markdown.nvim)
- `lua/plugins/writing.lua` (proofing, word count)
- `scripts/export_docs.py` — stub only (empty file to be filled in later)
- this file (`PROJECT.md`) as the decision record

**Out of scope:**

- `export_docs.py` logic (document export) — deferred proposal, returns in its own interview
- extra plugins beyond the three named ones (ZenMode, render-markdown, word count)
- automated tests and CI

**Done means (all points observable):**

1. `PROJECT.md` in Final status after your acceptance.
2. All listed files exist; Lua code clean and documented.
3. `lazy.nvim` bootstraps itself and loads the three plugins.
4. At startup: word wrap, no line numbers, no signcolumn, `pl` spellcheck,
   Zen mode on by default, text centered.
5. Word-like navigation: Ctrl+Arrows jump by words, Shift+Arrows select,
   `<leader>e` saves and asynchronously calls the export stub.
6. Markdown rendered live, word count visible.
7. `export_docs.py` exists as a stub and does nothing yet.

**Staging rules:** accepting this record never approves later stages
(export logic). Words like "go / do it all" authorize only the boundary above;
anything beyond it needs your explicit approval or moves to a follow-up topic.

## Step 2 amendment (approved)

Approved with your answer "Q1 -- A, Q2 -- A" to the Step-2 questions.

**Boundary additions:**

- `lua/core/help.lua` (new): F1 cheatsheet floating window.
- `init.lua`: also requires `core.help`.
- `lua/core/options.lua`: filetype-scoped hard wrap for prose (D9).

**Done means (Step 2):**

1. F1 opens a centered float listing the bindings; q/Esc/F1 closes it.
2. Markdown/text buffers get `textwidth=80` and auto-wrap while typing.
3. Lua (and other) buffers keep `textwidth=0`.

## Step 3 amendment (approved)

Approved with your answers "Q1 -- B, I prefer it to be more versatile."
and "Q2 -- A". Supersedes the D7 stub and Step-1 Done #7.

**Boundary (no new files):**

- `scripts/export_docs.py`: real pandoc conversion (was: stub).
- `lua/core/keymaps.lua`: `<leader>e` also captures the script's stderr,
  so failure reasons reach the notification.

**Done means (Step 3):**

1. `<leader>e` on `name.md` produces `name.docx` next to it, Polish
   characters intact, and the notification shows the output path.
2. Missing source file → clear error, no export attempted.
3. Missing pandoc → clear error telling you to install it.
4. Failing export → notification shows the failure reason, not silence.

## Step 4 amendment (approved)

Approved with your answers "B" (Q1: Times New Roman 12) and "Q2 A"
(options window with font → size → spacing pickers).

**Boundary:**

- `lua/core/export.lua` (new): picker flow + export runner.
- `lua/core/keymaps.lua`: `<leader>e` delegates to it.
- `scripts/export_docs.py`: `--font`/`--size`/`--spacing` args, styling
  via python-docx after the pandoc conversion.

**Done means (Step 4):**

1. `<leader>e` asks font, then size, then spacing (last picks first),
   then exports; cancelling any picker aborts silently.
2. The `.docx` carries the chosen font, size, and line spacing.
3. Missing python-docx → clear error telling you to install it.

## Step 5 amendment (docs, approved)

Approved with your request "Add all installation and this bash/zsh trick
to README". Boundary: new `README.md` (install, run, keys, export,
troubleshooting). No code changes.

## Open questions

None — decision tree exhausted and document accepted as Final.

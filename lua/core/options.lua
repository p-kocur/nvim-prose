-- Core editor options for prose writing.
-- Goal: a calm page of text -- soft word wrap, no code chrome,
-- Polish spellcheck. Plugin-specific options live in lua/plugins/.

local opt = vim.opt

-- -- Writing surface -------------------------------------------------------
opt.wrap = true -- soft-wrap long lines (visual only, file keeps long lines)
opt.linebreak = true -- wrap at word boundaries, never mid-word
opt.breakindent = true -- keep indentation on wrapped lines
opt.textwidth = 0 -- never hard-wrap while typing; wrapping stays visual

-- -- Hide code-oriented chrome ------------------------------------------------
opt.number = false -- no absolute line numbers
opt.relativenumber = false -- no relative line numbers
opt.signcolumn = "no" -- no gutter for diagnostics / git signs
opt.showmode = false -- no "-- INSERT --" text (the statusline shows the mode)
opt.laststatus = 2 -- one slim statusline (Decision D4: absolute minimum)
opt.fillchars = { eob = " " } -- hide the "~" end-of-buffer filler lines
opt.termguicolors = true -- true colors for Markdown rendering and Zen mode

-- -- Polish spellcheck ---------------------------------------------------------
opt.spell = true -- underline misspelled words
opt.spelllang = "pl" -- Polish dictionary
opt.spellfile = vim.fn.stdpath("config") .. "/spell/pl.utf-8.add" -- your own words (`zg`)

-- -- Word-like comfort ----------------------------------------------------------
opt.clipboard = "unnamedplus" -- yank/paste uses the system clipboard
opt.undofile = true -- persistent undo across sessions (prose is precious)

-- -- Hard wrap for prose files (Decision D9) --------------------------------------
-- Markdown/text get real newlines at 80 columns while typing (A4-ish width).
-- Single newlines render as spaces in Markdown, so reading is unaffected.
-- Code and config files keep soft-wrap-only (textwidth 0 above).
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.formatoptions:append("t") -- auto-wrap while typing
  end,
})

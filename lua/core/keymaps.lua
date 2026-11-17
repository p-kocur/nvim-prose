-- Word-like navigation and text selection.
-- Assumes a terminal that sends standard xterm keycodes for modified arrows
-- (Ctrl+Arrow, Shift+Arrow, Ctrl+Shift+Arrow). Ghostty, kitty, WezTerm and
-- modern VTE-based terminals all do.

local map = vim.keymap.set

-- -- Display-line movement ----------------------------------------------------
-- With soft wrap enabled, Up/Down move by screen line (like Word),
-- not by file line (Vim's default j/k behavior).
map({ "n", "v" }, "<Up>", "gk", { desc = "Move up by screen line" })
map({ "n", "v" }, "<Down>", "gj", { desc = "Move down by screen line" })
-- In Insert mode, fall back to plain arrows while a completion popup is open
-- so popup navigation keeps working.
map("i", "<Up>", function()
  return vim.fn.pumvisible() == 1 and "<Up>" or "<C-o>gk"
end, { expr = true, desc = "Move up by screen line" })
map("i", "<Down>", function()
  return vim.fn.pumvisible() == 1 and "<Down>" or "<C-o>gj"
end, { expr = true, desc = "Move down by screen line" })

-- -- Word and paragraph jumps (Ctrl+Arrows, like Word) -------------------------
-- Ctrl+Left/Right hop by words; Ctrl+Up/Down hop by paragraphs.
-- In Visual mode the same keys extend the selection.
map({ "n", "v" }, "<C-Left>", "b", { desc = "Jump one word left" })
map({ "n", "v" }, "<C-Right>", "w", { desc = "Jump one word right" })
map({ "n", "v" }, "<C-Up>", "{", { desc = "Jump one paragraph up" })
map({ "n", "v" }, "<C-Down>", "}", { desc = "Jump one paragraph down" })
-- <C-o> runs one Normal command and returns to Insert mode.
map("i", "<C-Left>", "<C-o>b", { desc = "Jump one word left" })
map("i", "<C-Right>", "<C-o>w", { desc = "Jump one word right" })
map("i", "<C-Up>", "<C-o>{", { desc = "Jump one paragraph up" })
map("i", "<C-Down>", "<C-o>}", { desc = "Jump one paragraph down" })

-- -- Select by words and paragraphs (Ctrl+Shift+Arrows, like Word) -------------
map("n", "<C-S-Left>", "vb", { desc = "Select one word left" })
map("n", "<C-S-Right>", "vw", { desc = "Select one word right" })
map("n", "<C-S-Up>", "v{", { desc = "Select one paragraph up" })
map("n", "<C-S-Down>", "v}", { desc = "Select one paragraph down" })
map("v", "<C-S-Left>", "b", { desc = "Extend selection one word left" })
map("v", "<C-S-Right>", "w", { desc = "Extend selection one word right" })
map("v", "<C-S-Up>", "{", { desc = "Extend selection one paragraph up" })
map("v", "<C-S-Down>", "}", { desc = "Extend selection one paragraph down" })

-- -- Select text (Shift+Arrows, like Word) --------------------------------------
-- From Normal or Insert this enters Visual mode and stays there:
-- type to replace the selection, yank/delete to use it, Esc to stop.
map("n", "<S-Left>", "vh", { desc = "Select one character left" })
map("n", "<S-Right>", "vl", { desc = "Select one character right" })
map("n", "<S-Up>", "vgk", { desc = "Select one screen line up" })
map("n", "<S-Down>", "vgj", { desc = "Select one screen line down" })
map("v", "<S-Left>", "h", { desc = "Extend selection one character left" })
map("v", "<S-Right>", "l", { desc = "Extend selection one character right" })
map("v", "<S-Up>", "gk", { desc = "Extend selection one screen line up" })
map("v", "<S-Down>", "gj", { desc = "Extend selection one screen line down" })
-- <C-o>v enters Visual mode; the motion after it extends the selection once.
map("i", "<S-Left>", "<C-o>vh", { desc = "Select one character left" })
map("i", "<S-Right>", "<C-o>vl", { desc = "Select one character right" })
map("i", "<S-Up>", "<C-o>vgk", { desc = "Select one screen line up" })
map("i", "<S-Down>", "<C-o>vgj", { desc = "Select one screen line down" })

-- -- Line start/end (Home/End, like Word) ----------------------------------------
-- g0/g$ respect soft wrap (screen line); 0/$ would jump whole file lines.
map({ "n", "v" }, "<Home>", "g0", { desc = "Go to start of screen line" })
map({ "n", "v" }, "<End>", "g$", { desc = "Go to end of screen line" })
map("i", "<Home>", "<C-o>g0", { desc = "Go to start of screen line" })
map("i", "<End>", "<C-o>g$", { desc = "Go to end of screen line" })
map("n", "<S-Home>", "vg0", { desc = "Select to start of screen line" })
map("n", "<S-End>", "vg$", { desc = "Select to end of screen line" })
map("v", "<S-Home>", "g0", { desc = "Extend selection to start of screen line" })
map("v", "<S-End>", "g$", { desc = "Extend selection to end of screen line" })
map("i", "<S-Home>", "<C-o>vg0", { desc = "Select to start of screen line" })
map("i", "<S-End>", "<C-o>vg$", { desc = "Select to end of screen line" })

-- -- Save and export --------------------------------------------------------------
-- <leader>e saves the file, then opens the export options (font, size,
-- spacing) and runs the converter asynchronously (see core/export).
map("n", "<leader>e", function()
  require("core.export").run()
end, { desc = "Save and export with options" })

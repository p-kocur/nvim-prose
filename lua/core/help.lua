-- Cheatsheet: a floating help window listing every binding (Decision D8).
-- Press F1 in any mode to toggle it; q or Esc closes it.
-- NOTE: the text below mirrors lua/core/keymaps.lua -- update both together.

local M = {}

local lines = {
  "nvim-prose cheatsheet              (F1 toggles, q/Esc closes)",
  "",
  "MOVE LIKE WORD",
  "  Up / Down            move by screen line (soft-wrapped)",
  "  Ctrl+Left / Right    jump one word",
  "  Ctrl+Up / Down       jump one paragraph",
  "  Home / End           start / end of screen line",
  "",
  "SELECT LIKE WORD",
  "  Shift+Arrows         select (stays selected; type to replace)",
  "  Ctrl+Shift+Arrows    select by word / paragraph",
  "  Shift+Home / End     select to start / end of line",
  "",
  "ACTIONS",
  "  Space e (<leader>e)  save, pick options, export it",
  "  F1                   this cheatsheet",
  "",
  "POLISH SPELLCHECK (built in)",
  "  ]s / [s              next / previous misspelling",
  "  z=                   spelling suggestions",
  "  zg / zw              add word to dictionary / mark wrong",
}

function M.open()
  -- Toggle: F1 while open closes the window.
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_close(M.win, true)
    M.win, M.buf = nil, nil
    return
  end
  M.buf = vim.api.nvim_create_buf(false, true) -- scratch, unlisted
  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, lines)
  vim.bo[M.buf].modifiable = false

  -- Editor size: prefer the attached UI, fall back to global dimensions
  -- (headless runs have no UI, but floats still open fine).
  local cols, rows = vim.o.columns, vim.o.lines
  local uis = vim.api.nvim_list_uis()
  if #uis > 0 then
    cols, rows = uis[1].width, uis[1].height
  end
  local content_width = 0
  for _, l in ipairs(lines) do
    content_width = math.max(content_width, vim.fn.strdisplaywidth(l))
  end
  local win_width = math.min(content_width + 4, cols - 4)
  local win_height = math.min(#lines + 2, rows - 4)
  M.win = vim.api.nvim_open_win(M.buf, true, {
    relative = "editor",
    width = win_width,
    height = win_height,
    col = math.floor((cols - win_width) / 2),
    row = math.floor((rows - win_height) / 2),
    border = "rounded",
    style = "minimal",
    title = " nvim-prose help ",
    title_pos = "center",
  })
  vim.wo[M.win].wrap = false -- content already fits; never reflow it

  local opts = { buffer = M.buf, nowait = true, silent = true, desc = "Close help window" }
  vim.keymap.set("n", "q", M.open, opts)
  vim.keymap.set("n", "<Esc>", M.open, opts)
end

vim.keymap.set({ "n", "i", "v" }, "<F1>", M.open, { desc = "Open nvim-prose cheatsheet" })

return M

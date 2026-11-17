-- nvim-prose: entry point.
-- A distraction-free writing setup that behaves like Word / Google Docs,
-- not like a code editor. See PROJECT.md for the settled decisions.

-- The leader key must be defined BEFORE lazy.nvim loads anything,
-- otherwise plugins would capture the default "\" (Decision D3: Space).
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("core.options")
require("core.keymaps")
require("core.help")
require("core.lazy")

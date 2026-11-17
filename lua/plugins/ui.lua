-- Interface: distraction-free Zen mode, opened automatically (Decision D6).

-- Tracks whether Zen is open and which window is Zen's own (via
-- on_open/on_close below). Zen's main window is itself a float, so quit
-- handlers must tell it apart from foreign floats (F1 cheatsheet).
-- quit_from_zen records a :q/:wq/:q! issued from Zen's window; Zen's own
-- cleanup consumes it (see on_close) to finish the quit on the plain
-- layout. A refused :q (E37) leaves it stale, so any later command line
-- (the only way to toggle Zen or retry) clears it first.
local zen_open = false
local zen_win = nil
local quit_from_zen = false

return {
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 100, -- narrow, centered column of prose
      },
      plugins = {
        options = {
          enabled = true,
          -- Zen hides the statusline by default; keep our minimal one so
          -- the word count stays visible while writing (Decisions D4/D5).
          laststatus = 2,
        },
      },
      on_open = function(win)
        zen_open = true
        zen_win = win
      end,
      on_close = function()
        zen_open = false
        zen_win = nil
        if quit_from_zen then
          quit_from_zen = false
          -- The quit that closed Zen's window is done; finish the job on
          -- the plain layout that remains. Plain :q is always right here:
          -- the original :q/:wq/:q! already wrote, discarded, or E37'd.
          vim.schedule(function()
            vim.cmd("q")
          end)
        end
      end,
    },
    config = function(_, opts)
      require("zen-mode").setup(opts)
      -- Open Zen once the UI is ready. A VimEnter autocmd (rather than a
      -- direct call) guarantees the editor has finished starting up.
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          require("zen-mode").toggle()
        end,
      })
      -- Single-:q quit with Zen open. Window surgery here backfires
      -- (closing Zen silently aborts the pending :q, closing the parent
      -- is refused with E444, :only is a no-op from a float), so just
      -- record where the quit came from: Zen's own cleanup (on_close)
      -- finishes it with a deferred plain :q. Only quits issued from
      -- Zen's own window count; :q from the F1 cheatsheet float just
      -- closes the float.
      vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
          quit_from_zen = zen_open and vim.api.nvim_get_current_win() == zen_win
        end,
      })
      vim.api.nvim_create_autocmd("CmdlineEnter", {
        callback = function()
          quit_from_zen = false
        end,
      })
    end,
  },
}

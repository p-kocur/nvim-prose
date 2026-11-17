-- Writing aids: proofing status and word count in one minimal
-- statusline (Decision D5: a single Lualine instead of two plugins).

-- Shows the active spell language (e.g. "PL"), empty when spell is off.
local function spell_status()
  if vim.wo.spell then
    return vim.o.spelllang:upper()
  end
  return ""
end

-- Live word count; in Visual mode counts the selection instead.
local function word_count()
  local wc = vim.fn.wordcount()
  if vim.fn.mode():find("[vV]") then
    return string.format("%d words", wc.visual_words or 0)
  end
  return string.format("%d words", wc.words or 0)
end

return {
  {
    "nvim-lualine/lualine.nvim",
    -- No devicons dependency on purpose: no file icons, nothing to install,
    -- and icons_enabled = false keeps Lualine from expecting them.
    opts = {
      options = {
        theme = "auto",
        icons_enabled = false,
        section_separators = "",
        component_separators = "",
      },
      sections = {
        -- Mode first: options.lua sets showmode=false, so this is the only
        -- mode indicator left.
        lualine_a = { "mode" },
        lualine_b = { "filename" },
        lualine_c = {},
        lualine_x = { spell_status },
        lualine_y = {},
        lualine_z = { word_count },
      },
    },
  },
}

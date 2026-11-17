-- Markdown: live rendering in the terminal (bold/italic really shown,
-- syntax markers hidden) for Markdown buffers only.

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {},
    -- `init` runs eagerly at startup (before the first Markdown buffer),
    -- so this catches the very first Markdown file too.
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          -- Let the renderer conceal syntax markers (**, ##, ...).
          vim.opt_local.conceallevel = 2
        end,
      })
    end,
    config = function(_, opts)
      require("render-markdown").setup(opts)
    end,
  },
}

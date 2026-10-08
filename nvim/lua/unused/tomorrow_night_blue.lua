return {
  "gnfisher/tomorrow-night-blue.nvim",
  name = 'tomorrow-night-blue',
  lazy = false,
  priority = 1000,
  config = function()
    require("tomorrow-night-blue").setup({
      compile_path = vim.fn.stdpath('cache') .. '/tomorrow-night-blue',
      compile_file_suffix = '_compiled',

      transparent = true,
      terminal_colors = true,

      styles = {
        comments = { italic = true, bold = true },
        keywords = { bold = false },
        functions = {},
        variables = {},
        diagnostics = {
          virtual_text = { italic = true },
        },
      },
    })
    
    vim.cmd.colorscheme("tomorrow-night-blue")

    -- Overrides to fix dim text and soften the blue background
    local colors = {
      -- soft_bg = "#182230",   -- Muted blue background
      comment = "#728299",   -- Brightened grey-blue for readable comments
    }

    vim.api.nvim_set_hl(0, "Normal", { bg = colors.soft_bg })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.soft_bg })
    vim.api.nvim_set_hl(0, "Comment", { fg = colors.comment, italic = true })
    vim.api.nvim_set_hl(0, "LineNr", { fg = colors.comment })
  end,
}

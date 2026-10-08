return {
  {
    'NMAC427/guess-indent.nvim',
    config = function()
      require('guess-indent').setup {
        auto_cmd = true,
        override_editorconfig = false,
        filetype_exclude = { 'netrw', 'tutor' },
        buftype_exclude = { 'help', 'nofile', 'terminal', 'prompt' },
        on_tab_options = { ['expandtab'] = false },
        on_space_options = { ['expandtab'] = true, ['tabstop'] = 'detected', ['softtabstop'] = 'detected', ['shiftwidth'] = 'detected' },
      }
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
}

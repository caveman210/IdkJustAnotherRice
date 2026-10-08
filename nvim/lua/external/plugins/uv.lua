return {
  'benomahony/uv.nvim',

  -- Set back to true so you can actually use it
  enabled = true,

  ft = { 'python' },

  dependencies = {
    -- REMOVED: 'nvim-telescope/telescope.nvim'
    -- Ensuring Snacks is loaded instead so it can handle the UI
    'folke/snacks.nvim',
  },

  config = function()
    require('uv').setup {
      auto_activate_venv = true,
      notify_activate_venv = true,
      auto_commands = true,

      -- Setting this to false stops it from hard-requiring Telescope.
      -- It will fall back to vim.ui.select, which Snacks automatically makes pretty!
      picker_integration = false,

      keymaps = {
        prefix = '<leader>x',
        commands = true,
        run_file = true,
        run_selection = true,
        run_function = true,
        venv = true,
        init = true,
        add = true,
        remove = true,
        sync = true,
        sync_all = true,
      },

      execution = {
        run_command = 'uv run python',
        terminal = 'neovim',
        notify_output = true,
        notification_timeout = 10000,
      },
    }
  end,
}

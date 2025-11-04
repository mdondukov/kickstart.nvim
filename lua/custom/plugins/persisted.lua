-- Persisted.nvim: Simple session management with Telescope integration
-- Automatically saves and restores sessions per directory
return {
  {
    'olimorris/persisted.nvim',
    lazy = false, -- Load immediately for session restore
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('persisted').setup {
        -- Save session automatically when Neovim starts or you load a session
        autostart = true,

        -- Automatically load the session for the current directory on startup
        autoload = true,

        -- Directories where sessions should not be saved
        should_save = function()
          -- Don't save for certain directories (exact match only)
          local excluded_dirs = { vim.fn.expand '~/', vim.fn.expand '~/Downloads', '/' }
          local cwd = vim.fn.getcwd()
          for _, dir in ipairs(excluded_dirs) do
            if cwd == dir then
              return false
            end
          end
          return true
        end,

        -- Use git branch in session name (useful for different feature branches)
        use_git_branch = false,

        -- Follow current working directory
        follow_cwd = true,

        -- Called when autoload is enabled but there is no session to load
        on_autoload_no_session = function()
          vim.notify('No session found for current directory', vim.log.levels.INFO)
        end,
      }

      -- Telescope integration (load after telescope is ready)
      vim.schedule(function()
        pcall(require('telescope').load_extension, 'persisted')
      end)
    end,
    keys = {
      -- Telescope integration for session management
      { '<leader>ss', '<cmd>Telescope persisted<cr>', desc = '[S]earch [S]essions' },
      -- Additional session commands
      { '<leader>sS', '<cmd>SessionSave<cr>', desc = '[S]ession [S]ave' },
      { '<leader>sL', '<cmd>SessionLoad<cr>', desc = '[S]ession [L]oad' },
      { '<leader>sD', '<cmd>SessionDelete<cr>', desc = '[S]ession [D]elete' },
    },
  },
}

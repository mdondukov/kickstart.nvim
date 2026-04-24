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

      -- Close special buffers before saving session (diff views, terminals, etc.)
      vim.api.nvim_create_autocmd('User', {
        pattern = 'PersistedSavePre',
        callback = function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local name = vim.api.nvim_buf_get_name(buf)
            local bt = vim.bo[buf].buftype
            if bt == 'nofile' or name:match '://' or name:match '%.git/' then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end,
      })

      -- Telescope integration (load after telescope is ready)
      vim.schedule(function()
        pcall(require('telescope').load_extension, 'persisted')
      end)
    end,
    keys = {
      { '<leader>Ss', '<cmd>Telescope persisted<cr>', desc = '[S]ession [s]earch' },
      { '<leader>SS', '<cmd>Persisted save<cr>', desc = '[S]ession [S]ave' },
      { '<leader>Sl', '<cmd>Persisted load<cr>', desc = '[S]ession [l]oad' },
      { '<leader>SL', '<cmd>Persisted load_last<cr>', desc = '[S]ession [L]oad last' },
      { '<leader>Sd', '<cmd>Persisted delete_current<cr>', desc = '[S]ession [d]elete current' },
      { '<leader>SD', '<cmd>Persisted delete<cr>', desc = '[S]ession [D]elete (pick)' },
    },
  },
}

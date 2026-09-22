-- Auto dark mode: follow macOS appearance (light/dark) while Neovim is running.
-- Neovim only detects the terminal background at startup, so this plugin polls
-- the system appearance and swaps the GitHub theme variant live, in sync with
-- Ghostty (theme = light:GitHub Light Default,dark:GitHub Dark Default).
return {
  {
    'f-person/auto-dark-mode.nvim',
    lazy = false,
    priority = 999, -- right after github-nvim-theme (1000)
    dependencies = { 'projekt0n/github-nvim-theme' },
    config = function()
      local function apply(mode)
        vim.o.background = mode
        vim.cmd.colorscheme('github_' .. mode .. '_default')
        vim.api.nvim_set_hl(0, 'CursorLine', { bg = mode == 'dark' and '#1a2029' or '#f6f8fa' })
      end

      require('auto-dark-mode').setup {
        update_interval = 2000, -- ms
        set_dark_mode = function()
          apply 'dark'
        end,
        set_light_mode = function()
          apply 'light'
        end,
      }
    end,
  },
}

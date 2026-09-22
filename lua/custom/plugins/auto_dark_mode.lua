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
        -- Same recipe blink.cmp uses for its borders: border cells share the float
        -- background, so there is no gap between the border line and the body.
        vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'NormalFloat' })
        -- Telescope is a set of floats too: use the float background for its
        -- panels (border/title/prompt inherit from TelescopeNormal), and give
        -- the selected row its own color so it does not blend into that bg.
        vim.api.nvim_set_hl(0, 'TelescopeNormal', { link = 'NormalFloat' })
        vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = mode == 'dark' and '#17335a' or '#dae9f9' })
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

return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = {
        char = '│',
        highlight = 'IblIndent',
      },
      scope = {
        enabled = false,
      },
    },
    config = function(_, opts)
      -- Thin, subtle indent guides
      vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#21262d', nocombine = true })
      require('ibl').setup(opts)
    end,
  },
}

return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown', 'md' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    code = {
      enabled = true,
      sign = true,
      style = 'full',
      position = 'left',
      language_pad = 0,
      disable_background = { 'diff' },
      width = 'full',
      left_pad = 0,
      right_pad = 0,
      min_width = 0,
      border = 'thin',
      above = '▄',
      below = '▀',
      highlight = 'RenderMarkdownCode',
      highlight_inline = 'RenderMarkdownCodeInline',
    },
    -- Подсветка для mermaid и plantuml блоков
    pipe_table = {
      enabled = true,
      preset = 'round',
    },
  },
}

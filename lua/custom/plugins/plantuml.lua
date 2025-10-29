return {
  -- Syntax highlighting для PlantUML
  {
    'aklt/plantuml-syntax',
    ft = { 'plantuml', 'puml', 'pu' },
  },

  -- Image preview в терминале (поддерживает Kitty, iTerm2, и другие)
  {
    '3rd/image.nvim',
    event = 'VeryLazy',
    dependencies = {
      'leafo/magick',
    },
    config = function()
      require('image').setup {
        backend = 'kitty', -- kitty, ueberzug, или auto
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { 'markdown', 'vimwiki', 'plantuml' },
          },
        },
        max_width = 100,
        max_height = 12,
        max_height_window_percentage = math.huge,
        max_width_window_percentage = math.huge,
        window_overlap_clear_enabled = true,
        window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
      }
    end,
  },
}

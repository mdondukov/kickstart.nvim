-- Translate: show a translation of the selected text (or current line) in a
-- floating window next to the cursor; it closes on the next cursor move.
-- Backed by translate-shell (`trans`, in Brewfile), which uses Google Translate
-- without an API key. Works inside LSP hover too: press K twice to enter the
-- hover window, select text, then <leader>Tr.

-- The plugin's built-in wrappers cut text by character; this one wraps by word.
local WRAP_WIDTH = 80

local function wrap_words(lines)
  local out = {}
  for _, line in ipairs(lines) do
    local current = ''
    for word in line:gmatch '%S+' do
      if current == '' then
        current = word
      elseif vim.api.nvim_strwidth(current) + 1 + vim.api.nvim_strwidth(word) > WRAP_WIDTH then
        table.insert(out, current)
        current = word
      else
        current = current .. ' ' .. word
      end
    end
    table.insert(out, current)
  end
  return out
end

return {
  {
    'uga-rosa/translate.nvim',
    cmd = 'Translate',
    keys = {
      { '<leader>Tr', '<Cmd>Translate ru<CR>', mode = { 'n', 'x' }, desc = 'To [R]ussian' },
      { '<leader>Te', '<Cmd>Translate en<CR>', mode = { 'n', 'x' }, desc = 'To [E]nglish' },
    },
    opts = {
      default = {
        command = 'translate_shell',
        parse_after = 'wrap_words',
        output = 'floating',
      },
      parse_after = {
        wrap_words = { cmd = wrap_words },
      },
      preset = {
        output = {
          -- zindex above LSP hover (50) so the translation shows on top of it
          floating = { border = 'rounded', zindex = 100 },
        },
      },
    },
  },
}

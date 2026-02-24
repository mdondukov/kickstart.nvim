-- Explicit indentation: 4 spaces
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

-- Use cindent instead of built-in GetJavaIndent() for better paren handling
vim.bo.indentexpr = ''
vim.bo.cindent = true

-- cinoptions for Java:
--   j1  = indent Java anonymous classes correctly
--   (s  = inside unclosed parens, indent by shiftwidth (not align to paren column)
--   Ws  = when opening paren is last on line, indent by shiftwidth from outer context
--   m1  = align closing paren with first char of the opening paren's line
vim.bo.cinoptions = 'j1,(s,Ws,m1'

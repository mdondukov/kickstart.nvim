-- PlantUML filetype settings
vim.opt_local.commentstring = "' %s"

-- Функция для компиляции PlantUML в указанный формат
local function compile_plantuml(format)
  format = format or 'svg'
  local file = vim.fn.expand '%:p'
  local extension = format == 'svg' and '.svg' or (format == 'pdf' and '.pdf' or '.png')
  local output = vim.fn.expand '%:p:r' .. extension
  local format_flag = '-t' .. format

  -- Проверяем наличие plantuml
  if vim.fn.executable 'plantuml' == 1 then
    -- Используем команду plantuml из PATH
    vim.fn.system(string.format('plantuml %s "%s" -o "%s"', format_flag, file, vim.fn.expand '%:p:h'))
  elseif vim.fn.filereadable(vim.fn.expand '~/plantuml.jar') == 1 then
    -- Используем jar файл из домашней директории
    vim.fn.system(string.format('java -jar ~/plantuml.jar %s "%s" -o "%s"', format_flag, file, vim.fn.expand '%:p:h'))
  else
    vim.notify('PlantUML не найден. Установите через: brew install plantuml', vim.log.levels.ERROR)
    return
  end

  if vim.v.shell_error == 0 then
    vim.notify('PlantUML скомпилирован в ' .. format:upper() .. ': ' .. output, vim.log.levels.INFO)
  else
    vim.notify('Ошибка компиляции PlantUML', vim.log.levels.ERROR)
  end
end

-- Функция для конвертации в PNG и открытия preview
local function preview_png()
  compile_plantuml('png')
  local output = vim.fn.expand '%:p:r' .. '.png'
  if vim.fn.filereadable(output) == 1 then
    vim.fn.system(string.format('open "%s"', output))
  end
end

-- Функция для конвертации в SVG и открытия preview
local function preview_svg()
  compile_plantuml('svg')
  local output = vim.fn.expand '%:p:r' .. '.svg'
  if vim.fn.filereadable(output) == 1 then
    vim.fn.system(string.format('open "%s"', output))
  end
end

-- Маппинги
vim.keymap.set('n', '<leader>up', preview_png, { buffer = 0, desc = '[U]ML P[N]G' })
vim.keymap.set('n', '<leader>us', preview_svg, { buffer = 0, desc = '[U]ML [S]VG' })

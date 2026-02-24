-- Java LSP configuration with Lombok support

-- Skip special buffers (e.g. gitsigns diff views, fugitive, restored from session)
local bufname = vim.api.nvim_buf_get_name(0)
if bufname == '' or bufname:match '://' or bufname:match '%.git/' then
  return
end

local jdtls = require 'jdtls'

-- Find root of project
local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
local root_dir = require('jdtls.setup').find_root(root_markers)
if not root_dir or root_dir == '' then
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = vim.fn.stdpath 'data' .. '/site/java/workspace-root/' .. project_name

-- Ensure workspace directory structure exists
vim.fn.mkdir(workspace_dir .. '/.metadata/.plugins/org.eclipse.core.resources/.root', 'p')
vim.fn.mkdir(workspace_dir .. '/.metadata/.plugins/org.eclipse.jdt.core', 'p')

-- Get the mason install path
local mason_path = vim.fn.stdpath 'data' .. '/mason'

-- Paths to jdtls installation
local jdtls_path = mason_path .. '/packages/jdtls'
local lombok_path = jdtls_path .. '/lombok.jar'

-- Determine OS config
local os_config = 'config_mac'
if vim.fn.has 'linux' == 1 then
  os_config = 'config_linux'
elseif vim.fn.has 'win32' == 1 then
  os_config = 'config_win'
end

-- Get capabilities from blink.cmp
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- Main jdtls config
local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ERROR',
    '-javaagent:' .. lombok_path,
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration',
    jdtls_path .. '/' .. os_config,
    '-data',
    workspace_dir,
  },
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        -- Specify runtimes if needed
        -- runtimes = {
        --   {
        --     name = 'JavaSE-17',
        --     path = '/path/to/jdk-17',
        --   },
        -- },
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      signatureHelp = { enabled = true },
      format = {
        enabled = true,
        onType = { enabled = true },
        settings = (function()
          -- Look for project-local formatter first, fall back to default
          local project_formatters = {
            'eclipse-formatter.xml',
            '.eclipse-formatter.xml',
            'formatter.xml',
          }
          for _, name in ipairs(project_formatters) do
            local path = root_dir .. '/' .. name
            if vim.fn.filereadable(path) == 1 then
              return { url = vim.uri_from_fname(path) }
            end
          end
          -- Default: IntelliJ-like Eclipse formatter
          return {
            url = vim.uri_from_fname(vim.fn.stdpath 'config' .. '/lang-servers/eclipse-java-formatter.xml'),
            profile = 'IntelliJLike',
          }
        end)(),
      },
      contentProvider = { preferred = 'fernflower' },
      -- Improve completion and refactoring
      completion = {
        favoriteStaticMembers = {
          'org.junit.jupiter.api.Assertions.*',
          'org.mockito.Mockito.*',
        },
        importOrder = {
          'java',
          'javax',
          'org',
          'com',
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      -- Improve import handling
      saveActions = {
        organizeImports = true,
      },
    },
  },
  init_options = {
    bundles = {},
  },
}

-- Start or attach to jdtls
jdtls.start_or_attach(config)

-- Custom keymaps for jdtls-specific features
vim.keymap.set('n', '<leader>ro', jdtls.organize_imports, { buffer = 0, desc = '[R]efactor: [O]rganize imports' })
vim.keymap.set('n', '<leader>rv', jdtls.extract_variable, { buffer = 0, desc = '[R]efactor: Extract [V]ariable' })
vim.keymap.set('n', '<leader>rc', jdtls.extract_constant, { buffer = 0, desc = '[R]efactor: Extract [C]onstant' })
vim.keymap.set('v', '<leader>rm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], { buffer = 0, desc = '[R]efactor: Extract [M]ethod' })

-- Command to clean and restart jdtls workspace
vim.api.nvim_create_user_command('JdtCleanWorkspace', function()
  local workspace_to_clean = vim.fn.stdpath 'data' .. '/site/java/workspace-root/' .. project_name
  vim.fn.delete(workspace_to_clean, 'rf')
  vim.notify('Cleaned workspace: ' .. workspace_to_clean .. '\nRestart Neovim to reinitialize jdtls', vim.log.levels.INFO)
end, { desc = 'Clean jdtls workspace for current project' })

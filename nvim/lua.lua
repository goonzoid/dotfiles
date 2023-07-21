require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "c",
    "cmake",
    "cpp",
    "css",
    "go",
    "html",
    "javascript",
    "lua",
    "make",
    "python",
    "query",
    "ruby",
    "rust",
    "terraform",
    "typescript",
    "tsx",
    "vim",
    "vimdoc",
    "yaml",
    "zig",
  },
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader>w",
      node_incremental = "<leader>w",
      node_decremental = "<leader>q",
      scope_incremental = "<leader>W",
    },
  },
  playground = { enable = true },
}

require("mason").setup()
require("mason-lspconfig").setup()

local lspconfig = require('lspconfig')

lspconfig.clangd.setup {}
lspconfig.eslint.setup {}
lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      telemetry = { enable = false },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
    },
  },
}
lspconfig.gopls.setup {}
lspconfig.rubocop.setup {}
lspconfig.ruby_ls.setup {}
lspconfig.rust_analyzer.setup {}
lspconfig.tailwindcss.setup {}
lspconfig.tsserver.setup {}
lspconfig.zls.setup {}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(event)
    vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = { buffer = event.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>F', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local close_floats = function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, false)
    end
  end
end
vim.keymap.set('n', '<space>', close_floats, { desc = 'Close floats' })

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Show diagnostic list in the location list' })
vim.keymap.set('n', '<leader>dd', function() vim.diagnostic.open_float() end,
  { desc = 'Show diagnostic list for current line' })
vim.keymap.set('n', '<leader>dc', function() vim.diagnostic.open_float({ scope = 'cursor' }) end,
  { desc = 'Show diagnostic list for current cursor position' })
vim.keymap.set('n', '<leader>df', function() vim.diagnostic.open_float({ scope = 'buffer' }) end,
  { desc = 'Show diagnostic list for whole buffer' })

local border_style = 'rounded'
vim.diagnostic.config {
  float = {
    source = 'always',
    border = border_style,
  },
}
require('lspconfig.ui.windows').default_options.border = border_style
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover, { border = border_style }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help, { border = border_style }
)

local scnvim = require('scnvim')
local editor = require('scnvim.editor')
local map = scnvim.map
local map_expr = scnvim.map_expr

scnvim.setup({
  keymaps = {
    ['<M-j>'] = {
      map(function()
        ---@diagnostic disable-next-line:missing-parameter
        editor.send_line()
        vim.cmd('stopinsert')
      end, 'i'),
      map('editor.send_line', 'n'),
    },
    ['<C-j>'] = {
      map(function()
        ---@diagnostic disable-next-line:missing-parameter
        editor.send_block()
        vim.cmd('stopinsert')
      end, 'i'),
      map('editor.send_block', 'n'),
      map('editor.send_selection', 'x'),
    },
    ['<CR>'] = map('postwin.toggle'),
    ['<leader>cs'] = map('sclang.start'),
    ['<leader>ct'] = map('sclang.stop'),
    ['<leader>cc'] = map('sclang.recompile'),
    ['<leader>cb'] = map_expr('s.boot'),
    ['<leader>cq'] = map_expr('s.quit'),
    ['<leader>cm'] = map_expr('s.meter'),
    ['<leader>cn'] = map_expr('s.plotTree'),
    ['<F9>'] = map_expr('s.record'),
    ['<F8>'] = map_expr('s.stopRecording'),
  },
  extensions = {
    tmux = {
      horizontal = false,
      size = '45%',
      cmd = 'tail',
      args = { '-F', '$1' }
    },
  },
})

---@diagnostic disable-next-line:param-type-mismatch
scnvim.load_extension('tmux')

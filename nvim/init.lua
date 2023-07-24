-------------------------------
-- general neovim config
-------------------------------

vim.g.mapleader = ','

vim.opt.expandtab = true
vim.opt.shiftwidth = 0 -- use the current tabstop value
vim.opt.tabstop = 4
vim.opt.textwidth = 120

vim.opt.completeopt = 'menu,preview,longest'
vim.opt.exrc = true
vim.opt.guicursor = ''
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·' }
vim.opt.number = true
vim.opt.scrolloff = 5
vim.opt.smartcase = true
vim.opt.spelllang = 'en_gb'
vim.opt.spellcapcheck = ''
vim.opt.splitright = true
vim.opt.undofile = true
vim.opt.wildmode = 'longest,list'

vim.g.netrw_liststyle = 3

vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('n', '<leader><leader>', '<C-^>')

vim.keymap.set('i', '<C-l>', '=>')

vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

vim.opt.statusline = [[%n: %f %y %m%=%(%3l:%02c%03V %P %L%)]]

-- only set cursorline for active buffer
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter', 'InsertLeave' }, {
  command = [[setlocal cursorline]],
})
vim.api.nvim_create_autocmd({ 'WinLeave', 'InsertEnter' }, {
  command = [[setlocal nocursorline]],
})

-- jump to last known position in buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    vim.cmd([[
      if &ft !~# 'commit\|rebase'
      \ && line("'\"") > 0
      \ && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
    ]])
  end,
})

-- close floating windows easily
local close_floats = function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, false)
    end
  end
end
vim.keymap.set('n', '<space>', close_floats, { desc = 'Close floats' })

-- lsp and diagnostic keymaps
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
    -- disable semantic highlighting for now
    vim.lsp.get_client_by_id(event.data.client_id).server_capabilities.semanticTokensProvider = nil
  end,
})

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Show diagnostic list in the location list' })
vim.keymap.set('n', '<leader>dd', function() vim.diagnostic.open_float() end,
  { desc = 'Show diagnostic list for current line' })
vim.keymap.set('n', '<leader>dc', function() vim.diagnostic.open_float({ scope = 'cursor' }) end,
  { desc = 'Show diagnostic list for current cursor position' })
vim.keymap.set('n', '<leader>df', function() vim.diagnostic.open_float({ scope = 'buffer' }) end,
  { desc = 'Show diagnostic list for whole buffer' })

-- lsp and diagnostic UI
local border_style = 'rounded'
vim.diagnostic.config {
  float = {
    source = 'always',
    border = border_style,
  },
}
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover, { border = border_style }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help, { border = border_style }
)


-------------------------------
-- filetype specific config
-------------------------------

for _, v in ipairs({
  { pattern = { 'asciidoc', 'gitcommit', 'markdown' }, command = [[setlocal spell]] },
  { pattern = { 'gitconfig', 'go', 'make' },           command = [[setlocal noexpandtab listchars=tab:\ \ ,trail:·]] },
  { pattern = { 'lua', 'ruby', 'vim' },                command = [[setlocal tabstop=2]] },
  { pattern = { 'tidal' },                             command = [[setlocal textwidth=0]] },
  { pattern = { 'tmux' },                              command = [[setlocal keywordprg=:Man\ tmux(#)]] },
}) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = v.pattern,
    command = v.command,
  })
end

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = 'Jenkinsfile*',
  command = [[setlocal filetype=groovy]],
})


-------------------------------
-- plugin config
-------------------------------

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone',
    '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'rebelot/kanagawa.nvim',
    priority = 999,
    config = function()
      require('kanagawa').setup({
        transparent = true,
      })
      vim.cmd('colorscheme kanagawa-wave')
    end,
  },
  {
    'davidgranstrom/scnvim',
    lazy = true,
    ft = 'supercollider',
    dependencies = {
      'davidgranstrom/scnvim-tmux',
    },
    config = function()
      local scnvim = require('scnvim')
      local map, map_expr = scnvim.map, scnvim.map_expr
      scnvim.setup({
        keymaps = {
          ['<M-j>'] = {
            map(function()
              ---@diagnostic disable-next-line:missing-parameter
              scnvim.editor.send_line()
              vim.cmd('stopinsert')
            end, 'i'),
            map('editor.send_line', 'n'),
          },
          ['<C-j>'] = {
            map(function()
              ---@diagnostic disable-next-line:missing-parameter
              scnvim.editor.send_block()
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
            args = { '-F', '$1' },
          },
        },
      })
      ---@diagnostic disable-next-line:param-type-mismatch
      scnvim.load_extension('tmux')
    end,
  },
  {
    'jpalardy/vim-slime',
    lazy = true,
    init = function()
      vim.g.slime_target = 'tmux'
      vim.g.slime_default_config = { socket_name = 'default', target_pane = '{next}' }
      vim.g.slime_dont_ask_default = 1
      vim.g.slime_haskell_ghci_add_let = 0
    end,
    keys = {
      { '<C-j>', '<esc><Plug>SlimeParagraphSend', mode = 'i' },
      { '<C-j>', '<Plug>SlimeParagraphSend',      mode = 'n' },
      { '<C-j>', '<Plug>SlimeRegionSend',         mode = 'x' },
    },
  },
  {
    'dense-analysis/ale',
    init = function()
      vim.g.ale_disable_lsp = 1
      vim.g.ale_echo_msg_format = '%linter%:%code% %s'
      vim.g.ale_set_loclist = 0
      vim.g.ale_use_neovim_diagnostics_api = 1
    end,
  },
  {
    'junegunn/fzf',
    lazy = false,
    dependencies = {
      'junegunn/fzf.vim',
    },
    init = function()
      vim.g.fzf_command_prefix = 'Fz'
      vim.g.fzf_layout = { window = { width = 0.9, height = 0.9 } }
    end,
    keys = {
      { '<leader>f',  '<cmd>FzFiles<cr>' },
      { '<leader>b',  '<cmd>FzBuffers<cr>' },
      { '<C-g>',      '<cmd>FzCommits<cr>' },
      { '<leader>gs', '<cmd>FzGFiles?<cr>' },
      { '<leader>ch', '<cmd>FzHistory:<cr>' },
      { '<leader>z',  '<cmd>FzRg<cr>' },
    }
  },
  {
    'wincent/ferret',
    keys = {
      { '<leader>a', '<Plug>(FerretAck)' },
      { '<leader>s', '<Plug>(FerretAckWord)' },
      { '<leader>S', '<Plug>(FerretAcks)' },
    },
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig.ui.windows').default_options.border = border_style
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
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/playground',
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'c',
          'cmake',
          'cpp',
          'css',
          'go',
          'html',
          'javascript',
          'lua',
          'make',
          'python',
          'query',
          'ruby',
          'rust',
          'terraform',
          'typescript',
          'tsx',
          'vim',
          'vimdoc',
          'yaml',
          'zig',
        },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<leader>w',
            node_incremental = '<leader>w',
            node_decremental = '<leader>q',
            scope_incremental = '<leader>W',
          },
        },
        playground = { enable = true },
      }
    end,
  },
  {
    'tidalcycles/vim-tidal',
    lazy = true,
    ft = 'tidal',
    init = function()
      vim.g.tidal_no_mappings = 1
    end,
  },
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup()
    end,
  },
  {
    'ludovicchabant/vim-gutentags',
    enabled = function() return vim.fn.executable('ctags') == 1 end,
  },
  {
    'majutsushi/tagbar',
    lazy = true,
    keys = {
      { '|', '<cmd>TagbarToggle<cr>' },
    },
  },
  {
    'ruanyl/vim-gh-line',
    init = function()
      vim.g.gh_use_canonical = 1
    end,
  },
  { 'mhinz/vim-signify' },
  { 'milkypostman/vim-togglelist' },
  { 'romainl/vim-cool' }, -- automatic :nohl
  { 'axelf4/vim-strip-trailing-whitespace' },
  { 'godlygeek/tabular' },
  { 'junegunn/goyo.vim' },
  { 'machakann/vim-swap' }, -- g< & g> to swap items around
  { 'tpope/vim-abolish' },  -- cr{c,m,s} to coerce to {camel,mixed,snake} case (and more)
  { 'tpope/vim-commentary' },
  { 'tpope/vim-endwise' },
  { 'tpope/vim-eunuch' },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-sensible' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-unimpaired' },
  { 'tpope/vim-vinegar' },
  { 'preservim/vimux' },
  { 'wellle/tmux-complete.vim' },
})

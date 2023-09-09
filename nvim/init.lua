-------------------------------
-- general neovim config
-------------------------------

vim.g.mapleader = ','

vim.opt.expandtab = true
vim.opt.shiftwidth = 0 -- use the current tabstop value
vim.opt.tabstop = 4
vim.opt.textwidth = 120

vim.opt.completeopt = 'menu,menuone'
vim.opt.exrc = true
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

vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p')
vim.keymap.set('n', '<leader><leader>', '<C-^>')

vim.keymap.set('i', '<C-l>', '=>')

vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

vim.keymap.set('n', '<leader>m', '<cmd>w<cr>|<cmd>make<cr>')

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

local declutter = function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, false)
    end
  end
  vim.cmd([[nohlsearch]])
end
vim.keymap.set('n', '<space>', declutter, { desc = 'Close floats' })

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

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
  { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
  { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist,
  { desc = 'Show diagnostic list in the location list' })
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

-- colorscheme selection
local colorschemes = {
  'kanagawa-wave',
  'kanagawa-dragon',
  'kanagawa-lotus',
  'catppuccin-mocha',
  'catppuccin-latte',
  'tokyonight-night',
}

local select_colorscheme = function()
  vim.ui.select(colorschemes, {}, function(choice)
    if (choice ~= nil) then
      vim.g.COLORSCHEME = choice
      vim.cmd('colorscheme ' .. choice)
    end
  end)
end
vim.keymap.set('n', '<leader>C', select_colorscheme)

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if (vim.g.COLORSCHEME == nil) then
      vim.g.COLORSCHEME = colorschemes[1]
    end
    vim.cmd('colorscheme ' .. vim.g.COLORSCHEME)
  end
})


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

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.zon',
  command = [[setlocal filetype=zig]],
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
    lazy = false,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
  },
  {
    'catppuccin/nvim',
    lazy = false,
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
          ['<cr>'] = map('postwin.toggle'),
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
      vim.g.ale_fixers = { go = { 'goimports', 'gofumpt' } }
      vim.g.ale_fix_on_save = 1
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
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      require('lspconfig.ui.windows').default_options.border = border_style
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require('lspconfig')
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
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
      lspconfig.clangd.setup { capabilities = capabilities, }
      lspconfig.eslint.setup { capabilities = capabilities, }
      lspconfig.gopls.setup { capabilities = capabilities, }
      lspconfig.rubocop.setup { capabilities = capabilities, }
      lspconfig.ruby_ls.setup { capabilities = capabilities, }
      lspconfig.rust_analyzer.setup { capabilities = capabilities, }
      lspconfig.tailwindcss.setup { capabilities = capabilities, }
      lspconfig.tsserver.setup { capabilities = capabilities, }
      lspconfig.zls.setup { capabilities = capabilities, }
    end,
  },
  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    event = 'LspAttach',
    config = function()
      require('fidget').setup({
        window = {
          blend = 0,
        },
      })
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lua',
      'andersevenrud/cmp-tmux',
      'dcampos/nvim-snippy',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        mapping = vim.tbl_extend('error',
          cmp.mapping.preset.insert(),
          {
            -- fallback to existing <cr> mappings (e.g. endwise)
            ['<cr>'] = function(fallback)
              fallback()
            end,
          }
        ),
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
        }, {
          {
            name = 'buffer',
            keyword_length = 3,
            option = {
              get_bufnrs = function() return vim.api.nvim_list_bufs() end
            },
          },
          { name = 'tmux', keyword_length = 3 },
        }),
        formatting = {
          format = function(entry, vim_item)
            local menu_icon = {
              nvim_lsp = 'λ',
              nvim_lua = ' ',
              buffer = '󰦨 ',
              path = '/',
              tmux = ' ',
              snippy = ' ',
            }
            vim_item.menu = menu_icon[entry.source.name]
            if entry.source.name == 'buffer' or entry.source.name == 'tmux' then
              vim_item.kind = ''
            else
              vim_item.kind = string.lower(vim_item.kind)
            end
            return vim_item
          end,
        },
        snippet = {
          expand = function(args)
            require('snippy').expand_snippet(args.body)
          end,
        },
      })
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
        formatting = {
          format = function(_, vim_item)
            vim_item.kind = ''
            return vim_item
          end,
        },
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'path' },
          { name = 'cmdline', keyword_length = 2 },
        },
        formatting = {
          format = function(_, vim_item)
            vim_item.kind = ''
            return vim_item
          end,
        },
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
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
      }
    end,
  },
  {
    'nvim-treesitter/playground',
    cmd = {
      'TSPlaygroundToggle',
    },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
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
  {
    'godlygeek/tabular',
    cmd = {
      'Tabularize',
    },
  },
  {
    'junegunn/goyo.vim',
    init = function()
      vim.g.goyo_width = 120
      vim.g.goyo_height = '90%'
    end,
    cmd = {
      'Goyo',
    },
  },
  {
    'preservim/vimux',
    enabled = function() return vim.fn.getenv('TMUX') ~= vim.NIL end,
    cmd = {
      'VimuxRunCommand',
    },
  },
  {
    'goonzoid/vim-signify', -- use my fork until https://github.com/mhinz/vim-signify/issues/408 is fixed
    lazy = false,
    init = function()
      vim.g.signify_sign_add               = '|'
      vim.g.signify_sign_delete            = '󰇘'
      vim.g.signify_sign_delete_first_line = '󰇘'
      vim.g.signify_sign_change            = '󰇘'
    end,
    keys = {
      { '<leader>Df', '<cmd>SignifyDiff<cr>' },
      { '<leader>hd', '<cmd>SignifyHunkDiff<cr>' },
      { '<leader>hr', '<cmd>SignifyHunkUndo<cr>' },
    },
  },
  { 'milkypostman/vim-togglelist' },
  { 'romainl/vim-cool' },   -- automatic :nohl
  { 'axelf4/vim-strip-trailing-whitespace' },
  { 'machakann/vim-swap' }, -- g< & g> to swap items around
  { 'tpope/vim-abolish' },  -- cr{c,m,s} to coerce to {camel,mixed,snake} case (and more)
  { 'tpope/vim-commentary' },
  { 'tpope/vim-endwise' },
  { 'tpope/vim-eunuch' },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-sensible' },
  { 'tpope/vim-sleuth' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-unimpaired' },
  { 'tpope/vim-vinegar' },
})

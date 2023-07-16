local scnvim = require 'scnvim'
local editor = require 'scnvim.editor'
local map = scnvim.map
local map_expr = scnvim.map_expr

scnvim.setup({
  keymaps = {
    ['<M-j>'] = {
      map(function()
        editor.send_line()
        vim.cmd('stopinsert')
      end, 'i'),
      map('editor.send_line', 'n'),
    },
    ['<C-j>'] = {
      map(function()
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

scnvim.load_extension 'tmux'

local scnvim = require 'scnvim'
local map = scnvim.map
local map_expr = scnvim.map_expr

scnvim.setup({
  keymaps = {
    ['<C-i>'] = map('editor.send_line', {'i', 'n'}),
    ['<C-j>'] = {
      map('editor.send_block', {'i', 'n'}),
      map('editor.send_selection', 'x'),
    },
    ['<CR>'] = map('postwin.toggle'),
    ['<leader>cs'] = map('sclang.start'),
    ['<leader>ct'] = map('sclang.stop'),
    ['<leader>cr'] = map('sclang.recompile'),
    ['<leader>cb'] = map_expr('s.boot'),
    ['<leader>cq'] = map_expr('s.quit'),
    ['<leader>cm'] = map_expr('s.meter'),
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

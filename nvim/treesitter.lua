require'nvim-treesitter.configs'.setup {
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
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader>w",
      node_incremental = "<leader>w",
      node_decremental = "<leader>q",
      scope_incremental = "<leader>W",
    },
  },
  playground = {
    enable = true,
  },
}

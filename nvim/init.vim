scriptencoding utf-8

call plug#begin()

" basics
Plug 'tpope/vim-sensible'
Plug 'rebelot/kanagawa.nvim'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" search and file navigation
Plug 'tpope/vim-vinegar'
Plug 'wincent/ferret'
Plug '~/.fzf' | Plug 'junegunn/fzf.vim'

" editing and navigation helpers
Plug 'axelf4/vim-strip-trailing-whitespace'
Plug 'godlygeek/tabular'
Plug 'junegunn/goyo.vim'
Plug 'machakann/vim-swap'
Plug 'milkypostman/vim-togglelist'
Plug 'romainl/vim-cool' " automatic :noh
Plug 'tpope/vim-abolish' " cr{c,m,s} to coerce to {camel,mixed,snake} case (and more)
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" git
Plug 'mhinz/vim-signify'
Plug 'ruanyl/vim-gh-line'
Plug 'tpope/vim-fugitive'

" ctags
if executable('ctags')
  Plug 'ludovicchabant/vim-gutentags'
endif
Plug 'majutsushi/tagbar'

" lsp and linting
Plug 'neovim/nvim-lspconfig'
Plug 'dense-analysis/ale'
Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'}
Plug 'williamboman/mason-lspconfig.nvim'

" system integration
Plug 'jpalardy/vim-slime'
Plug 'preservim/vimux'
Plug 'tpope/vim-eunuch'
Plug 'wellle/tmux-complete.vim'

" supercollider and tidal
Plug 'davidgranstrom/scnvim'
Plug 'davidgranstrom/scnvim-tmux'
Plug 'tidalcycles/vim-tidal'

call plug#end()

" Plugin configuration
source $HOME/.config/nvim/lua.lua

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

let mapleader=','

" Plugin configuration
source $HOME/.config/nvim/lsp.lua
source $HOME/.config/nvim/scnvim.lua
source $HOME/.config/nvim/treesitter.lua

let g:gh_use_canonical = 1
let g:netrw_liststyle = 3
let g:signify_vcs_list = [ 'git' ]
let g:tidal_no_mappings = 1
nnoremap <leader>S <Plug>(FerretAcks)
nnoremap \| :TagbarToggle<cr>

" ALE
let g:ale_disable_lsp = 1
let g:ale_use_neovim_diagnostics_api = 1
let g:ale_set_loclist = 0
let g:ale_echo_msg_format = '%linter%:%code% %s'

" fzf
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let g:fzf_command_prefix = 'Fzf'
nnoremap <leader>f :FzfFiles<cr>
nnoremap <c-g> :FzfCommits<cr>
nnoremap <leader>gs :FzfGFiles?<cr>
nnoremap <leader>b :FzfBuffers<cr>
nnoremap <leader>z :FzfRg<cr>
nnoremap <leader>ch :FzfHistory:<cr>

" Slime
let g:slime_default_config = {'socket_name': get(split($TMUX, ','), 0), 'target_pane': '{next}'}
let g:slime_dont_ask_default = 1
let g:slime_haskell_ghci_add_let = 0
let g:slime_target = 'tmux'
imap <c-j> <esc><Plug>SlimeParagraphSend
nmap <c-j> <Plug>SlimeParagraphSend
xmap <c-j> <Plug>SlimeRegionSend

" Disable neovim remote plugin providers
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_python3_provider = 0
let g:loaded_ruby_provider = 0

" Filetype detection
augroup miscFileType
  autocmd!
  autocmd FileType tmux setlocal keywordprg=:Man\ tmux(#)
  autocmd FileType go setlocal noexpandtab listchars=tab:\ \ ,trail:·
  autocmd FileType cpp setlocal commentstring=//\ %s
  autocmd FileType make setlocal noexpandtab
  autocmd FileType gitcommit,gitrebase setlocal nomodeline | :EnableSpell
  autocmd FileType tidal setlocal textwidth=0
  autocmd FileType lua setlocal shiftwidth=2 softtabstop=2
  autocmd BufNewFile,BufRead Jenkinsfile* setlocal filetype=groovy
augroup END

" Appearance
colorscheme kanagawa-wave
set statusline=%n:\ %f\ %y\ %m%=%(%3l:%02c%03V\ %P%)
set guicursor=

" Basic editing configuration
set number
set scrolloff=5
set splitright
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=120
" Make tabs and trailing whitespace visible
set list listchars=tab:▸\ ,trail:·
" Make searches case sensitive only if they contain upper-case characters
set ignorecase smartcase
set wildmode=longest,list
set wildignore+=*/tmp/*,*/node_modules/*,*.o,*.obj,*.exe,*.so,*.dll,*.pyc,.svn,.hg,.bzr,.git,.sass-cache,*.class,*.scssc
set undofile
set completeopt=menu,preview,longest

" Key mappings
command! W :w
command! Q :q
command! Bd :bd
" Allow yank and put to/from system clipboard
map <leader>y "*y
map <leader>p "*p
map <leader>P :setlocal paste! \| :set paste?<cr>
" Easier switch between files
nnoremap <leader><leader> <c-^>
" Insert a hash rocket with <c-l>
imap <c-l> =>
" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv
" make Y consistent with C and D. See :help Y.
nnoremap Y y$
nnoremap <leader>m :silent w \| :make<cr>

" Only show cursorline in active buffer
augroup cursorline
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

" Jump to last cursor position unless it's invalid or in an event handler,
" or the file is a git commit message
augroup lastCursorPosition
  autocmd!
  autocmd BufReadPost *
        \ if expand('%:t') == 'COMMIT_EDITMSG' |
        \   exe "normal gg" |
        \ elseif line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
augroup END

" Spelling
function! <SID>EnableSpell()
  setlocal spell spelllang=en_gb spellcapcheck=
endfunction
command! EnableSpell call <SID>EnableSpell()
function! <SID>DisableSpell()
  setlocal nospell
endfunction
command! DisableSpell call <SID>DisableSpell()

" dotfile editing helpers
nnoremap <leader>gv :e ~/dotfiles/nvim/init.vim<cr>
nnoremap <leader>gz :e ~/dotfiles/zsh/.zshrc<cr>
nnoremap <leader>gt :e ~/dotfiles/tmux/.tmux.conf<cr>

augroup dotfiles
  autocmd!
  autocmd bufwritepost init.vim source $MYVIMRC | edit ~/dotfiles/nvim/init.vim
  autocmd bufwritepost .tmux.conf silent !tmux source-file ~/.tmux.conf
augroup END

" Read .nvim.lua, .nvimrc, or .exrc in current working directory
set exrc

" vim: textwidth=0 tabstop=2 softtabstop=2 shiftwidth=2

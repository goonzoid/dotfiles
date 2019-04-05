set nocompatible

call plug#begin('~/.vim/plugged')

Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'chriskempson/base16-vim'
Plug 'elmcast/elm-vim'
Plug 'fatih/vim-go'
Plug 'gfontenot/vim-xcode'
Plug 'godlygeek/tabular'
Plug 'guns/vim-sexp'
Plug 'jpalardy/vim-slime'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-operator-user'
Plug 'luan/vipe'
Plug 'ludovicchabant/vim-gutentags'
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-swap'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'milkypostman/vim-togglelist'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'neomake/neomake'
Plug 'rhysd/vim-clang-format'
Plug 'rking/ag.vim'
Plug 'ruanyl/vim-gh-line'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'tidalcycles/vim-tidal'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-ruby/vim-ruby'
Plug 'wlangstroth/vim-racket'

call plug#end()

let mapleader=","

" Plugin configuration
runtime macros/matchit.vim
let g:clang_format#auto_format = 1
let g:elm_format_autosave = 1
let g:gh_use_canonical = 1
let g:rustfmt_autosave = 1
let g:sexp_enable_insert_mode_mappings = 0
let g:signify_vcs_list = [ 'git' ]
let g:tidal_no_mappings = 1
let g:neomake_open_list = 2
let g:neomake_list_height = 8
autocmd! BufWritePost * Neomake!
let g:fzf_command_prefix = 'FZF'
nnoremap <leader>f :FZFFiles<cr>
nnoremap <leader>b :FZFBuffers<cr>
nnoremap \| :TagbarToggle<cr>

" Slime
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": "{next}"}
let g:slime_dont_ask_default = 1
let g:slime_haskell_ghci_add_let = 0
let g:slime_target = "tmux"
imap <c-e> <esc><Plug>SlimeParagraphSend<cr>
nmap <c-e> <Plug>SlimeParagraphSend<cr>
xmap <c-e> <Plug>SlimeRegionSend<cr>

" Go
let g:go_fmt_command = "goimports"
let g:go_fmt_experimental = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1

" NERDTree
nnoremap \ :NERDTreeToggle<cr>
let NERDTreeShowHidden = 1

" Filetype detection
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 listchars=tab:\ \ ,trail:·
autocmd FileType python setlocal shiftwidth=4 tabstop=4
autocmd FileType cpp setlocal shiftwidth=4 tabstop=4 commentstring=//\ %s
autocmd FileType make setlocal noexpandtab shiftwidth=4 tabstop=4

" Appearance
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" Basic editing configuration
set hidden
set history=1000
set number
set splitright
set expandtab
set tabstop=2
set shiftwidth=2
set textwidth=80
set autoindent
set laststatus=2
set showmatch
set incsearch
set hlsearch
" Make tabs and trailing whitespace visible
set list listchars=tab:▸\ ,trail:·
" Make searches case sensitive only if they contain upper-case characters
set ignorecase smartcase
" Allow backspacing over everything in insert mode
set backspace=indent,eol,start
set title
set showcmd
set wildmenu
set wildmode=longest,list
set wildignore+=*/tmp/*,*/node_modules/*,*.o,*.obj,*.exe,*.so,*.dll,*.pyc,.svn,.hg,.bzr,.git,.sass-cache,*.class,*.scssc,*/Godeps/*,elm-stuff
set scrolloff=3
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set autowrite
set lazyredraw
" Fix delay after pressing ESC then O - http://ksjoberg.com/vim-esckeys.html
set timeout timeoutlen=1000 ttimeoutlen=100
syntax enable

" Key mappings
command! W :w
command! Q :q
command! Bd :bd
" Allow yank and put to/from system clipboard
map <leader>y "*y
map <leader>p "*p
nnoremap p ]p
" Easier switch between files
nnoremap <leader><leader> <c-^>
" Clear search buffer by hitting space
nnoremap <space> :nohlsearch<cr>
" Insert a hash rocket with <c-l>
imap <c-l> =><space>
" Not sure what the diff is between <c-c> and Esc
imap <c-c> <esc>
" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv
" make Y consistent with C and D. See :help Y.
nnoremap Y y$

" Only show cursorline in active buffer
augroup cursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" Jump to last cursor position unless it's invalid or in an event handler,
" or the file is a git commit message
augroup vimrcEx
  autocmd BufReadPost *
        \ if expand('%:t') == 'COMMIT_EDITMSG' |
        \   exe "normal gg" |
        \ elseif line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
augroup END

" Unset modeline for git commit messages and rebase todos
augroup vimrcEx
  autocmd BufReadPost *
        \ if expand('%:t') == 'COMMIT_EDITMSG' |
        \   setlocal nomodeline |
        \ elseif expand('%:t') == 'git-rebase-todo' |
        \   setlocal nomodeline |
        \ endif
augroup END

" Remove trailing whitespace
function! <SID>StripTrailingWhitespace()
  " Save last search and cursor position
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business
  %s/\s\+$//e
  " Restore previous search history and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
command! StripTrailingWhitespace call <SID>StripTrailingWhitespace()
nnoremap <leader>s :StripTrailingWhitespace<cr>

" Spelling
function! <SID>EnableSpell()
  :setlocal spell spelllang=en_gb
endfunction
command! EnableSpell call <SID>EnableSpell()
function! <SID>DisableSpell()
  :setlocal nospell
endfunction
command! DisableSpell call <SID>DisableSpell()

" Dotfile editing helpers
nnoremap <leader>gv :e ~/.vimrc<cr>
autocmd bufwritepost .vimrc source $MYVIMRC
nnoremap <leader>ga :e ~/.alacritty.yml<cr>
nnoremap <leader>gg :e ~/.gitconfig<cr>
nnoremap <leader>gn :e ~/.nowdothis<cr>
nnoremap <leader>gz :e ~/.zshrc<cr>
nnoremap <leader>gt :e ~/.tmux.conf<cr>
autocmd bufwritepost .tmux.conf silent !tmux source-file ~/.tmux.conf

" Read .vimrc, .exrc and .gvimrc in current working directory
set exrc
set secure " deliberately set at end of .vimrc, see :help 'secure'

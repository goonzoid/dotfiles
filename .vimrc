call plug#begin('~/.vim/plugged')

Plug 'benmills/vimux'                               " run commands in tmux panes
Plug 'danielwe/base16-vim'                          " colour schemes (using this fork until https://github.com/chriskempson/base16-vim/pull/198 is merged)
Plug 'elmcast/elm-vim'                              " all things elm
Plug 'fatih/vim-go'                                 " all things go
Plug 'gfontenot/vim-xcode'                          " work with Xcode projects
Plug 'godlygeek/tabular'                            " make tables
Plug 'guns/vim-sexp'                                " s-expression editing
Plug 'jpalardy/vim-slime'                           " send text to REPLs and other things
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim' " fzf integration
Plug 'junegunn/goyo.vim'                            " focus mode
Plug 'junegunn/limelight.vim'                       " hyper focus mode
Plug 'kana/vim-operator-user'                       " define custom operators - required by vim-clang-format
Plug 'kana/vim-textobj-user'                        " define custom text objects - required by vim-textobj-ruby
Plug 'ludovicchabant/vim-gutentags'                 " generates ctags files in the background
Plug 'luochen1990/rainbow'                          " rainbow parens and other markers
Plug 'machakann/vim-swap'                           " reorder delimited items
Plug 'majutsushi/tagbar'                            " ctag navigation
Plug 'mhinz/vim-signify'                            " show linewise vcs indicators
Plug 'milkypostman/vim-togglelist'                  " <leader>q/l for quickfix and location lists
Plug 'nelstrom/vim-textobj-rubyblock'               " custom text onbject for ruby blocks
Plug 'neomake/neomake'                              " async linting and make framework
Plug 'rhysd/vim-clang-format'                       " clang-format integration
Plug 'rking/ag.vim'                                 " ag integration
Plug 'ruanyl/vim-gh-line'                           " <leader>gh/gb to open current line on github
Plug 'rust-lang/rust.vim'                           " all things rust
Plug 'scrooloose/nerdtree'                          " filesystem tree explorer and utils
Plug 'tidalcycles/vim-tidal'                        " generate completions for superdirt samples
Plug 'tmux-plugins/vim-tmux'                        " tmux.conf editing help
Plug 'tpope/vim-abolish'                            " cr{c,m,s} to coerce to {camel,mixed,snake} case (and more)
Plug 'tpope/vim-bundler'                            " all things bundler
Plug 'tpope/vim-commentary'                         " comment stuff out
Plug 'tpope/vim-endwise'                            " close some structures automatically - e.g. add `end` for ruby funcs
Plug 'tpope/vim-eunuch'                             " wrappers for 'nix shell commands
Plug 'tpope/vim-fugitive'                           " wrappers for git commands
Plug 'tpope/vim-rails'                              " all things rails
Plug 'tpope/vim-rake'                               " all things rake
Plug 'tpope/vim-repeat'                             " better repetition
Plug 'tpope/vim-sexp-mappings-for-regular-people'   " additional s-expression mappings
Plug 'tpope/vim-surround'                           " mappings for editing 'surrounding pairs'
Plug 'tpope/vim-unimpaired'                         " pairs of handy bracket mappings
Plug 'tpope/vim-vinegar'                            " netrw enhancements
Plug 'vim-ruby/vim-ruby'                            " all things ruby
Plug 'wellle/tmux-complete.vim'                     " completions from tmux panes, sets completefunc by default
Plug 'wlangstroth/vim-racket'                       " all things racket

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
let NERDTreeHijackNetrw = 0

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

" vim: textwidth=0

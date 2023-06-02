scriptencoding utf-8

call plug#begin('~/.vim/plugged')

Plug 'axelf4/vim-strip-trailing-whitespace'         " smart trailing whitespace stripping
Plug 'chriskempson/base16-vim'                      " colour schemes
Plug 'dense-analysis/ale'                           " async linting
Plug 'fatih/vim-go'                                 " all things go
Plug 'gfontenot/vim-xcode'                          " work with Xcode projects
Plug 'gmoe/vim-faust'                               " all things faust
Plug 'godlygeek/tabular'                            " make tables
Plug 'hashivim/vim-terraform'                       " all things terraform
Plug 'jpalardy/vim-slime'                           " send text to REPLs and other things
Plug '~/.fzf' | Plug 'junegunn/fzf.vim'             " fzf integration
Plug 'junegunn/goyo.vim'                            " focus mode
Plug 'junegunn/limelight.vim'                       " hyper focus mode
Plug 'kana/vim-operator-user'                       " define custom operators - required by vim-clang-format
Plug 'ludovicchabant/vim-gutentags'                 " generate ctags files in the background
Plug 'luochen1990/rainbow'                          " rainbow parens and other markers
Plug 'machakann/vim-swap'                           " reorder delimited items
Plug 'majutsushi/tagbar'                            " ctag navigation
Plug 'mhinz/vim-signify'                            " show linewise vcs indicators
Plug 'milkypostman/vim-togglelist'                  " <leader>q/l for quickfix and location lists
Plug 'pangloss/vim-javascript'                      " all things javascipt
Plug 'preservim/vimux'                              " run commands in tmux panes
Plug 'rhysd/vim-clang-format'                       " clang-format integration
Plug 'ruanyl/vim-gh-line'                           " <leader>gh/gb/go to open current line on github
Plug 'rust-lang/rust.vim'                           " all things rust
Plug 'scrooloose/nerdtree'                          " filesystem tree explorer and utils
Plug 'supercollider/scvim'                          " syntax, completions, etc. for supercollider
Plug 'tidalcycles/vim-tidal'                        " generate completions for superdirt samples
Plug 'tmux-plugins/vim-tmux'                        " tmux.conf editing help
Plug 'tpope/vim-abolish'                            " cr{c,m,s} to coerce to {camel,mixed,snake} case (and more)
Plug 'tpope/vim-apathy'                             " set path and friends
Plug 'tpope/vim-commentary'                         " comment stuff out
Plug 'tpope/vim-endwise'                            " close some structures automatically - e.g. add `endfunction` for vimscript funcs
Plug 'tpope/vim-eunuch'                             " wrappers for 'nix shell commands
Plug 'tpope/vim-fugitive'                           " wrappers for git commands
Plug 'tpope/vim-repeat'                             " better repetition
Plug 'tpope/vim-sensible'                           " sensible defaults
Plug 'tpope/vim-surround'                           " mappings for editing 'surrounding pairs'
Plug 'tpope/vim-unimpaired'                         " pairs of handy bracket mappings
Plug 'tpope/vim-vinegar'                            " netrw enhancements
Plug 'vim-ruby/vim-ruby'                            " all things ruby
Plug 'wellle/tmux-complete.vim'                     " completions from tmux panes, sets completefunc by default
Plug 'wincent/ferret'                               " multi-file search (:Ack / <leader>a and more!)
Plug 'ziglang/zig.vim'                              " zig!

call plug#end()

let mapleader=','

" Plugin configuration
runtime macros/matchit.vim
let g:ale_completion_enabled = 1
let g:ale_open_list = 1
let g:ale_list_window_size = 4
let g:ale_echo_msg_format = '%linter%:%code% %s'
nnoremap <leader>g :ALEGoToDefinition<cr>
let g:clang_format#auto_format = 1
let g:elm_format_autosave = 1
let g:gh_use_canonical = 1
let g:netrw_liststyle = 3
let g:rustfmt_autosave = 1
let g:sexp_enable_insert_mode_mappings = 0
let g:signify_vcs_list = [ 'git' ]
let g:tidal_no_mappings = 1
let g:fzf_command_prefix = 'FZF'
nnoremap <leader>f :FZFFiles<cr>
nnoremap <leader>b :FZFBuffers<cr>
nnoremap \| :TagbarToggle<cr>

" Slime
let g:slime_default_config = {'socket_name': get(split($TMUX, ','), 0), 'target_pane': '{next}'}
let g:slime_dont_ask_default = 1
let g:slime_haskell_ghci_add_let = 0
let g:slime_target = 'tmux'
imap <c-j> <esc><Plug>SlimeParagraphSend<cr>
nmap <c-j> <Plug>SlimeParagraphSend<cr>
xmap <c-j> <Plug>SlimeRegionSend<cr>

" Go
let g:go_fmt_command = 'goimports'
let g:go_fmt_experimental = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1

" C/C++
let g:ale_c_parse_compile_commands = 1

" NERDTree
nnoremap \ :NERDTreeToggle<cr>
nnoremap <leader>nf :NERDTreeFind<cr>
let NERDTreeShowHidden = 1
let NERDTreeHijackNetrw = 0

" Filetype detection
augroup MiscFileType
  autocmd!

  autocmd FileType go setlocal noexpandtab listchars=tab:\ \ ,trail:·
  autocmd FileType cpp setlocal commentstring=//\ %s
  autocmd FileType make setlocal noexpandtab
  autocmd FileType gitcommit setlocal nomodeline
  autocmd FileType gitrebase setlocal nomodeline
  autocmd FileType tidal setlocal textwidth=0
  autocmd FileType lua setlocal shiftwidth=2 softtabstop=2
augroup END

" Appearance
if exists('$BASE16_THEME')
      \ && (!exists('g:colors_name') || g:colors_name !=? 'base16-$BASE16_THEME')
    let base16colorspace=256
    colorscheme base16-$BASE16_THEME
endif
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V\ %P%)

" Basic editing configuration
set hidden
set number
set splitright
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=80
set showmatch
set hlsearch
" Make tabs and trailing whitespace visible
set list listchars=tab:▸\ ,trail:·
" Make searches case sensitive only if they contain upper-case characters
set ignorecase smartcase
set title
set showcmd
set wildmode=longest,list
set wildignore+=*/tmp/*,*/node_modules/*,*.o,*.obj,*.exe,*.so,*.dll,*.pyc,.svn,.hg,.bzr,.git,.sass-cache,*.class,*.scssc,elm-stuff
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set autowrite
set lazyredraw
set undofile
set modeline

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
" Insert an arrow with <c-l>
imap <c-l> ->
" Not sure what the diff is between <c-c> and Esc
imap <c-c> <esc>
" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv
" make Y consistent with C and D. See :help Y.
nnoremap Y y$
nnoremap <leader>m :silent w \| :make<cr>

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
nnoremap <leader>gv :e $MYVIMRC<cr>
nnoremap <leader>gz :e ~/.zshrc<cr>
nnoremap <leader>gt :e ~/.tmux.conf<cr>

augroup Dotfiles
  autocmd!

  autocmd bufwritepost .vimrc source $MYVIMRC
  autocmd bufwritepost .tmux.conf silent !tmux source-file ~/.tmux.conf
augroup END

" Read .vimrc, .exrc and .gvimrc in current working directory
set exrc
set secure " deliberately set at end of .vimrc, see :help 'secure'

" vim: textwidth=0

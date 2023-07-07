scriptencoding utf-8

call plug#begin('~/.vim/plugged')

Plug 'axelf4/vim-strip-trailing-whitespace'         " smart trailing whitespace stripping
Plug 'davidgranstrom/scnvim'                        " supercollider (nvim only)
Plug 'davidgranstrom/scnvim-tmux'                   " tmux support for supercollider (nvim only)
Plug 'dense-analysis/ale'                           " async linting
Plug 'fatih/vim-go'                                 " all things go
Plug 'godlygeek/tabular'                            " make tables
Plug 'hashivim/vim-terraform'                       " all things terraform
Plug 'jpalardy/vim-slime'                           " send text to REPLs and other things
Plug 'jonathanfilip/vim-lucius'                     " colour scheme
Plug '~/.fzf' | Plug 'junegunn/fzf.vim'             " fzf integration
Plug 'junegunn/goyo.vim'                            " focus mode
Plug 'kana/vim-operator-user'                       " define custom operators - required by vim-clang-format
Plug 'leafgarland/typescript-vim'                   " all things typescript
Plug 'ludovicchabant/vim-gutentags'                 " generate ctags files in the background
Plug 'luochen1990/rainbow'                          " rainbow parens and other markers
Plug 'machakann/vim-swap'                           " reorder delimited items
Plug 'majutsushi/tagbar'                            " ctag navigation
Plug 'mhinz/vim-signify'                            " show linewise vcs indicators
Plug 'milkypostman/vim-togglelist'                  " <leader>q/l for quickfix and location lists
Plug 'pangloss/vim-javascript'                      " all things javascipt
Plug 'peitalin/vim-jsx-typescript'                  " jsx/txs
Plug 'preservim/vimux'                              " run commands in tmux panes
Plug 'rhysd/vim-clang-format'                       " clang-format integration
Plug 'romainl/vim-cool'                             " automatic :nohl
Plug 'ruanyl/vim-gh-line'                           " <leader>gh/gb/go to open current line on github
Plug 'rust-lang/rust.vim'                           " all things rust
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
let g:clang_format#auto_format = 1
let g:gh_use_canonical = 1
let g:go_highlight_functions = 1
let g:netrw_liststyle = 3
let g:rainbow_active = 1
let g:rustfmt_autosave = 1
let g:signify_vcs_list = [ 'git' ]
let g:tidal_no_mappings = 1
let g:fzf_command_prefix = 'FZF'
nnoremap <leader>f :FZFFiles<cr>
nnoremap <leader>b :FZFBuffers<cr>
nnoremap \| :TagbarToggle<cr>

" ALE
let g:ale_completion_enabled = 1
let g:ale_lsp_suggestions = 1
let g:ale_echo_msg_format = '%linter%:%code% %s'
let g:ale_rename_tsserver_find_in_comments = 1
let g:ale_linters = {'rust': ['analyzer']}
let g:ale_fixers = {'zig': ['zls']}
let g:ale_c_parse_compile_commands = 1
nnoremap <leader>gd :ALEGoToDefinition<cr>

" Slime
let g:slime_default_config = {'socket_name': get(split($TMUX, ','), 0), 'target_pane': '{next}'}
let g:slime_dont_ask_default = 1
let g:slime_haskell_ghci_add_let = 0
let g:slime_target = 'tmux'
imap <c-j> <esc><Plug>SlimeParagraphSend
nmap <c-j> <Plug>SlimeParagraphSend
xmap <c-j> <Plug>SlimeRegionSend

" Filetype detection
augroup MiscFileType
  autocmd!
  autocmd FileType go setlocal noexpandtab listchars=tab:\ \ ,trail:·
  autocmd FileType cpp setlocal commentstring=//\ %s
  autocmd FileType make setlocal noexpandtab
  autocmd FileType gitcommit,gitrebase setlocal nomodeline | :EnableSpell
  autocmd FileType tidal setlocal textwidth=0
  autocmd FileType lua setlocal shiftwidth=2 softtabstop=2
  autocmd BufNewFile,BufRead Jenkinsfile setlocal filetype=groovy
augroup END

" Appearance
colorscheme lucius
LuciusBlack

set statusline=%n:\ %f\ %y\ %m%=%(%3l:%02c%03V\ %P%)

" Basic editing configuration
set hidden
set number
set scrolloff=5
set splitright
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=120
set hlsearch
" Make tabs and trailing whitespace visible
set list listchars=tab:▸\ ,trail:·
" Make searches case sensitive only if they contain upper-case characters
set ignorecase smartcase
set title
set showcmd
set wildmode=longest,list
set wildignore+=*/tmp/*,*/node_modules/*,*.o,*.obj,*.exe,*.so,*.dll,*.pyc,.svn,.hg,.bzr,.git,.sass-cache,*.class,*.scssc
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set autowrite
set lazyredraw
set undofile
set modeline
set completeopt=menu,preview,longest

" Key mappings
command! W :w
command! Q :q
command! Bd :bd
" Allow yank and put to/from system clipboard
map <leader>y "*y
map <leader>p "*p
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
  setlocal spell spelllang=en_gb spellcapcheck=
endfunction
command! EnableSpell call <SID>EnableSpell()
function! <SID>DisableSpell()
  setlocal nospell
endfunction
command! DisableSpell call <SID>DisableSpell()

" dotfile editing helpers
nnoremap <leader>gv :e ~/dotfiles/vim/.vimrc<cr>
nnoremap <leader>gz :e ~/dotfiles/zsh/.zshrc<cr>
nnoremap <leader>gt :e ~/dotfiles/tmux/.tmux.conf<cr>

augroup dotfiles
  autocmd!
  autocmd bufwritepost .vimrc source $MYVIMRC | edit ~/dotfiles/vim/.vimrc
  autocmd bufwritepost .tmux.conf silent !tmux source-file ~/.tmux.conf
augroup END

" Read .vimrc, .exrc and .gvimrc in current working directory
set exrc
set secure " deliberately set at end of .vimrc, see :help 'secure'

" vim: textwidth=0 tabstop=2 softtabstop=2 shiftwidth=2

set nocompatible

" VUNDLE CONFIGURATION
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

Plugin 'gmarik/Vundle.vim'

Plugin 'fatih/vim-go'
Plugin 'guns/vim-sexp'
Plugin 'guns/vim-clojure-static'
Plugin 'honza/vim-snippets'
Plugin 'jpalardy/vim-slime'
Plugin 'justinmk/vim-sneak'
Plugin 'kana/vim-textobj-user'
Plugin 'lambdatoast/elm.vim'
Plugin 'luan/vipe'
Plugin 'luochen1990/rainbow'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'Shougo/neocomplete.vim'
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'tmux-plugins/vim-tmux'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-leiningen'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-sexp-mappings-for-regular-people'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-vinegar'
Plugin 'vim-ruby/vim-ruby'
Plugin 'wincent/command-t'
Plugin 'wlangstroth/vim-racket'

filetype plugin indent on
let mapleader=","

" PLUGIN CONFIGURATION
runtime macros/matchit.vim
let g:slime_target = "tmux"
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['objc'] }
let g:sexp_enable_insert_mode_mappings = 0

" replace 'f' with 1-char Sneak
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F

" Go
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1

" CommandT
let g:CommandTAlwaysShowDotFiles = 1
let g:CommandTTraverseSCM = "pwd"
nnoremap <c-p> :CommandTFlush<cr>\|:CommandT<cr>
nnoremap <leader>f :CommandTFlush<cr>\|:CommandT<cr>
nnoremap <leader>b :CommandTBuffer<cr>

" NERDTree
nnoremap \ :NERDTreeToggle<CR>
nnoremap \| :NERDTreeFind<CR>
let NERDTreeShowHidden = 1

" NeoComplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
let g:neocomplete#enable_auto_close_preview = 1

" NeoSnippet
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets,~/.vim/snippets'

imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" FILETYPE DETECTION
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 listchars=tab:\ \ ,trail:·
autocmd FileType python setlocal shiftwidth=4 tabstop=4
autocmd FileType make setlocal noexpandtab shiftwidth=4 tabstop=4

" APPEARANCE
:color nofrils-dark
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
set cmdheight=2

" BASIC EDITING CONFIGURATION
set hidden
set history=1000
set number
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
" Fix delay after pressing ESC then O - http://ksjoberg.com/vim-esckeys.html
set timeout timeoutlen=1000 ttimeoutlen=100
syntax on

" KEY MAPPINGS
command! W :w
command! Q :q
command! Bd :bd
" Allow yank and put to/from system clipboard
map <leader>y "*y
map <leader>p "*p
nnoremap p ]p
" Improve scrolling speed
nnoremap <c-e> 9<c-e>
nnoremap <c-y> 9<c-y>
" Easier switch between files
nnoremap <leader><leader> <c-^>
" Clear search buffer by hitting space
:nnoremap <space> :nohlsearch<cr>
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

" RENAME CURRENT FILE
function! RenameCurrent()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
command! RenameCurrent :call RenameCurrent()

" REMOVE TRAILING WHITESPACE
function! <SID>StripTrailingWhitespace()
  " Save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
command! StripTrailingWhitespace call <SID>StripTrailingWhitespace()
nnoremap <leader>s :StripTrailingWhitespace<cr>

" SWITCH BETWEEN TEST AND PRODUCTION CODE
function! OpenTestAlternate()
  " if b:rails_root exists we're in a rails app and should defer to rails.vim
  if exists('b:rails_root')
    :A
  else
    let new_file = AlternateForCurrentFile()
    exec ':e ' . new_file
  endif
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  if in_spec
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', 'lib/', '')
  else
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = substitute(new_file, '^lib/', 'spec/', '')
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

" RUNNING TESTS
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
map <leader>c :w\|:!script/features<cr>
map <leader>w :w\|:!script/features --profile wip<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " rust files are always considered to be test files
    let in_test_file = &filetype =~# 'rust' ||
        \ match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetCurrentTestFile()
    elseif !exists("t:current_test_file")
        return
    end
    call RunTests(t:current_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

function! SetCurrentTestFile()
    " Set the spec file that tests will be run for.
    let t:current_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    if &filetype =~# 'rust'
        exec ":!rust test ". a:filename
    elseif match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction

" Spelling
function! <SID>EnableSpell()
  :setlocal spell spelllang=en_gb
endfunction
command! EnableSpell call <SID>EnableSpell()

" DOTFILE EDITING HELPERS
nnoremap <leader>gv :e $MYVIMRC<CR>
autocmd bufwritepost .vimrc source $MYVIMRC
nnoremap <leader>gg :e ~/.gitconfig<CR>
nnoremap <leader>gz :e ~/.zshrc<CR>
nnoremap <leader>gt :e ~/.tmux.conf<CR>
autocmd bufwritepost .tmux.conf silent !tmux source-file ~/.tmux.conf

" Read .vimrc, .exrc and .gvimrc in current working directory
set exrc
set secure " deliberately set at end of .vimrc, see :help 'secure'

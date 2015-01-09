set nocompatible

" VUNDLE PLUGIN CONFIGURATION
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

Plugin 'gmarik/Vundle.vim'

Plugin 'christoomey/vim-tmux-navigator'
Plugin 'fatih/vim-go'
Plugin 'guns/vim-sexp'
Plugin 'jpalardy/vim-slime'
Plugin 'kana/vim-textobj-user'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'scrooloose/syntastic'
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

" PLUGIN CONFIG
let g:slime_target = "tmux"
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['objc'] }
runtime macros/matchit.vim
let g:go_fmt_command = "goimports"

" CommandT
let g:CommandTAlwaysShowDotFiles = 1
let g:CommandTTraverseSCM = "pwd"
nnoremap <c-p> :CommandTFlush<cr>\|:CommandT<cr>
nnoremap <leader>f :CommandTFlush<cr>\|:CommandT<cr>

" Mappings for FiREPLace
nnoremap <leader>e :Eval<cr>
nnoremap <leader>er :Eval!<cr>
nnoremap <leader>E :%Eval<cr>
nnoremap <leader>r :w\|:%Eval<cr>\|:Eval (run-tests)<cr>

" I like rainbows
autocmd VimEnter * RainbowParenthesesToggle
autocmd Syntax * RainbowParenthesesLoadRound
autocmd Syntax * RainbowParenthesesLoadSquare
autocmd Syntax * RainbowParenthesesLoadBraces

" FILETYPE DETECTION
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4
autocmd FileType python setlocal shiftwidth=4 tabstop=4

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
set cmdheight=2
set showtabline=2
set ruler
set title
set showcmd
set wildmenu
set wildmode=longest,list
set scrolloff=3
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set autowrite
" Fix delay after pressing ESC then O - http://ksjoberg.com/vim-esckeys.html
set timeout timeoutlen=1000 ttimeoutlen=100
syntax on

" Only show cursorline in active buffer
augroup cursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" Jump to last cursor position unless it's invalid or in an event handler,
" or the file is a git commit message
augroup vimrcEx
  autocmd!
  autocmd BufReadPost *
        \ if expand('%:t') == 'COMMIT_EDITMSG' |
        \   exe "normal gg" |
        \ elseif line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
augroup END

" KEY MAPPINGS
command! W :w
command! Q :q
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

" MULTIPURPOSE TAB KEY
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" ARROW KEYS ARE UNACCEPTABLE
map <Left> :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up> :echo "no!"<cr>
map <Down> :echo "no!"<cr>

" COLOR
:set t_Co=256
:color grb256

" STATUS LINE
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

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

" DOTFILE EDITING HELPERS
nnoremap <leader>v :e $MYVIMRC<CR>
autocmd bufwritepost .vimrc source $MYVIMRC
nnoremap <leader>g :e ~/.gitconfig<CR>
nnoremap <leader>z :e ~/.zshrc<CR>
nnoremap <leader>x :e ~/.tmux.conf<CR>
autocmd bufwritepost .tmux.conf silent !tmux source-file ~/.tmux.conf


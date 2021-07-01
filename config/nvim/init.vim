" auto install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'morhetz/gruvbox'

Plug 'Yggdroot/indentLine'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim'
Plug 'mtth/scratch.vim'
Plug 'simnalamburt/vim-mundo'
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
" nice things for netrw
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-abolish'
" ctrl-a ctrl-x for date and time
Plug 'tpope/vim-speeddating'
" *nix std commands for vim
Plug 'tpope/vim-eunuch'
Plug 'bronson/vim-visual-star-search'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'lyokha/vim-xkbswitch'
Plug 'ruanyl/vim-gh-line'

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'kassio/neoterm'
Plug 'kien/rainbow_parentheses.vim'
Plug 'kristijanhusak/vim-carbon-now-sh'

" syntax, linters and language plugins
Plug 'rizzatti/dash.vim'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'kana/vim-textobj-user'
Plug 'sheerun/vim-polyglot'
Plug 'sheerun/vim-go'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-jdaddy'
Plug 'neoclide/jsonc.vim'
Plug 'ap/vim-css-color'
Plug 'honza/vim-snippets'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" Plug 'eraserhd/parinfer-rust', { 'do': 'cargo build --release > /dev/null' }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
Plug 'janko/vim-test'

call plug#end()

set termguicolors
let g:gruvbox_italic = 1
let g:gruvbox_contrast_dark = 'soft'
let g:gruvbox_sign_column = 'bg0'
colorscheme gruvbox
" set background=dark

" Enable mouse usage (all modes)
set mouse=a

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set scrolloff=5
set autoindent
set noshowmode
set autoread

set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,nbsp:␣
set fillchars=vert:\│

" Do smart case matching
set smartcase
" Do case insensitive matching
set ignorecase
" Incremental search
set incsearch
set hlsearch
set wildmode=list:longest,full
set backspace=indent,eol,start
" Hide buffers when they are abandoned
set hidden
set wildmenu
set splitbelow
set splitright
set visualbell
set cursorline
set guicursor+=n-v-c:blinkon0
set ruler
set laststatus=2
set textwidth=79
" Show (partial) command in status line.
" set showcmd
set linespace=0
" Show matching brackets.
set showmatch
set wrap
set foldenable
set foldmethod=syntax
set foldlevelstart=20
set completeopt=menu,menuone,preview,noselect,noinsert
set shortmess=atIc
set cmdheight=2

" do not highlight lines longer than 800 char
set synmaxcol=800

set relativenumber
set number

set breakindent
set breakindentopt=sbr
set showbreak=└ 
set inccommand=nosplit
set diffopt+=vertical

" Make sure Vim returns to the same line when you reopen a file.
augroup line_return
  au!
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" Persist folds
set viewoptions=folds,cursor
augroup PersistFolds
  autocmd!
  autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup END

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Don’t display urls as spelling errors
syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell

" Don't count acronyms / abbreviations as spelling errors
" (all upper-case letters, at least three characters)
" Also will not count acronym with 's' at the end a spelling error
" Also will not count numbers that are part of this
" Recognizes the following as correct:
syn match AcronymNoSpell '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell

autocmd FileType qf setlocal nospell
autocmd FileType json,yaml,neoterm,fzf setlocal nospell

function! MyModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! MyReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return "╳"
  else
    return ""
  endif
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
       \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
       \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! CocCurrentFunction()
  return get(b:, 'coc_current_function', '')
endfunction

function! CocGitStatus()
  return get(g:, 'coc_git_status', '')
endfunction

let g:lightline = {
  \   'colorscheme': 'gruvbox',
  \   'component_function': {
  \     'readonly': 'MyReadonly',
  \     'modified': 'MyModified',
  \     'filename': 'MyFilename',
  \     'cocstatus': 'coc#status',
  \     'git': "CocGitStatus",
  \     'currentfunction': 'CocCurrentFunction'
  \   },
  \   'active': {
  \     'left': [
	\       ['mode', 'paste'],
	\       ['filename']
	\			],
  \     'right': [
	\       ['cocstatus', 'git', 'currentfunction'],
	\       ['lineinfo']
	\     ]
  \   }
  \ }


"don't wait too long for next keystroke
set timeoutlen=500
set updatetime=250
set smarttab

" lang
"
" Ctrl-^ for rus-eng keymap
" set keymap=russian-jcukenmac
" start on latin keymap
set iminsert=0
set imsearch=0
" hi lCursor guifg=NONE guibg=Cyan
set spell
set spelllang=ru_ru,en_gb
set spellfile=~/.config/nvim/spell/ru.utf-8.add,~/.config/nvim/spell/en.utf-8.add
hi clear SpellBad
hi SpellBad cterm=underline

autocmd CursorHold * silent call CocActionAsync('highlight')
set updatetime=100

" display only current cursorline
augroup CursorLine
  au!
  au VimEnter * setlocal cursorline
  au WinEnter * setlocal cursorline
  au BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END


set formatoptions=qrn1j
set wildignorecase
set history=500
set complete=.,b,u,],kspell
set wildignore+=**/node_modules
set clipboard+=unnamedplus

" Backups
set undofile
set undodir=~/.config/nvim/tmp/undo//
set nobackup
set noswapfile

function! CloseWindowOrKillBuffer()
  let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

  " We should never bdelete a nerd tree
  if matchstr(expand("%"), 'NERD') == 'NERD'
    wincmd c
    return
  endif

  if number_of_windows_to_this_buffer > 1
    wincmd c
  else
    bdelete
  endif
endfunction

nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>
nnoremap <silent> <D-w> :call CloseWindowOrKillBuffer()<CR>

tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap * *``

nnoremap <Right> <C-W>>
nnoremap <Left> <C-W><
nnoremap <Up> <C-W>-
nnoremap <Down> <C-W>+

" Treat warped lines as regular lines
nnoremap j gj
nnoremap k gk
nnoremap / /\v
vnoremap / /\v
nnoremap ; :
cmap cwd lcd %:p:h
vnoremap < <gv
vnoremap > >gv
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
" Cursor don't jump when joining lines
nnoremap J mzJ`z
" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap Y y$
map K <Nop>
nnoremap <c-t> :FZF<CR>
nnoremap <c-p> :FZF<CR>

nnoremap s :w<cr>

" Leader maps
nnoremap <SPACE> <Nop>
let mapleader = " "
nnoremap <leader>l :set list!<cr> \| :IndentLinesToggle<cr>
nnoremap <leader><space> :nohl<cr>
noremap <leader>u :MundoToggle<cr>
nnoremap <leader>lw :%s/^\s\+<cr>:nohl<cr>
nnoremap <leader>bl :g/^$/d<cr>:nohl<cr>
nnoremap <leader>ev :e $MYVIMRC<cr>
" Yank whole text line without spaces
nnoremap <leader>y ^y$
nnoremap <leader>S :%s///<left>
nnoremap <leader>a :Rg<space>
nnoremap <leader>wa :wa<cr>
nnoremap <leader>qq :qa!<cr>
nnoremap <leader>w <C-w>

nmap <leader>ja :A<cr>
nmap <leader>jA :AV<cr>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>s <Plug>(coc-rename)
nmap <F12> <Plug>(coc-definition)

vmap <C-j> <Plug>(coc-snippets-select)
imap <C-j> <Plug>(coc-snippets-expand-jump)
nnoremap <leader>k <Plug>(coc-diagnostic-info)
nnoremap <leader>. :CocAction<cr>
nnoremap <leader>o :only<cr>
nnoremap <leader>z :Goyo<cr>
nnoremap <leader>h :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Fugitive.vim
nnoremap <leader>gw :Gw<cr>
nnoremap <leader>gc :Git commit<cr>
nnoremap <leader>ga :Git commit --amend --reuse-message=HEAD<cr>
nnoremap <leader>gs :Git status<cr>
nnoremap <leader>gP :Git push --force<cr>

" neoterm
vnoremap <leader>tr :TREPLSendSelection<cr>
nnoremap <leader>tr :TREPLSendLine<cr>

nnoremap <leader>j :Ttoggle<cr>
nnoremap ` :Ttoggle<cr>
tnoremap <leader>j <C-\><C-n>:Ttoggle<cr>
tnoremap ` <C-\><C-n>:Ttoggle<cr>

nnoremap <leader>tc :Tclear<cr>
let g:neoterm_default_mod='botright'
let g:neoterm_autoinsert=1

cabbr <expr> %% expand('%:p:h')

" fzf
nnoremap <leader>b :Buffers<cr>

" Goyo
function! s:goyo_enter()
  " set relativenumber
  " set number
  set scrolloff=999
endfunction

function! s:goyo_leave()
  set scrolloff=5
  set background=dark
endfunction

autocmd! User GoyoEnter
autocmd! User GoyoLeave
autocmd  User GoyoEnter nested call <SID>goyo_enter()
autocmd  User GoyoLeave nested call <SID>goyo_leave()

autocmd BufWritePre * :%s/\s\+$//e

autocmd BufWritePost $MYVIMRC nested source $MYVIMRC

" filetypes
autocmd BufRead,BufNewFile Jenkinsfile set ft=groovy
autocmd BufRead,BufNewFile *.jenkinsfile set ft=groovy
autocmd BufRead,BufNewFile *.tpl set ft=html
autocmd BufRead,BufNewFile *.coffee set noexpandtab
autocmd BufRead,BufNewFile tsconfig*.json set filetype=jsonc
autocmd BufRead,BufNewFile *.plist set filetype=xml

let g:scratch_autohide = 0

let g:netrw_localrmdir = 'rm -r'

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

autocmd filetype qf wincmd J

autocmd VimResized * wincmd =

" emmet
let g:user_emmet_settings = {
\    'typescript.tsx': {
\        'extends': 'jsx',
\        'quote_char': "'"
\    }
\}

" vim-surround
au FileType javascript,typescript let b:surround_99 = "/* \r */"

" IndentLine
let g:indentLine_enabled = 0
let g:indentLine_char = '┆'

autocmd! FileType fzf,neoterm
autocmd FileType fzf,neoterm set laststatus=0 | autocmd WinLeave <buffer> set laststatus=2

" signify
let g:signify_sign_show_count = 0
let g:signify_sign_show_text = 0

" markdown-preview
let g:mkdp_browser = 'Choosy'
let g:mkdp_auto_close = 0

" vim-carbon-now-sh
let g:carbon_now_sh_options = {
      \ 'fm': 'Fira Code',
      \ 't': 'seti',
      \ 'pv': '0px',
      \ 'ph': '0px',
      \ 'bg': 'rgba(0,0,0,0)',
      \ }

" au BufEnter *.tsx set filetype=typescriptreact

autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

let g:projectionist_heuristics = {
\   "package.json": {
\     "*.tsx": {
\       "alternate": "{dirname}/__tests__/{basename}.test.tsx",
\       "type": "component"
\     },
\     "*.test.tsx": {
\       "alternate": "{dirname}/../{basename}.tsx",
\       "type": "test"
\     },
\     "*.ts": {
\       "alternate": "{dirname}/__tests__/{basename}.test.ts"
\     },
\     "*.test.ts": {
\       "alternate": "{dirname}/../{basename}.ts",
\       "type": "test"
\     },
\     "*.js": {
\       "alternate": "{dirname}/__tests__/{basename}.test.js"
\     },
\     "*.test.js": {
\       "alternate": "{dirname}/../{basename}.js",
\       "type": "test"
\     },
\   },
\ }

command! -nargs=0 Prettier :CocCommand prettier.formatFile

" coc extensions
let g:coc_global_extensions = ['coc-prettier', 'coc-git', 'coc-emoji', 'coc-tsserver', 'coc-json', 'coc-html', 'coc-css', 'coc-yaml', 'coc-emmet', 'coc-snippets', 'coc-svg', 'coc-reason', 'coc-go', 'coc-diagnostic']

try
    nmap <silent> [c :call CocAction('diagnosticNext')<cr>
    nmap <silent> ]c :call CocAction('diagnosticPrevious')<cr>
endtry

" xkbswitch
let g:XkbSwitchEnabled = 1
" let g:XkbSwitchIMappings = ['ru']

" vim-test
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
au TermOpen * setlocal nonumber norelativenumber
let test#strategy = "neovim"
let test#neovim#term_position = 'vert'
let test#javascript#jest#options = '--watch'

command! W noa write

" tab (window) nav
map <C-Tab> gt
map <C-S-Tab> gT

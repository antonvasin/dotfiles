" auto install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin('~/.config/nvim/plugged')

" Look
Plug 'morhetz/gruvbox'
Plug 'Yggdroot/indentLine'
Plug 'itchyny/lightline.vim'

" Editing & Navigation
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim'
Plug 'mtth/scratch.vim'
Plug 'simnalamburt/vim-mundo'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'kana/vim-textobj-user'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-speeddating' " ctrl-a ctrl-x for date and time
Plug 'lyokha/vim-xkbswitch'
Plug 'bronson/vim-visual-star-search'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Integrations
Plug 'mileszs/ack.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'tpope/vim-vinegar' " nice things for netrw
Plug 'tpope/vim-projectionist'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'ruanyl/vim-gh-line'
Plug 'kassio/neoterm'
Plug 'kristijanhusak/vim-carbon-now-sh'
Plug 'janko/vim-test'

" Languages
Plug 'rizzatti/dash.vim'
Plug 'tpope/vim-fireplace', Cond(!exists('g:vscode'))
Plug 'sheerun/vim-polyglot', Cond(!exists('g:vscode'))
Plug 'sheerun/vim-go'
Plug 'tpope/vim-jdaddy'
Plug 'neoclide/jsonc.vim'
Plug 'ap/vim-css-color'
Plug 'honza/vim-snippets'
" Plug 'neoclide/coc.nvim', Cond(!exists('g:vscode'))
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }
Plug 'github/copilot.vim'

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
set noshowmode
set autoindent
set autoread
set wildmenu
set ruler
set smarttab

set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,nbsp:␣
set fillchars=vert:\│

" Do smart case matching
set smartcase
" Do case insensitive matching
set ignorecase
" Incremental search
set hlsearch
set wildmode=list:longest,full
set backspace=indent,eol,start
" Hide buffers when they are abandoned
set hidden
set splitbelow
set splitright
set visualbell
set cursorline
set guicursor+=n-v-c:blinkon0
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
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()

" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

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

if (!exists('g:vscode'))
  " autocmd CursorHold * silent call CocActionAsync('highlight')
  " autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  set updatetime=100
end

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

map Q <Nop>

if (!exists('g:vscode'))
  nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>
  nnoremap <silent> <D-w> :call CloseWindowOrKillBuffer()<CR>
else
  map - <Nop>
end

if has('gui_running')
  nnoremap <D-p> :FZF<CR>
  set showtabline=0
  set guioptions=
end

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
" cmap cwd lcd %:p:h
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
nnoremap <leader>o :FZF<CR>
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
nnoremap <leader>a :Ack!<space>
nnoremap <leader>wa :wa<cr>
nnoremap <leader>qq :qa!<cr>
nnoremap <leader>w <C-w>

nmap <leader>ja :A<cr>
nmap <leader>jA :AV<cr>

" Coc
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
" nmap <leader>s <Plug>(coc-rename)
" nmap <F12> <Plug>(coc-definition)
" vmap <C-j> <Plug>(coc-snippets-select)
" imap <C-j> <Plug>(coc-snippets-expand-jump)
" nnoremap <leader>k <Plug>(coc-diagnostic-info)
" nnoremap <leader>. :CocAction<cr>
" nnoremap <leader>h :call <SID>show_documentation()<CR>

nnoremap <leader>o :only<cr>
nnoremap <leader>z :Goyo<cr>

nnoremap <leader>W :ToggleWorkspace<CR>

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

let g:projectionist_heuristics = {
\   "package.json": {
\     "*.tsx": {
\       "alternate": [
\         "{dirname}/__tests__/{basename}.test.tsx",
\         "{basename}.test.tsx",
\         "{basename}.spec.tsx"
\       ],
\       "type": "component"
\     },
\     "*.test.tsx": {
\       "alternate": "{dirname}/../{basename}.tsx",
\       "type": "test"
\     },
\     "*.ts": {
\       "alternate": "{dirname}/__tests__/{basename}.test.ts",
\       "type": "source"
\     },
\     "*.test.ts": {
\       "alternate": "{dirname}/../{basename}.ts",
\       "type": "test"
\     },
\     "*.js": {
\       "alternate": [
\         "{dirname}/__tests__/{basename}.test.js",
\         "{}.test.js",
\         "{}.spec.js",
\       ],
\       "type": "source"
\     },
\     "*.test.js": {
\       "alternate": ["{}.js", "{dirname}/../{basename}.js"],
\       "type": "test"
\     },
\     "*.spec.js": {
\       "alternate": ["{}.js", "{dirname}/../{basename}.js"],
\       "type": "test"
\     },
\    },
\  "project.clj": {
\     "*.clj": {
\       "alternate": "{dirname}/../test/{basename}_test.clj",
\       "type": "source"
\     },
\     "*_test.clj": {
\       "alternate": "{dirname}/../src/{basename}.clj",
\       "type": "source"
\     }
\  }
\}

" command! -nargs=0 Prettier :CocCommand prettier.formatFile

" coc extensions
" let g:coc_node_path = '/Users/antonvasin/.volta/tools/image/node/14.16.1/bin/node'
" let g:coc_global_extensions = ['coc-prettier', 'coc-git', 'coc-emoji', 'coc-tsserver', 'coc-json', 'coc-html', 'coc-css', 'coc-yaml', 'coc-emmet', 'coc-snippets', 'coc-svg', 'coc-reason', 'coc-go', 'coc-diagnostic']

" try
"     nmap <silent> [c :call CocAction('diagnosticPrevious')<cr>
"     nmap <silent> ]c :call CocAction('diagnosticNext')<cr>
" endtry

" xkbswitch
let g:XkbSwitchEnabled = 1
" let g:XkbSwitchIMappings = ['ru']

" vim-test
" nmap <silent> t<C-n> :TestNearest<CR>
" nmap <silent> t<C-f> :TestFile<CR>
" nmap <silent> t<C-s> :TestSuite<CR>
" nmap <silent> t<C-l> :TestLast<CR>
" nmap <silent> t<C-g> :TestVisit<CR>
au TermOpen * setlocal nonumber norelativenumber
let test#strategy = "neovim"
let test#neovim#term_position = 'vert'
let test#javascript#jest#options = '--watch'

command! W noa write

" tab (window) nav
map <C-Tab> gt
map <C-S-Tab> gT

" let g:ack_autoclose = 1
let g:ackprg = 'rg --vimgrep --smart-case'
let g:ack_use_cword_for_empty_search = 1

" LSP
lua << EOF
local lsp_installer = require("nvim-lsp-installer")
local util = require 'lspconfig.util'

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
    local opts = {}

    -- (optional) Customize the options passed to the server
    if server.name == "tsserver" then
        opts.root_dir = util.root_pattern("tsconfig.json");
    end

    if server.name == "denols" then
      opts.root_dir = util.root_pattern("deno.json");
      opts.init_options = {
        unstable = true,
        lint = true,
        importMap = "./import_map.json"
      }
    end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)

-- require'lspconfig'.tsserver.setup{}
-- require'lspconfig'.denols.setup{}
-- require'lspconfig'.eslint.setup{}
-- require'lspconfig'.dockerls.setup{}
-- require'lspconfig'.gopls.setup{}
-- require'lspconfig'.vimls.setup{}
-- require'lspconfig'.yamlls.setup{}
-- require'lspconfig'.cssls.setup{}
-- require'lspconfig'.jsonls.setup{}
-- require'lspconfig'.html.setup{}

vim.g.markdown_fenced_languages = {
  "ts=typescript"
}
EOF

nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ge <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> <leader>f    <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>r    <cmd>lua vim.lsp.buf.rename()<CR>

nnoremap <silent> <leader>. <cmd>lua vim.lsp.buf.code_action()<CR>
xmap <silent> <leader>. <cmd>lua vim.lsp.buf.range_code_action()<CR>

" prettier
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

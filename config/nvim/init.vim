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
" Plug 'sainnhe/gruvbox-material'
Plug 'Yggdroot/indentLine'
Plug 'itchyny/lightline.vim'

" Editing & Navigation
Plug 'windwp/nvim-autopairs'
Plug 'junegunn/goyo.vim'
Plug 'mtth/scratch.vim'
Plug 'simnalamburt/vim-mundo'
" Plug 'tpope/vim-commentary'
Plug 'numToStr/Comment.nvim'
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
Plug 'b0o/schemastore.nvim'
Plug 'ap/vim-css-color', { 'for': 'html,css,js,jsx,ts,tsx,vue,less,sass,style' }
Plug 'wuelnerdotexe/vim-astro'
Plug 'ellisonleao/glow.nvim'

" LSP
Plug 'nvim-lua/plenary.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'onsails/lspkind.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

call plug#end()

set termguicolors
let g:gruvbox_italic = 1
let g:gruvbox_contrast_dark = 'soft'
let g:gruvbox_sign_column = 'bg0'
let g:gruvbox_material_foreground = 'mix'
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
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

let g:lightline = {
  \   'colorscheme': 'gruvbox',
  \   'component_function': {
  \     'readonly': 'MyReadonly',
  \     'modified': 'MyModified',
  \     'filename': 'MyFilename',
  \     'git': 'FugitiveHead'
  \   },
  \   'active': {
  \     'left': [
	\       ['mode', 'paste'],
	\       ['filename']
	\			],
  \     'right': [
	\       ['git', 'currentfunction'],
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
nnoremap <leader>md :Glow<cr>

nmap <leader>ja :A<cr>
nmap <leader>jA :AV<cr>

nnoremap <leader>o :only<cr>
nnoremap <leader>z :Goyo<cr>

nnoremap <leader>x :%!xxd<cr>
nnoremap <leader>X :%!xxd -r<cr>

nnoremap <leader>W :ToggleWorkspace<CR>

" Fugitive.vim
nnoremap <leader>gw :Gw<cr>
nnoremap <leader>gc :Git commit<cr>
nnoremap <leader>ga :Git commit --amend<cr>
nnoremap <leader>gA :Git commit --amend --reuse-message=HEAD<cr>
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
\       "alternate":[
\         "{basename}.test.ts",
\         "{dirname}/{basename}.test.ts",
\        ],
\       "type": "source"
\     },
\     "*.test.ts": {
\       "alternate": [
\         "{basename}.ts",
\         "{dirname}/../{basename}.ts",
\       ],
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

" --------- lua config --------

lua << EOF

require('Comment').setup()

-- LSP
local lspconfig = require('lspconfig')
local util = require 'lspconfig.util'

require("nvim-lsp-installer").setup {
  automatic_installation = true,
}

local opts = { noremap=true, silent=true }
vim.keymap.set('n', 'ge', vim.diagnostic.open_float, opts)
vim.keymap.set('n', 'gE', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>.', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
end
-- nvim-cmp
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require 'cmp'
local lspkind = require('lspkind')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

lspconfig.astro.setup{}

lspconfig.tsserver.setup{
  root_dir = util.root_pattern("tsconfig.json", "package.json"),
  capabilities = capabilities,
  on_attach = on_attach,
}

local function deno_init_opts()
  opts = {
    unstable = true,
    lint = true,
  }

  if vim.fn.filereadable('./import_map.json') == 1 then
    opts.importMap = './import_map.json'
  end

  return opts
end

lspconfig.denols.setup{
  root_dir = util.root_pattern("deno.json", "mod.ts", "main.ts", "import_map.json", "lock.json");
  init_options = deno_init_opts(),
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "markdown" }
}

lspconfig.jsonls.setup{
  init_options = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    }
  },
  capabilities = capabilities,
  on_attach = on_attach,
}

local kind_icons = {
  Text = "abc",
  Method = ".()",
  Function = "ƒ",
  Constructor = "new",
  Field = ":",
  Variable = "var",
  Class = "C",
  Interface = "I",
  Module = "M",
  Property = ".",
  Unit = "U",
  Value = "V",
  Enum = "",
  Keyword = "",
  Snippet = "Snip",
  Color = "",
  File = "📄",
  Reference = "Ref",
  Folder = "📂",
  EnumMember = "E[]",
  Constant = "",
  Struct = "",
  Event = "Event",
  Operator = "or",
  TypeParameter = "<T>"
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
     ['<Tab>'] = cmp.mapping(function(fallback)
       if cmp.visible() then
         cmp.select_next_item()
 --      elseif luasnip.expand_or_jumpable() then
 --        luasnip.expand_or_jump()
       else
         fallback()
       end
     end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
--       elseif luasnip.jumpable(-1) then
--         luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),

  completion = {
    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
    col_offset = -2,
    side_padding = 0,
  },

  window = {
    completion = {
      border = 'rounded',
    },
  },

  sources = {
    { name = 'nvim_lsp' },
--    { name = 'luasnip' },
  },

  formatting = {
    fields = { "kind", "abbr" },
    format = function(entry, vim_item)
      -- local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)

      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      local strings = vim.split(vim_item.kind, "%s", { trimempty = true })
      vim_item.kind = "" .. strings[1] .. " "
      vim_item.menu = "    (" .. strings[2] .. ")"
      return vim_item
    end,
  },

  experimental = {
    ghost_text = true,
  }
}

vim.diagnostic.config({
  float = {
    source = 'always',
    focusable = false,
  },
  update_in_insert = false, -- default to false
  severity_sort = true, -- default to false
})

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
      null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.formatting.prettier,
      null_ls.builtins.completion.spell
  },
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.cmd("nnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.format()<CR>")

      -- format on save
      vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.format()")
    end

    if client.server_capabilities.documentRangeFormattingProvider then
      vim.cmd("xnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.range_format({})<CR>")
    end
  end,
})

require("nvim-autopairs").setup {}

EOF
let g:markdown_fenced_languages = ["ts=typescript"]

" nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
" nnoremap <silent> ge <cmd>lua vim.diagnostic.open_float()<CR>
" nnoremap <silent> gE <cmd>lua vim.diagnostic.setloclist()<CR>
" nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> <leader>r    <cmd>lua vim.lsp.buf.rename()<CR>
"
" nnoremap <silent> <leader>. <cmd>lua vim.lsp.buf.code_action()<CR>
" xmap <silent> <leader>. <cmd>lua vim.lsp.buf.range_code_action()<CR>

" autocmd BufWritePre *.py,*.ts,*.js,*.css,*.go,*.tf,*.html,*scss,*.jsx,*.tsx,*.md,*.astro lua vim.lsp.buf.format()

" Astro
let g:astro_typescript = 'enable'
let g:astro_stylus = 'enable'
let g:astro_indent = 'disable'

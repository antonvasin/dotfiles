vim.cmd([[
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

" Languages
Plug 'rizzatti/dash.vim'
Plug 'tpope/vim-fireplace', Cond(!exists('g:vscode'))
" Plug 'sheerun/vim-polyglot', Cond(!exists('g:vscode'))
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
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
]])

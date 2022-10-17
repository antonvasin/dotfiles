require("plugins")
require("settings")
require("keys")
require("lsp")
-- require("statusline")

require("Comment").setup()

require("nvim-autopairs").setup({})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "javascript", "typescript", "css", "html", "go", "clojure", "bash", "sql", "vim", "lua" },
	highlight = { enabled = true },
	auto_install = true,
})

vim.cmd([[
" display only current cursorline
augroup CursorLine
  au!
  au VimEnter * setlocal cursorline
  au WinEnter * setlocal cursorline
  au BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

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

autocmd! FileType fzf,neoterm
autocmd FileType fzf,neoterm set laststatus=0 | autocmd WinLeave <buffer> set laststatus=2

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

au TermOpen * setlocal nonumber norelativenumber
]])

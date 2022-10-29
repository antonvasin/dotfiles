-- Enable mouse usage (all modes)
vim.opt.mouse = "a"

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 5
vim.opt.showmode = false
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.wildmenu = true
vim.opt.ruler = true
vim.opt.smarttab = true

-- Do smart case matching
vim.opt.smartcase = true
-- Do case insensitive matching
vim.opt.ignorecase = true
-- Incremental search
vim.opt.hlsearch = true
vim.opt.wildmode = { "list", "longest", "full" }
vim.opt.backspace = { "indent", "eol", "start" }
-- Hide buffers when they are abandoned
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.visualbell = true
vim.opt.cursorline = true
vim.opt.guicursor:append({ "n-v-c:blinkon0" })
vim.opt.laststatus = 2
vim.opt.textwidth = 79
-- Show (partial) command in status line.
-- vim.opt.showcmd
vim.opt.linespace = 0
-- Show matching brackets.
vim.opt.showmatch = true
vim.opt.wrap = true
vim.opt.foldenable = true
vim.opt.foldmethod = "syntax"
vim.opt.foldlevelstart = 20
vim.opt.completeopt = { "menu", "menuone", "preview", "noselect", "noinsert" }
vim.opt.shortmess = "atIc"
vim.opt.cmdheight = 2

-- do not highlight lines longer than 800 char
vim.opt.synmaxcol = 800

vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.breakindent = true
vim.opt.breakindentopt = "sbr"
vim.opt.showbreak = "└  "
vim.opt.inccommand = "nosplit"
vim.opt.diffopt:append({ "vertical" })
vim.opt.viewoptions = { "folds", "cursor" }

--don't wait too long for next keystroke
vim.opt.timeoutlen = 500
if not vim.g.vscode then
  vim.opt.updatetime = 100
end

vim.opt.iminsert = 0
vim.opt.imsearch = 0

vim.opt.formatoptions = "qrn1j"
vim.opt.wildignorecase = true
vim.opt.history = 500
vim.opt.complete = { ".", "b", "u", "]", "kspell" }
vim.opt.wildignore:append({ "**/node_modules" })
vim.opt.clipboard:append({ "unnamedplus" })

-- Backups
vim.opt.undofile = true
vim.opt.undodir = "~/.config/nvim/tmp/undo//"
vim.opt.backup = false
vim.opt.swapfile = false

vim.g.scratch_autohide = 0

vim.g.netrw_localrmdir = "rm -r"

-- xkbswitch
vim.g.XkbSwitchEnabled = 1

-- rg
-- let g:ack_autoclose = 1
vim.g.ackprg = "rg --vimgrep --smart-case"
vim.g.ack_use_cword_for_empty_search = 1

vim.g.markdown_fenced_languages = { "ts=typescript" }

-- Astro
vim.g.astro_typescript = "enable"
vim.g.astro_stylus = "enable"
vim.g.astro_indent = "disable"

-- Make sure Vim returns to the same line when you reopen a file.
vim.cmd([[
augroup line_return
  au!
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END
]])

-- Persist folds
vim.cmd([[
augroup PersistFolds
  autocmd!
  autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup END
]])

-- Spelling
-- Don’t display urls as spelling errors
-- Don't count acronyms / abbreviations as spelling errors
-- (all upper-case letters, at least three characters)
-- Also will not count acronym with 's' at the end a spelling error
-- Also will not count numbers that are part of this
-- Recognizes the following as correct:
vim.opt.spell = true
vim.opt.spelllang = { "ru_ru", "en_gb" }
vim.cmd([[
autocmd FileType qf,json,yaml,neoterm,fzf setlocal nospell
hi SpellBad cterm=underdotted
" hi clear SpellBad
" hi lCursor guifg=NONE guibg=Cyan
syn match AcronymNoSpell '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell
]])
vim.cmd("syn match UrlNoSpell 'w+://[^[:space:]]+' contains=@NoSpell")

vim.cmd([[
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
]])

vim.cmd([[
au TermOpen * setlocal nonumber norelativenumber

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

" emmet
let g:user_emmet_settings = {
\    'typescript.tsx': {
\        'extends': 'jsx',
\        'quote_char': "'"
\    }
\}
]])

vim.g.projectionist_heuristics = {
  ["package.json"] = {
    ["*.tsx"] = {
      ["alternate"] = {
        "{dirname}/__tests__/{basename}.test.tsx",
        "{basename}.test.tsx",
        "{basename}.spec.tsx",
      },
      ["type"] = "component",
    },
    ["*.test.tsx"] = {
      ["alternate"] = "{dirname}/../{basename}.tsx",
      ["type"] = "test",
    },
    ["*.ts"] = {
      ["alternate"] = { "{basename}.test.ts", "{dirname}/{basename}.test.ts" },
      ["type"] = "source",
    },
    ["*.test.ts"] = {
      ["alternate"] = { "{basename}.ts", "{dirname}/../{basename}.ts" },
      ["type"] = "test",
    },
    ["*.js"] = {
      ["alternate"] = { "{dirname}/__tests__/{basename}.test.js", "{}.test.js", "{}.spec.js" },
      ["type"] = "source",
    },
    ["*.test.js"] = {
      ["alternate"] = { "{}.js", "{dirname}/../{basename}.js" },
      ["type"] = "test",
    },
    ["*.spec.js"] = {
      ["alternate"] = { "{}.js", "{dirname}/../{basename}.js" },
      ["type"] = "test",
    },
  },
  ["project.clj"] = {
    ["*.clj"] = {
      ["alternate"] = "{dirname}/../test/{basename}_test.clj",
      ["type"] = "source",
    },
    ["*_test.clj"] = {
      ["alternate"] = "{dirname}/../src/{basename}.clj",
      ["type"] = "source",
    },
  },
}

-- 24-bit colors
vim.opt.termguicolors = true
vim.cmd("colorscheme gruvbox")
vim.g.gruvbox_italic = 1
vim.g.gruvbox_contrast_dark = "soft"
vim.g.gruvbox_sign_column = "bg0"
vim.g.gruvbox_material_foreground = "mix"

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

-- vim.opt.listchars = { tab: '\▸', eol: '\¬', extends: '\❯', precedes: '\❮', nbsp: '\␣' }
-- vim.opt.fillchars = { vert: '│' }

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
vim.opt.updatetime = 250

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

vim.cmd([[
if (!exists('g:vscode'))
  set updatetime=100
end
]])

vim.g.scratch_autohide = 0

vim.g.netrw_localrmdir = "rm -r"

-- IndentLine
vim.g.indentLine_enabled = 0
vim.g.indentLine_char = "┆"

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
vim.opt.spell = true
vim.opt.spelllang = { "ru_ru", "en_gb" }
vim.opt.spellfile = { "~/.config/nvim/spell/ru.utf-8.add", "~/.config/nvim/spell/en.utf-8.add" }
-- syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell
-- syn match AcronymNoSpell '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell
-- hi lCursor guifg=NONE guibg=Cyan
vim.cmd([[
hi clear SpellBad
hi SpellBad cterm=underline
]])

-- Don’t display urls as spelling errors
--
-- Don't count acronyms / abbreviations as spelling errors
-- (all upper-case letters, at least three characters)
-- Also will not count acronym with 's' at the end a spelling error
-- Also will not count numbers that are part of this
-- Recognizes the following as correct:
vim.cmd([[
autocmd FileType qf setlocal nospell
autocmd FileType json,yaml,neoterm,fzf setlocal nospell
]])

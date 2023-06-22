-- 24-bit colors
vim.opt.termguicolors = true

-- Gruvbox
-- vim.g.gruvbox_italic = 1
-- vim.g.gruvbox_contrast_dark = "soft"
-- vim.g.gruvbox_sign_column = "bg0"
-- vim.cmd("colorscheme gruvbox")

-- gruvbox-material
vim.g.gruvbox_material_background = "soft"
vim.g.gruvbox_material_foreground = "mix"
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_enable_italic = 1
vim.cmd("colorscheme gruvbox-material")

-- IndentLine
vim.g.indentLine_enabled = 0
vim.g.indentLine_char = "┆"

-- Tab symbols, etc
vim.opt.listchars = "tab:▸ ,eol:¬,extends:❯,precedes:❮,nbsp:␣"
vim.opt.fillchars = "vert:│"

-- Display only current cursorline
vim.cmd([[
  augroup CursorLine
    au!
    au VimEnter * setlocal cursorline
    au WinEnter * setlocal cursorline
    au BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
  augroup END
]])

vim.cmd([[
  autocmd! FileType fzf,neoterm
  autocmd FileType fzf,neoterm set laststatus=0 | autocmd WinLeave <buffer> set laststatus=2
]])

vim.cmd("autocmd VimResized * wincmd =")

vim.opt.winblend = 25
vim.opt.pumblend = 25

if vim.g.neovide then
	vim.g.neovide_cursor_trail_size = 0.05
	vim.g.neovide_cursor_animation_length = 0.07
	vim.g.neovide_hide_mouse_when_typing = true
	vim.o.guifont = "JetBrainsMono Nerd Font Mono:h14"
	vim.g.neovide_remember_window_size = true

	-- Allow clipboard copy paste in neovim
	vim.g.neovide_input_use_logo = 1
	vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
	vim.keymap.set("v", "<D-c>", '"+y') -- Copy
	vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
	vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
	vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
	vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

	vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
end

vim.opt.signcolumn = "yes"

vim.opt.wildmode = "longest,list,full"
vim.opt.wildmenu = true

require("gitsigns").setup()

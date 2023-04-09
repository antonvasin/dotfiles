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

if vim.g.neovide then
	-- vim.g.neovide_floating_blur_amount_x = 8.0
	-- vim.g.neovide_floating_blur_amount_y = 8.0
	vim.g.neovide_cursor_trail_size = 0.1
	vim.g.neovide_hide_mouse_when_typing = true
	vim.o.guifont = "JetBrainsMono Nerd Font Mono:h14"
end

vim.opt.signcolumn = "yes"

require("gitsigns").setup()

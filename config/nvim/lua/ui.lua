-- 24-bit colors
vim.opt.termguicolors = true

-- Gruvbox
-- vim.g.gruvbox_italic = 1
-- vim.g.gruvbox_contrast_dark = "soft"
-- vim.g.gruvbox_sign_column = "bg0"
-- vim.cmd("colorscheme gruvbox")

-- gruvbox-baby
-- vim.g.gruvbox_baby_function_style = "NONE"
-- vim.g.gruvbox_baby_keyword_style = "italic"
-- vim.cmd("colorscheme gruvbox-baby")

-- Neon
-- vim.g.neon_style = "doom"
-- vim.g.neon_bold = true
-- vim.g.neon_transparent = true
-- vim.g.neon_italic_keyword = true
-- vim.g.neon_italic_function = true
-- vim.cmd("colorscheme neon")

-- gruvbox-material
vim.g.gruvbox_material_background = "soft"
vim.g.gruvbox_material_foreground = "mix"
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_enable_italic = 1
vim.cmd("colorscheme gruvbox-material")

require("lualine").setup({
	-- theme = "neon",
	theme = "gruvbox-material",
	options = {
		section_separators = "",
		component_separators = "",
		icons_enabled = false,
		-- sections = {
		-- 	lualine_b = {
		-- 		"branch",
		-- 		"diff",
		-- 		{
		-- 			"diagnostics",
		-- 			icons_enabled = true,
		-- 			symbols = { error = "●", warn = "◎", info = "○", hint = "◇" },
		-- 			always_visible = true,
		-- 			sources = { "nvim_lsp" },
		-- 		},
		-- 	},
		-- },
	},
})

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

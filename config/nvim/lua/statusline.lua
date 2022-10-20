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

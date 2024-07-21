-------- PLUGINS --------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Look
	{ "f-person/auto-dark-mode.nvim", config = true },

	-- Editing & Navigation
	{ "windwp/nvim-autopairs", config = true },
	{ "numToStr/Comment.nvim", config = true },
	"mbbill/undotree",
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{ "ibhagwan/fzf-lua" },

	-- Integrations
	{
		"mileszs/ack.vim",
		init = function()
			vim.g.ackprg = "rg --sort path --vimgrep --smart-case --no-heading"
		end,
	},
	-- nice things for netrw
	"tpope/vim-vinegar",
	"kassio/neoterm",

	-- Syntax
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},
	{ "tpope/vim-jdaddy", ft = "json" },
	{ "neoclide/jsonc.vim", ft = "json" },
	{ "ziglang/zig.vim", ft = "zig" },
	{
		"chrisgrieser/nvim-spider",
		keys = {
			{
				"w",
				"<cmd>lua require('spider').motion('w')<CR>",
				mode = { "n", "o", "x" },
			},
			{
				"e",
				"<cmd>lua require('spider').motion('e')<CR>",
				mode = { "n", "o", "x" },
			},
			{
				"b",
				"<cmd>lua require('spider').motion('b')<CR>",
				mode = { "n", "o", "x" },
			},
		},
	},

	-- LSP
	"nvim-lua/plenary.nvim",
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"hrsh7th/cmp-emoji",
			"onsails/lspkind.nvim",
			"b0o/schemastore.nvim",
		},
	},
	{ "folke/lazydev.nvim", ft = "lua" },
	"nvimtools/none-ls.nvim",
})
-------- PLUGINS --------

-------- SETTINGS --------
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
vim.opt.completeopt = { "menu", "menuone", "preview", "noselect", "noinsert" }
vim.opt.shortmess = "atIc"
vim.opt.cmdheight = 1

-- folding
vim.opt.foldenable = true
vim.opt.foldmethod = "manual"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99

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

-- Leader
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { silent = true, noremap = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
vim.opt.backup = false
vim.opt.swapfile = false

vim.g.netrw_localrmdir = "rm -r"

-- rg
-- let g:ack_autoclose = 1
vim.g.ackprg = "rg --vimgrep --smart-case"
vim.g.ack_use_cword_for_empty_search = 1

vim.g.markdown_fenced_languages = { "ts=typescript" }

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
vim.opt.spelllang = { "en_gb" }
vim.cmd([[
autocmd FileType markdown,text,html setlocal spell
hi SpellBad cterm=underdotted
" hi clear SpellBad
" hi lCursor guifg=NONE guibg=Cyan
syn match AcronymNoSpell '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell
]])
vim.cmd("syn match UrlNoSpell 'w+://[^[:space:]]+' contains=@NoSpell")

vim.cmd([[
au TermOpen * setlocal nonumber norelativenumber

autocmd BufWritePre * :%s/\s\+$//e

" autocmd BufWritePost $MYVIMRC nested source $MYVIMRC

" filetypes
autocmd BufRead,BufNewFile tsconfig*.json set filetype=jsonc
autocmd BufRead,BufNewFile *.plist set filetype=xml

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

autocmd filetype qf wincmd J
]])

-------- SETTINGS --------

-------- UI --------
-- 24-bit colors
vim.opt.termguicolors = true

-- Use default theme, mute functions and brackets
vim.api.nvim_set_hl(0, "Function", {})
-- mute import/export, etc
vim.api.nvim_set_hl(0, "Special", {})
vim.api.nvim_set_hl(0, "Todo", { bg = "NvimLightYellow" })

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

vim.opt.signcolumn = "yes"

vim.opt.wildmode = "longest,list,full"
vim.opt.wildmenu = true

local buf_scratch_name = "*scratch*"

local create_scratch_buffer = function()
	local buf = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_buf_set_name(buf, buf_scratch_name)
	return buf
end

local get_buf_by_name = function(name)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local buf_name = vim.api.nvim_buf_get_name(buf)
		if buf_name == name then
			return buf
		end
	end
	return -1
end

local toggle_scratch = function()
	local buf = get_buf_by_name(buf_scratch_name)
	if buf < 0 then
		buf = create_scratch_buffer()
	end
end

-------- UI --------

-------- LSP --------
local root_pattern = require("lspconfig.util").root_pattern
local luasnip = require("luasnip")
local cmp = require("cmp")
local null_ls = require("null-ls")

require("mason").setup()
require("mason-lspconfig").setup({
	automatic_installation = true,
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	if root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd()) then
		null_ls.disable("prettier")
		if client.name == "tsserver" then
			client.stop()
			return
		end
	end

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, bufopts)
	-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	-- vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, bufopts)
	-- find-replace
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)

	vim.keymap.set("n", "ge", vim.diagnostic.open_float, bufopts)
	vim.keymap.set("n", "gE", vim.diagnostic.setloclist, bufopts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)

	if vim.fn.exists("&makeprg") == 1 then
		-- Bind <leader>m to :make<CR>
		vim.keymap.set("n", "<leader>m", ":make<CR>", bufopts)
	end

	if client.server_capabilities.documentFormattingProvider then
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ timeout_ms = 5000 })
		end, bufopts)

		vim.api.nvim_clear_autocmds({ buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
			end,
		})
	end

	if client.server_capabilities.documentRangeFormattingProvider then
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ timeout_ms = 2000 })
		end, bufopts)
	end

	-- Highlight symbol on cursor hold
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
		vim.api.nvim_create_autocmd({ "CursorHold" }, {
			group = "lsp_document_highlight",
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved" }, {
			group = "lsp_document_highlight",
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end

	-- attempt to fix highlight conflicts with treesitter
	client.server_capabilities.semanticTokensProvider = nil
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require("lspconfig")

lspconfig.tsserver.setup({
	-- root_dir = root_pattern( --[[ "tsconfig.json",  ]] "package.json"),
	capabilities = capabilities,
	on_attach = on_attach,
})

local function deno_init_opts()
	local opts = {
		unstable = true,
		lint = true,
	}

	if vim.fn.filereadable("./import_map.json") == 1 then
		opts.importMap = "./import_map.json"
	end

	return opts
end

lspconfig.denols.setup({
	root_dir = root_pattern("deno.json", "deno.jsonc", "mod.ts", "main.ts", "import_map.json", "lock.json"),
	init_options = deno_init_opts(),
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"markdown",
	},
})

lspconfig.jsonls.setup({
	settings = {
		json = {
			schemas = require("schemastore").json.schemas({
				select = {
					".eslintrc",
					"package.json",
					"tsconfig.json",
				},
			}),
			validate = { enable = true },
		},
	},
	capabilities = capabilities,
	on_attach = on_attach,
})

-- lspconfig.eslint.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
-- })

lspconfig.zls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.jdtls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = function()
		return vim.fs.dirname(vim.fs.find({ ".gradlew", ".gitignore", "mvnw", "build.gradle" }, { upward = true })[1])
			.. "\\"
	end,
})

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "lazydev" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "emoji" },
		{ name = "buffer" },
	},
	completion = {
		winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
		col_offset = -3,
		side_padding = 0,
	},
	window = {
		completion = {
			border = "rounded",
		},
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			local lspkind_config = {
				mode = "symbol_text",
				maxwidth = 50,
				-- preset = "codicons",
			}
			local kind = require("lspkind").cmp_format(lspkind_config)(entry, vim_item)
			local strings = vim.split(kind.kind, "%s", { trimempty = true })
			local item = entry:get_completion_item()
			kind.kind = " " .. (strings[1] or "") .. " "

			if item.detail then
				kind.menu = "    " .. item.detail
			else
				kind.menu = "    " .. (strings[2] or "")
			end

			-- vim.notify(vim.inspect(entry.completion_item))
			-- item.data.file -> filename

			return kind
		end,
	},
	experimental = {
		ghost_text = true,
	},
	view = {
		entries = { name = "custom", selection_order = "near_cursor" },
	},
})

vim.diagnostic.config({
	virtual_text = false,
	-- virtual_text = {
	--   severety = vim.diagnostic.severity.ERROR,
	--   source = "if_many",
	-- },
	float = {
		source = "if_many",
		focusable = false,
	},
	update_in_insert = true,
	severity_sort = true,
})

lspconfig.cssls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.dockerls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.lua_ls.setup({
	on_init = function(client)
		-- local path = client.workspace_folders[1].name
		--
		-- if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
		--   return
		-- end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				},
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			},
		})
	end,
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
		},
	},
})

lspconfig.rust_analyzer.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "javascript", "typescript", "css", "html", "bash", "sql", "vim", "lua" },
	highlight = { enabled = true },
	auto_install = true,
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				-- You can optionally set descriptions to the mappings (used in the desc parameter of
				-- nvim_buf_set_keymap) which plugins like which-key display
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
				-- You can also use captures from other query groups like `locals.scm`
				["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
			},
		},
		swap = {
			enable = true,
			-- swap_next = {
			--   ["<leader>a"] = "@parameter.inner",
			-- },
			-- swap_previous = {
			--   ["<leader>A"] = "@parameter.inner",
			-- },
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = { query = "@class.outer", desc = "Next class start" },
				--
				-- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
				["]o"] = "@loop.*",
				-- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
				--
				-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
				-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
				["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
				["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
			-- Below will go to either the start or the end, whichever is closer.
			-- Use if you want more granular movements
			-- Make it even more gradual by adding multiple queries and regex.
			goto_next = {
				["]d"] = "@conditional.outer",
			},
			goto_previous = {
				["[d"] = "@conditional.outer",
			},
		},
	},
})

require("ts_context_commentstring").setup({})
vim.g.skip_ts_context_commentstring_module = true

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier.with({
			prefer_local = "node_modules/.bin",
		}),
		null_ls.builtins.diagnostics.actionlint,
		-- null_ls.builtins.code_actions.eslint,
	},
	on_attach = on_attach,
})
-------- LSP --------

-------- KEYS --------
local bufopts = { noremap = true, silent = true }

-- Pane movement with <C-h|j|k|l>
vim.keymap.set("n", "<C-h>", "<C-w>h", bufopts)
vim.keymap.set("n", "<C-j>", "<C-w>j", bufopts)
vim.keymap.set("n", "<C-k>", "<C-w>k", bufopts)
vim.keymap.set("n", "<C-l>", "<C-w>l", bufopts)
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", bufopts)
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", bufopts)
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", bufopts)
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", bufopts)

-- Move lines
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==") -- move line up(n)
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==") -- move line down(n)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv") -- move line up(v)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv") -- move line down(v)

-- Resize
vim.keymap.set("n", "<Right>", "<C-w>>", bufopts)
vim.keymap.set("n", "<left>", "<C-w><", bufopts)
vim.keymap.set("n", "<Up>", "<C-w>-", bufopts)
vim.keymap.set("n", "<Down>", "<C-w>+", bufopts)

-- Treat warped lines as regular lines
vim.keymap.set("n", "j", "gj", bufopts)
vim.keymap.set("n", "k", "gk", bufopts)

-- Cursor don't jump when joining lines
vim.keymap.set("n", "J", "mzJ`z", bufopts)

-- Don't jump to first highlight
vim.keymap.set("n", "*", "*``", bufopts)

-- Keep search matches in the middle of the window.
vim.keymap.set("n", "n", "nzzzv", bufopts)
vim.keymap.set("n", "N", "Nzzzv", bufopts)

-- Scroll by 3 lines on <C-e|y>
vim.keymap.set("n", "<C-e>", "3<C-e>", bufopts)
vim.keymap.set("n", "<C-y>", "3<C-y>", bufopts)

-- Keep visual mode when indenting
vim.keymap.set("v", "<", "<gv", bufopts)
vim.keymap.set("v", ">", ">gv", bufopts)

-- Case-insensitive search
vim.keymap.set("n", "/", "/\\v", bufopts)
vim.keymap.set("v", "/", "/\\v", bufopts)

-- Easy commands with ;
-- lua version waits for the next key to enter command mode
-- vim.keymap.set("n", ";", ":", bufopts)
vim.cmd([[nnoremap ; :]])

-- Yank till end of the line
vim.keymap.set("n", "Y", "y$", bufopts)

-- Get full folder path in command mdoe
vim.keymap.set("c", "cwd", "lcd %:p:h")
vim.keymap.set("n", "<leader>cd", ":lcd %:p:h<cr>", bufopts)

-- Save  with single key
vim.keymap.set("n", "s", ":w<cr>", bufopts)

vim.keymap.set("n", "<leader>cc", ":cclose<cr>")

-- Unmap K
vim.cmd("map K <Nop>")

-- FZF
-- vim.keymap.set("n", "<C-t>", ":FZF<cr>", bufopts)
-- vim.keymap.set("n", "<C-p>", ":FZF<cr>", bufopts)
--
vim.api.nvim_set_keymap("n", "<c-P>", "<cmd>lua require('fzf-lua').files()<CR>", bufopts)

-- LSP
vim.keymap.set("n", "<leader>Ls", ":LspInfo<cr>", bufopts)
vim.keymap.set("n", "<leader>Li", ":LspInstall<cr>", bufopts)
vim.keymap.set("n", "<leader>Lx", ":LspStop ", bufopts)

-- Undo History
vim.g.undotree_WindowLayout = 2
vim.g.undotree_SplitWidth = 34
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.cmd([[
  " Leader maps
  nnoremap <leader>l :set list!<cr> \| :IndentLinesToggle<cr>
  nnoremap <leader><space> :nohl<cr>
  "noremap <leader>u :MundoToggle<cr>
  nnoremap <leader>lw :%s/^\s\+<cr>:nohl<cr>
  nnoremap <leader>bl :g/^$/d<cr>:nohl<cr>
  nnoremap <leader>ev :tabe $MYVIMRC<cr>:lcd %:p:h<cr>
  " Yank whole text line without spaces
  nnoremap <leader>y ^y$
  nnoremap <leader>R :%s///<left>
  nnoremap <leader>a :Ack!<space>
  nnoremap <leader>qq :qa!<cr>
  nnoremap <leader>w <C-w>
  nnoremap <leader>md :Glow<cr>

  nnoremap <leader>dt i<C-R>=strftime("%FT%T%z")<CR><Esc>

  nmap <leader>ja :A<cr>
  nmap <leader>jA :AV<cr>

  nnoremap <leader>o :only<cr>

  " Hex
  nnoremap <leader>x :%!xxd<cr>
  nnoremap <leader>X :%!xxd -r<cr>

  " don't send escape sequence with S-Space
  tnoremap <S-Space> <Space>

  " nnoremap <leader>j :Ttoggle<cr>
  nnoremap ` :Ttoggle<cr>
  " tnoremap <leader>j <C-\><C-n>:Ttoggle<cr>
  tnoremap ` <C-\><C-n>:Ttoggle<cr>

  nnoremap <leader>tc :Tclear<cr>
  let g:neoterm_default_mod='botright'
  let g:neoterm_autoinsert=1
  let g:neoterm_repl_python='python3'

  cabbr <expr> %% expand('%:p:h')

  " fzf
  nnoremap <leader>b :Buffers<cr>
]])

vim.cmd([[
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
]])

vim.cmd([[
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

  command! W noa write

  function! SynStack()
    if !exists("*synstack")
      return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  endfunc
]])

-- MarkdownPreview
vim.keymap.set("n", "<leader>md", "<Plug>MarkdownPreviewToggle")

-------- KEYS --------

-------- PLUGINS --------
local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP =
      fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  print("Installing packer close and reopen Neovim...")
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- vim.cmd([[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerSync
--   augroup end
-- ]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "single" })
    end,
  },
})

-- Install your plugins here
packer.startup(function(use)
  use("wbthomason/packer.nvim") -- Have packer manage itself

  -- Look
  -- use({
  --   "jesseleite/nvim-noirbuddy",
  -- requires = { "tjdevries/colorbuddy.nvim", branch = "dev" },
  -- config = function()
  --   require("noirbuddy").setup({
  --     preset = "slate",
  --     -- colors = {
  --     --   -- primary = "#6EE2FF",
  --     --   primary = "#60d5f2",
  --     --   secondary = "#9EAACE",
  --     -- },
  --     styles = {
  --       italic = true,
  --       -- bold = true,
  --       underline = true,
  --     },
  --   })
  -- end,
  -- })
  use({ "kvrohit/rasmus.nvim" })
  use({ "andreypopp/vim-colors-plain" })
  use({ "preservim/vim-colors-pencil" })
  use({ "sainnhe/gruvbox-material" })
  use({ "nvim-lualine/lualine.nvim" })
  use("lukas-reineke/indent-blankline.nvim")
  -- use({
  --   "f-person/auto-dark-mode.nvim",
  --   config = function()
  --     local dark_mode = require("auto-dark-mode")
  --     dark_mode.setup({})
  --     -- dark_mode.init()
  --   end,
  -- })
  use({ "lewis6991/gitsigns.nvim" })

  -- Editing & Navigation
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  })
  use("junegunn/goyo.vim")
  use("mtth/scratch.vim")
  use("simnalamburt/vim-mundo")
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })
  use("tpope/vim-repeat")
  use("tpope/vim-surround")
  use("tpope/vim-unimpaired")
  use({
    "guns/vim-sexp",
    ft = { "clojure", "scheme", "racket", "lisp" },
    requires = {
      "tpope/vim-sexp-mappings-for-regular-people",
    },
  })
  use("kana/vim-textobj-user")
  use("mattn/emmet-vim")
  use("tpope/vim-speeddating") -- ctrl-a ctrl-x for date and time
  use("lyokha/vim-xkbswitch")
  use("bronson/vim-visual-star-search")
  use({ "ibhagwan/fzf-lua" })

  -- Integrations
  use("mileszs/ack.vim")
  use({
    "tpope/vim-fugitive",
    requires = {
      "tpope/vim-rhubarb",
    },
  })
  use("tpope/vim-vinegar") -- nice things for netrw
  use("tpope/vim-projectionist")
  use({ "Shougo/vimproc.vim", run = "make" })
  use("kassio/neoterm")
  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  })

  -- Syntax
  use("rizzatti/dash.vim")
  use({
    "tpope/vim-fireplace",
    ft = { "clojure" },
  })
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
          require("treesitter-context").setup({})
        end,
      },
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
      },
    },
  })
  use({ "sheerun/vim-go", ft = { "go" } })
  use({ "tpope/vim-jdaddy", ft = { "json" } })
  use({ "neoclide/jsonc.vim", ft = "json" })
  -- use({ "ap/vim-css-color", ft = { "html", "css", "javascript", "typescript", "vue", "less", "sass", "stylus" } })
  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        css = { css_fn = true },
        "javascript",
        "typescript",
        "astro",
        "less",
        "vue",
        "stylus",
        "html",
      })
    end,
  })
  use({ "wuelnerdotexe/vim-astro", ft = { "astro" } })
  use({ "ellisonleao/glow.nvim", ft = { "markdown" } })

  -- LSP
  use("nvim-lua/plenary.nvim")
  use({
    "neovim/nvim-lspconfig",
    requires = {
      "williamboman/nvim-lsp-installer",
      "jose-elias-alvarez/null-ls.nvim",
    },
  })
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "hrsh7th/cmp-emoji",
      "onsails/lspkind.nvim",
      "b0o/schemastore.nvim",
    },
  })

  use("folke/neodev.nvim")

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
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
vim.opt.spelllang = { "en_gb" }
vim.cmd([[
autocmd FileType qf,json,yaml,neoterm,fzf, setlocal nospell
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

" autocmd BufWritePost $MYVIMRC nested source $MYVIMRC

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
  ["deno.json"] = {
    [".ts"] = {
      ["alternate"] = {
        "{}_test.ts",
        "{}.test.ts",
      },
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

vim.cmd([[
  autocmd BufRead,BufEnter *.astro set filetype=astro
  autocmd BufRead,BufEnter *.mdx set filetype=markdown
]])
-------- SETTINGS --------

-------- UI --------
-- 24-bit colors
vim.opt.termguicolors = true
vim.api.nvim_set_option("background", "dark")

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
-- vim.cmd.colorscheme("gruvbox-material");

-- rasmus
vim.g.rasmus_italic_keywords = true
-- vim.g.rasmus_variant = "monochrome"
vim.cmd.colorscheme("rasmus")

-- lualine
require("lualine").setup({
  theme = "auto",
  options = {
    icons_enabled = true,
    section_separators = "",
    component_separators = "",
  },
  sections = {
    lualine_b = {
      "branch",
      "diff",
      { "diagnostics", symbols = { error = "✗ ", warn = "⚠ ", info = "i ", hint = "✶ " } },
    },

    lualine_x = {
      "encoding",
      { "fileformat", symbols = { unix = "𝕏", dos = "𝕎", mac = "𝕄" } },
      "filetype",
    },
  },
})

-- IndentLine
require("indent_blankline").setup({
  -- for example, context is off by default, use this to turn it on
  char = "┆", --┊
  treesitter = true,
  indent_level = 5,
  -- show_current_context = true,
  -- show_current_context_start = true,
  show_first_indent_level = false,
})

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
  vim.o.guifont = "Iosevka Term:h15"
  vim.g.neovide_remember_window_size = true

  -- Allow clipboard copy paste in neovim
  vim.g.neovide_input_use_logo = 1
  vim.keymap.set("n", "<D-s>", ":w<CR>")     -- Save
  vim.keymap.set("v", "<D-c>", '"+y')        -- Copy
  vim.keymap.set("n", "<D-v>", '"+P')        -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P')        -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+")     -- Paste command mode
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
-------- UI --------

-------- LSP --------
local root_pattern = require("lspconfig.util").root_pattern
local luasnip = require("luasnip")
local cmp = require("cmp")
local null_ls = require("null-ls")

require("nvim-lsp-installer").setup({
  automatic_installation = true,
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  if client.name == "denols" then
    null_ls.disable("prettier")
    vim.keymap.set("n", "<leader>di", ":DenolsCache<cr>")
  end

  if root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd()) then
    if client.name == "tsserver" then
      client.stop()
      return
    end
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

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

  -- Show diagnostics on cursor hold
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "cursor",
      }
      vim.diagnostic.open_float(nil, opts)
    end,
  })
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Call before lspconfig
require("neodev").setup({})

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

lspconfig.astro.setup({
  root_dir = root_pattern("astro.config.mjs"),
  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig.eslint.setup({
  on_attach = on_attach,
  capabilities = capabilities,
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
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "emoji" },
    { name = "buffer " },
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

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier.with({
      prefer_local = "node_modules/.bin",
    }),
    null_ls.builtins.diagnostics.actionlint,
    null_ls.builtins.code_actions.eslint,
  },
  on_attach = on_attach,
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
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      workspace = {
        -- remove annoying "Do you need to configure your work environment as luv"
        checkThirdParty = false,
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
  context_commentstring = {
    enable = true,
  },
})

-------- LSP --------

-------- KEYS --------
local bufopts = { noremap = true, silent = true }

-- Leader
vim.keymap.set("n", "<SPACE>", "<Nop>", bufopts)
vim.g.mapleader = " "

-- Pane movement with <C-h|j|k|l>
vim.keymap.set("n", "<C-h>", "<C-w>h", bufopts)
vim.keymap.set("n", "<C-j>", "<C-w>j", bufopts)
vim.keymap.set("n", "<C-k>", "<C-w>k", bufopts)
vim.keymap.set("n", "<C-l>", "<C-w>l", bufopts)
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", bufopts)
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", bufopts)
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", bufopts)
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", bufopts)

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

vim.cmd([[
  " Leader maps
  nnoremap <leader>l :set list!<cr> \| :IndentLinesToggle<cr>
  nnoremap <leader><space> :nohl<cr>
  noremap <leader>u :MundoToggle<cr>
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
  nnoremap <leader>z :Goyo<cr>

  " Hex
  nnoremap <leader>x :%!xxd<cr>
  nnoremap <leader>X :%!xxd -r<cr>

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
  " don't send escape sequence with S-Space
  tnoremap <S-Space> <Space>

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

  " tab (window) nav
  "map <C-Tab> gt
  "map <C-S-Tab> gT

  function! SynStack()
    if !exists("*synstack")
      return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  endfunc
]])

local toggleColors = function()
  if vim.g.colors_name == "rasmus" then
    -- local variants = { "dark", "monochrome" }
    local cur_variant = vim.g.rasmus_variant
    -- print(cur_variant, "var")
    if cur_variant == "dark" then
      print("set mono")
      vim.g.rasmus_variant = "monochrome"
    else
      print("set dark")
      vim.g.rasmus_variant = "dark"
    end
  end
end

vim.keymap.set("n", "<leader>CC", toggleColors, bufopts)

-- MarkdownPreview
vim.keymap.set("n", "<leader>md", "<Plug>MarkdownPreviewToggle")
-------- KEYS --------
